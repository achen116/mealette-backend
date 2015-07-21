class ApiController < ApplicationController

  def index
    if params[:address]
      geocodeResult = Geocoder.search(params[:address])
      latitude = geocodeResult[0].data['geometry']['location']['lat'].to_f
      longitude = geocodeResult[0].data['geometry']['location']['lng'].to_f
    else
      latitude = params[:lat].to_f
      longitude = params[:lon].to_f
    end

    coordinates = { latitude: latitude, longitude: longitude }
    result = Yelp.client.search_by_coordinates(coordinates)
    render json: result.businesses[0..9]
  end

end
