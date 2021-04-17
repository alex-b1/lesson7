require_relative './instance_counter.rb'

class Route
  include InstanceCounter

  @@instances = {}
  attr_reader :stations, :route_name

  def initialize(initial_station, end_station)
    @stations = [initial_station, end_station]
    @route_name = @stations[0].name.to_s + '-' + @stations[1].name.to_s
    @@instances[@route_name] = self

    register_instance
  end

  def add_station(station)
    @stations.insert(-2, station) unless validate_station? station
  end

  def remove_station(station)
    @stations.delete(station) unless validate_station? station
  end

  def get_stations_list
    @stations
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  private

  def validate_station?(station)
    @stations.find { |i| i[:name] == station[:name]}
  end
end
