if ENV['CI'] == 'true'
  require 'simplecov'
  SimpleCov.start
  require 'codecov'

  SimpleCov::Formatter::Codecov.class_eval do
    def shortened_filename(file)
      file.filename.gsub(/^#{SimpleCov.root}/, './checkout').gsub(/^\.\//, '')
    end
  end

  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

require 'pry-byebug'
require 'market_town/checkout'
