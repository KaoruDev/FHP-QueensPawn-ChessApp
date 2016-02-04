require 'test_helper'

class PawnTest < ActiveSupport::TestCase
  def setup
    @game = Game.new
    @first_white_pawn = Pawn.create(game: @game, color: 'white', x_position: 3, y_position: 6)
    @second_white_pawn = Pawn.create(game: @game, color: 'white', x_position: 5, y_position: 5)
    @first_black_pawn = Pawn.create(game: @game, color: 'black', x_position: 0, y_position: 1)
    @second_black_pawn = Pawn.create(game: @game, color: 'black', x_position: 2, y_position: 2)
  end

  test "First move white 1 space foward" do
    assert_equal true, @first_white_pawn.valid_move?(3, 5)
  end

  test "White first move pawn 2 space foward" do
    assert_equal true, @first_white_pawn.valid_move?(3, 4)
  end

  test "Invalid first move, too many steps foward" do
    assert_equal false, @first_white_pawn.valid_move?(3, 3)
    assert_equal false, @first_black_pawn.valid_move?(0, 5)
  end

  test "Invalid backward move" do
    assert_equal false, @first_white_pawn.valid_move?(3, 7)
    assert_equal false, @second_white_pawn.valid_move?(5, 6)
    assert_equal false, @first_black_pawn.valid_move?(0, 0)
    assert_equal false, @second_black_pawn.valid_move?(2, 1)
  end

  test "After white first move, 1 space foward" do
    assert_equal true, @second_white_pawn.valid_move?(5, 4)
  end

  test "Invalid 2nd move, moved too many steps foward" do
    @second_white_pawn.move_to!(x_position: 5, y_position: 3)
    assert_equal false, @second_white_pawn.valid_move?(5, 1)
    @second_black_pawn.move_to!(x_position: 2, y_position: 4)
    assert_equal false, @second_black_pawn.valid_move?(2, 2)
  end

  test "target_me Invalid diagonal move, no piece to capture" do
    assert_equal false, @second_white_pawn.valid_move?(4, 4)
    assert_equal false, @second_white_pawn.valid_move?(6, 4)
    assert_equal false, @second_black_pawn.valid_move?(3, 3)
    assert_equal false, @second_black_pawn.valid_move?(1, 3)
  end

  test "First move black 1 space foward" do
    assert_equal true, @first_black_pawn.valid_move?(0, 2)
  end

  test "First move black 2 space foward" do
    assert_equal true, @first_black_pawn.valid_move?(0, 3)
  end

  test "After black first move, 1 space foward" do
    assert_equal true, @second_black_pawn.valid_move?(2, 3)
  end

  test "White pawn right diagonal move to capture black" do
    Pawn.create(game: @game, color: 'black', x_position: 6, y_position: 4)
    assert_equal true, @second_white_pawn.valid_move?(6, 4)
  end

  test "White pawn left diagonal move to capture black" do
     Bishop.create(game: @game, color: 'black', x_position: 4, y_position: 4)
    assert_equal true, @second_white_pawn.valid_move?(4, 4)
  end

  test "White pawn left diagonal move cannot capture white" do
    Rook.create(game: @game, color: 'white', x_position: 4, y_position: 4)
    assert_equal false, @second_white_pawn.valid_move?(4, 4)
  end

  test "White pawn right diagonal move cannot capure white" do
    Pawn.create(game: @game, color: 'white', x_position: 6, y_position: 4)
    assert_equal false, @second_white_pawn.valid_move?(6, 4)
  end

  test "Black right diagonal move to capture white" do
    Rook.create(game: @game, color: 'white', x_position: 3, y_position: 3)
    assert_equal true, @second_black_pawn.valid_move?(3, 3)
  end

  test "Black left diagonal move to capture white" do
    Pawn.create(game: @game, color: 'white', x_position: 1, y_position: 3)
    assert_equal true, @second_black_pawn.valid_move?(1, 3)
  end

  test "Black left diagonal move cannot capture black" do
    Bishop.create(game: @game, color: 'black', x_position: 1, y_position: 3)
    assert_equal false, @second_black_pawn.valid_move?(1, 3)
  end

  test "Black right diagonal move cannot capture black" do
    Pawn.create(game: @game, color: 'black', x_position: 3, y_position: 3)
    assert_equal false, @second_black_pawn.valid_move?(3, 3)
  end
end
