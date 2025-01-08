class TransactionReportService
  def initialize(transactions, start_date, end_date)
    @transactions = transactions
    @start_date = DateTime.parse(start_date)
    @end_date = DateTime.parse(end_date)
  end

  def generate
    {
      total: total.to_f,
      average: average.to_f,
      average_without_fixed_transactions: average_without_fixed_transactions.to_f,
      forecast: remaining_days.positive? ? forecast.to_f : nil
    }
  end

  private

  def total
    @transactions.sum(:amount)
  end

  def average
    total / spent_days
  end

  def average_without_fixed_transactions
    @transactions.where(fixed: false).sum(:amount) / total_days
  end

  def forecast
    total + (average_without_fixed_transactions * remaining_days)
  end

  def remaining_days
    (@end_date - Date.today).to_i
  end

  def total_days
    (@end_date - @start_date).to_i + 1
  end

  def spent_days
    (total_days - remaining_days)
  end
end
