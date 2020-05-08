require_relative 'tic_tac_toe_node'

class SuperComputerPlayer < ComputerPlayer
  def move(game, mark)
    # build a TicTacToeNode from the board stored in the game passed in as an argument.
    node = TicTacToeNode.new(game.board, mark)
    
    possible_moves = node.children

    # iterate through the children of the node. If any of the children is a winning_node? for the mark passed in to the move method, return that node's prev_move_pos
    node = possible_moves.find { |child| child.winning_node?(mark) }

    return node.prev_move_pos if node

    # If none of the children of the node are winning_node?s, that's ok. Just pick one that isn't a losing_node? and return its prev_move_pos.

    node = possible_moves.find { |child| !child.losing_node?(mark) }

    return node.prev_move_pos if node

    # raise an error if there are no non-losing nodes
    raise "Oh crap, you beat the computer!"
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Play the brilliant computer!"
  hp = HumanPlayer.new("Jeff")
  cp = SuperComputerPlayer.new

  TicTacToe.new(hp, cp).run
end
