module WhenIWork

  class Avatar
    attr_reader :url, :size
    def initialize(hash)
      @url = hash['url']
      @size = hash['size']
    end
  end

end