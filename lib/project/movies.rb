class MovieDB::Movies
  attr_accessor :title, :id, :poster_path, :genres, :vote_average, :overview, :release_date, :budget, :revenue, :status, :runtime, :production_companies
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
  
  def production_list
    companies = []
    
    @production_companies.each do |hash|
      hash.each do |key, data|
        if key == 'name' 
          companies << data
        end
      end
    end
    companies.join(', ')
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