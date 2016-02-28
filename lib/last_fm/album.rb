module LastFm
  class Album
    attr_reader :title
    attr_reader :artist
    attr_reader :cover
    attr_reader :url

    def initialize(param = {})
      @title = param[:title]
      @cover = param[:cover].present? ? param[:cover] : 'backtracks-greyscale-medium.png'
      @artist = param[:artist]
      @url = param[:url]
      @url = "http://#{@url}" unless @url.start_with?("http://")
    end
  end
end
