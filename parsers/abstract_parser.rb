module Parsers
  class AbstractParser
    CSV_OPTIONS = {
      quote_char: '"',
      col_sep: ', ',
      headers: true,
      header_converters: :symbol
    }

    def parse
      routes = read
      format(routes)
    end

    def type
      self.class.to_s[/Parsers::(.*?)Parser/m, 1].downcase
    end

    private

    def read
      raise NotImplementedError, 'You should implement this method'
    end

    def format(_routes)
      raise NotImplementedError, 'You should implement this method'
    end

    def dir
      "tmp/#{type}"
    end
  end
end
