class Vote < ActiveRecord::Base
  belongs_to :status
  validates_uniqueness_of :status_id

  def rate(value)
    rating = value
    self.save
  end
end
