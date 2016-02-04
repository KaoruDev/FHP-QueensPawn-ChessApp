class CheckmateRunner
  def initialize(my_king: nil, game: nil)
    @my_king = my_king
    @opposite_color = my_king.opposite_color
    @game = game
  end

  def verify
    if piece_causing_check = @game.piece_causing_check(@my_king.color)
      return !@game.can_be_captured?(piece_causing_check)
    end

    false
  end
end
