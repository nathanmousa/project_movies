Class MovieDB::CLI

  def start
    puts "Welcome to the Movie Database App"
    puts "---------------------------------"
    menu
  end

  def menu
    puts "Press 1 to search."
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
