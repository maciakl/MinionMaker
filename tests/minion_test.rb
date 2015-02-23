require 'minitest/autorun'
require 'purdytest'
require_relative '../minionmaker'

class TestMinion < Minitest::Test

  def setup
    @minion = Minion.new
    @minion.race = 'Human'
    @minion.gender = 'Man'
    @minion.class = 'Warrior'
    @minion.social = 'Commoner'
    @minion.primary_weapon = 'Sword'
    @minion.weapon_type = 'steel'
    @minion.secondary_weapon = 'Bolas'
    @minion.armor_category = 'Plate'
    @minion.armor = 'cuirass'
    @minion.armor_type = 'steel'
    @minion.trait = ['Cruel', 'Greedy']
    @minion.hate = 'Orcs'
    @minion.fear = 'snakes'
    @minion.eyes = 'brown'
    @minion.hair = 'brown'
    @minion.skin = 'olive'
    @minion.features = 'square jaw'
    @minion.name = 'John Smith'

  end

  def test_traits
    refute_empty @minion.traits
    assert_equal 'Cruel, Greedy.', @minion.traits
  end

  def test_hates
    refute_empty @minion.hates
    assert_equal 'Hates Orcs.', @minion.hates
  end

  def test_fears
    refute_empty @minion.fears
    assert_equal 'Fears snakes.', @minion.fears
  end

  def test_appearance
    refute_empty @minion.appearance
    assert_equal 'Brown eyes, olive skin. Square jaw. Hair: brown.', @minion.appearance
  end

  def test_weapons
    refute_empty @minion.weapons
    assert_equal 'Weapons: Sword, Bolas.', @minion.weapons
  end

  def test_hash
    m = @minion.to_hash
    
    assert_equal 'Human' , m[:race]
    assert_equal 'Man' , m[:gender]
    assert_equal 'Warrior', m[:class]
    assert_equal 'Commoner', m[:social]
    assert_equal 'Sword', m[:primary_weapon]
    assert_equal 'steel', m[:weapon_type]
    assert_equal 'Bolas', m[:secondary_weapon]
    assert_equal 'Plate', m[:armor_category]
    assert_equal 'cuirass', m[:armor]
    assert_equal 'steel', m[:armor_type]
    assert_equal 'Orcs', m[:hate]
    assert_equal 'Hates Orcs.', m[:hates]
    assert_equal 'snakes', m[:fear]
    assert_equal 'Fears snakes.', m[:fears]
    assert_equal 'brown', m[:eyes]
    assert_equal 'brown', m[:hair]
    assert_equal 'olive', m[:skin]
    assert_equal 'square jaw', m[:features]
    assert_equal 'John Smith', m[:name]
    assert_equal 'Weapons: Sword, Bolas.', m[:weapons]
    assert_equal 'Brown eyes, olive skin. Square jaw. Hair: brown.', m[:appearance]
    assert_equal 'Cruel, Greedy.', m[:traits]

  end

end
