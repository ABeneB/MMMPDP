class Timetable

  attr_accessor :driver_order_times, :orders, :drivers, :initial_table, :totaltime, :driver_order_times
  
  def initialize(orders:[], drivers:[])
    self.orders = orders
    self.drivers = drivers
    self.driver_order_times = []
    self.totaltime = 0
  end  

  # Assigns orders to drivers
  def assign_based_on_algorithm!
    
    #Matrix vorberteiten
    build_timetable!
    
    # Store the initial table for later reporting purposes
    self.initial_table = driver_order_times
    
    orders_count = orders.length
    puts "MMMPDP"
    count = 1
    while orders_count > 0 do
      
      # Schnellsten Carrier herausfinden
      fastest_combination = fastest.clone
      # Order dem schnellsten Carrier zu sortieren
      order = fastest_combination.order.clone
      driver = fastest_combination.driver
      driver.set_order(fastest_combination.tour)

      if orders_count > 1
      # Order entfernen, weil bereits bearbeitet
      remove_order!(order)
      end
      
      # Zeit in der Matrix neuberechnen
      recalculate_driver_time!(fastest_combination.driver)

      orders_count = orders_count - 1
    end
    # Report
    drivers.each do |driver|
      puts "#{driver.name} fährt #{driver.tour.time.round(2)} ZE"
      if driver.id ="c1"
        driver.tour.tour.each do |element|
          puts element.name
        end
      end
      self.totaltime = self.totaltime + driver.tour.time
    end
    puts "Gesamtfahrzeit: #{self.totaltime.round(2)} ZE"
  end

  # Matrix erstellen
  def build_timetable!
    orders.each do |order|
      drivers.each do |driver|
        add_driver_order_time(
          DriverOrderTime.new(driver: driver, order: order, tour: driver.komplexe_tour(order).clone)
        )
      end
    end
    # Array mit allen Driver/Order Zeiten füllen
    driver_order_times 
  end

  def add_driver_order_time(driver_order_time)
    self.driver_order_times += [driver_order_time]
  end

  # Return schnellste DriverOrderTime.
  def fastest
    fastest = driver_order_times.first
    # Return nil wenn nur ein Element
    if !fastest
      return nil
    end
    # Abbruch wenn in der Matrix nur ein Element ist
    return fastest if driver_order_times.length == 1
    # Schnellste Tour/Carrier finden
    driver_order_times.each do |driver_order_time|
      if driver_order_time.tour.time < fastest.tour.time
        fastest = driver_order_time.clone
      end
    end
    fastest
  end

  # Removes all driver order times that contain a specific order
  def remove_order!(order)
    self.driver_order_times = driver_order_times.reject {|driver_order_time| driver_order_time.order.id == order.id }
    driver_order_times
  end

  # Returns all the unique orders.
  def orders_unique
    driver_order_times.map{|dto| dto.order}.uniq
  end

  # Returns all the timetable times
  def times
    driver_order_times.map{|dto| dto.tour.time}
  end

  # Returns all the timetable unique drivers
  def drivers_unique
    driver_order_times.map{|dto| dto.order}.uniq
  end

  def recalculate_driver_time!(driver)
    # Get all the combinations for the driver
    combinations = driver_order_times.select {|driver_order_time| driver_order_time.driver.id == driver.id }
    # Recalculate the time for each
    combinations.each do |driver_order_time|
      driver_order_time.tour = driver.komplexe_tour(driver_order_time.order).clone
    end
  end

end
