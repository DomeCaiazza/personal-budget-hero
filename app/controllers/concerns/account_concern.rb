module AccountConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_account
  end

  private

  def set_account
    if params[:account_id].blank? && current_user.accounts.count > 0
      redirect_to account_console_dashboard_path(account_id: current_user.accounts.first.id)
      return
    end
    @account = current_user.accounts.find(params[:account_id])
  end
end