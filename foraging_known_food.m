%% Chicken Foraging Simulation

% function [chicken_health, food_eaten, number_of_nodes_visited, chicken_positions, percentage_eating] = foraging_known_food(n, time, food_source, starting_chicken_health, food_amount)

% Values
dead = 0;
% Inputs
n = 5; % square matrix dimensions
time = 200; % time to run for 
food_source = 2; % number of positons of food
starting_chicken_health = 50; % How long the chciken will live for
food_amount = [10, 20]; % amount of food generated 
wait_for = 5;

%% Creates the graph
A = delsq(numgrid('S',n+2)); % generates the grid
G = graph(A,'omitselfloops'); % creates a graph which omits self looping nodes

    %% Creates food and chicken positions
    chicken_position = randperm(n.^2,1); % picks a random inital position for the chicken
    nodes_visited = [chicken_position]; % creates an array of nodes visited
    chicken_positions = [chicken_position]; % creates an array of all visited positions
    food_position = randperm(n.^2,food_source); % picks a random position 4 food sources
    aa = food_position;
    amount_of_food = randi(food_amount, 1, food_source); % makes amount of food between two values cant be 1 as then for 1:1 doesnt work 
    starting_food = sum(amount_of_food); % In order to work out how much food has been eaten all together
    
    %% Creates a 'health' of a chicken 
    chicken_health = starting_chicken_health; % Starting health of chicken
    health = [chicken_health]; % creates an array of the health of a chicken

    %% Values 
    time_gone = 1; % How much time has passed

    
    %% the walk to food when there are food positons left
    while time_gone < time && chicken_health > 1 % While there is still time left and chicken is still in health
       % disp('1')
       if chicken_health == 50 && time_gone > 2
          while time_gone < time && chicken_health > 40
                    disp('2')
                           %% Working out the nodes the chicken can travel to
                    % Update time
                    time_gone = time_gone +1;  
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
       elseif ~isempty(find(food_position == chicken_position, 1)) 
         
                disp('3')% the chciken is at the food and there is some to eat
               time_gone = time_gone +1; 
               chicken_positions(end+1) = chicken_position; 
                % Updating amount of food

                amount_of_food(index) = amount_of_food(index) - 1;
                amount_of_food(index)
                % Chicken Health
                chicken_health = chicken_health + 1;
                health(end+1) = chicken_health;
                if amount_of_food(index) == 0
                    food_position(food_position == chicken_position) = [];
                    amount_of_food(index) = [];
                end 
       
            
       elseif length(food_position) == 0 % if no food left to find randomly walk 

            while time_gone < time && chicken_health > 1
                    disp('2')
                           %% Working out the nodes the chicken can travel to
                    % Update time
                    time_gone = time_gone +1;  
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

       else % find some food 
                disp('4')
           d = distances(G, chicken_position, food_position, 'Method','unweighted');
           [value, index] = min(d);
           P = shortestpath(G,chicken_position,food_position(index), 'Method','unweighted');
           chicken_position = P(end);
           P = P(2:length(P));
           chicken_positions = [chicken_positions P]
             
               if time_gone + length(P) < time
                   time_for = length(P);
               else  % for when the agent doesnt have enough time to reach its target
                   time_for = time - time_gone;
               end 
                   for i = 1:time_for
                       % Update time
                        time_gone = time_gone +1; 
                       % Nodes visited
                       nodes_visited(end + 1) = chicken_position;
                       % Update health
                        chicken_health = chicken_health -1;
                        health(end+1) = chicken_health;

                   end 
       
       end 
    end 

% Outputs
starting_food
food_eaten = starting_food - sum(amount_of_food);
number_of_nodes_visited = length(nodes_visited);
%percentage_eating = (eating/(eating+not_eating))*100;
if chicken_health == 1
    disp('dead')
end 
 
    
    

