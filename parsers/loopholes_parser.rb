require_relative 'abstract_parser'
require_relative '../models/route'

module Parsers
  class LoopholesParser < AbstractParser
    ROUTES_FILE = 'routes.json'.freeze
    NODE_PAIRS_FILE = 'node_pairs.json'.freeze

    private

    def read
      routes_file = File.read("#{dir}/#{ROUTES_FILE}")
      routes_hash = MultiJson.load(routes_file, symbolize_keys: true)

      node_pairs_file = File.read("#{dir}/#{NODE_PAIRS_FILE}")
      node_pairs_hash = MultiJson.load(node_pairs_file, symbolize_keys: true)

      routes = routes_hash[:routes]
      routes.each do |r|
        node_pair = node_pairs_hash[:node_pairs].find { |p| p[:id] == r[:node_pair_id] }
        r.merge!(node_pair) if node_pair
      end
      routes
    end

    def format(routes)
      unique_route_ids = routes.map { |r| r[:route_id] }.uniq

      unique_route_ids.map do |route_id|
        routes_with_same_id = routes.select { |r| r[:route_id] == route_id }
                                    .sort_by { |r| r[:start_time] }
        next unless routes_with_same_id.first[:start_node] || routes_with_same_id.last[:end_node]

        Models::Route.new(
          type,
          routes_with_same_id.first[:start_node],
          routes_with_same_id.last[:end_node],
          Time.parse(routes_with_same_id.first[:start_time]),
          Time.parse(routes_with_same_id.last[:end_time])
        )
      end.compact
    end
  end
end
