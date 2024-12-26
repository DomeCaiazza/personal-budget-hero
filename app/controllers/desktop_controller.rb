class DesktopController < ApplicationController
  before_action :authenticate_user!
  layout "desktop"
end
