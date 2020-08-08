class LocationsController < ApplicationController

  before_action :get_location, only: [:update, :destroy]

  def index
    render json: Location.all
  end

  def create
    render json: Location.create(strong_params)
  end

  def destroy
    @location.delete
  end

  def update
    @location.update(strong_params)
  end

  private

  def strong_params
    params.require(:location).permit(:name, :locId, :isActive)
  end

  def get_location
    @location = Location.find(params[:id])
  end

end
