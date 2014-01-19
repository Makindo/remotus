namespace :fetch do
  desc "Fetch search results"
  task results: [:environment] do
    TwitterSearch.find_each(&:fetch_results)
  end

  desc "fetch gnip results"
  task gnip_results: :environment do
    TwitterSearch.find_each(&:fetch_gnip_results)
  end
end
