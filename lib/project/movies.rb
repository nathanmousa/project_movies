class MovieDB::Movies
  attr_accessor :title, :id, :poster_path, :genre_ids, :vote_average, :overview, :release_date
  @@all = []
  
  def initialize(args)
    args.each do |key, value|
      self.send("#{key}=", value) if self.respond_to?(key) #respond_to checks to see if class has method for that key, if not, ignore.
    end
    save
  end
  
  def self.all
    @@all
  end
  
  
  
  private
  def save
    @@all << self
  end
    
end