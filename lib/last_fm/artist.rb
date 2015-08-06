module LastFm
  class Artist
    attr_reader :name
    attr_reader :url

    def initialize(param = {})
      @name = param[:name]
      @url = param[:url]
      @url = "http://#{@url}" unless @url.start_with?("http://")
    end
  end
end
