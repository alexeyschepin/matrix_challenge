require_relative '../../test_helper'
require_relative '../../../models/route'

module Models
  class RouteTest < Minitest::Test
    def test_return_hash_with_correct_dates_format
      start_time = Time.parse '2030-12-31T22:00:01+09:00'
      end_time = Time.parse '2030-12-31T16:00:03+03:00'

      route = Models::Route.new(:sentinels, 'alpha', 'beta', start_time, end_time)
      route_hash = route.to_hash

      assert_equal '2030-12-31T13:00:01Z', route_hash[:start_time]
      assert_equal '2030-12-31T13:00:03Z', route_hash[:end_time]
    end
  end
end
