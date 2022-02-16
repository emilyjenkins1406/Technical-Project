 %% Chicken Foraging Simulation
 function [positions_chickens, percentage_eating, dead, min_health, variance, moving_on, all_agent_health, deadness, eating, percentage_visited,  number_of_nodes] = foraging_known_food(graphing, dominance_hierachy, chickens, n, time, food_source, starting_chicken_health, food_amount)

    %% Creates the graph
    A = delsq(numgrid('S',n+2)); % generates the grid
    G = graph(A,'omitselfloops'); % creates a graph which omits self looping nodes

    if graphing == 1
        [x,y] = meshgrid(1:n, 1:n); % to make the graph not 'fishbowl'
        p = plot(G, 'XData',x(:), 'YData',y(:)); % plotting the graph
        %% Set up the movie.
        writerObj = VideoWriter('chicken_video.avi'); % Name it.
        writerObj.FrameRate = 1; % How many frames per second.
        open(writerObj); % Starts the movie
    end 

    %% Creates food and chicken positions
    positions = randperm(n.^2,(chickens+food_source)); % creates positions for food and chickens
    positions_chickens = []; % Creates a matrix for the positions of the chickens
    positions_chickens(:, 1) = positions(1:chickens); % adds first position of the chicken to the matrix 
    food_position = positions(chickens + 1:end); % picks a random position 4 food sources
    all_food_positions = kron(food_position,ones(chickens,1)); % duplicates food positoions for all chickens
    starting_food_positions = all_food_positions;
    amount_of_food = randi(food_amount, 1, food_source); % makes amount of food between two values cant be 1 as then for 1:1 doesnt work 
    healths = []; % collects healths
        food_sources_visited = [];
    
    %% Dominance Hierachy where the lowest number = highest ranking
    moving_on = 0; % counts how many times the chicken moves on
    dead = 0; % counts how many dead
    
    %% Creates a 'health' of all chickens 
    health = zeros(chickens,1); % creates health array 
    health(:, 2) = starting_chicken_health; % adds first position of the chicken to the matrix 
    health(:,1) = []; % removes the first column 

    %% Values 
    time_gone = 0; % How much time has passed
    eating = zeros(chickens,1); % how mnay timesteps are spent eating
    not_eating = ones(chickens,1); % adding one for the first timestep
    all = 0;
    time_steps = 0;
    current_health = health(:, (time_gone+1));

    %% While there is still time left and a chicken is still in health
    while time_gone < (time -1) && dead < chickens
            
            time_gone = time_gone +1;  % Time passing
    
        for i = 1: chickens % making the higher ranking chicken move first
            
           %% Finding all possible food sources
           food = all_food_positions(i, :); 
           food(isnan(food)) = [];

           %% If the chicken has died health = 0 and position = NaN
           if  health(i, (time_gone)) == 1 || health(i, (time_gone)) == 0 
                health(i,(time_gone+1)) = 0; % Update health
                positions_chickens(i,(time_gone+1)) = NaN;

           %% When the chicken is at full health so waits ten timesteps just randomly walking
           elseif time_gone > 2 && health(i,(time_gone)) > 49 || time_steps > 0
           
               if health(i,(time_gone)) == 50 % begins the ten timesteps
                    time_steps = 10;
               end 

               %% Working out the nodes the chicken can travel to                
               neighbours = neighbors(G,positions_chickens(i,1)); 
               all_neighbours = neighbours;

               %% If loop so that the chicken doesnt return to the last visited node
               if time_gone > 1 % doesnt count the first step
                    neighbours(neighbours == positions_chickens(i,time_gone -1 )) = []; % gets rid of last visited node
               end
               
                %% Gets rid of nodes where higher ranking chickens are currently if hierchy is present 
               if i > 1 && dominance_hierachy == 1
                    for y = 1 : (i - 1)
                        % removes position as a possibilty
                        neighbours(neighbours == positions_chickens(y,time_gone)) = [];
                    end
               end
               
               %% But if this means there are no possible points to visit inculde all (make this to choose least higher chicken soon)
               if length(neighbours) < 1 
                   neighbours = all_neighbours;
               end 
               positions_chickens(i,(time_gone+1)) = neighbours(randi(length(neighbours),1)); % Randomly picks a node for the chicken to go to
               not_eating(i,1) = not_eating(i,1) +1;  % Not eating
               health(i,(time_gone+1)) = health(i,(time_gone)) - 1; % Update health
               time_steps = time_steps - 1; % decrease time left wondering
    
           %% When the chicken is at a food source
           elseif ~isempty(find(all_food_positions(i,:) == positions_chickens(i,time_gone), 1))
                food_sources_visited(end+1) = positions_chickens(i,time_gone);
               %% If there is another chicken and the hierachy is present 
               if ~isempty(find(positions_chickens(i,time_gone) == positions_chickens(1:(i-1),time_gone), 1))  && i > 1 && dominance_hierachy == 1 
                   % spends one timestep there realsies there is a higher ranking chicken so moves on
                   moving_on = moving_on + 1;
                   % removes the food positon as a further possibilty
                   [~, col] = find(all_food_positions(i) == positions_chickens(:,time_gone));
                   all_food_positions(i, col) = NaN; 
                   neighbours = neighbors(G,positions_chickens(i,time_gone)); % Working out the nodes the chicken can travel to
                   positions_chickens(i,(time_gone+1)) = neighbours(randi(length(neighbours),1));
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
                    end 
               end 
           
           %% When there is no food left so it just randomly walks   
           elseif isempty(food)  
               
                neighbours = neighbors(G,positions_chickens(i,time_gone)); % Working out the nodes the chicken can travel to
                all_neighbours = neighbours;
               %% Still doesnt meet with higher ranking chickens 
               if i > 1 && ~isempty(all_food_positions) && dominance_hierachy == 1
                    for p = 1 : (i - 1)
                         A = positions_chickens(1:(i-1),time_gone);
                        for ii = 1:length(A)       
                            neighbours(find(neighbours == A(ii), 1,'first')) = [];
                        end
                        [~, col] = find(all_food_positions(i) == positions_chickens(:,time_gone));
                        all_food_positions(i, col) = NaN;
                    end
               end

               %% But if this means there are no possible points to visit inculde all (make this to choose least higher chicken soon)
               if length(neighbours) < 1 
                   neighbours = all_neighbours;
               end 
            
               positions_chickens(i,(time_gone+1)) = neighbours(randi(length(neighbours),1));
               not_eating(i,1) = not_eating(i,1) +1;   % Not eating
               health(i,(time_gone+1)) = health(i,(time_gone)) - 1; % Update health
              
           %% If the chicken wants to find some food
           else 
               % Finding the distance from the current position to all food sources
               d = distances(G, positions_chickens(i,(time_gone)), food, 'Method','unweighted'); % unweighted graph
               [~, index] = min(d);
               path = shortestpath(G,positions_chickens(i,(time_gone)),food(index), 'Method','unweighted');
               % checks how far away the position is
               if length(path) == 1
                   value = 1;
               else 
                   value = 2; 
               end 
               positions_chickens(i,(time_gone+1)) = path(value);
               health(i,(time_gone+1)) = health(i,(time_gone)) - 1; % Update health
               not_eating(i,1) = not_eating(i,1) +1;   % Not eating    
           end 
             
        end 

%% If grpah was picked
if graphing == 1
            
     p = plot(G, 'XData',x(:), 'YData',y(:)); % plotting the graph
     highlight(p,food_position,'NodeColor','yellow') % Makes a food position yellow if it doesnt have a chicken there
        for i = 1 : chickens           
           if isnan(positions_chickens(i,time_gone+1)) %% dead as there is a nan value
               plotting = positions_chickens(i,:);
               plotting(isnan(plotting)) = [];
               highlight(p, plotting(end),'NodeColor','black', 'Marker', 'h', 'MarkerSize',8)  % Makes the chickens route green         
           else              
               highlight(p, positions_chickens(i,:),'NodeColor','green', 'Marker', 'h', 'MarkerSize',8)  % Makes the chickens route green
           end 
           if ~isempty(find(food_position == positions_chickens(:,time_gone), 1))
                [~, col] = find(food_position == positions_chickens(:,time_gone));
                eating_here = food_position(:,col);
                 highlight(p,eating_here,'NodeColor','magenta','Marker', 'h', 'MarkerSize',8) % Makes a food position yellow if it doesnt have a chicken there
           end 
        end 

    %% Takes a frame
    frame = getframe();
    writeVideo(writerObj, frame);
    lose(writerObj); 
end 
 
    end 

%% Finds the current health of all chickens
current_health = health(:, (time_gone+1)); 
dead = sum(current_health(:)==0);

    %% Working out what agents died
    deadness = [];
    for agents = 1:chickens
        if health(agents, (time_gone+1))==0
            deadness(end+1) = 1;
        else 
            deadness(end+1) = 0;
        end
    end 

%% Finding the min health of all the chickens ( minus the dead ones)
for i = 1:chickens % collects the health for chickens that survived
    if current_health(i) > 1
        all = all + 1;
        healths(all, :) = health(i, :);
    end 
end 

%% Outputs
percentage_eating = (mean(eating)/(mean(eating)+mean(not_eating)))*100;
min_health = min(healths, [], 'all'); % The min health of all chickens
mean_health = mean(healths,2); % mean health for all alive chikens 
variance = var(mean_health);
%% Finds how many sources have been visited
    b = unique(food_sources_visited,['stable']);
    percentage_visited = (length(b)/food_source)*100;
      number_of_nodes = unique(positions_chickens,['stable']);

    %% Calculating the health for all agents agent after a burn in of 10 timesteps
    all_agent_health = [];
    for agent = 1:chickens 
        a = ones(1, time - 11) * 0.9;
        b = 1:(time - 11);
        c = a.^b;
        bottom_sum = 1 + sum(c);
        upper_sum_healths = health(agent,11:time); % the one here indicates that its the firs agent = the most dominant!
        upper_sum_gammas = ones(1,1);
        upper_sum_gammas = horzcat(upper_sum_gammas,c);
        upper_sum = sum(upper_sum_gammas.*upper_sum_healths);
        health_of_agent = upper_sum/bottom_sum;
        all_agent_health(end+ 1) = health_of_agent;
    end 

end