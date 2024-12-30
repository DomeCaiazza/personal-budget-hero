class CostsService
  def initialize(costs)
    @costs = costs
  end

  def total
    @costs.sum(:amount)
  end

  def maths_average
    month_day = Date.new.day
    @costs.sum(:amount) / month_day
  end
end
