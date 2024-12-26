class ApplicationController < ActionController::Base
  include Pundit::Authorization
  after_action :verify_authorized
  after_action :verify_policy_scoped
end
