%% Chicken Foraging Simulation

function [positions_chickens, percentage_eating, dead, min_health, variance] = foraging_unknown_food(chickens, n, time, food_source, starting_chicken_health, food_amount)
    
    %% Creates food and chicken positions
    positions = randperm(n.^2,(chickens+food_source)); % determines the positons of chickens and food 
    positions_chickens = []; % Creates a matrix for the positions of the chickens
    positions_chickens(:, 1) = positions(1:chickens); % adds first position of the chicken to the matrix 
    food_position = positions(chickens + 1:end); % picks a random position 4 food sources
    amount_of_food = randi(food_amount, 1, food_source); % makes amount of food between two values cant be 1 as then for 1:1 doesnt work 
    healths = [];
    
    %% Creates a 'health' of a chicken 
    health = zeros(chickens,1);
    health(:, 2) = starting_chicken_health; % adds first position of the chicken to the matrix 
    health(:,1) = []; % removes the first column 
    
    %% Values 
    time_gone = 0; % How much time has passed
    eating = zeros(chickens,1);
    not_eating = ones(chickens,1); % adding one for the first timestep
    
    %% Creates the graph
     A = delsq(numgrid('S',n+2)); % generates the grid
     G = graph(A,'omitselfloops'); % creates a graph which omits self looping nodes

    %% Finds the current health of all chickens
     current_health = health(:, (time_gone+1));
     all_current_health = find(current_health < 2);
 
    %% While loop allowing the chicken to travel and eat food 
    while time_gone < (time - 1) && length(all_current_health) < 1  % While there is still time left and all chickens are still in health
      
        time_gone = time_gone +1;  % Time passing

     %% All chickens taking a singular step
     for i = 1:chickens

        position = find(food_position == positions_chickens(i,time_gone)); % Finds the amount of food at a food source     

        %% If a healthy chicken is at any of the food sources where there is food and still time left
        if ~isempty(position)  && amount_of_food(position) > 0 && time_gone < time    

                % Updating amount of food
                amount_of_food(position) = amount_of_food(position) - 1;           
                % Updating positions 
                positions_chickens(i,(time_gone+1)) = positions_chickens(i,time_gone);
                % Chicken Health
                health(i,(time_gone+1)) = health(i,(time_gone)) + 1;
                % Amount of time eating
                eating(i,1) = eating(i,1) +1;
           
        
        %% If the chicken isnt at any food    
        else 

            neighbours = neighbors(G,positions_chickens(i,1)); % Working out the nodes the chicken can travel to

           %% If loop so that the chicken doesnt return to the last visited node
           if time_gone > 1 % doesnt count the first step
                neighbours(neighbours == positions_chickens(i,time_gone -1 )) = []; % gets rid of last visited node
           end

           pick_neighbour = randi(length(neighbours),1); % Randomly picks a node for the chicken to go to
           positions_chickens(i,(time_gone+1)) = neighbours(pick_neighbour);
           not_eating(i,1) = not_eating(i,1) +1;   % Not eating
           health(i,(time_gone+1)) = health(i,(time_gone)) - 1; % Update health

        end 
      
     end 
     %% Finds the current health of all chickens
     current_health = health(:, (time_gone+1));
     all_current_health = find(current_health < 2);
    end 
     
%% Outputs
percentage_eating = (mean(eating)/(mean(eating)+mean(not_eating)))*100;
dead = sum(current_health(:) == 1);
a = 0;

%% Finding the min health of all the chickens ( minus the dead ones)
for i = 1:chickens % collects the helath for chickens that survived

    if current_health(i) > 1
        a = a +1;
        healths(a, :) = health(i, :);
    end 
end 

min_health = min(healths, [], 'all'); % The min health of all chickens
mean_health = mean(healths,2); % mean health for all alive chikens 
variance = var(mean_health);


