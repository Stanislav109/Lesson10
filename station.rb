class Station
  include InstanceCounter
  include Validation

  attr_reader :name, :trains

  validate :name, :presence
  validate :name, :type, String

  def self.all_stations
    @@all_stations
  end

  @@all_stations = []

  def initialize(name)
    @name = name
    validate!
    @trains = []
    register_instance
    @@all_stations << self
  end

  def list_of_trains
    trains.each { |train| yield train } if block_given?
  end

  def get_train(train)
    trains << train
  end

  def send_train(train)
    trains.delete(train)
  end

  
end
