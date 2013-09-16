class Vote < ActiveRecord::Base
  belongs_to :status

  def self.good
    where(value: true)
  end

  def self.bad
    where(value: false)
  end
end
