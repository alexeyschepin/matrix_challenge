require 'multi_json'

require_relative 'exchange_interface'
require_relative 'unzip_file'
require_relative '../parsers/factory'

module Services
  class DataProcessor
    TMP_DIR = 'tmp'.freeze

    def run
      @exchange_interface = Services::ExchangeInterface.new
      wakeup
      take_red
      Parsers::Factory::TYPES.each { |type| process_type(type) }
      cleanup
    end

    private

    def wakeup
      response = @exchange_interface.wakeup
      json = MultiJson.load(response.body, symbolize_keys: true)
      @red_pill = json[:pills][:red]
      @exchange_interface.passphrase = @red_pill[:passphrase]
      puts json[:"(\u2310\u25A0_\u25A0)"]
    end

    def take_red
      @exchange_interface.take_red(@red_pill[:location])
      puts 'You took red. There is no way back'
    end

    def process_type(type)
      @exchange_interface.download_routes(type)
      Services::UnzipFile.run("#{TMP_DIR}/#{type}.zip")
      routes = Parsers::Factory.build(type).new.parse
      routes.each do |r|
        response = @exchange_interface.post_route(r.to_hash)
        puts "Response code: #{response.code}"
      end
    end

    def cleanup
      FileUtils.rm_rf("#{TMP_DIR}/.", secure: true)
      puts 'Cleanup tmp files'
    end
  end
end
