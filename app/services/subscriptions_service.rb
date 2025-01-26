class SubscriptionsService
  SUBSCRIPTION_TYPE_TO_MONTHS = {
    "monthly" => 1,
    "quarterly" => 3,
    "semiannual" => 6,
    "annual" => 12
  }.freeze

  def initialize(user)
    @user = user
    return if @user.blank?

    create_subscriptions_category if @user.categories.subscriptions.empty?
    @transactions = @user.transactions.expenses.where.not(subscription_code: nil)
  end

  def apply
    @user.subscriptions.find_each do |subscription|
      months = SUBSCRIPTION_TYPE_TO_MONTHS[subscription.subscription_type]
      next if months.nil?

      last_transaction = find_last_transaction_for(subscription.code)

      if last_transaction.nil? || need_renewal?(last_transaction.date, months)
        create_subscription_transaction(subscription)
      end
    end
  end

  private

  def find_last_transaction_for(code)
    @transactions
      .where(subscription_code: code)
      .order(date: :desc)
      .first
  end

  def need_renewal?(last_date, months)
    last_date <= Time.current - months.months
  end

  def create_subscriptions_category
    @user.categories.create!(
      name: Subscription.model_name.plural.capitalize,
      hex_color: "#73b3d9",
      category_type: :subscriptions
    )
  end

  def create_subscription_transaction(subscription)
    @user.transactions.create!(
      subscription_code: subscription.code,
      category_id: @user.categories.subscriptions.first.id,
      amount: subscription.default_amount,
      description: subscription.description,
      date: Time.current.beginning_of_month,
      transaction_type: :expense
    )
  end
end
