class DriverOrderTime
  attr_accessor :driver, :order, :tour

  def initialize(driver:nil, order:nil, time:nil, tour:nil)
    method(__method__).parameters.each do |type, k|
      next unless type == :key
      v = eval(k.to_s)
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end
  
  def clone
    dot = DriverOrderTime.new
    dot.driver = self.driver
    dot.order = self.order.clone
    dot.tour = self.tour.clone
    dot
  end
  
end
