class MovieDB::CLI

  def start
    puts "Welcome to the Movie Database App"
    puts "---------------------------------"
    menu
  end

  def menu
    input = nil
    
    while input != 'exit'
      puts "Press 1 to search."
      input = gets.strip.downcase

      if input.to_i == 1
        search_movie
      else
        puts "Invalid Response. Please try again."
      end
    end
  end

  def search_movie
    input = nil
    
    puts "What movie would you like to search?"
    input = gets.strip
    MovieDB::APIService.search_movie(input)
  end
  
end