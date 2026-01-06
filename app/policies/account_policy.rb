class AccountPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      user.accounts
    end
  end

  def index?
    user_has_admin_or_user_privileges?
  end

  def show?
    user.accounts.include?(record)
  end

  def new?
    user_has_admin_or_user_privileges?
  end

  def create?
    user_has_admin_or_user_privileges?
  end

  def switch?
    user.accounts.include?(record)
  end
end
