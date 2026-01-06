class Console::SubscriptionsController < ConsoleController
  include AccountConcern
  before_action :set_subscription, only: [ :edit, :update, :destroy ]
  def index
    policy_scope(Subscription)
    @subscriptions = @account.subscriptions
    authorize(@subscriptions)
  end

  def new
    policy_scope(Subscription)
    @subscription = @account.subscriptions.build
    authorize @subscription
  end

  def edit
    authorize @subscription
  end

  def create
    policy_scope(Subscription)
    @subscription = @account.subscriptions.build(subscription_params)
    authorize @subscription
    if @subscription.save
      redirect_to account_console_subscriptions_path, notice: t("controllers.console.subscriptions.create.success")
    else
      flash.now[:danger] = t("controllers.console.subscriptions.create.error")
      render :new
    end
  end

  def update
    authorize @subscription
    if @subscription.update(subscription_params)
      redirect_to account_console_subscriptions_path, notice: t("controllers.console.subscriptions.update.success")
    else
      flash.now[:danger] = t("controllers.console.subscriptions.update.error")
      render :edit
    end
  end

  def destroy
    policy_scope(@subscription)
    authorize @subscription
    if @subscription.destroy
      flash[:success] = t("controllers.console.subscriptions.destroy.success")
      redirect_to account_console_subscriptions_path
    else
      flash[:danger] = "#{t('controllers.console.subscriptions.destroy.error')}: #{@subscription.errors.full_messages.join(". ")}"
      redirect_to account_console_subscriptions_path
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:description, :default_amount, :subscription_type)
  end

  def set_subscription
    policy_scope(Subscription)
    @subscription = @account.subscriptions.find(params[:id])
  end
end
