class Search < ActiveRecord::Base
  include Remotus::Provider

  after_create :fetch_results

  has_and_belongs_to_many :statuses
  belongs_to :account

  validates :query, uniqueness: true
  validates_with SearchValidator

  def fetch_results
    FetchSearchWorker.perform_async(id)
  end

  def geolocations
    Geolocation.where(source_type: "search", source_id: self.id)
  end

  def to_regex
    Regexp.new(query.downcase.gsub(/[a-z]+/, '(\&)').gsub(/ /, " (.*)").gsub(/$/, "( |$|\\.)(.*)").gsub(/^/, "(.*)"))
  end

  def query_regex
    [id, to_regex]
  end
end
