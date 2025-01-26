class Console::SubscriptionsController < ConsoleController
  before_action :set_subscription, only: [ :edit, :update, :destroy ]
  def index
    policy_scope(Subscription)
    @subscriptions = current_user.subscriptions
    authorize(@subscriptions)
  end

  def new
    policy_scope(Subscription)
    @subscription = current_user.subscriptions.build
    authorize @subscription
  end

  def edit
    authorize @subscription
  end

  def create
    policy_scope(Subscription)
    @subscription = current_user.subscriptions.build(subscription_params)
    authorize @subscription
    if @subscription.save
      redirect_to console_subscriptions_path, notice: t("labels.record_created")
    else
      render :new
    end
  end

  def update
    authorize @subscription
    if @subscription.update(subscription_params)
      redirect_to console_subscriptions_path, notice: t("labels.record_modified")
    else
      render :edit
    end
  end

  def destroy
    policy_scope(@subscription)
    authorize @subscription
    if @subscription.destroy
      flash[:success] = t("labels.record_destroyed")
      redirect_to console_subscriptions_path
    else
      flash[:danger] = "<b>#{t('labels.error_record_destroyed')}</b>: #{@subscription.errors.full_messages.join(". ")}"
      redirect_to console_subscriptions_path
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:description, :default_amount, :subscription_type)
  end

  def set_subscription
    policy_scope(Subscription)
    @subscription = current_user.subscriptions.find(params[:id])
  end
end
