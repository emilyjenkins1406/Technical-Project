%% Chicken Foraging Simulation

function [chicken_health, food_eaten, number_of_nodes_visited, chicken_positions, percentage_eating] = foraging_known_food(n, time, food_source, starting_chicken_health, food_amount)

%% Creates the graph
A = delsq(numgrid('S',n+2)); % generates the grid
G = graph(A,'omitselfloops'); % creates a graph which omits self looping nodes

    %% Creates food and chicken positions
    positions = randperm(n.^2,(1+food_source));
    chicken_position = positions(1);% picks a random inital position for the chicken
    nodes_visited = [chicken_position]; % creates an array of nodes visited
    chicken_positions = [chicken_position]; % creates an array of all visited positions
    food_position = positions(2:end); % picks a random position 4 food sources
    amount_of_food = randi(food_amount, 1, food_source); % makes amount of food between two values cant be 1 as then for 1:1 doesnt work 
    starting_food = sum(amount_of_food); % In order to work out how much food has been eaten all together
    
    %% Creates a 'health' of a chicken 
    chicken_health = starting_chicken_health; % Starting health of chicken
    health = [chicken_health]; % creates an array of the health of a chicken

    %% Values 
    time_gone = 1; % How much time has passed
    eating = 0;
    not_eating = 1;
    low_health = 40; % settingthe lwoer limit after when it is passed the chciken starts looking for food again.
    
    %% While there is still time left and chicken is still in health
    while time_gone < time && chicken_health > 1 
       
       %% When the chicken is at full health so waits ten timesteps just randomly walking
       if chicken_health == 50 && time_gone > 2

          while time_gone < time && chicken_health > low_health % = the lower limit  
                   
                % Working out the nodes the chicken can travel to                
                neighbours = neighbors(G,chicken_position);
                pick_neighbour = randi(length(neighbours),1); 
                chicken_position = neighbours(pick_neighbour);
                % Update time
                time_gone = time_gone +1;
                % Not eating 
                not_eating = not_eating + 1;
               % If loop so that the chicken doesnt return to the last visited node
               if length(chicken_positions) > 1 % doesnt count the first step
                    neighbours(neighbours == chicken_positions(end-1)) = []; % gets rid of last visited node
               end
                % Update chicken position
                chicken_positions(end+1) = chicken_position;
                % Update health
                chicken_health = chicken_health -1;
                health(end+1) = chicken_health;      
          end 

        %% When the chicken is at a food source
       elseif ~isempty(find(food_position == chicken_position, 1)) 
               % Time
               time_gone = time_gone +1; 
               % Eating 
               eating = eating + 1;
               % Chicken position
               chicken_positions(end+1) = chicken_position; 
               % Amount of food
               amount_of_food(index) = amount_of_food(index) - 1;
               % Chicken Health
               chicken_health = chicken_health + 1;
               health(end+1) = chicken_health;
               % When the food runs out at the source remove position
               if amount_of_food(index) == 0
                   food_position(food_position == chicken_position) = [];
                   amount_of_food(index) = [];
               end 
       
       %% When there is no food left so it just randomly walks   
       elseif isempty(food_position)  
            while time_gone < time && chicken_health > 1
  
                % Update time
                time_gone = time_gone +1;  
                % Not eating 
                not_eating = not_eating + 1;
                % Working out the nodes the chicken can travel to 
                neighbours = neighbors(G,chicken_position);
                pick_neighbour = randi(length(neighbours),1); % Randomly picks a node for the chicken to go to
                chicken_position = neighbours(pick_neighbour);  
                
                %% If loop so that the chicken doesnt return to the last visited node
                if length(chicken_positions) > 1 % doesnt count the first step
                     neighbours(neighbours == chicken_positions(end-1)) = []; % gets rid of last visited node
                end
                % Update chicken position
                chicken_positions(end+1) = chicken_position;
                % Update health
                chicken_health = chicken_health -1;
                health(end+1) = chicken_health; 
            end 

       %% If the chicken wants to find some food
       else 
           % Finding the distance from the current position to food sources
           d = distances(G, chicken_position, food_position, 'Method','unweighted'); % unweighted graph
           [value, index] = min(d);
           path = shortestpath(G,chicken_position,food_position(index), 'Method','unweighted');
           chicken_position = path(end);
           path = path(2:length(path));
           % Adding the path to the position array
           if (length(path) + length(chicken_positions)) < time
               time_for = length(path);
                chicken_positions = [chicken_positions path];
           else 
               time_for = time - time_gone;
               chicken_positions = [chicken_positions path(1:time_for)];
           end

               % Adding to arrays for a certain amount of time
               for i = 1:time_for
                   % Adding up i 
                   i = i + 1;
                   % Not eating 
                   not_eating = not_eating + 1;
                   % Update time
                   time_gone = time_gone +1; 
                   % Nodes visited
                   nodes_visited(end + 1) = chicken_position;
                   % Update health
                   chicken_health = chicken_health - 1;
                   health(end+1) = chicken_health;
              end 
       end 
    end 

% Outputs
food_eaten = starting_food - sum(amount_of_food);
number_of_nodes_visited = length(nodes_visited);
percentage_eating = (eating/(eating+not_eating))*100;


 
    
    

