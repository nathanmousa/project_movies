class MovieDB::Movies
  attr_accessor :title, :id, :poster_path, :genres, :vote_average, :overview, :release_date, :budget, :revenue, :status, :runtime, :production_companies, :cast, :character
  @@all = []
  
  def initialize(args)
    update(args)
    save
  end
  
  def update(args)
    args.each do |key, value|
      self.send("#{key}=", value) if self.respond_to?(key)
    end
  end
  
  def joined_list(var)
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
  
  def return_actor_list(value)
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