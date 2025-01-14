class Console::DashboardController < ConsoleController
  def index
    policy_scope(Transaction)
    @categories = current_user.categories
    params[:q] ||= {}
    authorize(Transaction)
    if params.dig(:q, :date_eq).present?
      year = params[:q][:date_eq]
      params[:q][:date_gteq] = "#{year}-01-01"
      params[:q][:date_lteq] = "#{year}-12-31"
    end

    @q = current_user.transactions.ransack(params[:q])
    @transactions = @q.result
    transactions_data = @transactions.group(:category_id, Arel.sql("MONTH(date)")).sum(:amount)

    @category_data = build_category_data(@categories, transactions_data)
  end

  protected

  def build_category_data(categories, transactions_data)
    category_data = {}
    categories.each do |category|
      monthly_sums = (1..12).map { |m| transactions_data[[ category.id, m ]] || 0 }
      total = monthly_sums.sum
      avg = total / 12.0

      category_data[category.id] = {
        name: category.name,
        color: category.hex_color,
        monthly_sums: monthly_sums,
        total: total,
        avg: avg
      }
    end
    category_data
  end
end
