class Mob
  attr_accessor :name, :hit_points, :damage, :armor, :mana, :spell_turn_values, :items

  SPELLS = { "Magic Missile" => { cost: 53, turns: 1, damage: 4 }, 
             "Drain" => { cost: 73, turns: 1, damage: 2, recharge: 2 }, 
             "Shield" => { cost: 113, turns: 6, armor: 7 }, 
             "Poison" => { cost: 173, turns: 6, damage: 3 }, 
             "Recharge" => { cost: 229, turns: 5, mana: 101 } }

  def initialize(name, str)
    @name = name
    @items = []
    @spell_turn_values = { "Shield" => 0, "Poison" => 0, "Recharge" => 0 }

    unless str.empty?
      matches =  str.scan(/([a-zA-Z ]+): (\d+)/m)
      matches.each do |match|
        var = match.first.strip.downcase.gsub(/ /,'_')
        instance_variable_set("@#{var}", match.last.to_i)
      end
      @original_hit_points = @hit_points
    end

    default_all_values
  end

  def duplicate
    Marshal.load(Marshal.dump(self))
  end

  def reset
    revive
    remove_all_items
  end

  def revive
    @hit_points = @original_hit_points
  end

  def attack(mob)
    attack = [1, (enhanced_attack - mob.enhanced_armor)].max
    mob.hit_points -= attack
  end

  def alive?
    hit_points > 0 && mana > -1
  end

  # Spells

  def can_use_spell?(spell_name)
    (@spell_turn_values[spell_name] == nil || @spell_turn_values[spell_name] == 0) && @mana - SPELLS[spell_name][:cost] >= 0
  end

  def use_spell(spell_name, other_mob)
    if can_use_spell?(spell_name)
      spell = SPELLS[spell_name]
      self.mana -= spell[:cost]
      @spell_turn_values[spell_name] = spell[:turns] if spell[:turns]
      spell[:cost]
    else
      0
    end
  end

  def use_spell_effects(spell_name, spell, other_mob)
    other_mob.hit_points -= spell[:damage] if spell[:damage]
    self.hit_points += spell[:recharge] if spell[:recharge]      
    self.mana += spell[:mana] if spell[:mana]
    @spell_turn_values[spell_name] = [0, @spell_turn_values[spell_name] - 1].max if @spell_turn_values.has_key?(spell_name)
  end

  def use_active_spells(other_mob)
    @spell_turn_values.keys.each do |spell_name|
      if @spell_turn_values[spell_name] > 0
        use_spell_effects(spell_name, SPELLS[spell_name], other_mob)
      end
    end
  end

  # Items

  def remove_all_items
    @items = []
  end

  def equip(items)
    @items << items
    @items.flatten!
    @items.reject!(&:nil?)
  end

  def enhanced_attack
    attack = @damage + @items.inject(0){ |sum, i| sum + i["damage"] }
    [1, attack].max
  end

  def enhanced_armor
    enhanced_armor = armor + @items.inject(0){ |sum, i| sum + i["armor"] }
    enhanced_armor += 7 if @spell_turn_values["Shield"] > 0
    enhanced_armor
  end

  private

  def default_all_values
    %w(name hit_points damage armor mana).each do |val|
      instance_variable_set("@#{val}", 0) if instance_variable_get("@#{val}").nil?
    end
  end
end
