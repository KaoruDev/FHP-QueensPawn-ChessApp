class Pawn < Piece

  def valid_move?(x, y)
    return false if !super
    ValidMoveRunners::Pawn.new({
      dest_x: x,
      dest_y: y,
      game: game,
      pawn: self,
    }).verify
  end

  def to_my_image_path
    # in assets/images
    "pawn_#{color}.svg"
  end
end
