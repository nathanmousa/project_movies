class MovieDB::Movies
  attr_accessor :title, :id, :poster_path, :genre_ids, :vote_count, :vote_average, :overview, :release_date
  
  def initialize(args)
    args.each do |key, value|
      self.send("#{key}=", value)
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