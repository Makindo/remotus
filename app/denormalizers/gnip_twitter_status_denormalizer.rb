class GnipTwitterStatusDenormalizer
  def initialize(status)
    @data = status.to_hash
    @data.deep_symbolize_keys!
  end

  def coordinates
    if @data.has_key?(:geo)
      @data[:geo][:coordinates]
    else
      [nil, nil]
    end
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
     text: @data[:body],
     latitude: latitude,
     longitude: longitude,
     data: @data,
     type: "TwitterStatus"
    }
  end
end
