json._links do
  json.self do
    json.href cars_path
  end
end

json._embedded do
  json.cars do
    json.array! @cars do |car|
      json._links do
        json.self do
          json.href car_path(car)
        end
        json.make do
          json.href make_path(car.make)
        end
      end
      json.id car.id
      json.color car.color
      json.doors car.doors
      json.purchased_on car.purchased_on
    end
  end
end