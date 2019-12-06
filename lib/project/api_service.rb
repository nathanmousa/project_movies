class MovieDB::APIService
  BASE_URL= 'https://api.themoviedb.org/3'
  API_KEY= '8f825809c9f952d7a6170a99fd272c40'

  def self.search_movie(search)
    results = JSON.parse(RestClient.get("#{BASE_URL}/search/movie?api_key=#{API_KEY}&query=#{search}"))
    results["results"].each do |movie|
      MovieDB::Movies.new(movie)
    end
  end

  def self.search_single_movie(search) #Used to get 2nd level data not found in broad movie search such as genre, budget, runtime, etc.
    results = JSON.parse(RestClient.get("#{BASE_URL}/movie/#{search.id}?api_key=#{API_KEY}"))
    search.update(results)
  end

  def self.top_movies
    results = JSON.parse(RestClient.get("#{BASE_URL}/movie/top_rated?api_key=#{API_KEY}&page=1"))
    results["results"].each do |movie|
      MovieDB::Movies.new(movie)
    end
  end

  def self.popular_movies
    results = JSON.parse(RestClient.get("#{BASE_URL}/movie/popular?api_key=#{API_KEY}&page=1"))
    results["results"].each do |movie|
      MovieDB::Movies.new(movie)
    end
  end

  def self.recommended(movie_id)
    results = JSON.parse(RestClient.get("#{BASE_URL}/movie/#{movie_id}/recommendations?api_key=#{API_KEY}&page=1"))
    results["results"].each do |movie|
      MovieDB::Movies.new(movie)
    end
  end

  def self.now_playing
    results = JSON.parse(RestClient.get("#{BASE_URL}/movie/now_playing?api_key=#{API_KEY}&page=1"))
    results["results"].each do |movie|
      MovieDB::Movies.new(movie)
    end
  end

  def self.upcoming_movies
    results = JSON.parse(RestClient.get("#{BASE_URL}/movie/upcoming?api_key=#{API_KEY}&page=1"))
    results["results"].each do |movie|
      MovieDB::Movies.new(movie)
    end
  end
end
