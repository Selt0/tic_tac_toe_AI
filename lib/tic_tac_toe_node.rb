require_relative 'tic_tac_toe'

class TicTacToeNode

  attr_reader :board, :next_mover_mark, :prev_move_pos

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(evaluator)
    #board is over and winner is the opponent
    if board.over?
      return board.won? && board.winner != evaluator
    end

    #player's turn and all the children nodes are losers
    if self.next_mover_mark == evaluator
      self.children.all? { |node| node.losing_node?(evaluator) }
    else
      #opponent's turn and one of the children nodes is a losing node for the player
      self.children.any? { |node| node.losing_node?(evaluator) }
    end
  end

  def winning_node?(evaluator)
    #board is over and winner is player
    if board.over?
      return board.won? && board.winner == evaluator
    end

    #players turn and one of the children nodes is a winning node
    if self.next_mover_mark == evaluator
      self.children.any? { |node| node.winning_node?(evaluator) }
    else
    #opponents turn and all the children nodes is a winning node for the player
      self.children.all? { |node| node.winning_node?(evaluator) }
    end
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    #returns nodes representing all the potential game states
    children = []

    (0..2).each do |row_idx|
      (0..2).each do |col_idx|
        pos = [row_idx, col_idx]
        #iterate through all the positions that are empty
        next unless board.empty?(pos) 
        
        #for each position, create a node by duping the board and putting a next_mover_mark on the pos
        board_copy = board.dup
        board_copy[pos] = self.next_mover_mark

        #alternate next_mover_mark so that next time the other player gets a move
        next_mover_mark = (self.next_mover_mark == :x ? :o : :x)

        #set prev_move_pos to the pos you just marked
        children << TicTacToeNode.new(board_copy, next_mover_mark, pos)
      end
    end
    children
  end
end
