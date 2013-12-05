class TwitterSearchResultsForm
  attr_reader :search
  attr_reader :statuses
  attr_reader :profiles

  def initialize(search, results, geolocation_id = nil)
    unless geolocation_id.blank?
      search_geolocation = Geolocation.find(geolocation_id)
      @geolocation = TwitterSearchLocation.clone_geo(search_geolocation)
    end
    @search = search
    @statuses = results.map do |result|
      TwitterStatus.new(result[:status]).tap do |status|
        status.searches << @search
        status.profile = TwitterProfile.new(result[:profile])
        status.profile.statuses << status
        unless @geolocation.blank?
          status.profile.geolocations << @geolocation
          @geolocation.save
        end
      end
    end

    @profiles = @statuses.map(&:profile)
  end

  def valid?
    @statuses.all?(&:valid?) && @search.valid?
  end

  def errors
    @statuses.map(&:errors) + @profiles.map(&:errors) << @search.errors
  end

  def save
    @profiles.each do |profile|
      begin
        profile.save if profile.valid?
        profile.geolocations.each do |geo|
          geo.save if geo.valid?
        end
      rescue ActiveRecord::RecordNotUnique
        original = Profile.where(profile.attributes.slice(:external_id, :type)).first
        status = profile.statuses.first
        status.profile = original
      end
    end

    @statuses.each do |status|
      begin
        status.save if status.valid?
      end
    end
    @search.save
  end
end
