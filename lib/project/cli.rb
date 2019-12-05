class MovieDB::CLI

  def start
    clear
    header
    menu
  end

  def menu
    input = nil
    
    while input != 'exit'
      spacer
      puts "What would you like to do today? Type 'exit' anytime to close the program."
      puts "1. Search Movie"
      input = gets.strip.downcase

      if input.to_i == 1 || input == "search movie"
        search_movie
      else
        puts "Invalid Response. Please try again or type 'exit' to close the program."
      end
    end
  end

  def search_movie
    input = nil
    
    while input != 'exit'
      clear
      header
      puts "What movie would you like to search?"
      input = gets.strip
      MovieDB::APIService.search_movie(input)
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
    puts "------------------------------------"
    puts "      The Movie Database App        "
    puts "------------------------------------"
  end
  
  def spacer
    puts ""
  end
  
end