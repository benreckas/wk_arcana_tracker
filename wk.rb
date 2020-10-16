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
      hero_search
    end
  end

  def puts_collected
    @heroes.each { |hero| puts hero[:name] if hero[:is_collected] }
    puts_hero_nums
  end

  def puts_uncollected
    @heroes.each { |hero| puts hero[:name] unless hero[:is_collected] }
    puts_hero_nums
  end

  def puts_hero_nums
    puts "#{@heroes.select { |h| h[:is_collected] }.length} heroes collected"
    puts "#{@heroes.reject { |h| h[:is_collected] }.length} heroes remaining"
  end

  def hero_search
    @heroes.each do |hero|
      next if hero[:is_collected]
      next unless hero[:name].downcase.include? @command.downcase

      puts "Collect: #{hero[:name]}?"
      print 'y/n: '
      should_collect = $stdin.gets.chomp

      collect_hero(hero) if should_collect.casecmp('y').zero?
    end
  end

  def reset
    puts 'Are you sure you want to reset all progress?'
    print 'y/n: '
    should_reset = $stdin.gets.chomp

    return unless should_reset.casecmp('y').zero?

    @heroes.each { |hero| hero[:is_collected] = false }

    overwrite_heroes_file
  end

  def collect_hero(defeated_hero)
    @heroes.each do |hero|
      hero[:is_collected] = true if hero[:name] == defeated_hero[:name]
    end

    overwrite_heroes_file

    puts "#{defeated_hero[:name]} was collected!"
  end

  def overwrite_heroes_file
    File.open('heroes.yml', 'w') do |out|
      YAML.dump(@heroes, out)
    end
  end
end

Tracker.new(command)
