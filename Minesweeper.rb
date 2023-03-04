class Minesweeper
    def initialize(num_rows, num_cols, num_bombs)
      @num_rows = num_rows
      @num_cols = num_cols
      @num_bombs = num_bombs
      @board = generate_board
    end
  
    def generate_board
      board = Array.new(@num_rows) { Array.new(@num_cols) }
      bombs_planted = 0
  
      while bombs_planted < @num_bombs
        row = rand(@num_rows)
        col = rand(@num_cols)
  
        if board[row][col] != "B"
          board[row][col] = "B"
          bombs_planted += 1
        end
      end
  
      board.each_with_index do |row, i|
        row.each_with_index do |cell, j|
          if cell != "B"
            neighbor_bomb_count = 0
            neighbors(i, j).each do |x, y|
              neighbor_bomb_count += 1 if board[x][y] == "B"
            end
            board[i][j] = neighbor_bomb_count
          end
        end
      end
  
      board
    end
  
    def neighbors(row, col)
      positions = []
      (row - 1..row + 1).each do |i|
        (col - 1..col + 1).each do |j|
          positions << [i, j] if i >= 0 && i < @num_rows && j >= 0 && j < @num_cols
        end
      end
      positions.delete([row, col])
      positions
    end
  
    def play
      @revealed_board = Array.new(@num_rows) { Array.new(@num_cols, "_") }
      game_over = false
  
      until game_over
        print_board
        puts "Enter the row and column you'd like to reveal (e.g. '3,4')"
        input = gets.chomp.split(",")
        row, col = input[0].to_i, input[1].to_i
  
        if @board[row][col] == "B"
          game_over = true
          puts "created by himanshu"
          puts "Game over! You hit a bomb."
          print_board(true)
        else
          reveal(row, col)
          if won?
            game_over = true
            puts "created by himanshu"
            puts "Congratulations, you won!"
            print_board(true)
          end
        end
      end
    end
  
    def reveal(row, col)
      return if @revealed_board[row][col] != "_"
  
      @revealed_board[row][col] = @board[row][col]
  
      if @board[row][col] == 0
        neighbors(row, col).each do |n_row, n_col|
          reveal(n_row, n_col)
        end
      end
    end
  
    def won?
      @revealed_board.flatten.none? { |cell| cell == "_" }
    end
  
    def print_board(reveal_all = false)
      puts "   " + (0...@num_cols).to_a.join(" ")
      @revealed_board.each_with_index do |row, i|
        print "#{i}  "
        row.each_with_index do |cell, j|
          if cell == "_"
            if reveal_all && @board[i][j] == "B"
              print "B "
            else
              print "_ "
            end
          else
            print "#{cell} "
          end
        end
        puts ""
      end
    end
  end
  
  game = Minesweeper.new(10, 10, 15)
  game.play
  