class MovieDB::Movies
  attr_accessor :title, :id, :genres, :vote_average, :overview, :release_date, :budget, :revenue, :status, :runtime, :production_companies, :cast, :character
  @@all = []
  
  def initialize(data)
    update(data)
    save
  end
  
  def update(data) #Searches through hash recieved and saving key + value to attr that matches name. Ignores any additional data not needed for this class.
    data.each do |key, value|
      self.send("#{key}=", value) if self.respond_to?(key)
    end
  end
  
  def joined_list(var) #Takes 3rd level data and binds them together in on line for user readability.
    array = []
    instance_variable = instance_variable_get("@#{var}")
    
    instance_variable.each do |hash|
      hash.each do |key, data|
        if key == 'name' 
          array << data
        end
      end
    end
    array.join(', ')
  end
  
  def return_actor_list(value) #Takes 3rd level data and saves it into it's own array to be listed later.
    array = []
    
    @cast.each do |hash|
      hash.each do |key, data|
        if key == value
          array << data
        end
      end
    end
    array
  end
  
  def self.all
    @@all
  end
  
  def self.reset
    @@all.clear
  end
  
  
  
  
  
  
  private
  def save
    @@all << self
  end
end