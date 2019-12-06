class MovieDB::CLI

  def start
    clear
    menu
  end

  def menu
    input = nil
    MovieDB::Movies.reset

    header
    puts "What would you like to do today?".colorize(:yellow)
    spacer
    puts "1. Search Movie"
    puts "2. Top Movies"
    puts "3. Popular Movies"
    puts "4. Recommended Movies"
    puts "5. Now Playing"
    puts "6. Upcoming Movies"
    spacer
    input = gets.strip.downcase

    while input != 'exit'
      if input.to_i == 1 || input == "search movie"
        search_movie
      elsif input.to_i == 2 || input == "top movies"
        top_movies
      elsif input.to_i == 3 || input == "popular movies"
        popular_movies
      elsif input.to_i == 4 || input == "recommended movies"
        recommended_movies
      elsif input.to_i == 5 || input == "now playing"
        now_playing
      elsif input.to_i == 6 || input == "upcoming movies"
        upcoming_movies
      elsif input == 'return'
        menu
      else
      invalid
      input = gets.strip.downcase
      end
    end
    close
  end

  def search_movie
    input = nil

    clear
    header
    puts "What movie would you like to search?".colorize(:yellow)
    spacer
    input = gets.strip.downcase

    while input != 'exit'
      if input == 'return'
        clear
        menu
      end

      clear
      header
      MovieDB::APIService.pull_movies('search', input)

      if MovieDB::Movies.all.count >= 1
        range = MovieDB::Movies.all.count.clamp(1, 7)
        MovieDB::Movies.all.take(range).each.with_index(1) do |movie, index|
          puts "#{index}. #{movie.title}"
        end
        spacer
        puts "What movie would you like to see more information on?".colorize(:yellow)
        select_movie(range)
      else
        puts "Sorry, there were no movies by that name. Please try again.".colorize(:yellow)
        spacer
        input = gets.strip.downcase
      end
    end
    close
  end

  def recommended_movies
    input = nil

    clear
    header
    puts "What movie did you recently like?".colorize(:yellow)
    input = gets.strip.downcase

    while input != 'exit'
      if input == 'return'
        clear
        menu
      end

      clear
      header
      MovieDB::APIService.pull_movies('search', input)
      movie = MovieDB::Movies.all[0]
      MovieDB::Movies.reset
      MovieDB::APIService.pull_movies('similar', nil, movie.id)
      puts "Here are some recommended movies based on #{movie.title}:".colorize(:yellow)
      spacer
      range = MovieDB::Movies.all.count.clamp(1, 5)
      MovieDB::Movies.all.take(range).each.with_index(1) do |movie, index|
        puts "#{index}. #{movie.title}"
      end
      spacer
      puts "What movie would you like to see more information on?".colorize(:yellow)
      select_movie(range)
    end
    close
  end

  def now_playing
    fetch_data("Here are a few movies playing today at your local theater:", "now_playing", 10)
  end

  def upcoming_movies
    fetch_data("Here are a few upcoming movies:", "upcoming", 10)
  end
  
  def top_movies
    fetch_data("Here are the top 20 movies of all time:", "top_rated", 20)
  end

  def popular_movies
    fetch_data("Here are the top 20 popular movies today:", "popular", 20)
  end

  def select_movie(array_range) #Search down Hippo for no data movies
    spacer
    input = gets.strip.downcase

    while input != 'exit'
      if input == 'return'
        clear
        menu
      elsif numeric(input) && input.to_i.between?(1, array_range)
        clear
        header
        movie = MovieDB::Movies.all[input.to_i - 1]
        MovieDB::APIService.search_single_movie(movie) #Update database with 2nd level data
        actor_hash = Hash[movie.return_actor_list('name').zip movie.return_actor_list('character')] #Combines 2 arrays into a hash
        title = Artii::Base.new

        if movie.title.length <= 13
          puts title.asciify("#{movie.title}") + "#{movie.release_date[5..6]}/#{movie.release_date[8..9]}/#{movie.release_date[0..3]}".colorize(:yellow)
        else
          puts "#{movie.title}"
          puts "#{movie.release_date[5..6]}/#{movie.release_date[8..9]}/#{movie.release_date[0..3]}".colorize(:yellow)
        end
        spacer
        
        if movie.vote_average.to_s.delete('.') != "00"
          puts "Rating: ".colorize(:yellow) + "%#{movie.vote_average.to_s.delete('.')}"
        else
          puts "Rating: ".colorize(:yellow) + "Not enough votes to provide a fair rating"
        end
        
        if !movie.joined_list('genres').empty?
          puts "Genre: ".colorize(:yellow) + "#{movie.joined_list('genres')}"
        else
          puts "Genre: ".colorize(:yellow) + "No Data"
        end
        
        puts "Status: ".colorize(:yellow) + "#{movie.status}"
        spacer
        
        if movie.runtime.to_i != 0
          puts "Runtime: ".colorize(:yellow) + "#{movie.runtime} Minutes"
        else
          puts "Runtime: ".colorize(:yellow) + "No Data"
        end
        
        if movie.revenue.to_i != 0
          puts "Revenue: ".colorize(:yellow) + "#{currency(movie.revenue)}"
        else
          puts "Revenue: ".colorize(:yellow) + "No Data"
        end
        
        if movie.budget.to_i != 0
          puts "Budget: ".colorize(:yellow) + "#{currency(movie.budget)}"
        else
          puts "Budget: ".colorize(:yellow) + "No Data"
        end
        
        if movie.revenue.to_i - movie.budget.to_i != 0
          puts "Profit: ".colorize(:yellow) + "#{currency(movie.revenue - movie.budget)}"
        else
          puts "Profit: ".colorize(:yellow) + "No Data"
        end
        spacer
        
        if !movie.joined_list('production_companies').empty?
          puts "Production Companies: ".colorize(:yellow) + "#{movie.joined_list('production_companies')}"
          spacer
        end
        
        puts "-----------------------------------------------------------------".colorize(:green)
        
        if !movie.overview.empty?
          spacer
          puts "Description:".colorize(:yellow)
          puts "#{movie.overview}"
          spacer
          puts "-----------------------------------------------------------------".colorize(:green)
        end
        
        if !actor_hash.empty?
          spacer
          puts "Starring:".colorize(:yellow)
          actor_hash.take(10).each do |name, character|
            puts "#{name} as #{character}"
          end
          spacer
          puts "-----------------------------------------------------------------".colorize(:green)
        end
        puts "Type 'exit' to close this app or 'return' to go back to the main menu.".colorize(:yellow)
        spacer
        input = gets.strip.downcase

        while input != 'exit'
          if input == 'return'
            clear
            menu
          else
            invalid
            input = gets.strip.downcase
          end
        end

      else
        invalid
        input = gets.strip.downcase
      end
    end
    close
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
    puts "----------------------------------------------------------------------".colorize(:green)
    puts "                       The Movie Database App                         ".colorize(:green)
    puts "----------------------------------------------------------------------".colorize(:green)
    puts "Type 'exit' to close this app or 'return' to go back to the main menu.".colorize(:yellow)
    spacer
    spacer
  end

  def spacer
    puts ""
  end

  def close
    clear
    puts "Thanks for using The Movie Database App! Goodbye!".colorize(:green)
    exit
  end

  def currency(num)
  "$#{num.to_s.gsub(/\d(?=(...)+$)/, '\0,')}"
  end

  def numeric(string)
    string.scan(/\D/).empty?
  end

  def invalid
    spacer
    puts "Invalid Response! Please try again or type 'exit' to close the program.".colorize(:light_red)
    spacer
  end
  
  def fetch_data(script, method, range)
    input = nil

    clear
    header
    puts "#{script}".colorize(:yellow)
    spacer
    MovieDB::APIService.pull_movies("#{method}")
    array_range = MovieDB::Movies.all.count.clamp(1, range)
    
    MovieDB::Movies.all.take(array_range).each.with_index(1) do |movie, index|
      puts "#{index}. #{movie.title}"
    end
    
    spacer
    puts "What movie would you like to see more information on?".colorize(:yellow)
    select_movie(array_range)
  end
end