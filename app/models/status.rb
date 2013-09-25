class Status < ActiveRecord::Base
  include Remote::Data
  include Remote::External
  include Remote::Provider

  belongs_to :profile
  has_and_belongs_to_many :searches
  has_one :geolocation
  has_one :vote

  validates_with StatusValidator

  def self.nonbad
    joins(:vote).where { id.not_in(Vote.pluck(:id)) | vote.value.eq(true) }
  end

  def self.neutral
    where { id.not_in(Vote.pluck(:id)) }
  end

  def self.good
    joins(:vote).where { vote.value.eq(true) }
  end

  def self.bad
    joins(:vote).where { vote.value.eq(false) }
  end

  def self.result
    joins(:searches).where { searches_statuses.status_id.eq(statuses.id) }
  end

  def disliked?
    !vote.value? if vote.present?
  end

  def liked?
    vote.value? if vote.present?
  end

  def fetch_data
    FetchStatusDataWorker.perform_async(id)
  end

  def has_location?
    latitude.present? && longitude.present?
  end

  def to_geolocation
    GeolocationFacade.new([latitude, longitude]).geolocation
  end

  private

  def generate_geolocation
    if profile.person.present? && has_location?
      FetchGeolocationWorker.perform_async(id)
    end
  end
end
