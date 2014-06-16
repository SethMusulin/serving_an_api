require 'spec_helper'
require 'rails_helper'

describe "Car API" do
  it "returns a list of cars" do
    ford = create_make(name: "Ford")
    chevy = create_make(name: "Chevy")
    red = create_car(color: "red", doors: 4, purchased_on: "1973-10-04", make_id: ford.id)
    blue = create_car(color: "blue", doors: 2, purchased_on: "2012-01-24", make_id: chevy.id)


    get '/cars', {}, {'Accept' => 'application/json'}

    expected_response = {
        "_links" => {
            "self" => {"href" => cars_path},
        },
        "_embedded" => {
            "cars" => [
                {
                    "_links" => {
                        "self" => {"href" => car_path(red)},

                        "make" => {"href" => make_path(red.make_id)}
                    },
                    "id" => red.id,
                    "color" => "red",
                    "doors" => 4,
                    "purchased_on" => "1973-10-04"
                },
                {
                    "_links" => {
                        "self" => {"href" => car_path(blue)},

                        "make" => {"href" => make_path(blue.make_id)}
                    },
                    "id" => blue.id,
                    "color" => "blue",
                    "doors" => 2,
                    "purchased_on" => "2012-01-24"
                },
            ]
        },
    }

    expect(response.code.to_i).to eq 200
    expect(JSON.parse(response.body)).to eq(expected_response)

  end
end

describe 'GET /cars/:id' do

  it 'returns one car' do
    ford = create_make(name: "Ford")
    red = create_car(color: "red", doors: 4, purchased_on: "1973-10-04", make_id: ford.id)

    get "/cars/#{red.id}", {}, {'Accept' => 'application/json'}

    expected_response = {
        "_links" => {
            "self" => {"href" => car_path(red)},
            "make" => {
                "href" => make_path(ford)
            }
        },
        "id" => red.id,
        "color" => "red",
        "doors" => 4,
        "purchased_on" => "1973-10-04"
    }

    expect(response.code.to_i).to eq 200
    expect(JSON.parse(response.body)).to eq(expected_response)
  end

  it 'returns a 404 if the car can not be found' do
    get '/cars/999', {}, {'Accept' => 'application/json'}

    expected_response = {}

    expect(response.code.to_i).to eq(404)
    expect(JSON.parse(response.body)).to eq(expected_response)
  end
end