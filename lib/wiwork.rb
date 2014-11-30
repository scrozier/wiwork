require File.dirname(__FILE__) + '/wiwapi_object'

Dir[File.dirname(__FILE__) + '/wiwork/*.rb'].each do |file|
  require file
end

Dir[File.dirname(__FILE__) + '/wiwork/methods/*.rb'].each do |file|
  require file
end

module WhenIWork
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :logging

    def initialize
      @logging = false
    end
  end
end