module TransactionsConcern
  extend ActiveSupport::Concern

  included do
    include AccountConcern
  end
  def set_categories
    transaction_type = params[:transaction_type]
    @categories = @account.categories
    if transaction_type.present?
      case transaction_type
      when "expense"
        @categories = @account.categories.expense
      when "income"
        @categories = @account.categories.income
      end
    end
  end

  def edit
    authorize @transaction
  end

  private

  def transaction_params
    params.require(:transaction).permit(:description, :date, :amount, :category_id, :transaction_type)
  end

  def set_transaction
    policy_scope(Transaction)
    @transaction = @account.transactions.find(params[:id])
  end
end
