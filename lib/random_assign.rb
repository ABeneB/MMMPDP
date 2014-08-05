class RandomAssign

  attr_accessor :orders, :drivers, :totaltime
  def initialize(orders:[], drivers:[])
    self.orders = orders
    self.drivers = drivers
    self.totaltime = 0
  end

  def assign_random!
    puts "Zufallsverfahren"
    count = 1
    while self.orders.any?
      # Select Driver
      driver = self.drivers[rand(0 .. self.drivers.length-1)]
      # Select Order
      order = self.orders[rand(0 .. self.orders.length-1)]
      # Assign Order to Driver
      driver.set_order(driver.komplexe_tour(order).clone)
      # bearbeitete Order entfernen
      self.orders.delete(order)
    end
    
    # Report
    self.drivers.each do |driver|
    # Damit der Default wert einer Tour (10000000) nicht in die Gesamtsumme kommt
      if driver.tour.orderarray.any? 
        puts "#{driver.name} fährt #{driver.tour.time.round(2)} ZE"
        if driver.name ="Carrier1"
          driver.tour.tour.each do |element|
            puts element.name
          end
        end
      self.totaltime = self.totaltime + driver.tour.time
      end
    end
    puts "Gesamtfahrzeit: #{self.totaltime.round(2)} ZE"
  end
end

