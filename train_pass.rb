class PassengerTrain < Train
  attr_reader :type

  def initialize(number)
    super
    @type = :passenger
  end

  protected

  def boost_speed(speed)
    self.speed += speed
  end

  def stop
    self.speed = 0
  end
end
