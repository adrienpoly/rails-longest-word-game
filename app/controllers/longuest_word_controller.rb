class LonguestWordController < ApplicationController
  def game
    @grid = Boggle.generate_grid(10)
    @start_time = Time.now
    session[:grid] = @grid
    session[:start_time] = @start_time
  end

  def score
    @attempt = params[:your_try]
    grid = session[:grid]
    start_time = Time.parse(session[:start_time])
    end_time = Time.now
    @result = Boggle.run_game(@attempt, grid, start_time, end_time)
  end
end

