class CarsController < ActionController::Base
  def index
    @cars = Car.all
  end

  def show
    @car = Car.find(params[:id])
    @make = Make.find(@car.make_id)
  end
end