class CategoryPolicy < ApplicationPolicy
  class Scope < Scope
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end
    def resolve
      if user.admin? || user.user?
        scope
      else
        scope.none
      end
    end
  end

  def index?
    user_has_admin_or_user_privileges?
  end

  def edit?
    user_has_admin_or_user_privileges? && record.category_type != "subscriptions"
  end

  alias new? index?
  alias create? index?
  alias update? index?
  alias destroy? index?
  alias generate_slug? index?
end
