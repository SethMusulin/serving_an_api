class CarsController < ActionController::Base
  def index
    @cars = Car.all
  end
end