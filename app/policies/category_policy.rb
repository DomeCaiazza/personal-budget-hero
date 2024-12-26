class CategoryPolicy < ApplicationPolicy
  class Scope < Scope
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

  alias new? index?
  alias create? index?
  alias update? index?
  alias edit? index?
  alias destroy? index?
  alias generate_slug? index?
end
