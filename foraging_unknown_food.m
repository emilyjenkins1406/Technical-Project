%% Chicken Foraging Simulation

function [positions_chickens, percentage_eating, dead, min_health, variance, moving_on] = foraging_unknown_food(graphing, dominance_hierachy, chickens, n, time, food_source, starting_chicken_health, food_amount)

    %% Creates food and chicken positionsz
    positions = randperm(n.^2,(chickens+food_source)); % determines the positons of chickens and food 
    positions_chickens = []; % Creates a matrix for the positions of the chickens
    positions_chickens(:, 1) = positions(1:chickens); % adds first position of the chicken to the matrix 
    food_position = positions(chickens + 1:end); % picks a random position 4 food sources
    all_food_positions = kron(food_position,ones(chickens,1));
    amount_of_food = randi(food_amount, 1, food_source); % makes amount of food between two values cant be 1 as then for 1:1 doesnt work 
    healths = [];

    %% Dominance Hierachy  % lowest number = highest ranking
    ranking = 1 : chickens; % where the highest ranking chicken is the first row of health and positions and so on
    moving_on = 0;
    dead = 0;
    
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
    while time_gone < (time - 1)  && dead < chickens % While there is still time left and there are still alikve chickens
  
        time_gone = time_gone +1;  % Time passing

     %% All chickens taking a singular step
     for i = 1:chickens % making the higher ranking chicken move first
        
        food = all_food_positions(i, :);
        food(isnan(food)) = [];
        position = find(food_position == positions_chickens(i,time_gone)); % Finds the amount of food at a food source     

        %% If a healthy chicken is at any of the food sources where there is food and still time left
        if  health(i, (time_gone)) == 1 || health(i, (time_gone)) == 0 

            health(i,(time_gone+1)) = 0; % Update health
            positions_chickens(i,(time_gone+1)) = NaN;
      
        elseif ~isempty(position)  && amount_of_food(position) > 0 && time_gone < time    
                
            %% if another chicken and dom hierachy present 
                if ~isempty(find(positions_chickens(i,time_gone) == positions_chickens(1:(i-1),time_gone), 1))  && i > 1 && dominance_hierachy == 1  % another chciken there
                   % Amount of time eating
                   eating(i,1) = eating(i,1) +1;
                   % spends one timestep there realsies there is a higher ranking chicken so moves on
                   moving_on = moving_on + 1;
                   % removes the food positon as a possibilty 
                   [~, col] = find(all_food_positions(i) == positions_chickens(:,time_gone));
                   all_food_positions(i, col) = NaN; 
                   neighbours = neighbors(G,positions_chickens(i,1)); % Working out the nodes the chicken can travel to
                   pick_neighbour = randi(length(neighbours),1); % Randomly picks a node for the chicken to go to
                   positions_chickens(i,(time_gone+1)) = neighbours(pick_neighbour);
                   not_eating(i,1) = not_eating(i,1) +1;   % Not eating
                   health(i,(time_gone+1)) = health(i,(time_gone)) - 1; % Update health
                   
               else
                    position = find(all_food_positions(i)== positions_chickens(i,time_gone));
                    
                   % Amount of time eating
                   eating(i,1) = eating(i,1) +1;
                   % Updating positions 
                   positions_chickens(i,(time_gone+1)) = positions_chickens(i,time_gone);
                   % Amount of food
                   amount_of_food(position) = amount_of_food(position) - 1; 
                   % Chicken Health
                   health(i,(time_gone+1)) = health(i,(time_gone)) + 1;
                   % When the food runs out at the source remove position
                   if amount_of_food(position) == 0
                       [~, col] = find(all_food_positions(i) == positions_chickens(i,time_gone));
                       all_food_positions(:, col) = [];
                       amount_of_food(position) = [];
                       food_position(position)= [];
                    end 
               end 
        
        %% If the chicken isnt at any food    
        else 

           neighbours = neighbors(G,positions_chickens(i,1)); % Working out the nodes the chicken can travel to
           all_neighbours = neighbours; 
           %% Gets rid of nodes where higher ranking chickens are currently at if dom hierachy present 
               if i > 1 && dominance_hierachy == 1
                    for p = 1 : (i - 1)
                        A = positions_chickens(1:(i-1),time_gone);
                        for ii = 1:length(A)       
                            neighbours(find(neighbours == A(ii), 1,'first')) = [];
                        end
                        
                    end
               end
           
               %% If loop so that the chicken doesnt return to the last visited node only if there are other options - would rather it repeat than go to the other chciken
           if time_gone > 1 && length(neighbours) > 1% doesnt count the first step
                neighbours(neighbours == positions_chickens(i,time_gone -1 )) = []; % gets rid of last visited node
           end

           %% IF no possible points to visit inculde all
               if length(neighbours) < 1 
                   neighbours = all_neighbours;
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
     dead = sum(current_health(:)==0);

    end 

%% Finding the min health of all the chickens ( minus the dead ones)
a = 0;
for i = 1:chickens % collects the helath for chickens that survived
    if current_health(i) > 1
        a = a +1;
        healths(a, :) = health(i, :);
    end 
end 

%% Outputs
percentage_eating = (mean(eating)/(mean(eating)+mean(not_eating)))*100;
min_health = min(healths, [], 'all'); % The min health of all chickens
mean_health = mean(healths,2); % mean health for all alive chikens 
variance = var(mean_health);