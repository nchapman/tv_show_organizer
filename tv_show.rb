require 'date'
require 'tv_rage'

class TVShow
  @@lowercase = %w[and for but or so nor an a the of to in for on with as by at from vs]
  @@quality = %w[PDTV DSR DSRip DVDRip HDTV]
  
  attr_reader :episode, :season
  
  def initialize(file_name)
    @file_name = file_name
    parse_episode_and_season
  end
  
  def date
    DateTime.parse($1.gsub(/\./, '/'), true) if @file_name =~ /\.(\d+\.\d+\.\d+)\./
  end
  
  def extension
    File.extname @file_name
  end
  
  def parse_episode_and_season
    if @file_name =~ /.[Ss](\d+)[Ee](\d+)./
      @season  = $1.to_i
      @episode = $2.to_i
    elsif @file_name =~ /\.(\d{3,4})\./
      @season  = $1.rjust(4, '0')[0,2].to_i
      @episode = $1.rjust(4, '0')[2,2].to_i
    elsif @file_name =~ /\.(\d{1,2})x(\d{1,2})\./
      @season  = $1.to_i
      @episode = $2.to_i
    else
      @season  = nil
      @episode = nil
    end
  end
  
  def quality
    @@quality.each { |quality| return quality if @file_name.downcase.include?(quality.downcase) }
    nil
  end
  
  def show_name
    if @file_name =~ /^(.+)\.([Ss]\d+[Ee]\d+|\d+\.\d+\.\d+|\d{3,4}|\d{1,2}x\d{1,2})/
      $1.split(/\./).collect { |word| @@lowercase.include?(word.downcase) ? word.downcase : word.capitalize }.join(' ').gsub(/^\w/) { |f| f.upcase }
    end
  end
  
  def tv_rage
    @tv_rage || (@tv_rage = TVRage.new(show_name, season, episode))
  end
  
  def self.new_from_path(path)
    path_pieces = path.split('/').reverse
    
    if path_pieces.size >= 3
      if path_pieces[0] =~ /Episode\s+(\d+)\.(.+)/
        episode = $1
        extension = $2
      end
      
      season = path_pieces[1].sub(/^Season\s+/, '')
      show = path_pieces[2].gsub(/[^\w\s]/, '').gsub(/\s+/, '.')
    end
    
    if episode && extension && season && show
      self.new("#{show}.#{season}x#{episode}.#{extension}")
    else
      nil
    end
  end
end
