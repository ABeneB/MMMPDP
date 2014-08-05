class Tour

  attr_accessor :tour, :capacityarray, :time, :orderarray
  
  def initialize
    self.tour = []
    self.orderarray = []
    self.capacityarray = [0]
    self.time= 10000000
  end
  
  def clone
    tour = Tour.new
    tour.time = self.time
    tour.capacityarray = self.capacityarray.clone
    #echtes klonen Orderarray
    orderarray = []
    self.orderarray.each do |order|
      new_order = order.clone # .clone wurde in Order ebenfalss modifiziert für echtes klonen
      orderarray.push(new_order)
    end
    tour.orderarray=orderarray
    #echtes klonen vom tourarray
       tourarray = []
    self.tour.each do |task|
      if task == nil
        binding.pry
      end
      new_task = task.clone
      new_task.position = task.position.clone
      tourarray.push(new_task)
    end
    tour.tour=tourarray
    tour # geclontes Objekt zurückgeben
  end
end