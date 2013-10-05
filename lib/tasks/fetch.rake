namespace :fetch do
  desc "Fetch search results"
  task results: [:environment] do
    Search.find_each(&:fetch_results)
  end
end
