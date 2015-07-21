class ApiController < ApplicationController

  def index
    if params[:address]
      geocodeResult = Geocoder.search(params[:address])

      if geocodeResult[0].data['geometry']['location']
        latitude = geocodeResult[0].data['geometry']['location']['lat'].to_f
        longitude = geocodeResult[0].data['geometry']['location']['lng'].to_f
      else
        return render json: {error: "Geocode failed", status: 400}
      end
    else
      latitude = params[:lat].to_f
      longitude = params[:lon].to_f
    end

    coordinates = { latitude: latitude, longitude: longitude }
    result = Yelp.client.search_by_coordinates(coordinates)

    if !result.businesses || result.businesses.length < 10
      return render json: {error: "No businesses found", status: 400}
    else
      return render json: result.businesses[0..9]
    end
  end

end
