module Remote
  module Data
    extend ActiveSupport::Concern

    included do
      serialize :data, JSON
    end
  end
end
