class KomplexeTour

  attr_accessor :tour, :origin, :destination, :position, :capacity, :speed
  
  def build_tour(tour,order,postion,new_capacity, speed)
    #Werte und Objekte vorbereiten
    set_ready(order, tour, postion, new_capacity, speed)
    new_tour = Tour.new

    #Schleife - Kapazitäsverlauf auf Stellen untersuchen, an den += order.kapazität nicht über Kapazität-max geht
    self.tour.capacityarray.each_with_index do |capacity, index|
      tmp_tour = self.tour.clone
      new_capacity = capacity + order.capacity
      if new_capacity <= self.capacity
        # An Stelle Origin-new einsetzen und capacityarray updaten von tmp_tour
        tmp_tour.capacityarray.insert(index+1, new_capacity)
        tmp_tour.tour.insert(index+1,self.origin)
        # tmp_tour capacityarray updaten. Alle Kapazitäten nach der neuen Origin werden um 
        #Kapazität des neuen Items erhöht
        new_capacityarray = []
        runarray = tmp_tour.capacityarray.clone
        runarray.each_with_index do |update_capacity, index1|
          if index1 > index+1
            newer_capacity = update_capacity + order.capacity
            new_capacityarray.push(newer_capacity)
          else
            new_capacityarray.push(update_capacity)
          end
        end
        tmp_tour.capacityarray = new_capacityarray.clone

        #Schleife - bis Kapazitätsgrenze verletzt werden würde, weil Delivery zu spät in Reihenfolge
        reset_tour = tmp_tour.clone
        reset_tour.capacityarray.each_with_index do |dest_capacity, index2|
          break if dest_capacity > self.capacity
          break if index2 < index

          # Destination-new einsetzen, Kapazität in Capacityarray und Destination in Tourarray
          if index2 == 0
            tmp_tour.tour.insert(index2+2,self.destination)
          else
            tmp_tour.tour.insert(index2+1,self.destination)
          end
          
          # Kapazitätsarray von tmp_tour updaten - Nach Desitnation wieder d.capacity abziehen
          new_capacityarray = []
          reset_tour.capacityarray.each_with_index do |update_capacity, index3|
            if index3 > index2+1
              update_capacity = update_capacity + self.destination.capacity
              new_capacityarray.push(update_capacity)
            else
              new_capacityarray.push(update_capacity)
            end
          end
          if new_capacityarray[new_capacityarray.length-1] != 0
            new_capacityarray.push(0)
          end         
          tmp_tour.capacityarray = new_capacityarray.clone          

          # Tourtime berechnen
          tmp_tour.time = time_for_tour(tmp_tour)
          
          # Wenn neue Tour schneller als bisherige neue Touren, wird die schnellere Zeit gespeichert
          if new_tour.time > tmp_tour.time
            new_tour = tmp_tour.clone
            new_tour.orderarray.push(order)
            tmp_tour = reset_tour.clone
          else
            # Zurücksetzen von tmp_tour
            tmp_tour = reset_tour.clone
          end
        end
      end
    end
    #Return schnellste Tour
    new_tour 
  end

  def set_ready (order, tour, position, capacity, speed)
    self.origin = Origin.new
    self.origin.name = "origin-#{order.name}"
    self.origin.id = order.id
    self.origin.position = order.origin
    self.origin.capacity = order.capacity

    self.destination = Destination.new
    self.destination.name = "destination-#{order.name}"
    self.destination.id = order.id
    self.destination.position = order.destination
    self.destination.capacity = order.capacity*-1
    
    
    self.position = Position.new
    self.position.position = position

    self.tour = tour
    if self.tour.tour.empty?
    self.tour.tour.push(self.position)
    end
    self.capacity = capacity
    self.speed = speed

  end

  # Für zwei Arrays pos1= [X,Y] ; pos2 = [X,Y] wird Zeit zurückgegeben
  # Kann durch andere Methoden /Schnittstellen zur Strecken- / Zeitberechnung ersetzt werden
  def time_for_distanz(pos1,pos2)
    pos1x = pos1[0]
    pos1y = pos1[1]
    pos2x = pos2[0]
    pos2y = pos2[1]

    distanz = (pos1x-pos2x)*(pos1x-pos2x)+(pos1y-pos2y)*(pos1y-pos2y)
    distanz = Math.sqrt(distanz)
    distanztime = distanz*self.speed # Geschwindigkeit von Carrier (1 LE/ZE)
  end

  # Gibt für ein tourobjekt die totalTourTime zurück
  def time_for_tour(tour)
    tour_array = tour.tour.clone
    time = 0
    tour_array.each_with_index do |position, index|
      if index >0
        index = index -1
        first =  tour_array[index] # Vorheriges Tourelement
        second = position # Aktuelles Tourelement
        time = time + time_for_distanz(first.position, second.position)
      end
    end
    time #return
  end
  
end