module LastFm
  class Track
    attr_reader :title
    attr_reader :artist
    attr_reader :url

    def initialize(param = {})
      @title = param[:title]
      @artist = param[:artist]
      @url = param[:url]
      @url = "http://#{@url}" unless @url.start_with?("http://")
    end
  end
end
