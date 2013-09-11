module Remote
  module External
    extend ActiveSupport::Concern

    included do
      validate :external_id, uniqueness: true
      validates_with ExternalValidator

      before_destroy :add_to_junk
    end

    module ClassMethods
      def existing
        where { gone.eq(false) }
      end

      def junk?(id)
        REDIS.sismember(self, id)
      end
    end

    def add_to_junk
      REDIS.sadd(self.class, external_id)
    end
  end
end
