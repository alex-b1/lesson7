require_relative './instance_counter.rb'

class Station
  include InstanceCounter

  @@instances = {}
  attr_accessor :trains, :name

  def initialize(name)
    @name = name
    validate!
    @trains = []
    @@instances[name] = self

    register_instance
  end

  def get_trains(b)
    @trains.each do |i|
    b.call(i)
    end
  end

  def arrival_train(train)
    @trains << train
  end

  def depart_train(train)
    @trains.filter! {|i| i.number != train.number}
    train.go_ahead

    while train.accelerate < 80
      train.accelerate
    end
  end

  def get_trains_by_type
   list = {
     cargo: (@trains.filter {|i| i.type == :cargo}).count ,
     passenger: (@trains.filter {|i| i.type == :passenger}).count,
    }
  end

  def self.all
    @@instances
  end

  def valid?
    validate!
      true
  rescue
      false
  end

  private

  def validate!
    raise 'Неверное значение' if name.empty?
    raise 'Такая станция уже есть' if @@instances[name]
  end
end