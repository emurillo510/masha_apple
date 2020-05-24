require_relative 'security_through_obscurity'

def test_is_valid_room_format()

    output = extract_coding("totally-real-room-200[decoy]")
    
    if output.sector_id == 200 && output.checksum == "decoy"
        ["totally", "real", "room"].each_with_index do |s, idx|
            if s != output.encrypted_name[idx]
                puts "test_is_valid_room_format fail."
            end
        end
        puts "test_is_valid_room_format pass."
    else
        puts "test_is_valid_room_format fail."
    end
end

def test_is_valid_room_invalid()

    encrypted_name = ["totally", "real", "room"]
    sector_id = 200
    checksum = "decoy"

    output = is_valid_room(encrypted_name, sector_id, checksum)

    if output == false
        puts "test_is_valid_room invalid case pass."
    else
        puts "test_is_valid_room invalid case fail."
    end
end

def test_is_valid_room_valid()

    encrypted_name = ["aaaaa", "bbb", "z", "y", "x"]
    sector_id = 123
    checksum = "abxyz"

    output = is_valid_room(encrypted_name, sector_id, checksum)

    if output == true
        puts "test_is_valid_room valid case pass."
    else
        puts "test_is_valid_room valid case fail."
    end
end

def test_sum_of_sector_id()

    rooms = ["aaaaa-bbb-z-y-x-123[abxyz]", "a-b-c-d-e-f-g-h-987[abcde]", "not-a-real-room-404[oarel]", "totally-real-room-200[decoy]"]

    output = sum_of_sector_ids(rooms)

    if output != 1514
        puts "test_sum_of_sector fail."
    else
        puts "test_sum_of_sector pass."
    end

end

puts "Running tests for security_through_obscurity_test.rb"
test_is_valid_room_format()
test_is_valid_room_valid()
test_is_valid_room_invalid()
test_sum_of_sector_id()
puts "Completed."