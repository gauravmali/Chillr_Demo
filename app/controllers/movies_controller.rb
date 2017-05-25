class MoviesController < ApplicationController
	# This method is for searching and displaying matched movies.
	def new
		searched_movie = params[:search] #The movie you search gets stored into this parameter.	
		if !searched_movie.to_s.empty?
			search_uri = URI.parse('https://api.themoviedb.org/3/search/movie')
			# Below we are passing api_key(for authentication) and the movie (string) searched into the API.
			search_uri.query = URI.encode_www_form([["api_key", "15cacb73da163c8e5e816fb17e13df8e"], ["query", "#{searched_movie}"]])
			search_response = Net::HTTP.get_response(search_uri)
			@search_response_body = JSON.parse(search_response.body) #Parsing the resonse body using Json
			@searched_movies_hash = {} #creating an empty hash to store movies id and title.
			@search_response_body["results"].each do |selected_movies|
				@searched_movies_hash[selected_movies["id"]] = selected_movies["original_title"] # Paring selected movies' ids (key) with the title name(value) in a hash. 
			end
		end
	end
	
	# This method is for displaying the selected movie's cast.
	def cast
		unique_movie_id = params[:query] #Remember the unique id we send when you click the movie, well here it is.
		if unique_movie_id != nil
			casting_uri = URI.parse("https://api.themoviedb.org/3/movie/#{unique_movie_id}/credits") #Passing that id into the Get API for searching the cast for that movie.
			casting_uri.query = URI.encode_www_form([["api_key", "15cacb73da163c8e5e816fb17e13df8e"]]) #using my api_key here again to authenticate the call.
			casting_response = Net::HTTP.get_response(casting_uri)
			@casting_response_body = JSON.parse(casting_response.body)
			@movie_casting_hash = {} #creating an empty hash to store casting details.
			@casting_response_body["cast"].each do |selected_cast|
				@movie_casting_hash[selected_cast["character"]] = selected_cast["name"] # Paring movie characters (key) and their real names (value) in a hash.
			end
		end
	end
end
