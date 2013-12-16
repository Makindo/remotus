require "spec_helper"

describe Search do
  before do 
    @search = Search.new(type: "TwitterSearch", query: "a Search")
    @expected_regex = /(.*)(a) (.*)(search)( |$|\.)(.*)/
  end

  it "Should be able to convert the query to a regex" do
    expect(@search.to_regex).to eql(@expected_regex)
  end

  it "should be able to create a query hash for stream searches" do
    expect(@search.query_regex[1]).to eql(@expected_regex)
  end

  it "should match a correct status" do
    expect(!!("this is a search".match(@search.to_regex))).to be_true
  end

  it "shouldn't match an incorrect status" do
    expect(!!("this a bad searching".match(@search.to_regex))).to_not be_true
  end
end
