require "test/unit"
require "tv_rage"

class TestTvRage < Test::Unit::TestCase
  def setup
    @greys_anatomy = TVRage.new('GreysAnatomy', 1, 2)
  end
  
  def test_show_name
    assert_equal("Grey's Anatomy", @greys_anatomy.show_name)
  end
  
  def test_show_url
    assert_equal('http://www.tvrage.com/Greys_Anatomy', @greys_anatomy.show_url)
  end
  
  def test_premiered
    assert_equal('2005', @greys_anatomy.premiered)
  end
  
  def test_episode_name
    assert_equal('The First Cut Is the Deepest', @greys_anatomy.episode_name)
  end
  
  def test_episode_url
    assert_equal('http://www.tvrage.com/Greys_Anatomy/episodes/71731', @greys_anatomy.episode_url)
  end
  
  def test_parse
    assert_nil(@greys_anatomy.parse(nil, nil))
    assert_nil(@greys_anatomy.parse('', ''))
  end
end