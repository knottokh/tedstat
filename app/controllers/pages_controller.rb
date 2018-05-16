class PagesController < ApplicationController
  before_action :check_user_home!
  def index
    @notcontainer = true
  end

  def show
  end
end
