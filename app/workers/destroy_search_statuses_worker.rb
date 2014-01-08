class DestroySearchWorker
  include Sidekiq::Worker

  def perform(id)
    @search = Search.find(id)
    @search.statuses.each do |status| 
      if status.searches.size == 1 && status.searches.first.id == @search.id
        status.destroy
      end
    end
    @search.destroy
  end
end
