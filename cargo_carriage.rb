require_relative './carriage.rb'

class CargoCarriage < Carriage
  TYPE = :cargo

  attr_reader :volume
  def initialize(volume)
    @volume = {total: volume, free: volume, occupied: 0}
  end

  def type
    TYPE
  end

  def take_value(value)
    @volume[:occupied] += value
    @volume[:free] -= value
  end

  def volume_occupied
    @volume[:occupied]
  end

  def volume_free
    @volume[:free]
  end

end
