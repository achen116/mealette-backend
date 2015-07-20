class GeocodeController < ApplicationController
  def index
    geocodeResult = Geocoder.search(params[:address])
    latitude = geocodeResult[0].data['geometry']['location']['lat']
    longitude = geocodeResult[0].data['geometry']['location']['lng']
    coordinates = { latitude: latitude.to_f, longitude: longitude.to_f }
    result = Yelp.client.search_by_coordinates(coordinates)
    render json: result.businesses[0..9]
  end
end
