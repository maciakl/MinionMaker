require 'pickup'
require 'yaml'

class MinionFactory
  def initialize()
    @data = YAML.load_file('data.yml')
  end

  def get_minion()

    minion = Minion.new()

    minion.race   = Pickup.new(@data['race']).pick(1)
    minion.gender = Pickup.new(@data['gender']).pick(1)
    minion.class  = Pickup.new(@data['class']).pick(1)
    minion.social  = Pickup.new(@data['social']).pick(1)
    #minion.class = 'Cleric'

    minion.primary_weapon = self.pick_weapon(minion.class, 'primary_weapon')
    minion.secondary_weapon = self.pick_weapon(minion.class, 'secondary_weapon')
    
    loadout = (@data.include? minion.class and @data[minion.class].include? 'armor') ? minion.class : 'Default'
    minion.armor  = Pickup.new(@data[loadout]['armor']).pick(1)

    minion.traits = Pickup.new(@data['traits']['common']).pick(3)
    minion.traits = minion.traits.uniq.reject(&:empty?).join(', ')
    minion.traits += ".\n" unless minion.traits.empty?

    minion.hates = Pickup.new(@data['traits']['hates']).pick(1)
    minion.hates = Pickup.new(@data['race']).pick(1)+'s' if minion.hates == 'race'
    minion.hates = "other #{minion.hates}" if minion.hates == minion.race+'s'
    minion.hates = Pickup.new(@data['class']).pick(1)+'s' if minion.hates == 'class'
    minion.hates = "other #{minion.hates}" if minion.hates == minion.class+'s'
    minion.hates = "" if minion.hates == 'nothing'
    minion.hates = "Hates #{minion.hates}.\n" unless minion.hates.empty?


    minion.fears = Pickup.new(@data['traits']['fears']).pick(1)
    minion.fears = "" if minion.fears == 'nothing'
    minion.fears = "Fears #{minion.fears}.\n" unless minion.fears.empty?

    return minion

  end

  def pick_weapon(rpg_class, type)
    current_loadout = default_loadout = @data['Default']
    current_loadout = @data[rpg_class] if @data.include? rpg_class and @data[rpg_class].include? type

    tmp = Pickup.new(current_loadout[type]).pick(1)

    if tmp == 'none'
      weapon = ''
    else
      current_loadout = default_loadout unless current_loadout.include? tmp
      weapon = Pickup.new(current_loadout[tmp]).pick(1)
    end

    return weapon

  end
end

class Minion

  attr_accessor :race
  attr_accessor :gender
  attr_accessor :class
  attr_accessor :social
  attr_accessor :traits
  attr_accessor :hates
  attr_accessor :fears

  attr_accessor :primary_weapon
  attr_accessor :secondary_weapon
  attr_accessor :armor

  def to_s
    "\n#{@race} #{@gender}\n" +
    "#{@class}, #{@social}\n"+

    "#{@traits}"+
    "#{@hates}"+
    "#{@fears}"+
    "Weapons: "+ [@primary_weapon, @secondary_weapon].reject(&:empty?).join(", ")+"\n"+
    "Armor: #{@armor}\n"
  end

end

m = MinionFactory.new()
puts m.get_minion()
