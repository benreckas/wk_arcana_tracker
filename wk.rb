require 'yaml'

command = ARGV.first

class Tracker
  def initialize(command = nil)
    @command = command
    @heroes = YAML.load(File.read('heroes.yml'))

    command_switch
  end

  def command_switch
    case @command
    when nil
      puts_uncollected
    when 'collected'
      puts_collected
    when 'reset'
      reset
    else
      hero_search(@command)
    end
  end

  def puts_collected
    @heroes.each { |h| puts h[:name] if h[:is_collected] }
    puts_hero_totals
  end

  def puts_uncollected
    @heroes.each { |h| puts h[:name] unless h[:is_collected] }
    puts_hero_totals
  end

  def puts_hero_totals
    puts "#{@heroes.select { |h| h[:is_collected] }.length} heroes collected"
    puts "#{@heroes.reject { |h| h[:is_collected] }.length} heroes remaining"
  end

  def hero_search(search_string)
    @heroes.each do |hero|
      # Skip iteration if hero is already collected or hero name doesn't include the search string
      next if hero[:is_collected]
      next unless hero[:name].downcase.include? search_string.downcase

      puts "Collect: #{hero[:name]}?"
      print 'y/n: '
      should_collect = $stdin.gets.chomp

      collect_hero(hero) if should_collect.casecmp('y').zero?
    end
  end

  def collect_hero(hero)
    @heroes.map { |h| h[:is_collected] = true if h[:name] == hero[:name] }

    puts "#{hero[:name]} was collected!"
    overwrite_heroes_file
  end

  def reset
    puts 'Are you sure you want to reset all progress?'
    print 'y/n: '
    should_reset = $stdin.gets.chomp

    return unless should_reset.casecmp('y').zero?

    @heroes.map { |h| h[:is_collected] = false }

    overwrite_heroes_file
  end

  def overwrite_heroes_file
    File.open('heroes.yml', 'w') { |out| YAML.dump(@heroes, out) }
    puts_hero_totals
  end
end

Tracker.new(command)
