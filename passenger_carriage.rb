require_relative './carriage.rb'

class PassengerCarriage < Carriage
  TYPE = :passenger
  attr_reader :number_seats

  def initialize(number_seats)
    @number_seats = number_seats
    @seats = {}
    @number_seats.times {|i| @seats["#{i + 1}"] = 'свободно'}
  end

  def type
    TYPE
  end

  def take_seat (number)
    @seats[number] = 'занято'
  end

  def occupied_seats
    count = 0
    @seats.each do |k, v|
      if v == 'занято'
        count +=1
      end
    end
    count
  end

  def free_seats
    count = 0
    @seats.each do |k, v|
      if v == 'свободно'
        count +=1
      end
    end
    count
  end
end
