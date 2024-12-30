# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NoMethodError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end

  def index?
    false
  end

  def user_has_admin_or_user_privileges?
    user.admin? || user.user?
  end

  alias_method :show?, :index?
  alias_method :create?, :index?
  alias_method :new?, :index?
  alias_method :update?, :index?
  alias_method :destroy?, :index?
end
