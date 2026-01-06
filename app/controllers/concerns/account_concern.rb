module AccountConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_account
  end

  private

  def set_account
    if params[:account_id].blank?
      redirect_to accounts_path
      return
    end

    @account = Account.find(params[:account_id])
    authorize @account, :show?
  rescue ActiveRecord::RecordNotFound
    raise Pundit::NotAuthorizedError
  end
end
