class MovieDB::CLI

  def start
    menu
  end

  def menu #Main Menu
    clear
    input = nil
    resetdb

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
    divider
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

  def find_movie
    input = nil

    MovieDB::Movies.find(input)
  end

  def search_movie #Take's user input and searches for movies
    input = nil

    clear
    header
    puts "What movie would you like to search?".colorize(:yellow)
    spacer
    divider
    spacer
    input = gets.strip.downcase

    while input != 'exit'
      if input == 'return'
        menu
      end

      clear
      header
      MovieDB::APIService.pull_movies('search', input)

      if MovieDB::Movies.all.count >= 1
        range = MovieDB::Movies.all.count.clamp(1, 10)
        MovieDB::Movies.all.take(range).each.with_index(1) do |movie, index|
          puts "#{index}. #{movie.title}"
        end
        spacer
        puts "What movie would you like to see more information on?".colorize(:yellow)
        puts "Type the number referencing the movie.".colorize(:yellow)
        select_movie(range)
      else
        puts "Sorry, there were no movies by that name. Please try again.".colorize(:yellow)
        spacer
        divider
        spacer
        input = gets.strip.downcase
      end
    end
    close
  end

  def recommended_movies #Take's user input and returns movies recommended
    input = nil

    clear
    header
    puts "What movie did you recently like?".colorize(:yellow)
    spacer
    divider
    spacer
    input = gets.strip.downcase

    while input != 'exit'
      if input == 'return'
        menu
      end

      clear
      header
      MovieDB::APIService.pull_movies('search', input)
      movie = MovieDB::Movies.all[0]
      resetdb
      MovieDB::APIService.pull_movies('similar', nil, movie.id)
      puts "Here are some recommended movies based on #{movie.title}:".colorize(:yellow)
      spacer
      range = MovieDB::Movies.all.count.clamp(1, 5)
      MovieDB::Movies.all.take(range).each.with_index(1) do |movie, index|
        puts "#{index}. #{movie.title}"
      end
      spacer
      puts "What movie would you like to see more information on?".colorize(:yellow)
      puts "Type the number referencing the movie.".colorize(:yellow)
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

  def select_movie(array_range) #Will select a specific movie and recieve level 2 data + display to user
    spacer
    divider
    spacer
    input = gets.strip.downcase

    while input != 'exit'
      if input == 'return'
        menu
      elsif numeric?(input) && input.to_i.between?(1, array_range)
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
          puts "Rating: ".colorize(:yellow) + "N/A"
        end

        if !movie.joined_list('genres').empty?
          puts "Genre: ".colorize(:yellow) + "#{movie.joined_list('genres')}"
        else
          puts "Genre: ".colorize(:yellow) + "N/A"
        end

        puts "Status: ".colorize(:yellow) + "#{movie.status}"
        spacer

        if movie.runtime.to_i != 0
          puts "Runtime: ".colorize(:yellow) + "#{movie.runtime} Minutes"
        else
          puts "Runtime: ".colorize(:yellow) + "N/A"
        end

        if movie.revenue.to_i != 0
          puts "Revenue: ".colorize(:yellow) + "#{currency(movie.revenue)}"
        else
          puts "Revenue: ".colorize(:yellow) + "N/A"
        end

        if movie.budget.to_i != 0
          puts "Budget: ".colorize(:yellow) + "#{currency(movie.budget)}"
        else
          puts "Budget: ".colorize(:yellow) + "N/A"
        end

        if movie.revenue.to_i - movie.budget.to_i != 0
          puts "Profit: ".colorize(:yellow) + "#{currency(movie.revenue - movie.budget)}"
        else
          puts "Profit: ".colorize(:yellow) + "N/A"
        end
        spacer

        if !movie.joined_list('production_companies').empty?
          puts "Production Companies: ".colorize(:yellow) + "#{movie.joined_list('production_companies')}"
          spacer
        end

        divider

        if !movie.overview.empty?
          spacer
          puts "Description:".colorize(:yellow)
          puts "#{movie.overview}"
          spacer
          divider
        end

        if !actor_hash.empty?
          spacer
          puts "Starring:".colorize(:yellow)
          actor_hash.take(10).each do |name, character|
            puts "#{name} as #{character}"
          end
          spacer
        end

        puts "Type 'exit' to close this app or 'return' to go back to the main menu.".colorize(:yellow)
        spacer
        divider
        spacer
        input = gets.strip.downcase

        while input != 'exit'
          if input == 'return'
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
  def clear #Clears Terminal
    if Gem.win_platform?
      system 'cls'
    else
      system 'clear'
    end
  end

  def header #Persistent Header
    divider
    puts "                       The Movie Database App                         ".colorize(:green)
    divider
    puts "Type 'exit' to close this app or 'return' to go back to the main menu.".colorize(:yellow)
    spacer
    spacer
  end

  def spacer #Breakline
    puts ""
  end

  def close #Prints Goodbye Message
    clear
    puts "Thanks for using The Movie Database App! Goodbye!".colorize(:green)
    exit
  end

  def currency(num) #Converts Digits to Currency Format
  "$#{num.to_s.gsub(/\d(?=(...)+$)/, '\0,')}"
  end

  def numeric?(string) #Checks if String is Numerical
    string.scan(/\D/).empty?
  end

  def invalid #Prints Invalid Response
    spacer
    puts "Invalid Response! Please try again or type 'exit' to close the program.".colorize(:light_red)
    spacer
  end

  def resetdb #Resets Program's Movie Database
    MovieDB::Movies.reset
  end

  def divider #Line Divider
    puts "----------------------------------------------------------------------".colorize(:green)
  end

  def fetch_data(script, method, range) #Grabs New Data w/ Given Script, Method, and Range
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
    puts "Type the number referencing the movie.".colorize(:yellow)
    select_movie(array_range)
  end
end
