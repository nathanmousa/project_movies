class MovieDB::Movies
  attr_accessor :title, :id, :poster_path, :genre_ids, :vote_average, :overview, :release_date, :budget, :revenue, :status, :runtime, :production_companies
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
  
  def companies
    x = @production_companies.each do |k, v|
    end
    binding.pry
  end
  
  def self.all
    @@all
  end
  
  
  
  private
  def save
    @@all << self
  end
    
end