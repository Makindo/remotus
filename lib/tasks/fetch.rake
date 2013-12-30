namespace :fetch do
  desc "Fetch search results"
  task results: [:environment] do
    TwitterSearch.find_each(&:fetch_results)
  end
end
