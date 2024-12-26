class MobileController < ApplicationController
  before_action :authenticate_user!
  layout "mobile"
end
