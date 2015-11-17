module LastFm
  class Fetch
    LASTFM_ARTIST = "get_weekly_artist_chart"
    LASTFM_ALBUM = "get_weekly_album_chart"
    LASTFM_TRACK = "get_weekly_track_chart"

    def fetch_chart(param = {})
      method = param[:method]
      user = param[:user]
      from = param[:from]
      to = param[:to]
      chart_size = param[:chart_size]
      format = param[:format]

      begin
        response = LastFM::User.send(method, :user => user, :from => from, :to => to).take(chart_size)
        if response.present?
          response.take(chart_size).map { |item| send(format, item) }
        else
          []
        end
      rescue
        []
      end
    end

    def new_artist(artist)
      Artist.new(:name => artist['name'], :url => artist['url'])
    end

    def new_album(album)
      response = @lastfm.album.get_info(:artist => album['artist']['content'],
                             :album => album['name'],
                             :mbid => album['mbid'],
                             :url => album['url'])
      Album.new(:title => response['name'],
                :artist => response['artist'],
                :url => response['url'],
                :cover => (response['image'].select{|img| img['size'] == 'large'}.first)['content'])
    end

    def new_track(track)
      Track.new(:title => track['name'],
                :artist => track['artist']['content'],
                :url => track['url'])
    end

    def get_charts(params = {})
      user = params[:user]
      years_ago = params[:years_ago]
      chart_size = params[:chart_size]

      last_year = Time.now - (years_ago * 365 * 24 * 60 * 60)

      #TODO: factor this out so it's not being repeated for every year
      chart = @lastfm.user.get_weekly_chart_list(:user => user).select { |c|
        c['from'].to_i <= last_year.to_i && c['to'].to_i >= last_year.to_i
      }.first

      return [[],[],[]] if chart.nil?

      artists = fetch_chart(:method => LASTFM_ARTIST,
                            :user => user,
                            :from => chart['from'], :to => chart['to'],
                            :chart_size => chart_size,
                            :format => "new_artist")

      albums = fetch_chart(:method => LASTFM_ALBUM,
                            :user => user,
                            :from => chart['from'], :to => chart['to'],
                            :chart_size => chart_size,
                            :format => "new_album")

      tracks = fetch_chart(:method => LASTFM_TRACK,
                           :user => user,
                           :from => chart['from'], :to => chart['to'],
                           :chart_size => chart_size,
                           :format => "new_track")

      [artists, albums, tracks]
    end
  end
end
