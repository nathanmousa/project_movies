class MovieDB::Movies
  attr_accessor :title, :id, :poster_path, :genres, :vote_average, :overview, :release_date, :budget, :revenue, :status, :runtime, :production_companies, :name, :character
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
  
  def genre_list
    genres = []
    
    @genres.each do |hash|
      hash.each do |key, data|
        if key == 'name' 
          genres << data
        end
      end
    end
    genres.join(', ')
  end
  
  def actor_list
    actor_name = []
    
    @name.each do |hash|
      hash.each do |key, data|
        if key == 'name' 
          actor_name << data
        end
      end
    end
    actor_name
  end
  
  def character_list
    character = []
    
    @character.each do |hash|
      hash.each do |key, data|
        if key == 'character' 
          character << data
        end
      end
    end
    character
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