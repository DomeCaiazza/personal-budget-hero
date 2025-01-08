class Mobile::TransactionsController < MobileController
  before_action :set_transaction, only: [ :edit, :update ]
  before_action :set_categories, only: [ :edit, :new ]
  def index
    policy_scope(Transaction)
    @transactions = current_user.transactions.order(id: :desc)
    authorize(@transactions)
  end

  def new
    @transaction = policy_scope(Transaction).new
    authorize @transaction
  end

  def edit
    authorize @transaction
  end

  def create
    policy_scope(Transaction)
    @transaction = current_user.transactions.new(transaction_params)
    authorize @transaction
    if @transaction.save
      flash[:success] = t("labels.record_created")
      redirect_to new_mobile_transaction_path, success: t("labels.record_created")
    else
      flash[:danger] = @transaction.errors.full_messages.join("<br>").html_safe
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @transaction
    if @transaction.update(transaction_params)
      redirect_to mobile_transactions_path, notice: t("labels.record_modified")
    else
      render :edit
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:description, :date, :amount, :category_id)
  end

  def set_transaction
    @transaction = policy_scope(Transaction).find(params[:id])
  end

  def set_categories
    @categories = current_user.categories
  end
end
