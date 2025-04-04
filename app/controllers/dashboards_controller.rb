class DashboardsController < ApplicationController
  def show
    @plants = Current.user.plants
  end
end
