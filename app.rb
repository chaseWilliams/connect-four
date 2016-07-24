require './lib/loader'
include GameErrors
class App < Sinatra::Application

  def initialize
    super
    @game = 'hello'
  end

  # for front end
  get '/' do

  end

  after do
    print @game.pieces.board_print
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
    @game = Game.new(board_size)
    {
        board: @game.pieces,
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
    puts @game.class
    @game.add_piece column, player
    results = @game.check_for_victory
    {
        board: @game.pieces,
        results: results
    }
  end
end