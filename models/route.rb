module Models
  class Route < Struct.new(:source, :start_node, :end_node, :start_time, :end_time)
    def to_hash
      to_h.merge(
        start_time: start_time.utc.iso8601,
        end_time: end_time.utc.iso8601
      )
    end
  end
end
