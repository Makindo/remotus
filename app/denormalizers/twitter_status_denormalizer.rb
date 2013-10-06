class TwitterStatusDenormalizer < Remotus::Denormalizer
  KEYS = [:id_str, :text, :coordinates]

  def initialize(status)
    @data = status.to_hash
  end

  def coordinates
    attributes.coordinates || { "coordinates" => [] }
  end

  def latitude
    coordinates["coordinates"].first
  end

  def longitude
    coordinates["coordinates"].last
  end

  def to_hash
    {
      external_id: attributes.id_str,
      text: attributes.text,
      latitude: latitude,
      longitude: longitude,
      data: @data,
      type: "TwitterStatus"
    }
  end
end
