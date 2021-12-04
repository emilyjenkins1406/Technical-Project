%% Chicken Foraging Simulation

function [chicken_health, food_eaten, number_of_nodes_visited,chicken_positions, percentage_eating] = foraging_unknown_food(n, time, food_source, starting_chicken_health, food_amount)
    
    %% Creates food and chicken positions
    chicken_position = randperm(n.^2,1); % picks a random inital position for the chicken
    nodes_visited = [chicken_position]; % creates an array of nodes visited
    chicken_positions = [chicken_position]; % creates an array of all visited positions
    food_position = randperm(n.^2,food_source); % picks a random position 4 food sources
    amount_of_food = randi(food_amount, 1, food_source); % makes amount of food between two values cant be 1 as then for 1:1 doesnt work 
    starting_food = sum(amount_of_food); % In order to work out how much food has been eaten all together
    
    %% Creates a 'health' of a chicken 
    chicken_health = starting_chicken_health; % Starting health of chicken
    health = [chicken_health]; % creates an array of the health of a chicken

    %% Values 
    time_gone = 1; % How much time has passed
    eating = 0;
    not_eating = 1;
    
     %% Creates the graph
     A = delsq(numgrid('S',n+2)); % generates the grid
     G = graph(A,'omitselfloops'); % creates a graph which omits self looping nodes
    
    %% While loop allowing the chicken to travel and eat food 
    while time_gone < time && chicken_health > 1  % While there is still time left and chicken is still in health
          
       %% Working out the nodes the chicken can travel to
       nodes_visited(end+1) = chicken_position;
       neighbours = neighbors(G,chicken_position);
       pick_neighbour = randi(length(neighbours),1); % Randomly picks a node for the chicken to go to
       chicken_position = neighbours(pick_neighbour);  
    
       %% If loop so that the chicken doesnt return to the last visited node
       if length(chicken_positions) > 1 % doesnt count the first step
            neighbours(neighbours == chicken_positions(end-1)) = []; % gets rid of last visited node
       end
        
        %% If the chicken is at any of the food sources
        if ~isempty(find(food_position == chicken_position, 1))       

            position = find(food_position == chicken_position); % Finds the amount of food at that food source        
            while amount_of_food(position) > 0 && chicken_health <= starting_chicken_health -1 && time_gone < time 
                % Updating amount of food
                amount_of_food(position) = amount_of_food(position) - 1;
                % Updating chicken positon
                chicken_positions(end+1) = chicken_position;                
                % Time passing
                time_gone = time_gone +1; 
                % Chicken Health
                chicken_health = chicken_health + 1;
                health(end+1) = chicken_health;
                eating = eating + 1;
            end
        
        %% If the chicken isnt at any food    
        else 
            % Update chicken position
            chicken_positions(end+1) = chicken_position;
            % Update health
            chicken_health = chicken_health -1;
            health(end+1) = chicken_health;
            not_eating = not_eating + 1;
            % Update time
            time_gone = time_gone +1; 

        end 
    end 
% Outputs
food_eaten = starting_food - sum(amount_of_food);
number_of_nodes_visited = length(nodes_visited);
percentage_eating = (eating/(eating+not_eating))*100;
    
    

