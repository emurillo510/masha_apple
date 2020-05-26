=begin
--- Day 4: Security Through Obscurity ---

Finally, you come across an information kiosk with a list of rooms. 

Of course, the list is encrypted and full of decoy data, but the instructions to decode the list are barely hidden nearby. 

Better remove the decoy data first.

Each room consists of an encrypted name (lowercase letters separated by dashes) followed by a dash, a sector ID, and a checksum in square brackets.

A room is real (not a decoy) if the checksum is the five most common letters in the encrypted name, in order, with ties broken by alphabetization. 

For example:

    aaaaa-bbb-z-y-x-123[abxyz] is a real room because the most common letters are a (5), b (3), and then a tie between x, y, and z, which are listed alphabetically.
    a-b-c-d-e-f-g-h-987[abcde] is a real room because although the letters are all tied (1 of each), the first five are listed alphabetically.
    not-a-real-room-404[oarel] is a real room.
    totally-real-room-200[decoy] is not.

Of the real rooms from the list above, the sum of their sector IDs is 1514.

What is the sum of the sector IDs of the real rooms?
=end

class RoomDetails
    attr_accessor :encrypted_name, :sector_id, :checksum

    def initialize(encrypted_name, sector_id, checksum)
        @encrypted_name = encrypted_name
        @sector_id = sector_id
        @checksum = checksum
    end
end

def extract_coding(str)
    
    room_fmt = /[a-zA-Z-]+\d{3}\[\w+\]/
    sector_fmt = /\d{3}/
    checksum_fmt = /([a-z]+)/
    
    if str.empty?
        return
    end

    output = str.match(room_fmt)

    output = output[0].split("-")

    last = output.last

    sec_id = sector_fmt.match(last)[0].to_i

    checksum = checksum_fmt.match(last)[0]

    output.pop()

    return RoomDetails.new(output, sec_id, checksum)
end

def is_valid_room(encrypted_name, sector_id, checksum)

    # a room is real if the checksum from left to right matches the number of occurences ties broken by alphabetical
    # map keys ordered by number of occurences and alphabet

    occurences = {}

    checksum.each_char do |c|
        occurences[c] = 0
    end

    encrypted_name.each do |e|
        e.each_char do |c|
            if occurences[c]
                occurences[c] +=  1
            end
        end
    end

    occurences = Hash[occurences.sort_by{|k, v| [-v,k]}]

    for idx in 0..checksum.length - 1
        if occurences.keys[idx] != checksum[idx]
            #p occurences
            #p checksum
            return false
        end
    end
    
    return true
end

def sum_of_sector_ids(rooms)

    sum = 0
    rooms.each do |r|
        room_details = extract_coding(r)
        if is_valid_room(room_details.encrypted_name, room_details.sector_id, room_details.checksum) == true
            sum += room_details.sector_id
        end
    end

    return sum 
end

def solve()
    file = File.open("./input2.txt").read
    rooms = file.split(" ")
    output = sum_of_sector_ids(rooms)
    p output
end

solve()