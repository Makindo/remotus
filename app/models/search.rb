class Search < ActiveRecord::Base
  include Remote::Provider

  after_create :fetch_results

  has_and_belongs_to_many :statuses

  validates :query, uniqueness: true
  validates_with SearchValidator

  def fetch_results
    FetchSearchWorker.perform_async(id)
  end
end
