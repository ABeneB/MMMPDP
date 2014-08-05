class Order

  attr_accessor :name, :id, :capacity, :origin, :destination

  # echtes klonen von Orderobjekt
  def clone
    order = Order.new
    order.name = self.name
    order.id = self.id
    order.capacity = self.capacity
    order.origin = self.origin
    order.destination = self.destination.clone
    order # return Klon
  end

end
