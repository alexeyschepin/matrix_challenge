require 'zip'

module Services
  class UnzipFile
    class << self
      def run(filename)
        dir = File.dirname(filename)
        Zip::File.open(filename) do |zip_file|
          zip_file.each { |entry| entry.extract("#{dir}/#{entry.name}") }
        end
      end
    end
  end
end
