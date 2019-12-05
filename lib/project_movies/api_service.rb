class MovieDB::APIService
  BASE_URL= 'https://api.themoviedb.org/3'
  API_KEY= '8f825809c9f952d7a6170a99fd272c40'

  def self.search_movie(input)
    movie_results = RestClient.get("#{BASE_URL}/search/movie?api_key=#{API_KEY}&query=#{input}")
  end
end
