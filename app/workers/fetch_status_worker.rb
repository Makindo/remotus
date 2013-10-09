class FetchStatusWorker
  include Sidekiq::Worker
  include Remotus::Worker::Fetcher

  sidekiq_options queue: :statuses

  def perform(id)
    @resource = Status.find(id)
    @resource.update_attributes(remote_class.new(@resource.external_id).record)
  end
end
