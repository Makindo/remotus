class Profile < ActiveRecord::Base
  include Remote::Data
  include Remote::External

  has_many :statuses, dependent: :destroy
  has_one :geolocation, as: :source

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
end
