class CarsController < ActionController::Base
  def index
    @cars = Car.all
  end

  def create
    attributes = JSON.parse(request.body.read)
    @car = Car.create(attributes)
    render status: 201
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