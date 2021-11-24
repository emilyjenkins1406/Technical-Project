%% Chicken Foraging Simulation

function [chicken_health, food_eaten, number_of_nodes_visited, chicken_positions] = foraging_known_food(n, time, food_source, starting_chicken_health, food_amount)
  
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
    
     %% Creates the graph
     A = delsq(numgrid('S',n+2)); % generates the grid
     G = graph(A,'omitselfloops'); % creates a graph which omits self looping nodes

    
    %% While loop allowing the chicken to travel and eat food 
    while time_gone < time && chicken_health > 1  % While there is still time left and chicken is still in health

       d = distances(G, chicken_position, food_position, 'Method','unweighted');
       [value, index] = min(d);
       P = shortestpath(G,chicken_position,food_position(index), 'Method','unweighted');
       chicken_position = P(end);
       P = P(2:length(P)-1);
       chicken_positions = [chicken_positions P]; 

       for i = 1:length(P)
           % Nodes visited
           nodes_visited(end + 1) = chicken_position;
           % Update health
            chicken_health = chicken_health -1;
            health(end+1) = chicken_health;
            % Update time
            time_gone = time_gone +1; 
       end 

       while amount_of_food(index) > 0 && chicken_health <= starting_chicken_health -1 && time_gone < time 
            % Updating amount of food
            amount_of_food(index) = amount_of_food(index) - 1;
            % Updating chicken positon
            chicken_positions(end+1) = chicken_position;                
            % Time passing
            time_gone = time_gone +1; 
            % Chicken Health
            chicken_health = chicken_health + 1;
            health(end+1) = chicken_health;
       end
           food_position(food_position == chicken_position) = [];
   end 
    % Outputs
    food_eaten = starting_food - sum(amount_of_food);
    number_of_nodes_visited = length(nodes_visited);
 
    
    

