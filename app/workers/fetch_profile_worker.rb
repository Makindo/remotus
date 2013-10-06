class FetchProfileDataWorker
  include Sidekiq::Worker
  include Remotus::Worker::Fetcher

  sidekiq_options queue: :profiles

  def perform(id)
    @resource = Profile.find(id)
    @resource.update_attributes(remote_class.new(@resource.external_id).record)
  end
end
