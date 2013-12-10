require "spec_helper"

describe TwitterSearchResultsForm do
  before do
    @statuses = []
    (1..3).each do |number| 
          @statuses << Twitter::Status.new(id: number, id_str: "#{number}", text: "a test tweet, number #{number}", 
                                 user: {
                                        id: number,
                                        id_str: "#{number}",
                                        name: "Test User #{number}",
                                        screen_name: "tester_#{number}"
                                       })
    end
    @results = @statuses.map { |status| TwitterSearchDenormalizer.new(status).to_hash }
    @search = Search.new(query: "search_results_form")
    @form = described_class.new(@search, @results)
  end

  it "should be valid" do
    expect(@form).to be_valid
  end
end
