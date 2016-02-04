class Piece < ActiveRecord::Base
  belongs_to :game
  validate :validate_color?

  def self.types
    %w(King Queen Rook Bishop Knight Pawn)
  end

  def validate_color?
    errors.add(:color, 'Invalid color') unless color == 'white' || color == 'black'
  end

  def is_vertical?(x_destination, y_destination)
  	self.x_position == x_destination
  end

  def is_horizontal?(x_destination, y_destination)
  	self.y_position == y_destination
  end

  def is_diagonal?(x_destination, y_destination)
  	x_destination - x_position == y_destination - y_position
  end

  def vertical_obstruction?(x_destination, y_destination)
  	is_obstructed = false
    ((self.y_position + 1)...y_destination).each do |y|
      if game.piece_at(x_destination, y)
        is_obstructed = true
	  	  break
      end
		end
		is_obstructed
  end

  def horizontal_obstruction?(x_destination, y_destination)
    is_obstructed = false
    ((self.x_position + 1)...x_destination).each do |x|
      if game.piece_at(x, y_destination)
        is_obstructed = true
        break
      end
  	end
  	is_obstructed
  end

  def diagonal_obstruction?(x_destination, y_destination)
    is_obstructed = false
    y_pos = (self.y_position + 1)
    ((self.x_position + 1)...x_destination).each do |x|
      if game.piece_at(x, y_pos)
        is_obstructed = true
        break
      end
      y_pos += 1
    end
    is_obstructed
  end

  def is_obstructed?(x_destination, y_destination)
    return diagonal_obstruction?(x_destination, y_destination) if is_diagonal?(x_destination, y_destination)
    return vertical_obstruction?(x_destination, y_destination) if is_vertical?(x_destination, y_destination)
    return horizontal_obstruction?(x_destination, y_destination) if is_horizontal?(x_destination, y_destination)
    raise 'Invalid input. Not diagonal, horizontal or vertical.'
  end

  def move_to!(x_position: nil, y_position: nil)
    another_piece = self.game.piece_at(x_position, y_position)
    if another_piece #exists...
      if another_piece.color != self.color #check if same color
        another_piece.destroy
        successful_move!(x_position: x_position, y_position: y_position)
      else
        return false
      end
    else
      successful_move!(x_position: x_position, y_position: y_position)
    end
  end

  def valid_move?(x, y)
    if x < 0 || x > 7
      return false
    elsif y < 0 || y > 7
      return false
    end
    return true
  end

  def opposite_color
    color == "white" ? "black" : "white"
  end

  private

  def successful_move!(x_position: nil, y_position: nil)
    self.update(x_position: x_position, y_position: y_position, has_moved: true)
    :success
  end

end
