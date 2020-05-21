=begin

advent of code 2016

--- Day 1: No Time for a Taxicab ---

Santa's sleigh uses a very high-precision clock to guide its movements, and the clock's oscillator is regulated by stars. 

Unfortunately, the stars have been stolen... by the Easter Bunny. 

To save Christmas, Santa needs you to retrieve all fifty stars by December 25th.

Collect stars by solving puzzles. 

Two puzzles will be made available on each day in the Advent calendar; the second puzzle is unlocked when you complete the first. 

Each puzzle grants one star. Good luck!

You're airdropped near Easter Bunny Headquarters in a city somewhere. 

"Near", unfortunately, is as close as you can get 

- the instructions on the Easter Bunny Recruiting Document the Elves intercepted start here, and nobody had time to work them out further.

The Document indicates that you should start at the given coordinates (where you just landed) and face North. 

Then, follow the provided sequence: either turn left (L) or right (R) 90 degrees, 

then walk forward the given number of blocks, ending at a new intersection.

There's no time to follow such ridiculous instructions on foot, though, so you take a moment and work out the destination. 

Given that you can only walk on the street grid of the city, how far is the shortest path to the destination?

For example:

    Following R2, L3 leaves you 2 blocks East and 3 blocks North, or 5 blocks away.
    R2, R2, R2 leaves you 2 blocks due South of your starting position, which is 2 blocks away.
    R5, L5, R5, R3 leaves you 12 blocks away.

How many blocks away is Easter Bunny HQ?

# Note to self:

Sounds like we are on a secret mission to safe Christmas from the Easter Bunny. We sound like ninjas.
Since the problem describes our context as a street grid of the city, we should use a coordinate system to describe our movements.

I would label our starting position as the "origin".

Using the origin I would the examples provided and mark them as references to determine how far we are from the Easter Bunny's HQ.

From the looks of it we need to calculate the "manhattan distance" between two points, but we need to set-up some abstractions to help 
make solving this problem easier.

We need a concept of direction to help figure out the starting and endpoint given an origin and collection of directions to produce an output.

1. decrypt encoded string.
2. each command is delimited by a comma.
3. first string is the direction.
4. second is the number of blocks

=end


# The location represents a point in the city-grid (x,y) coordinate-system.
class Location
    attr_accessor :x, :y

    def initialize(x,y)
        @x = x
        @y = y
    end
end

# Finds the easter bunny using the recruitment file, initial drop off point and initial facing direction (compass naviation N,S,E,W)
def find_bunny(easter_bunny_recruit_doc, origin, facing)

    if !easter_bunny_recruit_doc
        puts "blank file."
        return
    end

    distance = 0

    commands = []

    # abstract this
    File.open(easter_bunny_recruit_doc).each do |line|
        commands = line.split(",")
    end

    destination = Location.new(origin.x, origin.y)

    # abstract this
    commands.each do |c|

        direction = ""
        blocks = ""

        if c.strip().length > 0
            direction = /\w/.match(c.strip())
            blocks = /\d+$/.match(c)

        end

        p "direction: #{direction} blocks: #{blocks}"
        direction = direction[0].to_s
        blocks = blocks[0].to_i

        p "origin #{origin.inspect}"
    
        if facing == "N" && direction == "R"
            facing = "E"
            # add x-axis
            destination.x += blocks
        elsif facing == "N" && direction == "L"
            facing = "W"
            # subtract x-axis
            destination.x -= blocks
        elsif facing == "S" && direction == "R"
            facing = "W"
            # subtract x-axis
            destination.x -= blocks
        elsif facing == "S" && direction == "L"
            facing = "E"
            # add x-axis
            destination.x += blocks
        elsif facing == "E" && direction == "R"
            facing = "S"
            # subtract y-axis
            destination.y -= blocks
        elsif facing == "E" && direction == "L"
            facing = "N"
            # add y-axis
            destination.y += blocks
        elsif facing == "W" && direction == "R"
            facing = "N"
            # add y-axis
            destination.y += blocks
        elsif facing == "W" && direction == "L"
            facing = "S"
            # subtract y-axis
            destination.y -= blocks
        end

        p "destination: #{destination.inspect}"

        # distance = destination - origin

        # abstract this
        distance = (destination.x - origin.x).abs + (destination.y - origin.y).abs
        p "distance: #{distance}"
    end
end

easter_bunny_recruit_doc = "./input.txt"
drop_off_point = Location.new(0,0)
facing = "N"

distance = find_bunny(easter_bunny_recruit_doc, drop_off_point, facing)
p "distance: #{distance}"