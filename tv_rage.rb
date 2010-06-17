require 'open-uri'

class TVRage
  attr_reader :show_name, :show_url, :premiered, :episode_name, :episode_url
  
  def initialize(show, season, episode)
    if show
      @show, @season, @episode = show.gsub(/\s/, '_'), season, episode
      load_quick_info
    end
  end
  
  def load_quick_info
    url = "http://services.tvrage.com/tools/quickinfo.php?show=#{@show}&ep=#{@season.to_s.rjust(2, '0')}x#{@episode.to_s.rjust(2, '0')}"

    result = open(url).string
    
    @show_name = parse 'Show Name', result
    @show_url  = parse 'Show URL', result
    @premiered = parse 'Premiered', result

    if result =~ /^Episode Info@(.+)\^(.+)\^(.+)$/
      @episode_name = $2
    else
      @episode_name = nil
    end
    
    @episode_url = parse 'Episode URL', result
  end
  
  def parse(key, text)
    $1 if text =~ /^#{key}@(.*?)$/
  end
end
