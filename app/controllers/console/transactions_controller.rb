class Desktop::TransactionsController < DesktopController
  include TransactionsConcern
  before_action :set_transaction, only: [ :edit, :update, :destroy ]
  before_action :set_categories, only: [ :edit, :new, :update, :index, :create ]

  def index
    policy_scope(Transaction)
    params[:q] ||= { date_gteq: Date.today.beginning_of_month, date_lteq: Date.today.end_of_month }
    @q = current_user.transactions.ransack(params[:q])
    @transactions = @q.result
    @transactions_report = TransactionReportService.new(@transactions, params[:q][:date_gteq].to_s, params[:q][:date_lteq].to_s).generate
    authorize(@transactions)
  end

  def new
    policy_scope(Transaction)
    @transaction_type = params[:transaction_type] if Transaction.transaction_types.keys.include?(params[:transaction_type])
    @transaction = current_user.transactions.build
    authorize @transaction
  end

  def create
    policy_scope(Transaction)
    @transaction = current_user.transactions.build(transaction_params)
    authorize @transaction
    if @transaction.save
      redirect_to console_transactions_path, notice: t("labels.record_created")
    else
      render :new
    end
  end

  def update
    authorize @transaction
    if @transaction.update(transaction_params)
      redirect_to console_transactions_path, notice: t("labels.record_modified")
    else
      render :edit
    end
  end

  def destroy
    policy_scope(@transaction)
    authorize @transaction
    if @transaction.destroy
      flash[:success] = t("labels.record_destroyed")
    else
      flash[:danger] = "<b>#{t('labels.error_record_destroyed')}</b>: #{@transaction.errors.full_messages.join(". ")}"
    end
    redirect_to console_transactions_path
  end
end
