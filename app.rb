require './lib/loader'
include GameErrors
class App < Sinatra::Application

  def initialize
    super
    # note that a Redis instance must already be running

  end

  # for front end
  get '/' do

  end

  # default API route
  get '/api/:method' do
    #params.each {|key, value| value = value.to_i unless key == 'method'}
    begin
      if params['method'] == 'begin_game'
        response = begin_game params['size'].to_i
      elsif params['method'] == 'play'
        response = play params['col'].to_i, params['player'].to_i
      else
        raise BadMethodError
      end

    rescue BadMethodError => err
      status 400
      {status: 'fail', reason: err}.to_json
    else
      puts 'got to good'
      response[:status] = 'good'
      response.to_json
    end
  end

  def begin_game board_size
    puts "begin_game called"
    game = Game.new(board_size)
    Cache.save game.dump
    {
        board: game.pieces,
        results: {
            win: false,
            player: nil
        }

    }
  end

  def play column, player
    puts "play called"
    if column.nil? || player.nil?
      raise BadParam
    end
    game_contents = Cache.current
    game = Game.new(game_contents['size'], game_contents['pieces'], game_contents['piece_count'])
    game.add_piece column, player
    results = game.check_for_victory
    Cache.save game.dump
    {
        board: game.pieces,
        results: results
    }
  end
end
