class ApiController < ApplicationController

  def index
    # Check for geolocation ====================================================
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

    # Check for category filter ===============================================
    if params[:category]
      category = {term: params[:category]}
    else
      category = {term: 'food'}
    end

    # Check for shuffle =======================================================
    x = 0
    y = 9
    result_range = x..y

    p '^'*100
    p result_range
    p '^'*100

    counter = params[:repopulate].to_i if params[:repopulate]

    if params[:repopulate]
        x += counter * 10
        y += counter * 10
        result_range = x..y
        p '$'*100
        p result_range
        p '$'*100

    end

        p '*'*100
        p result_range
        p '*'*100

    # Yelp API Query ==========================================================
    result = Yelp.client.search_by_coordinates(coordinates, category)

    p "-- "
    p result.businesses.length
    p "-- "

    if !result.businesses || result.businesses.length < 10
      return render json: {error: "No businesses found", status: 400}
    else
      return render json: result.businesses[result_range]
    end
  end

end
