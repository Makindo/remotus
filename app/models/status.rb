class Status < ActiveRecord::Base
  include Remotus::Data
  include Remotus::External
  include Remotus::Provider

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

  def self.with_votes
    joins(:vote).where("votes.rating is not null")
  end

  def self.needs_review
    self.with_votes.where("votes.value = false")
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

  def like
    if vote then vote.update_attribute(:value, true) else create_vote(value: true) end
  end

  def dislike
    if vote then vote.update_attribute(:value, false) else create_vote(value: false) end
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
