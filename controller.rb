require_relative 'game'

helpers do
	def new_game(num_creatures)
		session[:game] = Game.new(params["num_creatures"].to_i)
	end

	def current_game
		session[:game]
	end

	def game_on?
		!session[:game].nil?
	end

	def creature_locations
		current_game.creature_locations(true)
	end

	def reset
		session.clear
	end
end

get '/' do
	reset
	erb :index
end

post '/' do
	reset
	new_game(params["num_creatures"].to_i)
	erb :index
end

post '/tick' do
	current_game.tick
	erb :index
end