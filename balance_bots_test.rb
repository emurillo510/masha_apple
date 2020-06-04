require_relative 'balance_bots'

# token tests
def test1_token
    t = Token.new("LOW", "BOT", "1", "BOT", "2")
    if t.value != "LOW" &&
        t.origin_type != "BOT" &&
        t.origin != "1" &&
        t.dest_type != "BOT" &&
        t.dest != "2"
        puts "test1_token failed"
        return
    end
    puts "test1_token."
end

def test2_token
    t = Token.new("HIGH", "BOT", "1", "OUTPUT", "2")
    if t.value != "HIGH" &&
        t.origin_type != "BOT" &&
        t.origin != "1" &&
        t.dest_type != "OUTPUT" &&
        t.dest != "2"
        puts "test1_token failed"
        return
    end
    puts "test2_token."
end

def test3_token
    t = Token.new(3, nil, nil, "BOT", "3")
    if t.value != 3 &&
        t.origin_type != nil &&
        t.origin != nil &&
        t.dest_type != "BOT" &&
        t.dest != "3"
        puts "test1_token failed"
        return
    end
    puts "test3_token."
end

# parsing tests

@c = RobotController.new
# takes value instruction output destination
def test1_instruction
    cmd = "value 5 goes to bot 2"
    t = @c.validate_instruction(cmd)

    if t.length != 1
        p "test1_instruction length should be 1"
        return
    end

    if t[0].value != "5"
        p "test1 value should be string numerical"
    end

    if t[0].origin_type != nil && t[0].origin != nil
        p "test1 origin should be both nil"
    end

    if t[0].dest_type != "BOT" && t[0].dest != "2"
        p "test1 dest should be bot-2"
    end
    puts "test1_instruction pass"
end

# takes value instruction output destination
def test2_instruction
    cmd = "bot 2 gives low to bot 1 and high to bot 0"
    t = @c.validate_instruction(cmd)

    if t.length != 2
        p "test2_instruction length should be 2"
        return
    end

    if t[0].value != "LOW"
        p "test2_instruction first token should be low"
        return
    end

    if t[0].origin_type != "BOT" && t[0].origin != "2"
        p "test2_instruction origin should be bot-2"
        return
    end

    if t[1].value != "HIGH"
        p "test2_instruction first token should be high"
        return
    end

    if t[1].dest_type != "BOT" && t[1].dest != "0"
        p "test2_instruction second token should got to bot-0"
        return
    end

    puts "test2_instruction pass"


end

# process instruction map creation
def test1_process()
    cmd = "value 5 goes to bot 2"
    t = @c.validate_instruction(cmd)
    robot_map = @c.process_instruction(t)
    
    if robot_map["BOT-2"].nil?
        p "test1_process value instruction robot creation failed"
        return
    end

    p "test1_process passed."

end

def test2_process()
    cmd = "value 5 goes to bot 3"
    t = @c.validate_instruction(cmd)
    robot_map = @c.process_instruction(t)
    
    if robot_map["BOT-2"].nil? == true
        p "test2_process value instruction robot creation failed"
        return
    end

    p "test2_process passed."

end

def test3_process()

    cmds = [
        "value 5 goes to bot 2",
        "bot 2 gives low to bot 1 and high to bot 0",
        "value 3 goes to bot 1",
        "bot 1 gives low to output 1 and high to bot 0",
        "bot 0 gives low to output 2 and high to output 0",
        "value 2 goes to bot 2"
    ]

    robot_map = {}

    cmds.each do |cmd|
        p "cmd: #{cmd}"
        t = @c.validate_instruction(cmd)
        
        robot_map = @c.process_instruction(t)
    end

    if robot_map["BOT-2"].nil? == true
        p "test3_process bot 2 expected"
        return 
    end

    if robot_map["BOT-1"].nil? == true
        p "test3_process bot 1 expected"
        return 
    end

    if robot_map["BOT-0"].nil? == true
        p "test3_process bot 0 expected"
        return 
    end

    if robot_map["OUTPUT-1"].nil? == true
        p "test3_process output 2 expected"
        return 
    end

    if robot_map["OUTPUT-2"].nil? == true
        p "test3_process output 2 expected"
        return 
    end

    if robot_map["OUTPUT-0"].nil? == true
        p "test3_process output 0 expected"
        return 
    end

    p "test3_process passed."

end

# process instruction map update

def test4_process()

    cmds = [
        "value 5 goes to bot 2",
        "bot 2 gives low to bot 1 and high to bot 0",
        "value 3 goes to bot 1",
        "bot 1 gives low to output 1 and high to bot 0",
        "bot 0 gives low to output 2 and high to output 0",
        "value 2 goes to bot 2"
    ]

    robot_map = {}

    t = @c.validate_instruction(cmds[0])    
    robot_map = @c.process_instruction(t)

    if robot_map["BOT-2"].nil?
        p "test4_process expecting bot-2 key"
        return
    end

    if robot_map["BOT-2"].id != "BOT-2"
        p "test4_process expecting bot-2 id"
        return
    end

    if robot_map["BOT-2"].value_storage[0] != "5"
        p "test4_process expecting bot-2 to have value 5 in slot 0"
        return
    end

    if robot_map["BOT-2"].instructions.length != 0
        p "test4_process expecting bot-2 to have zero instructions"
        return
    end

    t = @c.validate_instruction(cmds[1])    
    robot_map = @c.process_instruction(t)
    
    if robot_map["BOT-2"].instructions.length != 2
        p "test4_process expecting bot-2 with 2 instruction"
        return
    end

    if robot_map.keys.length != 3
        p robot_map.keys
        p "test4_process expecting 3 keys"
        return
    end

    t = @c.validate_instruction(cmds[2])    
    robot_map = @c.process_instruction(t)

    if robot_map["BOT-1"].value_storage[0] != "3"
        p "test4_process expecting bot-1 with value 3"
        return
    end

    t = @c.validate_instruction(cmds[3])    
    robot_map = @c.process_instruction(t)

    if robot_map["BOT-1"].instructions.length != 2
        p "test4_process expecting bot-1 have instructions with 2 tokens"
        return
    end

    t = @c.validate_instruction(cmds[4])    
    robot_map = @c.process_instruction(t)

    if robot_map["BOT-0"].instructions.length != 2
        p "test4_process expecting bot-0 have instructions with 2 tokens"
        return
    end

    # check before

    if robot_map["BOT-2"].value_storage[0] != "5" &&
        robot_map["BOT-2"].value_storage[1] != nil
        p "test4_process expecting 5,nil before last instruction"
        return
    end

    if robot_map["BOT-1"].value_storage[0] != "3" &&
        robot_map["BOT-1"].value_storage[1] != nil
        p "test4_process expecting 3,nil before last instruction"
        return
    end

    if robot_map["BOT-2"].instructions.length != 2
        p "test4_process expecting bot-2 instruction length of 2"
        return
    end

    if robot_map["BOT-1"].instructions.length != 2
        p "test4_process expecting bot-1 instruction length of 2"
        return
    end

    if robot_map["BOT-0"].instructions.length != 2
        p "test4_process expecting bot-0 instruction length of 2"
        return
    end

    t = @c.validate_instruction(cmds[5])    
    robot_map = @c.process_instruction(t)

    if robot_map["BOT-2"].value_storage[0] != nil
        robot_map["BOT-2"].value_storage[1] != nil
        p "test4_process expecting bot-2 values empty"
    end

    if robot_map["BOT-1"].value_storage[0] != nil
        robot_map["BOT-1"].value_storage[1] != nil
        p "test4_process expecting bot-1 values empty"
    end

    if robot_map["BOT-0"].value_storage[0] != nil
        robot_map["BOT-0"].value_storage[1] != nil
        p "test4_process expecting bot-0 values empty"
    end

    if robot_map["BOT-2"].value_storage[0] != nil
        robot_map["BOT-2"].value_storage[1] != nil
        p "test4_process expecting bot-2 values empty"
    end

    if robot_map["OUTPUT-1"].value_storage[0] != "2"
        p "test4_process expecting output-1 should have value 2"
    end

    if robot_map["OUTPUT-2"].value_storage[0] != "3"
        p "test4_process expecting output-2 should have value 3"
    end

    if robot_map["OUTPUT-0"].value_storage[0] != "5"
        p "test4_process expecting output-5 should have value 5"
    end



    p "test4_process passed."

end


 
test1_token()
test2_token()
test3_token()

test1_instruction()
test2_instruction()

#test1_process()
#test2_process()
#test3_process()
test4_process()