module ApplicationHelper
  def currency_formatter(amount)
    return "-" if amount.nil?
    number_to_currency(amount, unit: "€", separator: ",", delimiter: ".")
  end
end
