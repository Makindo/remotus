class GnipTwitterStatusDenormalizer
  def initialize(status)
    @data = status.to_hash
    @data.deep_symbolize_keys!
  end

  def coordinates
    @data[:geo][:coordinates]
  end

  def latitude
    coordinates.first
  end

  def longitude
    coordinates.last
  end

  def to_hash
    {
     external_id: @data[:object][:id].split(':').last,
     text: @data[:object][:summary],
     latitude: latitude,
     longitude: longitude,
     data: @data,
     type: "TwitterStatus"
    }
  end
end
