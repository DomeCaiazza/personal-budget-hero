class Webapp::TransactionsController < WebappController
  include TransactionsConcern
  before_action :set_transaction, only: [ :edit, :update ]
  before_action :set_categories, only: [ :edit, :new ]

  def index
    policy_scope(Transaction)
    @transactions = @account.transactions.order(date: :desc)
    authorize(@transactions)
  end

  def new
    @transaction = policy_scope(Transaction).new
    @transaction_type = params[:transaction_type] if Transaction.transaction_types.keys.include?(params[:transaction_type])
    authorize @transaction
  end

  def create
    policy_scope(Transaction)
    @transaction = @account.transactions.new(transaction_params)
    authorize @transaction
    if @transaction.save
      flash[:success] = t("labels.record_created")
      redirect_to new_account_webapp_transaction_path(@account), success: t("labels.record_created")
    else
      flash[:danger] = @transaction.errors.full_messages.join("<br>").html_safe
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @transaction
    if @transaction.update(transaction_params)
      redirect_to account_webapp_transactions_path(@account), notice: t("labels.record_modified")
    else
      render :edit
    end
  end
end
