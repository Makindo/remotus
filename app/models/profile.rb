class Profile < ActiveRecord::Base
  include Remotus::Data
  include Remotus::External
  include Remotus::Provider

  has_many :statuses, dependent: :destroy
  has_many :geolocations, as: :source, dependent: :destroy

  validates_with ProfileValidator

  def fetch_data
    FetchProfileDataWorker.perform_async(id)
  end

  def fetch_timeline
    FetchTimelineWorker.perform_async(id)
  end

  def has_location?
    location.present?
  end

  def to_location
    GeolocationFacade.new(location).geolocation
  end

  def to_names
    PiplNameRemote.new(name).names
  end

  private

  def generate_names
    if person.present? && name.present?
      FetchNamesWorker.perform_async(id)
    end
  end

  def generate_geolocation
    if person.present? && has_location?
      FetchGeolocationWorker.perform_async(id)
    end
  end

  def increase_count(method_count)
    IncreaseDailyStatsWorker.perform_async(self.class.to_s, method_count)
  end

  def method_missint(method, *args, &block)
    if method.to_s =~ /^increase_(.+)_count$/
      increase_count($1)
    else
      super
    end
  end
end
