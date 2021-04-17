require_relative './train.rb'
require_relative './cargo_train.rb'
require_relative './passenger_train.rb'
require_relative './carriage.rb'
require_relative './passenger_carriage.rb'
require_relative './cargo_carriage.rb'
require_relative './route.rb'
require_relative './station.rb'

class Main

  def initialize
    @trains_list = []
    @routes_list = []
    @stations_list = []
    @command_list = {
        1 => {title: 'Создать станцию', command: -> {create_station}},
        2 => {title: 'Создать поезд', command: -> {create_train}},
        3 => {title: 'Создать маршрут', command: -> {create_route}},
        4 => {title: 'Добавить станцию в маршруту', command: -> {add_station_to_route}},
        5 => {title: 'Удалить станцию из маршрута', command: -> {remove_station_from_route}},
        6 => {title: 'Назначить маршрут поезду', command: -> {set_route}},
        7 => {title: 'Добавлить вагон к поезду', command: -> {add_carriage}},
        8 => {title: 'Отцепить вагон от поезда', command: -> {remove_carriage}},
        9 => {title: 'Перемещать поезд по маршруту вперед', command: -> {go_ahead}},
        10 => {title: 'Перемещать поезд по маршруту назад', command: -> {go_back}},
        11 => {title: 'Просматривать список станций', command: -> {show_stations}},
        12 => {title: 'Просматривать список поездов на станции', command: -> {show_trains_on_station}},
        13 => {title: 'Указать производителя поезда', command: -> {set_train_manufacturer}},
        14 => {title: 'Получить производителя поезда', command: -> {get_train_manufacturer}},
        15 => {title: 'Указать производителя вагонов', command: -> {set_carriage_manufacturer}},
        16 => {title: 'Получить производителя вагонов', command: -> {get_carriage_manufacturer}},
        17 => {title: 'Получить все станции', command: -> {get_all_stations}},
        18 => {title: 'Найти поезд', command: -> {find_train}},
        19 => {title: 'Кол-во поездов', command: -> {get_trains_count}},
        20 => {title: 'Кол-во станций', command: -> {get_stations_count}},
        21 => {title: 'Кол-во маршрутов', command: -> {get_routes_count}},
        22 => {title: 'Список станций', command: -> {get_trains_on_stations}},
        23 => {title: 'Занять место или вагон', command: -> {take_place}},
    }
  end

  def dispatch
    begin
      loop do
        clear
        show_tasks
        task = get_task
        break if !@command_list[task]
        puts @command_list[task][:command].call
        continue
      end
      print 'Вы вышли из программы'
    rescue Exception => e
      puts "Ошибка: #{e.message}"
      continue
      dispatch
    end
  end

  private
  attr_accessor :stations_list, :routes_list, :trains_list

  def clear
    if Gem.win_platform?
      system 'cls'
    else
      system 'clear'
    end
  end

  def show_tasks
    puts 'Введите номер задачи : '
    @command_list.each do |k, v|
      puts "#{k} - #{v[:title]}"
    end
  end

  def get_task
    gets.chomp.to_i
  end

  def get_string
    gets.chomp.to_s.downcase.strip
  end

  def create_station
    print 'Ведите название станции: '
    name = get_string
    station = Station.new(name)
    @stations_list.push({
       name: name,
       station: station,
    })
  end

  def create_train
    train_options = {}
    print 'Ведите номер поезда: '
    train_options[:number] = get_string
    print 'Ведите тип поезда: '
    train_options[:type] = get_string.to_sym
    print 'Ведите кол-во вагонов поезда: '
    count = get_string.to_i

    train_options[:carriages] = []
    count.times.with_index do |i, idx|
      if train_options[:type] == :cargo
        print "Ведите объем вагона №#{idx + 1}: "
        volume = get_string.to_i
        train_options[:carriages].push(CargoCarriage.new(volume))
      elsif train_options[:type] == :passenger
        print 'Ведите количество мест в вагоне: '
        volume = get_string.to_i
        train_options[:carriages].push(PassengerCarriage.new(volume))
      end
    end

    train = train_options[:type] == :cargo ? CargoTrain.new(train_options) : PassengerTrain.new(train_options)
    @trains_list.push({
       number: train_options[:number],
       train: train,
     })
  end

  def create_route
    if @stations_list.length >= 2

      @stations_list.each do |i|
        puts "Станция : #{i[:name]}"
      end
      print 'Ведите начальную и конечную станцию через дефис: '
      name = get_string.split('-')

      first_station = @stations_list.find {|i| i[:name] == name[0]}
      last_station = @stations_list.find {|i| i[:name] == name[1]}

      route = Route.new(first_station[:station], last_station[:station])

      @routes_list.push({
         name: name.join('-'),
         route: route,
      })
    elsif
      puts 'Создайте хотя бы 2 станции'
    end
  end

  def select_route
    puts 'Выберите маршрут для поезда: '

    @routes_list.each do |i|
      puts "маршрут : #{i[:name]}"
    end

    name = get_string
    route_item = @routes_list.find {|i| i[:name] == name}
    route = route_item[:route]
  end

  def select_station
    puts 'Выберите станцию: '

    @stations_list.each do |i|
      puts "Станция : #{i[:name]}"
    end

    name = get_string
    station_item = @stations_list.find {|j| j[:name] == name}
    station = station_item[:station]
  end

  def select_train
    puts 'Выберите поезд: '

    @trains_list.each do |i|
      puts "Поезд номер : #{i[:number]}"
    end

    number = get_string
    train_item = @trains_list.find {|j| j[:number] == number}
    train = train_item[:train]
  end

  def add_station_to_route
    route = select_route
    station = select_station

    stations = route.add_station station

    if stations
      stations
    else
      puts 'Ошибка, такая станция уже есть'
    end
  end

  def remove_station_from_route
    route = select_route
    station = select_station

    stations = route.remove_station station
    if stations
      stations
    else
      puts 'Ошибка, такой станции нет'
    end
  end

  def set_route
    train = select_train
    route = select_route

    station = train.route route
    station.arrival_train train
    puts "Вы на станции: #{station}"
  end

  def add_carriage
    train = select_train

    carriage = train.type == :cargo ? CargoCarriage.new : PassengerCarriage.new
    carriages = train.attach_carriage(carriage)
    if carriages
      puts carriages
    else
      puts 'Поезд движется'
    end
  end

  def remove_carriage
    train = select_train

    if train.carriages.length == 0
      puts 'Вагон больше нет'
      return
    end

    carriages = train.detach_carriage
    if carriages
      puts carriages
    else
      puts 'Поезд движется'
    end
  end

  def go_ahead
    train = select_train
    station = train.go_ahead
    if station
      puts station
    else
      puts 'вы на последней станции'
    end
  end

  def go_back
    train = select_train
    station = train.go_back
    if station
      puts station
    else
      puts 'Вы на первой станции'
    end
  end

  def show_stations
    puts @stations_list
  end

  def show_trains_on_station
    station = select_station

    puts station.trains
  end

  def set_train_manufacturer
    train = select_train

    print 'Введи название производителя: '
    manufacturer = get_string
    train.company_name = manufacturer
  end

  def get_train_manufacturer
    train = select_train
    puts "Производитель #{train.company_name}"
  end

  def set_carriage_manufacturer
    train = select_train

    print 'Введи название производителя вагонов поезда: '
    manufacturer = get_string
    train.carriages.each do |i|
      i.company_name = manufacturer
    end
  end

  def get_carriage_manufacturer
    train = select_train
    train.carriages.each do |i|
      puts "Производитель #{i.company_name}"
    end
  end

  def get_all_stations
    stations = Station.all
    stations.each do |i|
      puts "Станция: #{i}"
    end
  end

  def find_train
    print 'Введите номер поезда: '
    number = get_string
    train = Train.find(number)
    if train
      puts "Ваш поезд: #{train}"
    else
      puts 'Такого поезда нет'
    end
  end

  def get_trains_count
    puts "Грузовых поездов #{CargoTrain.instances}"
    puts "Пассажирских поездов: #{PassengerTrain.instances}"
  end

  def get_stations_count
    puts "Кол- во станций: #{Station.instances}"
  end

  def get_routes_count
    puts  "Кол- во маршрутов: #{Route.instances}"
  end

  def get_trains_on_stations
    c = lambda do |i|
      type = i.type
      puts "Тип вагона #{i.type}"
      if type == :passenger
        puts "Свободных мест - #{i.free_seats}"
        puts "Занято мест - #{i.occupied_seats}"
      else
        puts "Свободного места - #{i.volume_free}"
        puts "Занято - #{i.volume_occupied}"
      end
    end

    b = lambda do |i|
      puts "Номер поезда: #{i.number}"
      puts "Тип поезда: #{i.type}"
      puts "Кол-во вагонов: #{i.carriages.length}"
      i.carriages_list c
    end
    stations = Station.all
    stations.each do |k,v|
      v.get_trains b
    end
  end

  def take_place
    c = lambda do |i|
      print 'Введите объем: '
      number = get_string.to_i
      i.take_value number
    end

    s = lambda do |i|
      print 'Введите номер сиденья: '
      number = get_string.to_i
      i.take_seat number
    end

    train = select_train
    type = train.type
    if type == :cargo
      train.carriages_list c
    else
      train.carriages_list s
    end
  end

  def continue
    puts 'нажмите любуюклавишу чтобы продолжить'
    gets
  end
end

main = Main.new
main.dispatch