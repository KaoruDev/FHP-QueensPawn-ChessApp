module ValidMoveRunners
  class Pawn
    def initialize(configs={})
      @dest_x = configs[:dest_x]
      @dest_y = configs[:dest_y]
      @destination = [@dest_x, @dest_y]
      @game = configs[:game]
      @pawn = configs[:pawn]
    end

    def verify
      return false if invalid_forward_move?
      return true if is_moving?

      target_piece = @game.piece_at(*@destination)

      !!(target_piece && target_piece.color == @pawn.opposite_color && capture_move_is_valid?)
    end

    def capture_move_is_valid?
      (@dest_x - @pawn.x_position).abs == 1
    end

    def is_moving?
      @dest_x == @pawn.x_position
    end

    def invalid_forward_move?
      is_moving_backwards? || moving_more_than_allowed_spaces?
    end

    def moving_more_than_allowed_spaces?
      movement = (@dest_y - @pawn.y_position).abs
      allowed_spaces = @pawn.has_moved? || !is_moving? ? 1 : 2
      movement > allowed_spaces
    end

    def is_moving_backwards?
      if @pawn.color == 'black'
        @dest_y < @pawn.y_position
      else
        @dest_y > @pawn.y_position
      end
    end
  end
end
