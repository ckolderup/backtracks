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
        response = LastFM::User.send(method, :user => user, :from => from, :to => to)
        if response.present?
          # .first.first bullshit thanks to the new lastfm API response changes
          # TODO: clean this up, ideally with ruby 2.3 and Hash#dig
          artists = response.values.first.values.first
          artists.take(chart_size).map { |item| send(format, item) }
        else
          []
        end
      rescue StandardError => error
        # TODO: send to some sort of logger
        []
      end
    end

    def new_artist(artist)
      { name: artist['name'],
        url: artist['url'].start_with?('http://') ? artist['url'] : "http://#{artist['url']}" }
    end

    def new_album(album)
      response = LastFM::Album.get_info(:artist => album['artist']['#text'],
                             :album => album['name'],
                             :mbid => album['mbid'],
                             :url => album['url'])
      {
        :title => album['name'],
        :artist => album['artist']['#text'],
        :url => album['url'].start_with?('http://') ? album['url'] : "http://#{album['url']}",
        :cover => (response['album']['image'].select{|img| img['size'] == 'large'}.first)['#text'] || 'http://backtracks.co/public/images/backtracks-greyscale-medium.png' #TODO: return nil and push this into the mailer where we can generate a thumbprinted asset tag
      }
    end

    def new_track(track)
      {
        :title => track['name'],
        :artist => track['artist']['#text'],
        :url => track['url'].start_with?('http://') ? track['url'] : "http://#{track['url']}"
      }
    end

    def get_charts(params = {})
      user = params[:user]
      years_ago = params[:years_ago]
      chart_size = params[:chart_size]

      last_year = Time.now - (years_ago * 365 * 24 * 60 * 60)

      #TODO: factor this out so it's not being repeated for every year
      response = LastFM::User.get_weekly_chart_list(:user => user)

      charts = response["weeklychartlist"] && response["weeklychartlist"]["chart"]

      chart = charts.select { |c|
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
