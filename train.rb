require_relative './instance_counter.rb'
require_relative './company_manufacturer.rb'
require_relative './station.rb'

class Train
  include CompanyManufacturer
  include InstanceCounter

  @@instances = {}
  attr_reader :carriages, :number, :type, :speed, :station, :is_move, :route
  NUMBER_FORMAT = /([а-яА-Я]|\d){3}-*([а-яА-Я]|\d){2}/
  TRAIN_TYPES = [:cargo, :passenger]

  def initialize(options)
    @number = options[:number]
    @type = options[:type]

    validate!
    @carriages = [].concat(options[:carriages])
    @speed = 0
    @@instances[@number] = self
    register_instance
  end

  def carriages_list(b)
    @carriages.each do |i|
      b.call(i)
    end
  end

  def accelerate(speed = 10)
    @speed += speed
  end

  def slow_down(speed = 10)
    @speed = @speed < speed ? 0 : @speed - speed
  end

  def attach_carriage(carriage)
    if !validate_speed? && validate_carriage?(carriage)
      @carriages << carriage
    end
  end

  def detach_carriage
    if !validate_speed?
      @carriages.pop
    end
  end

  def route(route)
    @route = route
    @station = @route.stations.first
  end

  def go_ahead
    @station = next_station if next_station
  end

  def go_back
    @station = previous_station if previous_station
  end

  def self.find(number)
    @@instances[number] || nil
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  private

  def validate!
    raise 'Не правильный номер поезда' if number !~ NUMBER_FORMAT
    raise 'Не правильный тип поезда' if !TRAIN_TYPES.include? type
    raise 'Такой поезд уже есть' unless @@instances[number].nil?
  end

  def validate_carriage?(carriage)
    carriage.class::TYPE == @type
  end

# validate_speed? используется только в классе Train для проверки скорости
  def validate_speed?
    @speed > 0
  end

# next_station, previous_station также будем использовать для проверки, что станция не конечная

  def next_station
    index = @route.stations.index @station
    length = @route.stations.length
    if index == length - 1
      false
    else
      @route.stations[index + 1]
    end
  end

  def previous_station
    index = @route.stations.index @station
    if index == 0
      false
    else
      @route.stations[index - 1]
    end
  end
end


