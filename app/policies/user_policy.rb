class UserPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope
      else
        scope.where(id: user.id)
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
