require "spec_helper"

describe TwitterStreamRemote do
  before do
    @search = Search.new(type: "TwitterSearch", query: "a test query", active: true)
    @search.save
  end
  
  it "should be able to create a new remote with query regexs" do
    @remote = TwitterStreamRemote.new([], 1)
    expect(@remote.instance_variable_get(:@regexs)).to_not be_blank
    regexs  = @remote.instance_variable_get(:@regexs)
    expect(regexs[@search.id]).should == /(.*)(a) (.*)(test) (.*)(query)(.*)/
  end
end
