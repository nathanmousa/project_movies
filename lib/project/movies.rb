class MovieDB::Movies
  attr_accessor :title, :id, :backdrop_path, :genre_ids, :vote_average, :overview, :release_date, :budget, :revenue, :status, :tagline
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
  
  def self.all
    @@all
  end
  
  
  
  private
  def save
    @@all << self
  end
    
end