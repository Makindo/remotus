class TwitterStatusDenormalizer < Remotus::Denormalizer
  KEYS = [:id_str, :text, :coordinates]

  def initialize(status)
    @data = status.to_hash
  end

  def coordinates
    @data[:coordinates] || { :coordinates => [] }
  end

  def latitude
    coordinates[:coordinates].last
  end

  def longitude
    coordinates[:coordinates].first
  end

  def to_hash
    {
      external_id: @data[:id].to_s,
      text: @data[:text],
      latitude: latitude,
      longitude: longitude,
      data: @data,
      type: "TwitterStatus"
    }
  end
end
