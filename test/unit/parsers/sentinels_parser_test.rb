require_relative '../../test_helper'
require_relative '../../../models/route'
require_relative '../../../parsers/sentinels_parser'

module Parsers
  class SentinelsParserTest < Minitest::Test
    def setup
      @unformatted_routes = [
        {
          route_id: '1',
          node: 'alpha',
          index: '0',
          time: '2030-12-31T22:00:01+09:00'
        }, {
          route_id: '1',
          node: 'beta',
          index: '1',
          time: '2030-12-31T18:00:02+05:00'
        }, {
          route_id: '1',
          node: 'gamma',
          index: '2',
          time: '2030-12-31T16:00:03+03:00'
        }, {
          route_id: '2',
          node: 'delta',
          index: '0',
          time: '2030-12-31T22:00:02+09:00'
        }, {
          route_id: '2',
          node: 'beta',
          index: '1',
          time: '2030-12-31T18:00:03+05:00'
        }, {
          route_id: '2',
          node: 'gamma',
          index: '2',
          time: '2030-12-31T16:00:04+03:00'
        }, {
          route_id: '3',
          node: 'zeta',
          index: '0',
          time: '2030-12-31T22:00:02+09:00'
        }
      ]
    end

    def test_read_returns_routes
      sentinels_parser = Parsers::SentinelsParser.new

      assert_equal @unformatted_routes, sentinels_parser.send(:read)
    end

    def test_format_returns_routes
      sentinels_parser = Parsers::SentinelsParser.new
      formatted_routes = [
        Models::Route.new('sentinels', 'alpha', 'gamma', Time.parse('2030-12-31T22:00:01+09:00'), Time.parse('2030-12-31T16:00:03+03:00')),
        Models::Route.new('sentinels', 'delta', 'gamma', Time.parse('2030-12-31T22:00:02+09:00'), Time.parse('2030-12-31T16:00:04+03:00')),
        Models::Route.new('sentinels', 'zeta', 'zeta', Time.parse('2030-12-31T22:00:02+09:00'), Time.parse('2030-12-31T22:00:02+09:00'))
      ]

      assert_equal formatted_routes, sentinels_parser.send(:format, @unformatted_routes)
    end
  end

  class SentinelsParser
    def dir
      'test/files/sentinels'
    end
  end
end
