require_relative 'sentinels_parser'
require_relative 'sniffers_parser'
require_relative 'loopholes_parser'

module Parsers
  class Factory
    TYPES = %i[sentinels sniffers loopholes].freeze
    def self.build(type)
      Object.const_get('Parsers').const_get("#{type.capitalize}Parser")
    end
  end
end
