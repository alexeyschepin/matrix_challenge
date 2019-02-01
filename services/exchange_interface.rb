require 'httparty'

module Services
  class ExchangeInterface
    include HTTParty

    base_uri 'challenge.distribusion.com/the_one'

    attr_accessor :passphrase

    def options
      {
        headers: { Accept: 'application/json' },
        query: { passphrase: @passphrase }
      }
    end

    def wakeup
      self.class.get('/', options)
    end

    def take_red(path)
      self.class.get(path, options)
    end

    def download_routes(type)
      filename = "tmp/#{type}.zip"
      File.open(filename, 'w') do |file|
        n_options = options.rmerge(
          query: { source: type },
          stream_body: true
        )
        self.class.get('/routes', n_options) { |fragment| file.write(fragment) }
      end
    end

    def post_route(hash_route)
      n_options = options.rmerge(
        body: hash_route,
        stream_body: true
      )
      self.class.post('/routes', n_options)
    end
  end
end
