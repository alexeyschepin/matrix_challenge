require 'csv'

require_relative 'abstract_parser'
require_relative '../models/route'

module Parsers
  class SentinelsParser < AbstractParser
    ROUTES_FILE = 'routes.csv'.freeze

    private

    def read
      routes = []
      CSV.foreach("#{dir}/#{ROUTES_FILE}", CSV_OPTIONS) do |row|
        routes << row.to_hash
      end
      routes
    end

    def format(routes)
      unique_route_ids = routes.map { |r| r[:route_id] }.uniq

      unique_route_ids.map do |route_id|
        routes_with_same_id = routes.select { |r| r[:route_id] == route_id }
                                    .sort_by { |r| r[:index] }
        Models::Route.new(
          type,
          routes_with_same_id.first[:node],
          routes_with_same_id.last[:node],
          Time.parse(routes_with_same_id.first[:time]),
          Time.parse(routes_with_same_id.last[:time])
        )
      end
    end
  end
end
