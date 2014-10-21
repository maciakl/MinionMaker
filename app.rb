require 'pickup'
require 'yaml'

class MinionFactory
  def initialize()
    @data = YAML.load_file('data.yml')
  end

  def get_minion()

    minion = Minion.new()

    #minion.race = 'Kobold'
    minion.race   = Pickup.new(@data['race']).pick(1)
    minion.gender = Pickup.new(@data['gender']).pick(1)
    minion.class  = Pickup.new(@data['class']).pick(1)
    minion.social = Pickup.new(@data['social']).pick(1)
    minion.class  = Pickup.new(@data['class']).pick(1)
    #minion.class = 'Fighter'

    minion.primary_weapon   = self.indirect_category_pick(minion.class, 'primary_weapon')
    minion.secondary_weapon = self.indirect_category_pick(minion.class, 'secondary_weapon')
    minion.armor            = self.category_pick(minion.class, 'armor')
    
    minion.traits = Pickup.new(@data['traits']['common']).pick(3)
    minion.traits = minion.traits.uniq.reject(&:empty?).join(', ')
    minion.traits += ".\n" unless minion.traits.empty?

    minion.hates = Pickup.new(@data['traits']['hates']).pick(1)
    minion.hates = Pickup.new(@data['race']).pick(1)+'s' if minion.hates == 'race'
    minion.hates = "other #{minion.hates}" if minion.hates == minion.race+'s'
    minion.hates = Pickup.new(@data['class']).pick(1)+'s' if minion.hates == 'class'
    minion.hates = "other #{minion.hates}" if minion.hates == minion.class+'s'
    minion.hates = "Hates #{minion.hates}.\n" unless minion.hates.empty?


    minion.fears = Pickup.new(@data['traits']['fears']).pick(1)
    minion.fears = "" if minion.fears == 'nothing'
    minion.fears = "Fears #{minion.fears}.\n" unless minion.fears.empty?

    minion.eyes = self.category_pick(minion.race, 'eyes')
    minion.hair = self.category_pick(minion.race, 'hair_style')
    unless minion.hair == 'shaved head' or minion.hair == 'bald'
        minion.hair += ", #{self.category_pick(minion.race, 'hair_color')}" 
    end
    minion.skin = self.category_pick(minion.race, 'skin')


    return minion

  end

  def category_pick(category, item)
    category = @data[category]['same_as'] if @data.include? category and @data[category].include? 'same_as'
    current_loadout = default_loadout = @data['Default']
    current_loadout = @data[category] if @data.include? category and @data[category].include? item
    Pickup.new(current_loadout[item]).pick(1)
  end

  def indirect_category_pick(rpg_class, type)
    current_loadout = default_loadout = @data['Default']
    current_loadout = @data[rpg_class] if @data.include? rpg_class and @data[rpg_class].include? type

    tmp = Pickup.new(current_loadout[type]).pick(1)

    if tmp.empty?
      weapon = ''
    else
      current_loadout = default_loadout
      current_loadout = @data[rpg_class] if @data.include? rpg_class and @data[rpg_class].include? tmp
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

  attr_accessor :eyes
  attr_accessor :hair
  attr_accessor :skin

  attr_accessor :primary_weapon
  attr_accessor :secondary_weapon
  attr_accessor :armor

  def to_s
    "\n#{@race} #{@gender}\n" +
    "#{@class}, #{@social}\n"+

    "#{@traits}"+
    "#{@hates}"+
    "#{@fears}"+
    "#{@eyes.capitalize} eyes, #{@skin} skin.\n"+
    "Hair: #{@hair}.\n"+

    "Weapons: "+ [@primary_weapon, @secondary_weapon].reject(&:empty?).join(", ")+"\n"+
    "Armor: #{@armor}\n"
  end

end

m = MinionFactory.new()

(0..4).each do
  puts m.get_minion()
end
