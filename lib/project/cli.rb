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

  def top_movies
    input = nil

    clear
    header
    puts "Here are the top 20 movies of all time:".colorize(:yellow)
    spacer
    MovieDB::APIService.pull_movies('top_rated')
    range = MovieDB::Movies.all.count.clamp(1, 20)
    MovieDB::Movies.all.take(range).each.with_index(1) do |movie, index|
      puts "#{index}. #{movie.title}"
    end
    spacer
    puts "What movie would you like to see more information on?".colorize(:yellow)
    select_movie(range)
  end

  def popular_movies
    input = nil

    clear
    header
    puts "Here are the top 20 popular movies today:".colorize(:yellow)
    spacer
    MovieDB::APIService.pull_movies('popular')
    range = MovieDB::Movies.all.count.clamp(1, 20)
    MovieDB::Movies.all.take(range).each.with_index(1) do |movie, index|
      puts "#{index}. #{movie.title}"
    end
    spacer
    puts "What movie would you like to see more information on?".colorize(:yellow)
    select_movie(range)
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
    input = nil

    clear
    header
    puts "Here are a few movies playing today at your local theater:".colorize(:yellow)
    spacer
    MovieDB::APIService.pull_movies('now_playing')
    range = MovieDB::Movies.all.count.clamp(1, 10)
    MovieDB::Movies.all.take(range).each.with_index(1) do |movie, index|
      puts "#{index}. #{movie.title}"
    end
    spacer
    puts "What movie would you like to see more information on?".colorize(:yellow)
    select_movie(range)
  end

  def upcoming_movies
    input = nil

    clear
    header
    puts "Here are a few upcoming movies:".colorize(:yellow)
    spacer
    MovieDB::APIService.pull_movies('upcoming')
    range = MovieDB::Movies.all.count.clamp(1, 10)
    MovieDB::Movies.all.take(range).each.with_index(1) do |movie, index|
      puts "#{index}. #{movie.title}"
    end
    spacer
    puts "What movie would you like to see more information on?".colorize(:yellow)
    select_movie(range)
  end





  def select_movie(array_range)
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
        puts "Rating: ".colorize(:yellow) + "%#{movie.vote_average.to_s.delete('.')}"
        puts "Genre: ".colorize(:yellow) + "#{movie.joined_list('genres')}"
        puts "Status: ".colorize(:yellow) + "#{movie.status}"
        spacer
        puts "Runtime: ".colorize(:yellow) + "#{movie.runtime} Minutes"
        puts "Budget: ".colorize(:yellow) + "#{currency(movie.budget)}"
        puts "Revenue: ".colorize(:yellow) + "#{currency(movie.revenue)}"
        puts "Profit: ".colorize(:yellow) + "#{currency(movie.revenue - movie.budget)}"
        spacer
        puts "Production Companies: ".colorize(:yellow) + "#{movie.joined_list('production_companies')}"
        spacer
        puts "-----------------------------------------------------------------".colorize(:green)
        spacer
        puts "Description:".colorize(:yellow)
        puts "#{movie.overview}"
        spacer
        puts "-----------------------------------------------------------------".colorize(:green)
        spacer
        puts "Starring:".colorize(:yellow)
        actor_hash.take(10).each do |name, character|
          puts "#{name} as #{character}"
        end
        spacer
        puts "-----------------------------------------------------------------".colorize(:green)
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
end
