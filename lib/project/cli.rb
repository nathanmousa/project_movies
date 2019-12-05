class MovieDB::CLI

  def start
    clear
    menu
  end

  def menu
    input = nil
    
    header
    puts "What would you like to do today? Type 'exit' anytime to close the program."
    spacer
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
      header
      MovieDB::Movies.all.take(5).each.with_index(1) do |movie, index|
        puts "#{index}. #{movie.title}"
      end
      spacer
      puts "What movie would you like to see more information on? Type 'return' to go back to the main menu."
      input = gets.strip.downcase
      
      if input == 'exit'
        close
      elsif input == 'return'
        clear
        menu
      elsif input == [1..5]
        movie = MovieDB::Movies.all[input.to_i - 1]
        MovieDB::APIService.search_single_movie(movie)
        clear
        header
      
        title = Artii::Base.new
        if movie.title.split.size <= 2
          puts title.asciify("#{movie.title}") + "#{movie.release_date[5..6]}/#{movie.release_date[8..9]}/#{movie.release_date[0..3]}"
        else
          puts "#{movie.title}"
          puts "#{movie.release_date[5..6]}/#{movie.release_date[8..9]}/#{movie.release_date[0..3]}"
        end
        spacer
        puts "Rating: %#{movie.vote_average.to_s.delete('.')}"
        puts "Genre: #{movie.genre_list}"
        puts "Status: #{movie.status}"
        spacer
        puts "Runtime: #{movie.runtime}"
        puts "Budget: #{currency(movie.budget)}"
        puts "Revenue: #{currency(movie.revenue)}"
        puts "Profit: #{currency(movie.revenue - movie.budget)}"
        spacer
        puts "Production Companies: #{movie.production_list}"
        spacer
        puts "Description: #{movie.overview}"
        spacer
        spacer
        puts "-----------------------------------------------------------------"
        puts "Type 'exit' to close this app or 'return' to go back to the main menu."
        input = gets.strip.downcase
      
        if input == 'exit'
          close
        elsif input == 'return'
          clear
          menu
        else
          puts "Invalid Response. Please try again or type 'exit' to close the program."
        end
      else
      puts "Invalid Response. Please try again or type 'exit' to close the program."
      menu #NEED TO RESTRUCTURE AND SEPERATE METHODS
      end
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
    puts "-----------------------------------------------------------------"
    puts "                     The Movie Database App                      "
    puts "-----------------------------------------------------------------"
    spacer
  end
  
  def spacer
    puts ""
  end
  
  def close
    clear
    puts "Thanks for using The Movie Database App! Goodbye!"
    exit
  end
  
  def currency(num)
  "$#{num.to_s.gsub(/\d(?=(...)+$)/, '\0,')}"
  end
  
end