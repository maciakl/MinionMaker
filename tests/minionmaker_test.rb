require 'minitest/autorun'
require 'purdytest'
require_relative '../minionmaker'

class TestMinionFactoryWithMockData < Minitest::Test

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

  def test_name_pick
    choice = @mm.name_pick('Human', 'Male', 'Commoner')
    assert_equal 'Jon Smith', choice


    choice = @mm.name_pick('Orc', 'Female', 'Noble')
    assert_empty choice
  end
  
end

class TestMinionFactoryWIthRealData < Minitest::Test

  def setup
    @mm = MinionFactory.new
    @minion = @mm.get_minion
  end

  def test_minion_object
    assert_instance_of Minion, @minion
    assert_kind_of String, @minion.race
    assert_kind_of String, @minion.gender
    assert_kind_of String, @minion.class
    assert_kind_of String, @minion.social
    assert_kind_of Array, @minion.trait
    #assert_kind_of String, @minion.traits
    assert_kind_of String, @minion.hate
    #assert_kind_of String, @minion.hates
    assert_kind_of String, @minion.fear
    #assert_kind_of String, @minion.fears
    assert_kind_of String, @minion.eyes
    assert_kind_of String, @minion.hair
    assert_kind_of String, @minion.skin
    assert_kind_of String, @minion.features
    assert_kind_of String, @minion.name
    assert_kind_of String, @minion.primary_weapon
    assert_kind_of String, @minion.weapon_type
    assert_kind_of String, @minion.secondary_weapon
    assert_kind_of String, @minion.secondary_weapon
    assert_kind_of String, @minion.armor
    assert_kind_of String, @minion.armor_category
    assert_kind_of String, @minion.armor_type
  end



end
