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
    @account = current_user.accounts.find(params[:account_id])
  end
end