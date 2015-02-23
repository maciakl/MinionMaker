require 'bundler'
require 'bundler/setup'
require 'pickup'
require 'yaml'
require 'json'

class MinionFactory

  def initialize()
    @data = YAML.load_file('data.yml')
    @names = YAML.load_file('names.yml')
  end

  def get_minion()

    minion = Minion.new()

    # Basic attributes
    minion.race   = Pickup.new(@data['race']).pick(1)
    minion.gender = Pickup.new(@data['gender']).pick(1)
    minion.class  = Pickup.new(@data['class']).pick(1)
    minion.social = Pickup.new(@data['social']).pick(1)
    minion.class  = Pickup.new(@data['class']).pick(1)

    # Equipment
    minion.primary_weapon      = self.indirect_category_pick(minion.class, 'primary_weapon')
    minion.weapon_type         = self.category_pick(minion.class, 'weapon_type')
    minion.secondary_weapon    = self.indirect_category_pick(minion.class, 'secondary_weapon')
    minion.armor_category      = self.category_pick(minion.class, 'armor')
    minion.armor               = self.direct_category_pick(minion.class, 'armor', minion.armor_category)

    if minion.armor_category == 'Cloth' or minion.armor_category == 'Leather'
      minion.armor_type        = ''
    else
      minion.armor_type        = self.category_pick(minion.class, 'weapon_type')
    end
   
    # Build personality trait array
    minion.trait = Pickup.new(@data['traits']['common']).pick(3)
    minion.trait = minion.trait.uniq.reject(&:empty?)

    # Pick an object of hatered
    minion.hate = Pickup.new(@data['traits']['hates']).pick(1)

    if minion.hate == 'race'
      minion.hate = Pickup.new(@data['race']).pick(1)+'s'
      minion.hate = "other #{minion.hate}" if minion.hate == minion.race+'s' 
    elsif minion.hate == 'class'
      minion.hate = Pickup.new(@data['class']).pick(1)+'s'
      minion.hate = "other #{minion.hate}" if minion.hate == minion.class+'s'
    elsif @data['misc'].include? minion.hate
      minion.hate = Pickup.new(@data['misc'][minion.hate]).pick(1)
    end


    # Pick greatest fear
    minion.fear = Pickup.new(@data['traits']['fears']).pick(1)
    
    if @data['misc'].include? minion.fear
      minion.fear = Pickup.new(@data['misc'][minion.fear]).pick(1)
    end


    # Pick appearance trait
    minion.eyes = self.category_pick(minion.race, 'eyes')
    minion.hair = self.category_pick(minion.race, 'hair_style')
    unless minion.hair == 'shaved head' or minion.hair == 'bald'
        minion.hair += ", #{self.category_pick(minion.race, 'hair_color')}" 
    end
    minion.skin = self.category_pick(minion.race, 'skin')
    minion.features = self.category_pick(minion.race, 'features')

    minion.name = self.name_pick(minion.race, minion.gender, minion.social)


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

  def direct_category_pick(rpg_class, type, choice)
    current_loadout = default_loadout = @data['Default']
    current_loadout = @data[rpg_class] if @data.include? rpg_class and @data[rpg_class].include? type

    if choice.empty?
      weapon = ''
    else
      current_loadout = default_loadout
      current_loadout = @data[rpg_class] if @data.include? rpg_class and @data[rpg_class].include? choice
      weapon = Pickup.new(current_loadout[choice]).pick(1)
    end

    return weapon

  end

  def name_pick(race, gender, social)
    if @names.include? race

      src = @names[race]

      if src['given'].include? gender
        given_src = src['given'][gender]
      else
        given_src = src['given']
      end

      # Get given name
      given   = MinionFactory.get_name(given_src)


      # Get surname

      if src['surname'].include? social
        surname_src = src['surname'][social]
      else
        surname_src = src['surname']
      end

      if surname_src

        separator = MinionFactory.get_separator(src['surname'], social)
        if not separator.empty?

          # Names with 'son of' and 'daughter of'
          if separator == 'patronymic'
            if gender == 'Male' then separator = 'son of' end
            if gender == 'Female' then separator = 'daughter of' end

            if src['given'].include? 'Male' 
              p_src = src['given']['Male']
            else 
              p_src = src['given']
            end

            surname = "#{separator} #{MinionFactory.get_name(p_src)}"

          else
            # Names with separator like 'of Loxley'
            separator = "#{src['surname']['preposition'][social]}"
            surname = "#{separator} #{MinionFactory.get_name(surname_src)}"
          end
        else
          surname = MinionFactory.get_name(surname_src)
        end
      
      else
        surname = ''
      end

      # Get location
      if src.include? 'location' and src['location'].include? social
        
        location = "of #{MinionFactory.get_name(src['location'][social])}"
      else
        location = ''
      end


      name = [given, surname, location].reject(&:empty?).join(" ")
    else
      name = ''
    end

    return name
  end


  def self.get_name(src)
      if src.include? 'prefix' and src.include? 'postfix'
        Pickup.new(src['prefix']).pick(1).capitalize + 
        Pickup.new(src['postfix']).pick(1)
      else
        Pickup.new(src).pick(1)
      end
  end

  def self.get_separator(src, category)
    if src.include? 'preposition' and src['preposition'].include? category
        src['preposition'][category]
    else
        ''
    end
  end

end






class Minion

  attr_accessor :race
  attr_accessor :gender
  attr_accessor :class
  attr_accessor :social
  attr_accessor :trait
  attr_accessor :hate
  attr_accessor :fear

  attr_accessor :eyes
  attr_accessor :hair
  attr_accessor :skin
  attr_accessor :features

  attr_accessor :name

  attr_accessor :primary_weapon
  attr_accessor :weapon_type
  attr_accessor :secondary_weapon
  attr_accessor :armor
  attr_accessor :armor_category
  attr_accessor :armor_type

  def traits
    unless @trait.empty?
      @trait.join(', ') + "."
    else
      ""
    end
  end

  def hates
    unless @hate.empty?
      "Hates #{@hate}." 
    else
      ""
    end
  end

  def fears
    unless @fear.empty?
      "Fears #{@fear}." 
    else
      ""
    end
  end

  def appearance
    "#{@eyes.capitalize} eyes, #{@skin} skin."+
    " #{@features.capitalize}"+ (@features.empty? ? '' : '.')+
    " Hair: #{@hair}."
  end

  def weapons
    "Weapons: "+ [@primary_weapon, @secondary_weapon].reject(&:empty?).join(", ")+"."
  end

  def to_s
    "\n#{@name}\n"+
    "#{@race} #{@gender}\n" +
    "#{@class}, #{@social}\n"+

    "#{traits}\n"+
    "#{hates}\n"+
    "#{appearance}\n"+

    "#{weapons}\n"+
    "Armor: #{@armor}\n"
  end

  def to_hash
    {
      :name => @name,
      :race => @race,
      :gender => @gender,
      :class => @class,
      :social => @social,
      :hate => @hate,
      :fear => @fear,
      :hates => hates,
      :fears => fears,
      :traits => traits,
      :eyes => @eyes,
      :hair => @hair,
      :skin => @skin,
      :features => @features,
      :appearance => appearance,
      :primary_weapon => @primary_weapon,
      :weapon_type => @weapon_type,
      :secondary_weapon => @secondary_weapon,
      :weapins => weapons,
      :armor_category => @armor_category,
      :armor_type => @armor_type,
      :armor => @armor
    }
  end

  def to_json
    self.to_hash().to_json
  end

end
