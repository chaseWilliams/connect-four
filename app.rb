require './lib/loader'

class App < Sinatra::Application

  # for front end
  get '/' do

  end

  # default API route
  get '/api/*' do
    begin
      response = self.send params['splat']
    rescue StandardError => err
      status 400
      {status: 'fail', reason: 'bad method name in query'}.to_json
    else
      response[:status] = 'good'
      response.to_json
    end
  end

  def setup board_size
    @game = Game.new(board_size)
    {
        board: @game.pieces,
        {
            win: false,
            player: nil
        }

    }
  end

  def play column, player
    @game.add_piece column, player
    results = @game.check_for_victory
    {
        board: @game.pieces,
        results
    }
  end
end