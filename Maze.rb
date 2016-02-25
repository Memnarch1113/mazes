#Gabriel Seltzer 2/8/2016
#Mazes PA

class Maze
  @x_size
  @y_size
  @cells
  def initialize (x, y)
    @x_size = x
    @y_size = y
    @cells = Hash.new
  #  @cells = Array.new(x)
  #  @cells.map!{Array.new(y)}
  end

  def load(seed)
    seed = seed.split(//)

    x = 0
    y = 0
    skip = 0
    saved = 0
    (((@x_size*2)+2)..(seed.length-(@x_size*2)-2)).each do |current_index|
    #  puts "CURRENT INDEX IS: #{current_index} Which is #{seed[current_index]}"
      if skip == 0
        if seed[current_index-1].to_i == 0
          connected_left = "0"
        else
          connected_left = "1"
        end
        if seed[current_index+1].to_i == 0
          connected_right = "0"
        else
          connected_right = "1"
        end
        if seed[current_index-(@x_size*2+1)].to_i == 0
          connected_up = "0"
        else
          connected_up = "1"
        end
        if seed[current_index+@x_size*2+1].to_i == 0
          connected_down = "0"
        else
          connected_down = "1"
        end
        if seed[current_index].to_i == 1
          is_occupied = "1"
        else
          is_occupied = "0"
        end
        diag = seed[current_index+@x_size*2].to_i
        @cells[[x,y]] = Cell.new(is_occupied, connected_left, connected_right, connected_up, connected_down, diag,x,y)
      #  puts "Saving cell: #{is_occupied} #{connected_left} #{connected_right} #{connected_up} #{connected_down} TO #{x},#{y}"
        saved += 1
        skip = 2
        x += 1

      end
      #puts "SKIP IS #{skip}, X is #{x}"
      if x >= @x_size
        x = 0
        skip = @x_size*2+4
        y += 1
      end
      skip -= 1
    end
  end

  def display
    (@x_size*2+1).times do
      print '1'
    end
    puts
    @y_size.times do |j|
      @x_size.times do |i|
        print "#{@cells[[i,j]].left}#{@cells[[i,j]].occupied}"
      end
      puts "1"
      @x_size.times do |i|
        print "#{@cells[[i,j]].diag}#{@cells[[i,j]].down}"
      end
      puts 1
    end
  end


  def solve(beg_x, beg_y, end_x, end_y)
    beg_x -= 1
    beg_y -= 1
    end_x -= 1
    end_y -= 1
    stack = Array.new
    stack.push @cells[[end_x,end_y]]
    connected = Array.new
    connected.push (@cells[[end_x,end_y]])
  #  puts "#{@cells[[end_x,end_y]].occupied} #{@cells[[end_x,end_y]].left} #{@cells[[end_x,end_y]].right} #{@cells[[end_x,end_y]].up} #{@cells[[end_x,end_y]].down} "
  #  puts stack.empty?
  #  puts !connected.find {|cell| cell.x == beg_x && cell.y == beg_y} == nil

    until stack.empty? || !connected.find {|cell| cell.x == beg_x && cell.y == beg_y} == nil do
      temp = stack.pop
    #  puts "TEMP: #{temp.occupied} #{temp.left} #{temp.right} #{temp.up} #{temp.down}"
      if temp.occupied == "0"
        if temp.left == "0" && connected.find {|cell| cell.x == temp.x-1 && cell.y == temp.y} ==nil
          stack.push @cells[[temp.x-1,temp.y]]
          connected.push @cells[[temp.x-1,temp.y]]
        end
        if temp.right == "0" && connected.find {|cell| cell.x == temp.x+1 && cell.y == temp.y} == nil
          stack.push @cells[[temp.x+1,temp.y]]
          connected.push @cells[[temp.x+1,temp.y]]
        end
        if temp.up == "0" && connected.find {|cell| cell.x == temp.x && cell.y == temp.y-1} == nil
          stack.push @cells[[temp.x,temp.y-1]]
          connected.push @cells[[temp.x,temp.y-1]]
        end
        if temp.down == "0" && connected.find {|cell| cell.x == temp.x && cell.y == temp.y+1} == nil
          stack.push @cells[[temp.x,temp.y+1]]
          connected.push @cells[[temp.x,temp.y+1]]
        end
      end
    end
  #  puts connected
  #  puts stack
    if connected.find {|cell| cell.x == beg_x && cell.y == beg_y} != nil
      return true
    else
      return false
    end
  end

  def trace(beg_x, beg_y, end_x, end_y,visited = nil)
    if visited == nil
      visited = []
      beg_x -= 1
      beg_y -= 1
      end_x -= 1
      end_y -= 1
    end
    cur = @cells[[beg_x,beg_y]]
  #  puts "CURRENT: #{cur}"
    if beg_x == end_x && beg_y == end_y
      return [cur]
    end

    if cur.left == "0" && visited.find {|cell| cell.x == cur.x-1 && cell.y == cur.y} == nil
  #    puts "going left"
      answer = trace(cur.x-1,cur.y,end_x,end_y, (visited.push cur))
      if answer != nil
        return answer.push cur
      end
    end

    if cur.right == "0" && visited.find {|cell| cell.x == cur.x+1 && cell.y == cur.y} == nil
  #    puts "going right"
      answer = trace(cur.x+1,cur.y,end_x,end_y, (visited.push cur))
      if answer != nil
        return answer.push cur
      end
    end

    if cur.up == "0" && visited.find {|cell| cell.x == cur.x && cell.y == cur.y-1} == nil
  #    puts "going up"
      answer = trace(cur.x,cur.y-1,end_x,end_y, (visited.push cur))
      if answer != nil
        return answer.push cur
      end
    end

    if cur.down == "0" && visited.find {|cell| cell.x == cur.x && cell.y == cur.y+1} == nil
  #    puts "going down"
      answer = trace(cur.x,cur.y+1,end_x,end_y, (visited.push cur))
      if answer != nil
        return answer.push cur
      end
    end
    return nil

  end

end

class Cell
  attr_reader :left
  attr_reader :right
  attr_reader :up
  attr_reader :down
  attr_reader :occupied
  attr_reader :diag
  attr_reader :x
  attr_reader :y
  def initialize (occupied, left, right, up, down, diag, x, y)
    @x = x
    @y = y
    @diag = diag
    @occupied = occupied
    @left = left
    @right = right
    @up = up
    @down = down

  end
  def to_s
    return "(#{@x+1},#{@y+1})"
  end
end

temp = Maze.new(4,4)
temp.load("111111111100010001111010101100010101101110101100000101111011101101000101111111111")
temp.display
puts temp.solve(1,4,4,4)
puts temp.trace(1,4,4,4)
puts temp.solve(4,4,3,4)
puts temp.trace(4,4,3,4)
