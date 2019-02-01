require 'rake/testtask'

task default: :app

namespace :app do
  desc 'Matrix app'
  task :run do
    require_relative 'lib/core_extensions/hash/hash_recursive_merge'
    require_relative 'services/data_processor'
    Services::DataProcessor.new.run
  end
end

Rake::TestTask.new(:test) do |test|
  test.libs << 'test'
  test.test_files = FileList['test/unit/**/*_test.rb', 'test/integration/**/*_test.rb']
  test.verbose = false
end

namespace :test do
  Rake::TestTask.new(:units) do |test|
    test.libs << 'test'
    test.test_files = FileList['test/unit/**/*_test.rb']
    test.verbose = false
  end
  Rake::TestTask.new(:integrations) do |test|
    test.libs << 'test'
    test.test_files = FileList['test/integration/**/*_test.rb']
    test.verbose = false
  end
end
