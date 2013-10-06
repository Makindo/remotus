class FetchSearchWorker
  include Sidekiq::Worker
  include Remotus::Worker::Fetcher

  sidekiq_options queue: :searches

  def perform(id)
    @resource = Search.find(id)
    records.save
  end

  private

  def records
    form_class.new(@resource, remote_class.new(@resource.query).records)
  end

  def form_class
    "#{@resource.type}ResultsForm".camelcase.constantize
  end
end
