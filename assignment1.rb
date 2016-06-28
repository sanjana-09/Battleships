require 'colorize'
arr = Array.new(10){Array.new(10,0)} #10x10 array containing ships
updated_position = Array.new(11){Array.new(11,'U')} #array used for the user interface

def near_miss(arr,x,y) #Checks if a ship is near
  if  x > 0 && arr[x-1][y] != 0 ||
      x < 9 && arr[x+1][y] != 0 ||
      y > 0 && arr[x][y-1] != 0 ||
      y < 9 && arr[x][y+1] != 0
    'That was a near miss.'
  end
end

def sunk_msg(count_a,count_c,count_d1, count_d2, count_m)#displays a message if the ship has been completely sunk
  if count_a == 5
    puts 'You have destroyed the aircraft carrier.'
  end

  if count_c == 4
    puts 'You have destroyed the cruiser.'
  end

  if count_d1 == 3
    puts 'You have destroyed one destroyer.'
  end

  if count_d2 == 3
    puts'You have destroyed the second destroyer.'
  end

  if count_m == 2
    puts 'You have destroyed the submarine.'
  end
end


def select_positions (orientation,i,j,arr,count,l,des_placed)#finds valid positions for placing ships
  begin
    count = 0
    if orientation <= 5
      (j..j+l-1).each do |x| #horizontal
        if x<=arr.length-1 && arr[i][x]!='A' && arr[i][x]!='D1' && arr[i][x]!='D2' && arr[i][x]!='C' && arr[i][x]!='M' #checking for available positions
          count+=1
        end
      end

      if count == l #checks if there are valid contiguous positions for the length of the ship
        place_ships(orientation,count,l,arr,i,j,des_placed) #calls method to place ships
      else
        i = rand(0..9)
        j = rand(0..9)
      end

    else
      (i..i+l-1).each do |x| #vertical
        if x<=arr.length-1 && arr[x][j]!='A' && arr[x][j]!='D1' && arr[x][j]!='D2' && arr[x][j]!='C' && arr[x][j]!='M'
          count+=1
        end
      end

      if count == l
        place_ships(orientation,count,l,arr,i,j,des_placed)
      else
        i = rand(0..9)
        j = rand(0..9)
      end

    end
  end while(count!=l)  #loop continues till all ships are positioned
end

def place_ships(orientation,count,l,arr,i,j,des_placed)  #places ships
  if orientation<=5 #places horizontally
    case count
      when 5
        (j..j+l-1).each do |x|
          arr[i][x]='A'   #places aircraft carrier
        end
      when 4
        (j..j+l-1).each do |x|
          arr[i][x]='C'
        end
      when 3
        if des_placed==0  #checks whether the first destroyer has been placed; des_placed==3 if it has.
          (j..j+l-1).each do |x|
            arr[i][x]='D1'
            des_placed+=1
          end
        else
          (j..j+l-1).each do |x|
            arr[i][x]='D2'
          end
        end
      when 2
        (j..j+l-1).each do |x|
          arr[i][x]='M'
        end
      else
        (j..j+l-1).each do |x|
          arr[i][x]=0
        end
    end

  else #places vertically
    case count
      when 5
        (i..i+l-1).each do |x|
          arr[x][j]='A'
        end
      when 4
        (i..i+l-1).each do |x|
          arr[x][j]='C'
        end
      when 3
        if des_placed==0
          (i..i+l-1).each do |x|
            arr[x][j]='D1'
            des_placed+=1
          end
        else
          (i..i+l-1).each do |x|
            arr[x][j]='D2'
          end
        end
      when 2
        (i..i+l-1).each do |x|
          arr[x][j]='M'
        end
      else
        (i..i+l-1).each do |x|
          arr[x][j]=0
        end
    end
  end
end

def draw_updated_grid(updated_position) #draws updated grid
  (0..updated_position.length-2).each do|x|
    updated_position[0][x+1]=x #numbers columns
  end

  (0..updated_position.length-2).each do|x|
    updated_position[x+1][0]=x  #numbers rows
  end

  updated_position[0][0]='X'# top-left corner

  (0..updated_position.length-1).each do|i|
    (0..updated_position.length-1).each do|j|
      case updated_position[i][j]
        when 0..9
          print updated_position[i][j] #prints the x axis and y axis
        when 'S'
          print updated_position[i][j].colorize(:background => :red)
        when 'W'
          print updated_position[i][j].colorize(:background => :light_blue)
        else
          print updated_position[i][j].colorize(:background => :white)
      end
    end
    puts ''
  end
end

def update(i,j,updated_position,arr) #updates the array after the user shoots at a position
  if arr[i][j]=='A' || arr[i][j]=='D1' || arr[i][j]=='D2' || arr[i][j]=='C' || arr[i][j]=='M'
    updated_position[i+1][j+1]='S'
  else
    updated_position[i+1][j+1]='W'
  end
end

def ship(arr,length,des_placed)
  i = rand(0..9)
  j = rand(0..9)
  orientation = rand(1..10)
  l = length #length of the ship
  count = 0  #counter for positioning purposes
  select_positions(orientation,i,j,arr,count,l,des_placed)
end

ship(arr,5,0) #calling method to place ships
ship(arr,4,0)
ship(arr,3,0)
ship(arr,3,3) #parameter des_placed changes after first destroyer is placed
ship(arr,2,0)

puts 'There are five ships in the grid.'.colorize(:background => :green) #outputs basic instructions
puts ''
puts 'One ship of length 2 (submarine)'.colorize(:background => :green)
puts ''
puts 'Two ships of length 3 (destroyers)'.colorize(:background => :green)
puts ''
puts 'One ship of length 4 (cruiser)'.colorize(:background => :green)
puts ''
puts 'One ship of length 5 (aircraft carrier)'.colorize(:background => :green)
puts ''
puts 'The aim is to destroy all ships in the least amount of shots and hence, the lesser the score the better.'.colorize(:background => :green)
puts ''
draw_updated_grid(updated_position) #initially all places unknown in grid and seen as 'U'

tries = 0 #keeps count of how many times user has shot at a position
ships = 0 #keeps count of each individual part of every ship hit
count_a=0
count_c=0
count_d1=0
count_d2=0
count_m=0

begin
  puts 'Enter a pair of coordinates (row,column):'  #gets coordinates from user
  x=gets.chomp.to_i
  y=gets.chomp.to_i
  if x<0 || x>9 || y<0 || y>9
    puts 'Invalid coordinates. Both coordinates should be between 0 to 9!'
  else

    if updated_position[x+1][y+1]=='S' || updated_position[x+1][y+1]=='W'
      puts 'You have already shot here!'
    else

      if arr[x][y]=='A' or arr[x][y]=='D1' or arr[x][y]=='D2' or arr[x][y]=='C' or arr[x][y]=='M' #A ship has been hit
        print 'You have hit a ship at: ',x,',',y,'!'
        puts ''
        ships +=1
        update(x,y,updated_position,arr)#updates position after a coordinate has been shot at

#keeping track of destroyed ships
        case arr[x][y]
          when 'A'
            count_a+=1
          when 'D1'
            count_d1+=1
          when 'D2'
            count_d2+=1
          when 'C'
            count_c+=1
          else
            count_m+=1
        end

      else
        print 'You missed! There is only water at: '
        print x,',',y
        puts ''
        update(x,y,updated_position,arr)

        puts near_miss(arr,x,y) #calls method to check if there is a ship nearby
      end
      draw_updated_grid(updated_position)
      tries+=1  #updates score
    end
  end
  sunk_msg(count_a,count_c,count_d1,count_d2,count_m) #calls method to display message if ship is sunk

end  while (ships!=17)  #Loop continues till all ships are destroyed

if ships == 17
  puts 'Congratulations!You have destroyed all ships!'
  puts 'Your score is: ' ,tries
end
















