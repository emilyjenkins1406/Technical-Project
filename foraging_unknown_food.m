%% Chicken Foraging Simulation

function [positions_chickens, percentage_eating, dead, min_health, variance, moving_on, all_agent_health, alive_agent_health, deadness, eating, percentage_visited,  number_of_nodes, number_of_nodes_agents] = foraging_unknown_food(knowledge, penalites, graphing, dominance_hierachy, chickens, n, time, food_source, starting_chicken_health, food_amount)

    %% Creates food and chicken positionsz
    positions = randperm(n.^2,(chickens+food_source)); % determines the positons of chickens and food 
    positions_chickens = []; % Creates a matrix for the positions of the chickens
    positions_chickens(:, 1) = positions(1:chickens); % adds first position of the chicken to the matrix 
    food_position = positions(chickens + 1:end); % picks a random position 4 food sources
    all_food_positions = kron(food_position,ones(chickens,1));
    starting_food_positions = all_food_positions;
    amount_of_food = randi(food_amount, 1, food_source); % makes amount of food between two values cant be 1 as then for 1:1 doesnt work 
    healths = [];
    food_sources_visited = [];
    %% Dominance Hierachy  % lowest number = highest ranking
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
    current_health = health(:, (time_gone+1));

      if graphing == 1
        [x,y] = meshgrid(1:n, 1:n); % to make the graph not 'fishbowl'
        p = plot(G, 'XData',x(:), 'YData',y(:)); % plotting the graph
        %% Set up the movie.
        writerObj = VideoWriter('chicken_video.avi'); % Name it.
        writerObj.FrameRate = 1; % How many frames per second.
        open(writerObj); % Starts the movie
      end 

    %% While loop allowing the chicken to travel and eat food 
    while time_gone < (time - 1)  && dead < chickens % While there is still time left and there are still alikve chickens
  
        time_gone = time_gone +1;  % Time passing

     %% All chickens taking a singular step
     for i = 1:chickens % making the higher ranking chicken move first
        
        position = find(food_position == positions_chickens(i,time_gone)); % Finds the amount of food at a food source     

        %% If a healthy chicken is at any of the food sources where there is food and still time left
        if  health(i, (time_gone)) == 1 || health(i, (time_gone)) == 0 

            health(i,(time_gone+1)) = 0; % Update health
            positions_chickens(i,(time_gone+1)) = NaN;
      
        elseif ~isempty(position)  && amount_of_food(position) > 0 && time_gone < time    
                 food_sources_visited(end+1) = positions_chickens(i,time_gone);
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
            %% No knowledeg 
        if knowledge == 0
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
        
                   %% If no possible points to visit inculde all
                       if length(neighbours) < 1 
                           neighbours = all_neighbours;
                       end 
        
                   pick_neighbour = randi(length(neighbours),1); % Randomly picks a node for the chicken to go to
                   positions_chickens(i,(time_gone+1)) = neighbours(pick_neighbour);
                  
        %% knowledge of food sources that agents are at          
        else 
             
            food_sources_agents_seen = unique(food_sources_visited,['stable']);

            if length(food_sources_agents_seen) == 0      
                   neighbours = neighbors(G,positions_chickens(i,time_gone)); % Working out the nodes the chicken can travel to
                 
                   all_neighbours = neighbours; 
                   %% Gets rid of nodes where higher ranking chickens are currently at if dom hierachy present 
                       if i > 1 && dominance_hierachy == 1
                            for r = 1 : (i - 1)
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
        
                   %% If no possible points to visit inculde all
                       if length(neighbours) < 1 
                           neighbours = all_neighbours;
                       end 
        
                   pick_neighbour = randi(length(neighbours),1); % Randomly picks a node for the chicken to go to
                   positions_chickens(i,(time_gone+1)) = neighbours(pick_neighbour);
                 
                   
            
            else % an agent has gone to a source so head there go to the one closest
                % if an agent has tried it recelty wait ten tiemsteps of
                % randomy walking 
                
                if time_gone > 10
                    agents_recent_positions = positions_chickens(i,(end-9:end));
                    agents_food_sources_seen = food_sources_agents_seen;
                     for z = 1:length(food_sources_agents_seen)
                         if ismember(food_sources_visited(1,z), agents_recent_positions) == 1
                                      % means recently visited so get rid of it as an option 
                                      agents_food_sources_seen( agents_food_sources_seen == food_sources_visited(1,z)) = [];
                         end 
                     end 
                     if isempty(agents_food_sources_seen)
                         % randomly walk 
 
                           neighbours = neighbors(G,positions_chickens(i,time_gone)); % Working out the nodes the chicken can travel to
                           pick_neighbour = randi(length(neighbours),1); % Randomly picks a node for the chicken to go to
                           positions_chickens(i,(time_gone+1)) = neighbours(pick_neighbour);
                     else 
                         d = distances(G, positions_chickens(i,(time_gone)), agents_food_sources_seen, 'Method','unweighted'); % unweighted graph
                        [~, index] = min(d);
                         path = shortestpath(G,positions_chickens(i,(time_gone)),agents_food_sources_seen(index), 'Method','unweighted');
                                if length(path) == 1
                                        value = 1;
                                 else 
                                         value = 2; 
                                 end 
                                         positions_chickens(i,(time_gone+1)) = path(value);
        
                     end 
                else 
     
                       d = distances(G, positions_chickens(i,(time_gone)), food_sources_agents_seen, 'Method','unweighted'); % unweighted graph
                       [~, index] = min(d);
                       if knowledge == 1 %% Only subset 
                           if min(d) > 10 % only let agents have the kwolendeg if they are ten timesteps away (radius of ten)
                               % randomly walk 
     
                               neighbours = neighbors(G,positions_chickens(i,time_gone)); % Working out the nodes the chicken can travel to
                               pick_neighbour = randi(length(neighbours),1); % Randomly picks a node for the chicken to go to
                               positions_chickens(i,(time_gone+1)) = neighbours(pick_neighbour);
                           else 
    
                                 path = shortestpath(G,positions_chickens(i,(time_gone)),food_sources_agents_seen(index), 'Method','unweighted');
                                 if length(path) == 1
                                        value = 1;
                                 else 
                                         value = 2; 
                                 end 
                                         positions_chickens(i,(time_gone+1)) = path(value);
                           end 
                      else % when there is full knowldge or food sources agent is at
                       path = shortestpath(G,positions_chickens(i,(time_gone)),food_sources_agents_seen(index), 'Method','unweighted');
                        if length(path) == 1
                           value = 1;
                       else 
                           value = 2; 
                       end 

                            positions_chickens(i,(time_gone+1)) = path(value);
                       end 
                      
                end 
                     
        end 
       
        end
        not_eating(i,1) = not_eating(i,1) +1;   % Not eating
        health(i,(time_gone+1)) = health(i,(time_gone)) - 1; % Update health
  

        end 
     end
%% Finds the current health of all chickens
 current_health = health(:, (time_gone+1));
 dead = sum(current_health(:)==0);    
    
    end 

    %% Working out what agents died
    deadness = [];
    for agents = 1:chickens
        if health(agents, (time_gone+1))==0
            deadness(end+1) = 1;
        else 
            deadness(end+1) = 0;
        end
    end 

%% Finding the min health of all the chickens (minus the dead ones)
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

%% Finds how many sources have been visited
    b = unique(food_sources_visited,['stable']);
    percentage_visited = (length(b)/food_source)*100; % percenatge of food sources visited
      number_of_nodes = unique(positions_chickens); 
           number_of_nodes( isnan(number_of_nodes)) = []; % gets rid of last visited node
      %% Finds how mnay different nodes the agents have been on 
number_of_nodes_agents = arrayfun(@(x) numel(unique(positions_chickens(x,:))), (1:size(positions_chickens,1)).');

    %% Calculating the health for all agents agent after a burn in of 10 timesteps
    all_agent_health = [];
    for agent = 1:chickens 
        a = ones(1, time_gone - 11) * 0.9;
        b = 1:(time_gone - 11);
        c = a.^b;
        bottom_sum = 1 + sum(c);
        upper_sum_healths = health(agent,11:time_gone); % the one here indicates that its the firs agent = the most dominant!
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
            a = ones(1, time_gone - 11) * 0.9;
            b = 1:(time_gone - 11);
            c = a.^b;
            bottom_sum = 1 + sum(c);
            upper_sum_healths = health(agent,11:time_gone); % the one here indicates that its the firs agent = the most dominant!
            upper_sum_gammas = ones(1,1);
            upper_sum_gammas = horzcat(upper_sum_gammas,c);
            upper_sum = sum(upper_sum_gammas.*upper_sum_healths);
            health_of_agent = upper_sum/bottom_sum;
            alive_agent_health(end+ 1) = health_of_agent;
        end 
    end 

     end 
 
