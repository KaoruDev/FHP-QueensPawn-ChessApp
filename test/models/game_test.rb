require 'test_helper'
require 'rr'

class GameTest < ActiveSupport::TestCase

  test "populate board" do
    game = FactoryGirl.create(:game)
    game.populate_board!
    assert_equal 32, game.pieces.count
  end

  def setup
    @game = FactoryGirl.create(:game)
    @game.populate_board!
    @game.save
  end

  test "any opposite pieces causing check false" do
    assert_equal false, @game.check?("white")
    assert_equal false, @game.check?("black")
  end

  test "any pieces causing check true 1" do

    b_pawn1 = @game.pieces.find_by(type: "Pawn", x_position: 5, y_position: 1)
    b_pawn1.update_attributes(x_position: 5, y_position: 3)

    w_pawn1 = @game.pieces.find_by(type: "Pawn", x_position: 4, y_position: 6)
    w_pawn1.update_attributes(x_position: 4, y_position: 5)

    b_pawn2 = @game.pieces.find_by(type: "Pawn", x_position: 6, y_position: 1)
    b_pawn2.update_attributes(x_position: 6, y_position: 3)

    white_queen = @game.pieces.find_by(type: "Queen", x_position: 3, y_position: 7)
    white_queen.update_attributes(x_position: 7, y_position: 3)

    assert_equal true, @game.check?("black")
  end

  test "any pieces causing check true 2" do
    Pawn.destroy_all(color: 'black', game: @game)
    @game.pieces.create(type: "Bishop", color: "white", x_position: 6, y_position: 2)
    assert_equal true, @game.check?("black")
  end

  test "no checkmate for black" do
    game = FactoryGirl.create(:game)

    FactoryGirl.create(:piece, type: 'King', color: 'black', x_position: 2, y_position: 0, game: game)
    FactoryGirl.create(:piece, type: 'Bishop', color: 'black', x_position: 4, y_position: 0, game: game)
    FactoryGirl.create(:piece, type: 'Rook', color: 'black', x_position: 0, y_position: 3, game: game)
    FactoryGirl.create(:piece, type: 'Pawn', color: 'black', x_position: 0, y_position: 1, game: game)
    FactoryGirl.create(:piece, type: 'Pawn', color: 'black', x_position: 1, y_position: 1, game: game)
    FactoryGirl.create(:piece, type: 'Pawn', color: 'black', x_position: 2, y_position: 1, game: game)

    FactoryGirl.create(:piece, type: 'King', color: 'white', x_position: 6, y_position: 7, game: game)
    target_piece = FactoryGirl.create(:piece, type: 'Bishop', color: 'white', x_position: 5, y_position: 3, game: game)
    FactoryGirl.create(:piece, type: 'Rook', color: 'white', x_position: 5, y_position: 7, game: game)
    FactoryGirl.create(:piece, type: 'Pawn', color: 'white', x_position: 5, y_position: 6, game: game)
    FactoryGirl.create(:piece, type: 'Pawn', color: 'white', x_position: 6, y_position: 5, game: game)
    FactoryGirl.create(:piece, type: 'Pawn', color: 'white', x_position: 7, y_position: 6, game: game)

    assert_equal 12,    game.pieces.count
    assert_equal true,  game.can_be_captured?(target_piece)
    assert_equal false, game.checkmate?('black')
    assert_equal false, game.checkmate?('white')
  end

  test "checkmate for black" do
    game = FactoryGirl.create(:game)

    FactoryGirl.create(:piece, type: 'King', color: 'black', x_position: 6, y_position: 0, game: game)
    FactoryGirl.create(:piece, type: 'Queen', color: 'black', x_position: 6, y_position: 3, game: game)
    FactoryGirl.create(:piece, type: 'Rook', color: 'black', x_position: 1, y_position: 5, game: game)
    FactoryGirl.create(:piece, type: 'Pawn', color: 'black', x_position: 5, y_position: 1, game: game)
    FactoryGirl.create(:piece, type: 'Pawn', color: 'black', x_position: 6, y_position: 1, game: game)
    FactoryGirl.create(:piece, type: 'Pawn', color: 'black', x_position: 7, y_position: 1, game: game)

    FactoryGirl.create(:piece, type: 'King', color: 'white', x_position: 6, y_position: 7, game: game)
    target_piece = FactoryGirl.create(:piece, type: 'Queen', color: 'white', x_position: 4, y_position: 0, game: game)
    FactoryGirl.create(:piece, type: 'Rook', color: 'white', x_position: 5, y_position: 7, game: game)
    FactoryGirl.create(:piece, type: 'Pawn', color: 'white', x_position: 5, y_position: 6, game: game)
    FactoryGirl.create(:piece, type: 'Pawn', color: 'white', x_position: 6, y_position: 6, game: game)
    FactoryGirl.create(:piece, type: 'Pawn', color: 'white', x_position: 7, y_position: 6, game: game)

    assert_equal false, game.can_be_captured?(target_piece)
    assert_equal true,  game.checkmate?('black')

    # white king on (6, 7) is protected by 3 pawns but put in checkmate by black queen on (6, 3)
     assert_equal false, game.checkmate?('white') # test returns true!?
  end

  test "can be captured black in check" do
    game = FactoryGirl.create(:game)

    FactoryGirl.create(:piece, type: 'King', color: 'black', x_position: 7, y_position: 7, game: game)
    target_piece = FactoryGirl.create(:piece, type: 'Rook', color: 'white', x_position: 0, y_position: 7, game: game)
    FactoryGirl.create(:piece, type: 'Rook', color: 'black', x_position: 0, y_position: 0, game: game)

    assert_equal true,  game.can_be_captured?(target_piece)
    assert_equal false, game.checkmate?('black')
  end

  test "can be captured white in check" do
    game = FactoryGirl.create(:game)

    FactoryGirl.create(:piece, type: 'King', color: 'white', x_position: 7, y_position: 7, game: game)
    target_piece = FactoryGirl.create(:piece, type: 'Rook', color: 'black', x_position: 6, y_position: 7, game: game)
    FactoryGirl.create(:piece, type: 'Rook', color: 'white', x_position: 6, y_position: 6, game: game)

    assert_equal true,  game.can_be_captured?(target_piece)
    assert_equal false, game.checkmate?('white')
  end

end
