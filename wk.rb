defeated_hero = ARGV.first

def remove_hero(hero)
  collected_data = File.open('collected.txt', 'a')
  hero_data = File.open('heroes.txt')
  heroes = hero_data.readlines.map(&:chomp)

  heroes.delete(hero)

  collected_data.write(hero)
  collected_data.write("\n")
  File.write('heroes.txt', heroes.join("\n"), mode: 'w')

  hero_data.close
  collected_data.close
end

if defeated_hero
  hero_data = File.open('heroes.txt')
  heroes = hero_data.readlines.map(&:chomp)

  heroes.each do |hero|
    next unless hero.include? defeated_hero

    puts "I found: #{hero}"
    puts 'Collect their Bones? y/n'
    should_collect = $stdin.gets.chomp

    remove_hero(hero) if should_collect == 'y'
  end

  hero_data.close
else
  hero_data = File.open('heroes.txt', 'r')
  heroes = hero_data.readlines.map(&:chomp)

  puts "#{heroes.length} uncollected bones: "
  heroes.each do |hero|
    puts hero
  end

  hero_data.close
end
