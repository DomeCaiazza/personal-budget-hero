class Desktop::DashboardController < DesktopController
  def index
    policy_scope(Cost)
    @categories = current_user.categories
    params[:q] ||= {}
    authorize(Cost)
    if params.dig(:q, :date_eq).present?
      year = params[:q][:date_eq]
      params[:q][:date_gteq] = "#{year}-01-01"
      params[:q][:date_lteq] = "#{year}-12-31"
    end

    @q = current_user.costs.ransack(params[:q])
    @costs = @q.result
    costs_data = @costs.group(:category_id, Arel.sql("MONTH(date)")).sum(:amount)

    @category_data = build_category_data(@categories, costs_data)
  end

  protected

  def build_category_data(categories, costs_data)
    category_data = {}
    categories.each do |category|
      monthly_sums = (1..12).map { |m| costs_data[[ category.id, m ]] || 0 }
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
