class Vote < ActiveRecord::Base
  belongs_to :status

  validates_uniqueness_of :status_id

  def self.good
    where(value: true)
  end

  def self.bad
    where(value: false)
  end

  def rate(value)
    rate = value
    self.save
  end
end
