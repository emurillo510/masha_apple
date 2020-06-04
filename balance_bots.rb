=begin

--- Day 10: Balance Bots ---

You come upon a factory in which many robots are zooming around handing small microchips to each other.

Upon closer examination, you notice that each bot only proceeds when it has two microchips, and once it does, it gives each one to a different bot 

or puts it in a marked "output" bin. Sometimes, bots take microchips from "input" bins, too.


Inspecting one of the microchips, it seems like they each contain a single number; 

the bots must use some logic to decide what to do with each chip. 
    

You access the local control computer and download the bots' instructions (your puzzle input).

Some of the instructions specify that a specific-valued microchip should be given to a specific bot; 

the rest of the instructions indicate what a given bot should do with its lower-value or higher-value chip.

For example, consider the following instructions:

value 5 goes to bot 2
bot 2 gives low to bot 1 and high to bot 0
value 3 goes to bot 1
bot 1 gives low to output 1 and high to bot 0
bot 0 gives low to output 2 and high to output 0
value 2 goes to bot 2

    Initially, bot 1 starts with a value-3 chip, and bot 2 starts with a value-2 chip and a value-5 chip.
    Because bot 2 has two microchips, it gives its lower one (2) to bot 1 and its higher one (5) to bot 0.
    Then, bot 1 has two microchips; it puts the value-2 chip in output 1 and gives the value-3 chip to bot 0.
    Finally, bot 0 has two microchips; it puts the 3 in output 2 and the 5 in output 0.

In the end, output bin 0 contains a value-5 microchip, output bin 1 contains a value-2 microchip, and output bin 2 contains a value-3 microchip. In this configuration, bot number 2 is responsible for comparing value-5 microchips with value-2 microchips.

Based on your instructions, what is the number of the bot that is responsible for comparing value-61 microchips with value-17 microchips?


=end

class Robot
    attr_accessor :id, :value_storage, :instructions

    def initialize(id)
        @id = id
        @value_storage = Array.new()
        @instructions = []
    end

    def receive_value(value)

        @value_storage.append(value)
        @value_storage = @value_storage.sort

        if @value_storage.length == 2
            if (@value_storage.include? "17") ||
                (@value_storage.include? "61")
                p "id: #{@id}"
            end
            return true
        end

        return false
    end

    def get_value(command)

        if command == "LOW"
            return @value_storage[1]
        else
            return @value_storage[0]
        end
    end
    def receive_instruction(token)
        @instructions.push(token)
    end
end

class Token
    attr_accessor :value, :origin_type, :origin, :dest_type, :dest
    def initialize(*args)
        @value = args[0]
        @origin_type = args[1]
        @origin = args[2]
        @dest_type = args[3]
        @dest = args[4]
    end
end

class RobotController

    attr_accessor :robot_map, :count

    def initialize()
        @robot_map = {}
    end
    
    def execute()
      file = File.open("./input3.txt").read
      instructions = file.split("\n")
      
      instructions.each do |i|
        instruction_token = validate_instruction(i)
        process_instruction(instruction_token)
      end

      return @robot_map
    end

    def update_map()
        # update mappings
        @robot_map.keys.each do |k|
            robot = @robot_map[k]
            if robot.value_storage.length == 2
                @robot_map[k].instructions.each do |i|
                   # p ": #{i.inspect}"
                    src_key = "#{i.origin_type}-#{i.origin}"
                    dest_key = "#{i.dest_type}-#{i.dest}"
                    #p "src_key: #{src_key}"
                    #p "dest_key: #{dest_key}"
                    value = ""

                    if i.value == "LOW"
                        value = @robot_map[src_key].value_storage[0]
                        @robot_map[src_key].value_storage[0] = nil        
                    elsif i.value == "HIGH"
                        value = @robot_map[src_key].value_storage[1]
                        @robot_map[src_key].value_storage[1] = nil 
                    end
                    #p "src_key #{src_key}"
                    #p "dest_key #{dest_key}"
                    #p "src_key before: #{@robot_map[src_key].value_storage}"
                    #p "dest_key before: #{@robot_map[dest_key].value_storage}"
                    @robot_map[dest_key].receive_value(value)
                    #p "src_key after: #{@robot_map[src_key].value_storage}"
                    #p "dest_key after: #{@robot_map[dest_key].value_storage}"
                    
                    
                end
            end
        end
    end

    def process_instruction(token)
        
        if token.length == 1
            #p "TOKEN1: #{token[0].value} #{token[0].origin_type} #{token[0].origin} #{token[0].dest_type} #{token[0].dest}"
            key = "#{token[0].dest_type}-#{token[0].dest}"
            robot = @robot_map[key]
            if robot.nil?
                robot = Robot.new(key)
                @robot_map[key] = robot
            end

            if token[0].value.to_i.is_a? Numeric

                result = robot.receive_value(token[0].value)
                if result == true
                    update_map()
                end
            end


        elsif token.length == 2
            
            token.each do |t|
                #p "TOKEN2: #{t.value} #{t.origin_type} #{t.origin} #{t.dest_type} #{t.dest}"
                
                key = "#{t.origin_type}-#{t.origin}"
                dest_key = "#{t.dest_type}-#{t.dest}"

                #p "key: #{key}"
                #p "dest_key: #{dest_key}"

                robot = @robot_map[key]
                dest_robot = @robot_map[dest_key]

                
                if robot.nil?
                    robot = Robot.new(key)
                    @robot_map[key] = robot
                end
                
                if dest_robot.nil?
                    robot = Robot.new(dest_key)
                    @robot_map[dest_key] = robot
                end
                if robot.value_storage.length < 2
                    #robot.receive_instruction(token)
                    @robot_map[key].receive_instruction(t)
                end
            end

        else
            p "incorrect number of tokens"
        end

        #p @robot_map

        return @robot_map
    end

    def validate_instruction(instruction)
        output = extract_coding(instruction) 
        line = output[0].split(" ")
        token_low = nil
        token_high = nil

        if line[0] == "value"
            if line[1].to_i.is_a? Numeric
                if line[2] == "goes" && line[3] == "to" && line[4] == "bot"
                    if line[5].to_i.is_a? Numeric
                        return [Token.new(line[1], nil, nil, "BOT", line[5])]
                    end
                end
            end
        elsif line[0] == "bot"
            if line[1].to_i.is_a? Numeric
                if line[2] == "gives"
                    if line[3] == "low"
                        if line[4] == "to"
                            if line[6].to_i.is_a? Numeric
                                if line[5] == "bot"
                                    token_low = Token.new("LOW", "BOT", line[1], "BOT", line[6])
                                end
                                if line[5] == "output"
                                    token_low = Token.new("LOW", "BOT", line[1], "OUTPUT", line[6])
                                end
                                if line[7] == "and" && line[8] == "high" && line[9] == "to"
                                    if line[11].to_i.is_a? Numeric
                                        if line[10] == "bot"
                                            token_high = Token.new("HIGH", "BOT", line[1], "BOT", line[11])
                                        end
                                        if line[10] == "output"
                                            token_high = Token.new("HIGH", "BOT", line[1], "OUTPUT", line[11])
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
           # p "token_low #{token_low.inspect} #{token_high.inspect}"
            return [token_low, token_high] 
        end
    
        p "instruction is not in correct format."
        return
    end
end

def extract_coding(str)
    
    value_fmt = /^value (\d+) goes to bot (\d+)$/
    rule_fmt = /^bot (\d+) gives low to (output|bot) (\d+) and high to (output|bot) (\d+)$/
    
    if str.empty?
        return
    end

    if value_fmt.match(str)
        return value_fmt.match(str)
    else
        return rule_fmt.match(str)
    end
end

control_center = RobotController.new()
result = control_center.execute()

result.keys.each do |k|
    p "k: #{k} #{result[k].value_storage}"
end