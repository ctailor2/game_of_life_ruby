require_relative 'game'

helpers do
	def new_game(num_creatures)
		session.clear
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
end

get '/' do
	erb :index
end

post '/' do
	new_game(params["num_creatures"].to_i)
	@creature_locations = current_game.creature_locations(true)
	erb :index
end

post '/tick' do
	current_game.tick
	@creature_locations = current_game.creature_locations(true)
	erb :index
end