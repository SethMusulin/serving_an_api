class CarsController < ActionController::Base
  def index
    @cars = Car.all
  end

  def show
    if Car.find_by(id: params[:id])
      @car = Car.find(params[:id])
      @make = Make.find(@car.make_id)
    else
      render json: {}, status: 404
    end
  end
end