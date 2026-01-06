class AccountsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  after_action :verify_policy_scoped
  layout "webapp"

  def index
    @accounts = policy_scope(Account)
    authorize Account
  end

  def new
    policy_scope(Account)
    @account = Account.new
    authorize @account
  end

  def create
    policy_scope(Account)
    @account = Account.new(account_params)
    authorize @account
    
    if @account.save
      # Aggiungi l'utente corrente all'account
      AccountUser.create(account: @account, user: current_user)
      redirect_to accounts_path, notice: t("controllers.accounts.create.success")
    else
      flash.now[:danger] = t("controllers.accounts.create.error")
      render :new
    end
  end

  def switch
    policy_scope(Account)
    @account = current_user.accounts.find(params[:id])
    authorize @account
    
    # Reindirizza alla dashboard console dell'account selezionato
    redirect_to account_console_dashboard_path(@account), notice: t("controllers.accounts.switch.success")
  end

  private

  def account_params
    params.require(:account).permit(:name, :description)
  end
end

