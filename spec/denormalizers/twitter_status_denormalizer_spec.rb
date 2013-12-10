require "spec_helper"

 describe TwitterStatusDenormalizer do
   before do
     @status = Twitter::Tweet.new(id: 1, id_str: "1", text: "a tweet to test status denormalizer",
                                 :coordinates => {type: "Point", :coordinates => [122.3331, 47.6097]})
     @denormalized_tweet = described_class.new(@status)
   end

   it "should be convertable to a hash" do
     expect(@denormalized_tweet.to_hash[:external_id]).to be_eql("1")
   end
   
   it "should have the correct longitude and latitude" do
     expect(@denormalized_tweet.latitude).should == 47.6097
     expect(@denormalized_tweet.longitude).should == 122.3331
   end
 end
   
