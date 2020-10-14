# frozen_string_literal: true

require 'yaml'

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
else
  heroes = YAML.load(File.read('heroes.yml'))

  heroes.each do |hero|
    puts hero[:name]
  end
end
