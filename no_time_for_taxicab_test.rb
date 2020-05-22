require_relative 'no_time_for_taxicab'

# unit tests for finding bunny headquarters

# test extract_commands
def test_extract_commands_empty_file()
    begin
    commands = extract_commands("./empty_input.txt")
    
    if commands.length > 0
        puts "test_extract_commands_empty_file expected to fail. error_input.txt has valid data."
    end

    rescue Exception => e
        puts "test_extract_commands_empty_file pass."
        return true
    end
end

def test_extract_commands_multi_file()
    begin
    commands = extract_commands("./invalid_input.txt")
    
    puts "test_extract_commands_empty_file expected to fail. invalid_input.txt has valid data."
    
rescue Exception => e
        puts "test_extract_commands_multi_file pass."
        return true
    end
end

def test_extract_pattern_empty()
    begin

    output = extract_pattern(/\w/, "")

    puts "extract pattern_empty_test fails."

    rescue Exception => e

        puts "test_extract_pattern_empty_test pass."


    end
end

def test_extract_pattern_invalid()

    output = extract_pattern(/\w/, "A2")

    if output[0] != "L" || output[0] != "R"
        puts "extract_pattern_invalid_test pass."
    else
        puts "extract_pattern_invalid_test failed."
    end

end

def test_extract_pattern_invalid_two()

    output = extract_pattern(/\w/, "LL2")

    if output[0] != "L" || output[0] != "R"
        puts "test_extract_pattern_invalid_test_two pass."
    else
        puts "test_extract_pattern_invalid_test_two failed."
    end

end


def test_extract_pattern_valid_left()
    output = extract_pattern(/\w/, "L2")

    if output[0] != "L" || output[0] != "R"
        puts "test_extract_pattern_valid_left pass."
    else
        puts "test_extract_pattern_valid_left failed."
    end

end

def test_extract_pattern_valid_right()

    output = extract_pattern(/\w/, "R2")

    if output[0] != "L" || output[0] != "R"
        puts "test_extract_pattern_valid_right pass."
    else
        puts "test_extract_pattern_valid_right failed."
    end
end

def test_extract_pattern_valid_number()
    output = extract_pattern(/\d+$/, "R2")

    output = output[0].to_i

    if output > 0
        puts "test_extract_pattern_valid_number pass."
    else
        puts "test_extract_pattern_valid_number failed."
    end
end

def test_extract_pattern_valid_large_number()
    output = extract_pattern(/\d+$/, "R147")

    output = output[0].to_i

    if output > 0
        puts "test_extract_pattern_valid_number pass."
    else
        puts "test_extract_pattern_valid_number failed."
    end
end

def test_coordinate_system_mover_origin_clockwise_single_steps()

    commands = ["R1", "R1", "R1", "R1"]
    origin = Location.new(0,0)
    facing = "N"

    destination = coordinate_system_mover(commands, origin, facing)

    if destination.x == 0 && destination.y == 0
        puts "test_coordinate_system_mover_origin_clockwise_single_steps pass."
    else
        puts "test_coordinate_system_mover_origin_clockwise_single_steps fail."
    end

end

def test_coordinate_system_mover_origin_counter_clockwise_single_steps()

    commands = ["L1", "L1", "L1", "L1"]
    origin = Location.new(0,0)
    facing = "N"

    destination = coordinate_system_mover(commands, origin, facing)

    if destination.x == 0 && destination.y == 0
        puts "test_coordinate_system_mover_origin_counter_clockwise_single_steps pass."
    else
        puts "test_coordinate_system_mover_origin_counter_clockwise_single_steps fail."
    end
end

def test_coordinate_system_mover_origin_north_west_steps()
    commands = ["R100", "L150"]
    origin = Location.new(0,0)
    facing = "N"

    destination = coordinate_system_mover(commands, origin, facing)

    if destination.x == 100 && destination.y == 150
        puts "test_coordinate_system_mover_origin_north_west_steps pass."
    else
        puts "test_coordinate_system_mover_origin_north_west_steps fail."
    end
end

def test_city_grid
    origin = Location.new(7,8)
    destination = Location.new(3,2)

    output = city_grid_distance(origin, destination)
    if output == 10
        puts "test_city_grid test pass."
    else
        puts "test_city_grid test fail."
    end
end

def test_find_bunny()

    easter_bunny_recruit_doc = "./input.txt"
    drop_off_point = Location.new(0,0)
    facing = "N"

    distance = find_bunny(easter_bunny_recruit_doc, drop_off_point, facing)

    if distance == 256
        puts "test_find_bunny pass."
    else 
        puts "test_find_bunny failed."
    end

end

p "Running tests for finding the easter bunny..."
test_extract_commands_empty_file()
test_extract_commands_multi_file()
test_extract_pattern_empty()
test_extract_pattern_invalid()
test_extract_pattern_invalid_two()
test_extract_pattern_valid_left()
test_extract_pattern_valid_right()
test_extract_pattern_valid_number()
test_extract_pattern_valid_large_number()
test_coordinate_system_mover_origin_clockwise_single_steps()
test_coordinate_system_mover_origin_counter_clockwise_single_steps()
test_coordinate_system_mover_origin_north_west_steps()
test_city_grid()
test_find_bunny()
p "Test complete."