class Console::TransactionsController < ConsoleController
  include TransactionsConcern
  before_action :set_transaction, only: [ :edit, :update, :destroy ]
  before_action :set_categories, only: [ :edit, :new, :update, :index, :create ]

  def index
    policy_scope(Transaction)
    params[:q] ||= { date_gteq: Date.today.beginning_of_month, date_lteq: Date.today.end_of_month }

    if params[:apply_subscriptions].present?
      SubscriptionsService.new(@account).apply
      flash[:success] = t("controllers.console.transactions.apply_subscriptions.success")
    end
    @q = @account.transactions.ransack(params[:q])
    @transactions = @q.result.order(date: :desc)
    @transactions_report = TransactionReportService.new(@transactions, params[:q][:date_gteq].to_s, params[:q][:date_lteq].to_s).generate
    authorize(@transactions)
  end

  def new
    policy_scope(Transaction)
    @transaction_type = params[:transaction_type] if Transaction.transaction_types.keys.include?(params[:transaction_type])
    @transaction = @account.transactions.build
    authorize @transaction
  end

  def create
    policy_scope(Transaction)
    @transaction = @account.transactions.build(transaction_params)
    authorize @transaction
    if @transaction.save
      redirect_to account_console_transactions_path, notice: t("controllers.console.transactions.create.success")
    else
      flash.now[:danger] = t("controllers.console.transactions.create.error")
      render :new
    end
  end

  def update
    authorize @transaction
    if @transaction.update(transaction_params)
      redirect_to account_console_transactions_path, notice: t("controllers.console.transactions.update.success")
    else
      flash.now[:danger] = t("controllers.console.transactions.update.error")
      render :edit
    end
  end

  def destroy
    policy_scope(@transaction)
    authorize @transaction
    if @transaction.destroy
      flash[:success] = t("controllers.console.transactions.destroy.success")
    else
      flash[:danger] = "#{t('controllers.console.transactions.destroy.error')}: #{@transaction.errors.full_messages.join(". ")}"
    end
    redirect_to account_console_transactions_path
  end
end
