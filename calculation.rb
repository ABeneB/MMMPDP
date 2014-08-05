require 'json'
require 'pry'
require "rails"


def current_dir
  File.dirname(__FILE__)
end

Dir[current_dir + '/lib/*.rb'].each {|file| require file }

class Calculation

  attr_accessor :orders, :drivers

  def load_orders
    self.orders = File.open( current_dir + "/json/orders.json", "r" ) do |f|
      (JSON.load( f ))
    end
        # Ausgabe der Orderdaten in die Console
    puts "Orders:"
    puts orders
    # Daten als Objekt-Array vorbereiten
    order_array = orders["order"]
    new_orders = []
    order_array.each do |order_json|
      o = Order.new
      o.name = order_json["name"]
      o.id = order_json["id"]
      o.capacity = order_json["capacity"]
      o.origin = order_json["origin"]
      o.destination = order_json["destination"]
      new_orders.push(o)
    end
    self.orders = new_orders 
  end

  def load_drivers
    self.drivers = File.open( current_dir + "/json/carriers.json", "r" ) do |f|
      JSON.load( f )
    end
        # Ausgabe der Driverdaten in die Console
    puts "Carrier:"
    puts drivers
    # Daten als Objekt-Array vorbereiten
    carrier_array = drivers["carrier"]
    new_carrier = []
    carrier_array.each do |carrier_json|
      c = Driver.new
      c.name = carrier_json["name"]
      c.id = carrier_json["id"]
      c.capacity = carrier_json["capacity"]
      c.position= carrier_json["position"]
      new_carrier.push(c)
    end
    self.drivers = new_carrier
  end

  def perform

    # set data
    load_orders
    load_drivers
    orders1 = []
    orders.each do |order|
      o = order.clone
      orders1.push(o)
    end
    drivers1 = []
    drivers.each do |driver|
      d = driver.clone
      drivers1.push(d)
    end

    #Zufallsverfahren
    random = RandomAssign.new(orders:orders, drivers:drivers)
    random.assign_random!
    
    #MMMPDP
    timetable = Timetable.new(orders: orders1, drivers: drivers1)
    timetable.assign_based_on_algorithm!
  end
end   
#Status
puts "running..."


c = Calculation.new
c.perform

