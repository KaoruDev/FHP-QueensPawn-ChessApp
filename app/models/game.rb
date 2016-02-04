class Game < ActiveRecord::Base
  has_many :pieces
  #after_create :populate_board!

  def populate_board!
    (0..7).each do |y|
      Piece.create(:type => 'Pawn', :color => 'black', :game_id => id, :x_position => y, :y_position => 1)
    end
    Piece.create(:type => 'Rook', :color => 'black', :game_id => id, :x_position => 0, :y_position => 0)
    Piece.create(:type => 'Rook', :color => 'black', :game_id => id, :x_position => 7, :y_position => 0)

    Piece.create(:type => 'Knight', :color => 'black', :game_id => id, :x_position => 1, :y_position => 0)
    Piece.create(:type => 'Knight', :color => 'black', :game_id => id, :x_position => 6, :y_position => 0)

    Piece.create(:type => 'Bishop', :color => 'black', :game_id => id, :x_position => 2, :y_position => 0)
    Piece.create(:type => 'Bishop', :color => 'black', :game_id => id, :x_position => 5, :y_position => 0)

    Piece.create(:type => 'King', :color => 'black', :game_id => id, :x_position => 4, :y_position => 0)
    Piece.create(:type => 'Queen', :color => 'black', :game_id => id, :x_position => 3, :y_position => 0)

    (0..7).each do |y|
      Piece.create(:type => 'Pawn', :color => 'white', :game_id => id, :x_position => y, :y_position => 6)
    end
    Piece.create(:type => 'Rook', :color => 'white', :game_id => id, :x_position => 0, :y_position => 7)
    Piece.create(:type => 'Rook', :color => 'white', :game_id => id, :x_position => 7, :y_position => 7)

    Piece.create(:type => 'Knight', :color => 'white', :game_id => id, :x_position => 1, :y_position => 7)
    Piece.create(:type => 'Knight', :color => 'white', :game_id => id, :x_position => 6, :y_position => 7)

    Piece.create(:type => 'Bishop', :color => 'white', :game_id => id, :x_position => 2, :y_position => 7)
    Piece.create(:type => 'Bishop', :color => 'white', :game_id => id, :x_position => 5, :y_position => 7)

    Piece.create(:type => 'King', :color => 'white', :game_id => id, :x_position => 4, :y_position => 7)
    Piece.create(:type => 'Queen', :color => 'white', :game_id => id, :x_position => 3, :y_position => 7)
  end

  def piece_at(column_coordinate, row_coordinate)
    pieces.where(x_position: column_coordinate, y_position: row_coordinate).first
  end

  def check?(color)
    !!piece_causing_check(color)
  end

  def piece_causing_check(color)
    king = pieces.find_by(type: 'King', color: color)
    opponents_pieces = pieces.where(color: king.opposite_color)
    destination = [king.x_position, king.y_position]

    opponents_pieces.find do |piece|
      piece.valid_move?(*destination) && !piece.is_obstructed?(*destination)
    end

  end

  def can_be_captured?(piece_causing_check)
    destination = [piece_causing_check.x_position, piece_causing_check.y_position]

    !!pieces.where(color: piece_causing_check.opposite_color).find do |piece|
      piece.valid_move?(*destination) && !piece_causing_check.is_obstructed?(*destination)
    end
  end

  def checkmate?(color)
    king_in_check = pieces.find_by(type: 'King', color: color)
    runner = CheckmateRunner.new(my_king: king_in_check, game: self)
    runner.verify
  end

end
