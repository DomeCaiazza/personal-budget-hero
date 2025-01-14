class TransactionReportService
  def initialize(transactions, start_date, end_date, today = DateTime.now)
    @expenses = transactions.expenses
    @incomes = transactions.incomes
    @start_date = DateTime.parse(start_date)
    @end_date = DateTime.parse(end_date)
    @today = today
  end

  def generate
    {
      total_expenses: total_expenses,
      total_incomes: total_incomes,
      saved: saved,
      expenses_average_as_of_today: expenses_average_as_of_today,
      expenses_without_subscriptions_average: nil,
      expenses_forecast: expenses_forecast,
      total_days: total_days,
      passed_days: passed_days,
      remaining_days: remaining_days
    }
  end

  def total_expenses
    @expenses.sum(:amount)
  end

  def total_incomes
    @incomes.sum(:amount)
  end

  def saved
    total_incomes + total_expenses
  end

  def expenses_average_as_of_today
    return total_expenses / total_days if @end_date <= @today

    total_expenses / passed_days
  end

  def expenses_forecast
    return nil if @end_date <= @today

    total_expenses + (expenses_average_as_of_today * remaining_days)
  end

  def total_days
    (@end_date - @start_date).to_i + 1
  end

  def passed_days
    (@today - @start_date).to_i + 1
  end

  def remaining_days
    total_days - passed_days
  end
end
