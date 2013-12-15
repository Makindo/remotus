class FacebookProfileRemote
  def initialize(query)
    begin
      @client = Remotus::RemoteFacebook.client
      @profile = @client.get_object(query)
      @form = FacebookProfileResultsForm.new(@profile)
    rescue Koala::Facebook::ClientError => error
      warn "Facebook client malfunctioned #{error}"
    rescue Koala::Facebook::ServerError => error
      warn "facebook server malfunctioned #{error}"
      sleep(rand(10..20).minutes) and retry
    end
  end
end
