class TwitterSearchResultsForm
  attr_reader :search
  attr_reader :statuses
  attr_reader :profiles

  def initialize(search, results)
    @search = search
    @statuses = results.map do |result|
      TwitterStatus.new(result[:status]).tap do |status|
        status.searches << @search
        status.profile = TwitterProfile.new(result[:profile])
        status.profile.statuses << status
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
        profile.save
      rescue ActiveRecord::RecordNotUnique
        original = Profile.where(profile.attributes.slice(:external_id, :type)).first
        status = profile.statuses.first
        status.profile = original
        Rails.logger.debug(profile.attributes)
        Rails.logger.warn("Profile wasn't unique")
      end
    end

    @statuses.each do |status|
      begin
        status.save
      rescue ActiveRecord::RecordNotUnique
        Rails.logger.debug(status.attributes)
        Rails.logger.warn("Status wasn't unique")
      end
    end
    @search.save
  end
end
