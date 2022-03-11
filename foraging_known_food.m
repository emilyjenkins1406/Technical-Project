 %% Chicken Foraging Simulation
 function [positions_chickens, percentage_eating, dead, min_health, variance, moving_on, all_agent_health, alive_agent_health, deadness, eating, percentage_visited,  number_of_nodes, number_of_nodes_agents ] = foraging_known_food(penalites, graphing, dominance_hierachy, chickens, n, time, food_source, starting_chicken_health, food_amount)

    %% Values
    agents_seen_each_other = [];
    path = zeros(1,chickens); % chicken doesnt have a path set
    all_paths = zeros(chickens,time); % path to transverse 
    moving_on = 0; % counts how many times the chicken moves on
    dead = 0; % counts how many dead
    time_gone = 0; % How much time has passed
    eating = zeros(chickens,1); % how many timesteps are spent eating
    not_eating = ones(chickens,1); % adding one for the first timestep
    all = 0;
    alls = 0;
    time_steps = 0;
    food_sources_visited = [];
    
       
    %% Creates the graph
    A = delsq(numgrid('S',n+2)); % generates the grid
    G = graph(A,'omitselfloops'); % creates a graph which omits self looping nodes

    %% Makes a 'visable' graph for the user if input == 1
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
        
    %% Creates a 'health' of all chickens 
    health = zeros(chickens,1); % creates health array 
    health(:, 2) = starting_chicken_health; % adds first position of the chicken to the matrix 
    health(:,1) = []; % removes the first column 

    %% health
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
                  if penalites == 1
                    % collects info to be used when deciding when to come back
                    new_spotting = [i; 0; time_gone; positions_chickens(i,time_gone)]; % fill in other chicken when i can
                    agents_seen_each_other = [agents_seen_each_other, new_spotting];
                  else 
                    % removes the food positon as a further possibilty
                    [~, col] = find(all_food_positions(i) == positions_chickens(:,time_gone));
                    all_food_positions(i, col) = NaN; 
                  end 
                   neighbours = neighbors(G,positions_chickens(i,time_gone)); % Working out the nodes the chicken can travel to
                   positions_chickens(i,(time_gone+1)) = neighbours(randi(length(neighbours),1));
                   not_eating(i,1) = not_eating(i,1) +1;   % Not eating
                   health(i,(time_gone+1)) = health(i,(time_gone)) - 1; % Update health   
                   path(1,i) = 0; % as the chicken is now at the end of its route and needs to find a new path 
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
               if penalites == 1
                   
                       %% Makes sure arrays are all the same length
                       where_nans_are = isnan(all_food_positions(i,:));
                       for nans = 1: length(all_food_positions(i,:))
                          % If there is a NaN then get rid of it
                           if where_nans_are(1,nans) == 1
                               amount_of_food_2 = amount_of_food;
                               amount_of_food_2(:,nans) = [];
                               all_food_positions_2 = all_food_positions(i,:);
                               all_food_positions_2(:,nans) = [];
                           end 
                       end  
        
                       %% Check to see if any of the food points are too far away 
                       % If there was a NaN present
                       remove = d > health(i,(time_gone)); % finding what food_positions are too far away that the agent wont madke it
                       elements_of_d = 0;
                       if sum(where_nans_are) > 0 
                            for  remove_position = 1:length(d)
                               if remove(remove_position) == 1
                                   d(remove_position - elements_of_d) = [];
                                   all_food_positions_2(remove_position - elements_of_d) = [];
                                   amount_of_food_2(remove_position - elements_of_d) = [];
                                   elements_of_d = elements_of_d + 1;
                               end
                            end 
                            %% Add a penalty for far away food - reduces the 'food_per_step'
                            penalties_distance = [];
                            for penalty = 1: length(d)
                                penalties_distance(end+1) = 1 - 0.8^(d(penalty));
                            end
                           
        
        
                          move_to = [all_food_positions_2; d; amount_of_food_2];
                       % If there wasnt a NaN present
                       else 
                           all_food_positions_3 = all_food_positions(i,:);
                          
                           amount_of_food_3 = amount_of_food;
                           for  remove_position = 1:elements_of_d
                               if remove(remove_position) == 1
                                   d(remove_position - elements_of_d) = [];
                                   all_food_positions_3(remove_position - elements_of_d) = [];
                                   amount_of_food_3(remove_position - elements_of_d) = [];
                                   elements_of_d = elements_of_d + 1;
                                   
                               end
         
                           end 
                           %% Add a penalty for far away food - reduces the 'food_per_step'
                            penalties_distance = [];
                            for penalty = 1: length(d)
                                penalties_distance(end+1) = 0.9^(d(penalty)/5);
                            end
                    %% Add a penalty if another agent has been seen at a source
                    penalties = [];
                   if length(agents_seen_each_other) > 1 
                    % find where this agent has seen others in the past 
                    indices = find(agents_seen_each_other(1,:)== i);
                    agent_seen_others = agents_seen_each_other(:,[indices]);
         
                   if ~isempty(agent_seen_others) % see if the agent has seen others
                       for food_running = 1: length(amount_of_food_3) % run through all the food positions
                           if sum(agent_seen_others(4,:)==all_food_positions_3(food_running)) > 0 
                               [~, column] = find(agent_seen_others(4,:)==all_food_positions_3(food_running));
                                % find the most recent time another memebr was seen and apply a penalty 
                               time_when_seen = agent_seen_others(3,max(column)); 
                               last_seen = time_gone - time_when_seen;
                               seen_penalty = 1 - 0.9^(last_seen);
                               penalties(end+1) = seen_penalty; % pentalty added
                              
                           else 
                               penalties(end+1) = 1; % no pentalty added
                           end 
                  
                       end 
                   end
                       
                   end 
        
                   move_to = [all_food_positions_3; d; amount_of_food_3];
                       end 
                       
                       if isempty(move_to) == 1 % If the agent wont make it anywhere so a random food source is picked for them to 'try' get too
                            set_path = shortestpath(G,positions_chickens(i,(time_gone)), food_position(randi(length(food_position),1)), 'Method','unweighted'); % finds shortest path to selcted food position
                       else % if the agent can make it 
                           [B, I] = sort(move_to(2, :));
                           move_to(2, :) = B;
                           move_to(3, :) = move_to(3, I); % "shuffle" the third row to match the sorting order
                           move_to(1, :) = move_to(1, I); % "shuffle" the third row to match the sorting order
                           steps_per_food = bsxfun(@rdivide,move_to(3,:),move_to(2,:)); % divides the amount of food by the number of steps to each food source
        
                           if length(penalties) >1
                            steps_per_food = steps_per_food.*penalties; % applying penalties for seeing agents
                           end 
        
                           steps_per_food = steps_per_food.*penalties_distance; % applying penalties for distance
        
                           [~, index] = max(steps_per_food); % picks the max steps per 'food' where now (move_to(1, index)) will be node we want to go too
                           set_path = shortestpath(G,positions_chickens(i,(time_gone)),(move_to(1, index)), 'Method','unweighted'); % finds shortest path to selcted food position
                       end
                       
                       %% Checks how far away the desired food position is
                       if length(set_path) == 1
                           value = 1;
                       else 
                           value = 2; 
                       end 
               %% else if penalties are being used 
               else 
                   [~, index] = min(d);
                   set_path = shortestpath(G,positions_chickens(i,(time_gone)),food(index), 'Method','unweighted');
                   % checks how far away the position is
                   if length(path) == 1
                       value = 1;
                   else 
                       value = 2; 
                   end 
                  
               end 

                %% Updates positions and health 
               positions_chickens(i,(time_gone+1)) = set_path(value);
               health(i,(time_gone+1)) = health(i,(time_gone)) - 1; % Update health
               not_eating(i,1) = not_eating(i,1) +1;   % Not eating
               
                %% Makes a path and adds it to a matrix so that we know all paths the agents are on
               nan_values_needed = time - length(set_path);
               nan_values = zeros(1,nan_values_needed);
               path_for_matrix = cat(2,set_path,nan_values);
               path_for_matrix = path_for_matrix(1:time); % adds nan values until the path covers all time
               all_paths(i,:) = path_for_matrix;
               path(1,i) = length(set_path) - 3; %
               % make path counter to see what the next step is
               step_counter = 3.*ones(1,chickens);
           end 
             
        end 
    end 

%% If grpah was picked
if graphing == 1
            
          
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
    close(writerObj); 
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

%% Finds how many sources have been visited
    b = unique(food_sources_visited,['stable']);
    percentage_visited = (length(b)/food_source)*100;
      number_of_nodes = unique(positions_chickens,['stable']);
           number_of_nodes( isnan(number_of_nodes)) = []; % gets rid of last visited node
%% Finds how mnay different nodes the agents have been on 
number_of_nodes_agents = arrayfun(@(x) numel(unique(positions_chickens(x,:))), (1:size(positions_chickens,1)).');

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
        variance = var(all_agent_health); 
       %% Calculating the health for all agents agent after a burn in of 10 timesteps for alive agents 
    alive_agent_health = [];
    for agent = 1:chickens 
        if current_health(agent) > 1
            a = ones(1, time - 11) * 0.9;
            b = 1:(time - 11);
            c = a.^b;
            bottom_sum = 1 + sum(c);
            upper_sum_healths = health(agent,11:time); % the one here indicates that its the firs agent = the most dominant!
            upper_sum_gammas = ones(1,1);
            upper_sum_gammas = horzcat(upper_sum_gammas,c);
            upper_sum = sum(upper_sum_gammas.*upper_sum_healths);
            health_of_agent = upper_sum/bottom_sum;
            alive_agent_health(end+ 1) = health_of_agent;
        end 
    end 
end