module TransactionsConcern
  extend ActiveSupport::Concern

  def set_categories
    transaction_type = params[:transaction_type]
    @categories = current_user.categories
    if transaction_type.present?
      case transaction_type
      when "expense"
        @categories = current_user.categories.expense
      when "income"
        @categories = current_user.categories.income
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
    @transaction = current_user.transactions.find(params[:id])
  end
end
