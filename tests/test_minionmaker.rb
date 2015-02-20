require 'minitest/autorun'
require_relative '../minionmaker'

class TestMinionMaker < Minitest::Test

  def setup
    @mm = MinionFactory.new
    @mm.instance_variable_set(:@data, YAML.load_file(File.join(__dir__,'mockdata.yml')))
    @mm.instance_variable_set(:@names, YAML.load_file(File.join(__dir__, 'mocknames.yml')))
    @minion = @mm.get_minion
  end

  def test_minion_object
    refute_nil @minion
    assert_instance_of Minion, @minion
    assert_equal 'Human', @minion.race
    assert_equal 'Male', @minion.gender
    assert_equal 'Warrior', @minion.class
    assert_equal 'Commoner', @minion.social
    assert_equal ['Greedy'], @minion.trait
    assert_equal 'Greedy.', @minion.traits
    assert_equal 'other Humans', @minion.hate
    assert_equal 'Hates other Humans.', @minion.hates
    assert_equal 'snakes', @minion.fear
    assert_equal 'Fears snakes.', @minion.fears
    assert_equal 'brown', @minion.eyes
    assert_equal 'short, brown', @minion.hair
    assert_equal 'pale', @minion.skin
    assert_equal 'square jaw', @minion.features
    assert_equal 'Jon Smith', @minion.name
    assert_equal 'Sword', @minion.primary_weapon
    assert_equal 'steel', @minion.weapon_type
    assert_equal 'Bolas', @minion.secondary_weapon
    assert_equal 'Bolas', @minion.secondary_weapon
    assert_equal 'full plate armor', @minion.armor
    assert_equal 'Plate', @minion.armor_category
    assert_equal 'steel', @minion.armor_type
  end

  def test_category_pick
    choice = @mm.category_pick('Orc', 'hair_color')
    assert_equal 'brown', choice
  end

  def test_indirect_category_pick
    choice = @mm.indirect_category_pick('Rogue', 'primary_weapon')
    assert_equal 'Sword', choice
  end

  def test_direct_category_pick
    choice = @mm.direct_category_pick('Rogue', 'armor', 'Plate' )
    assert_equal  'full plate armor', choice
  end
  
end
