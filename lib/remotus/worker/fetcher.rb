module Remotus
  module Worker
    module Fetcher
      private
      def remote_class
        "#{@resource.type}Remote".camelcase.constantize
      end
    end
  end
end
