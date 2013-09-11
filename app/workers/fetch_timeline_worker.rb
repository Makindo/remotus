class FetchTimelineWorker
  include Sidekiq::Worker
  include Remote::Worker::Fetcher

  sidekiq_options queue: :timelines

  def perform(id)
    @resource = Profile.find(id)
    records.save
  end

  private

  def remote_class
    "#{@resource.type}TimelineRemote".camelcase.constantize
  end

  def records
    form_class.new(@resource, remote_class.new(@resource.external_id).records)
  end

  def form_class
    "#{@resource.type}TimelineForm".camelcase.constantize
  end
end
