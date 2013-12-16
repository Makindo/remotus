class FacebookProfileDenormalizer < Remotus::Denormalizer
  KEYS = [:id, :first_name, :last_name,:username,:gender, :locale]
  
  def initialize(profile)
    @data = profile.to_hash
  end

  def to_hash
    {
     external_id: attributes.id,
     name: "#{attributes.first_name} #{attributes.last_name}",
     username: attributes.username,
     data: @data,
     type: "FacebookProfile"
    }
  end
end
