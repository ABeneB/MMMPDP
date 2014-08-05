class Driver

  attr_accessor :name, :capacity, :position, :id, :tour, :speed
  def initialize()
    self.tour = Tour.new
    self.speed = 1 # Kein Carrier fährt schneller oder langsamer als 1 , außer es wird beim erstellen geändert. Default ist 1
  end

  def set_order (tour) #set_tour! umbennenen
    self.tour = tour.clone
  end

  # Tour erstellen. tour.time ist die Zeit die für die Tour benötigt wird.
  def komplexe_tour (order)
    komplexe_tour = KomplexeTour.new
    new_tour = komplexe_tour.build_tour(self.tour,order,self.position, self.capacity, self.speed)
  end


end # Ende der Klasse
