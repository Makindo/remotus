require "spec_helper"

describe TwitterStreamResultsForm do
  before do
    @status = Twitter::Status.new(id: 1, id_str: "1", text: "a test tweet", 
                                 user: {
                                        id: 1,
                                        id_str: "1",
                                        name: "Test User",
                                        screen_name: "tester"
                                       })
    @search = Search.new(query: "test")
    @form = described_class.new(@search, @status)
  end

  it "should be valid" do
    expect(@form).to be_valid
  end

  it "should have a profile" do
    expect(@form).to respond_to(:profile)
  end

  it "should have a status" do
    expect(@form).to respond_to(:status)
  end

  it "should have a search" do
    expect(@form).to respond_to(:search)
  end

  it "should be saveable" do
    expect(@form).to respond_to(:save)
  end
end
