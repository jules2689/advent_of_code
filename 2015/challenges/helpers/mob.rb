class Mob
  attr_accessor :name, :hp, :damage, :armor

  def initialize(name, str)
    matches = str.match(/Hit Points: (\d+).*Damage: (\d+).*Armor: (\d+)/m)
    @name = name
    @hp = matches[1].to_i
    @original_hp = @hp
    @damage = matches[2].to_i
    @armor = matches[3].to_i
    @items = []
  end

  def reset
    revive
    remove_all_items
  end

  def revive
    @hp = @original_hp
  end

  def attack(mob)
    mob.hp -= (enhanced_attack - mob.enhanced_armor)
  end

  def alive?
    hp > 0
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
    @damage + @items.inject(0){ |sum, i| sum + i["damage"] }
  end

  def enhanced_armor
    armor + @items.inject(0){ |sum, i| sum + i["armor"] }
  end
end
