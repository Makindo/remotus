class BingGeolocationRemote
  include Remotus::Remote

  def initialize(id)
    @geolocation = Geolocation.find(id)

    if @geolocation.city.present?
      @result_location = Geocoder.search(@geolocation.city).first
    elsif @geolocation.latitude.present? && @geolocation.longitude.present?
      @result_location = Geocoder.search([@geolocation.latitude,@geolocation.longitude]).first
    else
      warn("Not enough location to find Geolocation")
    end

    @city = @result_location.city || @geolocation.city
    @state = @result_location.state || @geolocation.state
    @country = @result_location.country || @geolocation.country
    @latitude = @result_location.latitude || @geolocation.latitude
    @longitude = @result_location.longitude || @geolocation.longitude
  end

  def record
    {
      city: @city,
      state: @state,
      country: @country,
      latitude: @latitude,
      longitude: @longitude,
      zip: @zip,
      data: @result_location
    }
  end
end
