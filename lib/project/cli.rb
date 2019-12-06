class MovieDB::CLI

  def start
    clear
    menu
  end

  def menu
    input = nil
    MovieDB::Movies.reset

    header
    puts "What would you like to do today?"
    spacer
    puts "1. Search Movie"
    puts "2. Top Movies"
    puts "3. Popular Movies"
    puts "4. Recommended Movies"
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
    puts "What movie would you like to search?"
    input = gets.strip.downcase

    while input != 'exit'
      if input == 'return'
        clear
        menu
      end

      clear
      header
      MovieDB::APIService.search_movie(input)
      MovieDB::Movies.all.take(8).each.with_index(1) do |movie, index|
        puts "#{index}. #{movie.title}"
      end

      spacer
      puts "What movie would you like to see more information on?"
      select_movie
    end
    close
  end

  def top_movies
    input = nil

    clear
    header
    puts "Here are the top 20 movies of all time:"
    spacer
    MovieDB::APIService.top_movies
    MovieDB::Movies.all.take(20).each.with_index(1) do |movie, index|
      puts "#{index}. #{movie.title}"
    end

    spacer
    puts "What movie would you like to see more information on?"
    select_movie
  end

  def popular_movies
    input = nil

    clear
    header
    puts "Here are the top 20 popular movies today:"
    spacer
    MovieDB::APIService.popular_movies
    MovieDB::Movies.all.take(20).each.with_index(1) do |movie, index|
      puts "#{index}. #{movie.title}"
    end

    spacer
    puts "What movie would you like to see more information on?"
    select_movie
  end

  def recommended_movies
    input = nil

    clear
    header
    puts "What movie did you recently like?"
    input = gets.strip.downcase

    while input != 'exit'
      if input == 'return'
        clear
        menu
      end

      clear
      header
      MovieDB::APIService.search_movie(input)
      MovieDB::Movies.all.take(8).each.with_index(1) do |movie, index|
        puts "#{index}. #{movie.title}"
      end

      spacer
      puts "Select which movie you want to base your recommendations on."
      input = gets.strip.downcase

      while input != 'exit'
        if input == 'return'
          clear
          menu
        elsif numeric(input)
          clear
          header
          movie = MovieDB::Movies.all[input.to_i - 1]
          MovieDB::APIService.recommended(movie)
          MovieDB::Movies.all.take(8).each.with_index(1) do |movie, index|
            puts "#{index}. #{movie.title}"
          end
        else
          invalid
          input = gets.strip.downcase
        end
      end
      close
    end
    close
  end

  def select_movie #NEED TO FIX USER FROM SELECTING OUTSIDE ARRAY RANGE + STOP QUERY IF NO MOVIE IS AVAILABLE + IF ONLY ONE MOVIE, SKIP SELECTION AND GO STRAIGHT TO MOVIE
    input = gets.strip.downcase

    while input != 'exit'
      if input == 'return'
        clear
        menu
      elsif numeric(input)
        clear
        header
        movie = MovieDB::Movies.all[input.to_i - 1]
        MovieDB::APIService.search_single_movie(movie)
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
        puts "Runtime: #{movie.runtime} Minutes"
        puts "Budget: #{currency(movie.budget)}"
        puts "Revenue: #{currency(movie.revenue)}"
        puts "Profit: #{currency(movie.revenue - movie.budget)}"
        spacer
        puts "Production Companies: #{movie.production_list}"
        spacer
        spacer
        puts "Description:"
        puts "#{movie.overview}"
        spacer
        puts "-----------------------------------------------------------------"
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
    puts "----------------------------------------------------------------------"
    puts "                       The Movie Database App                         "
    puts "----------------------------------------------------------------------"
    puts "Type 'exit' to close this app or 'return' to go back to the main menu."
    spacer
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

  def numeric(string)
    string.scan(/\D/).empty?
  end

  def invalid
    puts "Invalid Response. Please try again or type 'exit' to close the program."
  end

end
