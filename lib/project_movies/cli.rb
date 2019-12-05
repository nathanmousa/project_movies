Class MovieDB::CLI

  def start
    puts "Welcome to the Movie Database App"
    menu
  end

  def menu
    puts "List Functionality Here"
    input = gets.strip

    search_movie if input == 1
  end

  private
  def search_movie
    puts "What movie would you like to search?"
    input = gets.strip

    MovieDB::APIService.search_movie(input)

  end
end
