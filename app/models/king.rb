class King < Piece

  def possible_moves(x_position, y_position)
    x, y = x_position, y_position
    width, height = 8, 8

    moves = [
      [(x+1), y], [x, (y+1)],
      [(x-1), y], [x, (y-1)],
      [(x+1), (y+1)], [(x-1), (y+1)],
      [(x-1), (y-1)], [(x+1), (y-1)]
    ]

    moves.select do |coord|
      x, y = coord[0], coord[1]
      x >= 0 && (x <= (width - 1)) && y >= 0 && (y <= (height - 1))
    end
  end

  def valid_move?(new_x_position, new_y_position)
    new_position = [new_x_position, new_y_position]
    possible_moves(x_position, y_position).include? new_position 
  end

end
