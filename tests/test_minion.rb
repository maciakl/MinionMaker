require 'minitest/autorun'
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
    @minion.armor_category = 'steel'
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

end
