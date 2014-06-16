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

describe 'POST /cars' do
  it 'allows users with a token to create a car' do
    user = create_user

    ford = create_make(name: "Ford")

    headers = {
        'Accept' => 'application/json',
        'Authorization' => user.api_authentication_token
    }

    posted_data = {
        "make_id" => ford.id,
        "color" => 'blue',
        "doors" => 2,
        "purchased_on" => "2012-01-24"
    }.to_json

    expect { post '/cars', posted_data, headers }.to change { Car.count }.by(1)

    created_car = Car.last

    expected_response = {
        "_links" => {
            "self" => {"href" => car_path(created_car)},
            "make" => {"href" => make_path(ford)},
        },
        "id" => created_car.id,
        "color" => "blue",
        "doors" => 2,
        "purchased_on" => "2012-01-24"
    }

    expect(response.code.to_i).to eq(201)
    expect(JSON.parse(response.body)).to eq(expected_response)
  end

  it "does not allow a user without an API token to create a car" do

    create_user

    ford = create_make(name: "Ford")

    headers = {
        'Accept' => 'application/json',
    }

    posted_data = {
        "make_id" => ford.id,
        "color" => 'blue',
        "doors" => 2,
        "purchased_on" => "2012-01-24"
    }.to_json

    expect { post '/cars', posted_data, headers }.to change { Car.count }.by(0)
    expected_response = {}

    expect(response.code.to_i).to eq(401)
    expect(JSON.parse(response.body)).to eq(expected_response)
  end

  it "does not alow a user with an invalid token to create a car" do
    user = create_user
    invalid_token = '1234-42342342-23234'

    expect(user.api_authentication_token).to_not eq invalid_token

    ford = create_make(name: "Ford")

    headers = {
        'Accept' => 'application/json',
        'Authorization' => invalid_token
    }

    posted_data = {
        "make_id" => ford.id,
        "color" => 'blue',
        "doors" => 2,
        "purchased_on" => "2012-01-24"
    }.to_json

    expect { post '/cars', posted_data, headers }.to change { Car.count }.by(0)
    expected_response = {}

    expect(response.code.to_i).to eq(401)
    expect(JSON.parse(response.body)).to eq(expected_response)
  end
end