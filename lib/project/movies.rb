class MovieDB::Movies
  attr_accessor :title, :id, :poster_path, :genre_ids, :vote_average, :overview, :release_date, :budget, :revenue, :status, :runtime, :production_companies, :company
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
  
  def self.all
    @@all
  end
  
  
  
  private
  def save
    @@all << self
  end
    
end