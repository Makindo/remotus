class Search < ActiveRecord::Base
  include Remotus::Provider

  after_create :fetch_results

  has_and_belongs_to_many :statuses
  belongs_to :account

  validates_uniqueness_of :query, :scope => [:account_id, :type]
  validates_with SearchValidator

  def fetch_results
    FetchSearchWorker.perform_async(id)
  end

  def training_set
    statuses.with_votes.where("votes.human_reviewed = true")
  end

  def training_set_hash(base_status_id = 0)
    results = Array.new
    training_set.limit(500).pluck(:id, :text).each do |status| 
      unless status[0] == base_status_id
        results << {id: status[0], text: status[1]}
      end
    end
    if results.size > ENV["MIN_TRAINING_SET_SIZE"].to_i then results else nil end
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
