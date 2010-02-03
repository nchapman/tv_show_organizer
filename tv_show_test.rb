require 'test/unit'
require 'tv_show'

class TVShowTest < Test::Unit::TestCase
  def setup
    @daily_show = TVShow.new('the.daily.show.07.23.07.dsr.xvid-sys.[VTV].avi')
    @flight_of_the_conchords = TVShow.new('Flight.of.the.Conchords.S01E03.PDTV.XviD-NoTV.avi')
    @damages = TVShow.new('damages.101.ws.dsr-dimension.[VTV].avi')
    @house = TVShow.new('House.1x01.Pilot.WS_DVDRip_XviD-FoV.avi')
    @greys_anatomy = TVShow.new('Greys.Anatomy.s01e02.avi')
    @man_vs_wild = TVShow.new('Man.vs.Wild.S01E01.Moab.Desert.Utah.WS[goat].avi')
  end
  
  def test_show_name
    assert_equal "The Daily Show", @daily_show.show_name
    assert_equal "Flight of the Conchords", @flight_of_the_conchords.show_name
    assert_equal "Damages", @damages.show_name
    assert_equal "House", @house.show_name
    assert_equal "Greys Anatomy", @greys_anatomy.show_name
    assert_equal "Man vs Wild", @man_vs_wild.show_name
  end
  
  def test_tv_rage_show_name
    assert_equal "The Daily Show", @daily_show.tv_rage.show_name
    assert_equal "Flight of the Conchords", @flight_of_the_conchords.tv_rage.show_name
    assert_equal "Damages", @damages.tv_rage.show_name
    assert_equal "House", @house.tv_rage.show_name
    assert_equal "Grey's Anatomy", @greys_anatomy.tv_rage.show_name
    assert_equal "Man vs. Wild", @man_vs_wild.tv_rage.show_name
  end
  
  def test_season
    assert_nil @daily_show.season
    assert_equal 1, @flight_of_the_conchords.season
    assert_equal 1, @damages.season
    assert_equal 1, @house.season
    assert_equal 1, @greys_anatomy.season
    assert_equal 1, @man_vs_wild.season
  end
  
  def test_episode
    assert_nil @daily_show.episode
    assert_equal 3, @flight_of_the_conchords.episode
    assert_equal 1, @damages.episode
    assert_equal 1, @house.episode
    assert_equal 2, @greys_anatomy.episode
    assert_equal 1, @man_vs_wild.episode
  end
  
  def test_tv_rage_episode_name
    assert_nil @daily_show.tv_rage.episode_name
    assert_equal "Mugged", @flight_of_the_conchords.tv_rage.episode_name
    assert_equal "Pilot", @damages.tv_rage.episode_name
    assert_equal "Pilot", @house.tv_rage.episode_name
    assert_equal "The First Cut Is the Deepest", @greys_anatomy.tv_rage.episode_name
    assert_equal "Moab Desert, Utah", @man_vs_wild.tv_rage.episode_name
  end
  
  def test_quality
    assert_equal 'DSR', @daily_show.quality
    assert_equal 'PDTV', @flight_of_the_conchords.quality
    assert_equal 'DSR', @damages.quality
    assert_equal 'DVDRip', @house.quality
    assert_nil @greys_anatomy.quality
    assert_nil @man_vs_wild.quality
  end
  
  def test_date
    assert_not_nil @daily_show.date
    assert_equal '2007-07-23T00:00:00Z', @daily_show.date.to_s
    assert_nil @flight_of_the_conchords.date
    assert_nil @damages.date
    assert_nil @house.date
    assert_nil @greys_anatomy.date
    assert_nil @man_vs_wild.date
  end
  
  def test_new_from_path
    tv_show_from_path = TVShow.new_from_path("/Volumes/media/Video/xvid/TV/So You Think You Can Dance/Season 3/Episode 18.avi")
    
    assert_not_nil tv_show_from_path
    assert_equal 'Performance - Top Eight', tv_show_from_path.tv_rage.episode_name
  end
end