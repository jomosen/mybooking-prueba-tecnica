require 'rake'

require_relative 'config/application'

task :basic_environment do
  desc "Basic environment"
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

namespace :foo do
  desc "Foo task"
  task :bar do
    puts "Foo bar"
  end
end
