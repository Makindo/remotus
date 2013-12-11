require "spec_helper"

describe Search do
  before do 
    @search = Search.new(type: "TwitterSearch", query: "a Search")
  end

  it "Should be able to convert the query to a regex" do
    expect(@search.to_regex).to eql(/(.*)(a) (.*)(search)(.*)/)
  end

  it "should be able to create a query hash for stream searches" do
    expect(@search.query_regex[1]).to eql(/(.*)(a) (.*)(search)(.*)/)
  end
end
