class WebappController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  after_action :verify_policy_scoped
  layout "webapp"
end
