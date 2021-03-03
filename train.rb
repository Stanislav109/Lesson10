class Train
  include Manufacturer
  include InstanceCounter
  include Validation

  attr_accessor :speed, :station, :wagons
  attr_reader :type, :number, :route

  validate :number, :presence

  NUMBER_FORMAT = /[0-9a-z_]{3}[-]?[0-9a-z_]{2}$/

  def self.find_train(number)
    @@all_trains[number]
  end

  @@all_trains = {}

  def initialize(number)
    @number = number
    validate!
    @type = type
    @wagons = []
    @speed = 0
    register_instance
    @@all_trains[number] = self
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def list_of_wagons
    wagons.each { |wagon| yield wagon } if block_given?
  end

  def add_wagons(wagon)
    if speed.zero?
      wagons << wagon
    else
      puts 'You must stop'
    end
  end

  def delete_wagons(wagon)
    if speed.zero?
      wagons.delete(wagon)
    else
      puts 'You must stop'
    end
  end

  def route=(route)
    @route = route
    self.station = self.route.stations.first
    station.get_train(self)
  end

  def move_next_station
    station.send_train(self)
    self.station = route.stations[route.stations.index(station) + 1]
    station.get_train(self)
  end

  def move_previous_station
    station.send_train(self)
    self.station = route.stations[route.stations.index(station) - 1]
    station.get_train(self)
  end

  def next_station
    route.stations[route.stations.index(station) + 1]
  end

  def previous_station
    route.stations[route.stations.index(station) - 1]
  end

  protected

  def validate!
    raise 'Number must be 5 simbols' if number.length < 5
    raise 'Number has invalid format' if number !~ NUMBER_FORMAT
  end

  def boost_speed(speed)
    self.speed += speed
  end

  def stop
    self.speed = 0
  end
end
