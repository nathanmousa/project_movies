class MovieDB::CLI

  def start
    clear
    header
    menu
  end

  def menu
    input = nil
    
    spacer
    puts "What would you like to do today? Type 'exit' anytime to close the program."
    puts "1. Search Movie"
    input = gets.strip.downcase
    
    if input == 'exit'
      close
    elsif input.to_i == 1 || input == "search movie"
      search_movie
    else
      puts "Invalid Response. Please try again or type 'exit' to close the program."
    end
  end

  def search_movie
    input = nil
    
    clear
    header
    puts "What movie would you like to search? Type 'return' to go back to the main menu."
    input = gets.strip.downcase
    
    if input == 'exit'
      close
    elsif input == 'return'
      clear
      menu
    else
      MovieDB::APIService.search_movie(input)
      clear
      puts "What movie would you like to see more information on?"
      MovieDB::Movies.all.each.with_index(1) do |movie, index|
        puts "#{index}. #{movie.title}"
      end
      
      input = gets.strip.downcase
      movie_selection = MovieDB::Movies.all[input.to_i - 1]
      MovieDB::APIService.search_single_movie(movie_selection)
    end
  end
  
  
  
  private
  def clear
    if Gem.win_platform?
      system 'cls'
    else
      system 'clear'
    end
  end
  
  def header
    puts "---------------------------------------------"
    puts "           The Movie Database App            "
    puts "---------------------------------------------"
  end
  
  def spacer
    puts ""
  end
  
  def close
    clear
    puts "Thanks for using The Movie Database App! Goodbye!"
    exit
  end
  
end