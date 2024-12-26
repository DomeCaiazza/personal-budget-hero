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
    create?
  end

  def new?
    create?
  end

  def show?
    create?
  end

  def create?
    user.admin? || user.user?
  end

  def destroy?
    update?
  end

  def edit?
    update?
  end

  def update?
    user.admin? || record.id == user.id
  end
end
