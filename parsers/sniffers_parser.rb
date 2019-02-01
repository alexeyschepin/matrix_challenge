require 'csv'

require_relative 'abstract_parser'
require_relative '../models/route'

module Parsers
  class SniffersParser < AbstractParser
    SEQUENCES_FILE = 'sequences.csv'.freeze
    ROUTES_FILE = 'routes.csv'.freeze
    NODE_TIMES_FILE = 'node_times.csv'.freeze

    private

    def read
      routes = []
      CSV.foreach("#{dir}/#{SEQUENCES_FILE}", CSV_OPTIONS) do |row|
        routes << row.to_hash
      end

      CSV.foreach("#{dir}/#{ROUTES_FILE}", CSV_OPTIONS) do |row|
        routes.select do |r|
          r[:route_id] == row.to_hash[:route_id]
        end.each { |r| r.merge!(row) }
      end

      CSV.foreach("#{dir}/#{NODE_TIMES_FILE}", CSV_OPTIONS) do |row|
        routes.select do |r|
          r[:node_time_id] == row.to_hash[:node_time_id]
        end.each { |r| r.merge!(row) }
      end
      routes
    end

    def format(routes)
      unique_route_ids = routes.map { |r| r[:route_id] }.uniq

      unique_route_ids.map do |route_id|
        routes_with_same_id = routes.select { |r| r[:route_id] == route_id }
                                    .sort_by { |r| r[:node_time_id] }

        start_time = Time.parse(routes_with_same_id.first[:time])
        end_time = routes_with_same_id.inject(start_time) do |time, route|
          time + route[:duration_in_milliseconds].to_i / 1000
        end

        Models::Route.new(
          type,
          routes_with_same_id.first[:start_node],
          routes_with_same_id.last[:end_node],
          start_time,
          end_time
        )
      end
    end
  end
end
