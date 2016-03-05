module Charts
  @@CHART_SIZE = 6 # should be divisible by rows
  @@ROWS = 2

  def self.v1(username, max_years=4)
    fetch = LastFm::Fetch.new
    years = []

    years_ago = 1
    while years.size < max_years && years_ago < 12 #chosen arbitrarily, idk
      (artists, albums, tracks) = fetch.get_charts(:user => username,
                          :years_ago => years_ago,
                          :chart_size => @@CHART_SIZE)

      result = {
        num: years_ago,
        plural: (years_ago == 1)? "" : "s",
        album_rows:
          albums.nil? ? [] : albums.each_slice(@@CHART_SIZE / @@ROWS).map { |row|
            { albums: row }
          },
        artists: artists,
        tracks: tracks
      }

      years << result if albums.present? && albums.size >= 3
      years_ago += 1
    end

    if years.select { |y| y[:album_rows].present? }.present?
      years
    else
      {}
    end
  end
end
