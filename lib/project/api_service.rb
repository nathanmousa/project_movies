class MovieDB::APIService
  BASE_URL= 'https://api.themoviedb.org/3'
  API_KEY= '8f825809c9f952d7a6170a99fd272c40'

  def self.search_single_movie(search) #Used to get 2nd level data not found in broad movie search such as genre, budget, runtime, etc.
    results = JSON.parse(RestClient.get("#{BASE_URL}/movie/#{search.id}?api_key=#{API_KEY}"))
    actors = JSON.parse(RestClient.get("#{BASE_URL}/movie/#{search.id}/credits?api_key=#{API_KEY}"))
    search.update(results)
    search.update(actors)
  end

  def self.pull_movies(method, search=nil, movie_id=nil)
    if search != nil
      results = JSON.parse(RestClient.get("#{BASE_URL}/#{method}/movie?api_key=#{API_KEY}&query=#{search}"))
    elsif movie_id != nil
      results = JSON.parse(RestClient.get("#{BASE_URL}/movie/#{movie_id}/#{method}?api_key=#{API_KEY}&page=1"))
    else
      results = JSON.parse(RestClient.get("#{BASE_URL}/movie/#{method}?api_key=#{API_KEY}&page=1"))
    end
    results["results"].each do |movie|
      MovieDB::Movies.new(movie)
    end
  end
end
