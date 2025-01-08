class CostReportService
  def initialize(costs, start_date, end_date)
    @costs = costs
    @start_date = start_date
    @end_date = end_date
  end

  def generate
    {
      total: total,
      average: average,
      average_without_fixed_costs: average_without_fixed_costs,
      costs_forecast: remaining_days.positive? ? costs_forecast : nil
    }
  end

  private

  def total
    @costs.sum(:amount)
  end

  def average
    total / spent_days
  end

  def average_without_fixed_costs
    @costs.where(fixed: false).sum(:amount) / total_days
  end

  def costs_forecast
    total + (average_without_fixed_costs * remaining_days)
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
