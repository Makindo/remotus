class Status < ActiveRecord::Base
  include Remotus::Data
  include Remotus::External
  include Remotus::Provider

  delegate :match_percentage, to: :vote
  delegate :human_reviewed, to: :vote
  delegate :machine_reviewed, to: :vote
  delegate :matched_status_id, to: :vote

  belongs_to :profile
  has_and_belongs_to_many :searches
  has_one :geolocation
  has_one :vote
  accepts_nested_attributes_for :vote
  before_save :save_vote
  after_save :build_vote

  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode

  validates_with StatusValidator

  def self.result
    joins(:searches).where { searches_statuses.status_id.eq(statuses.id) }
  end

  def self.without_votes
    joins(:vote).where("votes.rating is null")
  end

  def self.with_votes
    joins(:vote).where("votes.rating is not null")
  end

  def self.needs_review
    joins(:vote).where("votes.machine_reviewed = true and votes.human_reviewed = false")
  end

  def self.have_not_been_rated
    joins(:vote).where("votes.machine_reviewed = false and votes.human_reviewed = false")
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

  def rating
    vote.rating
  end

  def rate(rating)
    vote || build_vote
    vote.rate(rating)
  end

  def build_vote
    vote = Vote.new(status_id: self.id) if vote.blank?
    vote.save if vote.present?
  end
  
  private

  def generate_geolocation
    if profile.person.present? && has_location?
      FetchGeolocationWorker.perform_async(id)
    end
  end

  def save_vote
    vote.save if vote.present?
  end
end
