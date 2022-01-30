 %% Chicken Foraging Simulation
%function [positions_chickens, percentage_eating, dead, min_health, variance, moving_on] = foraging_known_food(graphing, dominance_hierachy, chickens, n, time, food_source, starting_chicken_health, food_amount)
all_food_eaten = [];
number = [];
health = [];
deaths = [];
eating = [];
min_healths = [];
variances = [];
movings_on = [];
average_min_health = [];
average_movings_on = [];
percentage_of_eating = []; 
percentage_of_deaths = []; 
average_variance = [];
move_to = [];
% Values
dead = 0;
dominance_hierachy = 1;
% Inputs
n = 10; % square matrix dimensions
time = 5; % time to run for 
food_source = 3; % number of positons of food
starting_chicken_health = 10; % How long the chciken will live for
food_amount = [10, 20]; % amount of food generated 
chickens = 1;
graphing = 0; % 1 = present 


% Values
dead = 0;

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
    amount_of_food = randi(food_amount, 1, food_source); % makes amount of food between two values cant be 1 as then for 1:1 doesnt work 
    healths = []; % collects healths
    
    %% Dominance Hierachy where the lowest number = highest ranking
    ranking = 1 : chickens; % where the highest ranking chicken is the first row of health and positions and so on
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
    low_health = 40; % settingthe lower limit after when it is passed the chciken starts looking for food again.
    all = 0;
    time_steps = 0;
    amount = 0;
    
    %% Finds the current health of all chickens
    current_health = health(:, (time_gone+1));
    all_current_health = find(current_health < 2);

    %% While there is still time left and a chicken is still in health
    while time_gone < (time -1) && dead < chickens
  
            
            time_gone = time_gone +1;  % Time passing
    %% Highligting nodes on the graph 
    
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
                       [row, col] = find(all_food_positions(i) == positions_chickens(i,time_gone));
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
               [~, idx] = find(d > -Inf, food_source, 'first');
               % Makes sure that the distances are in order with their
               % correpsonding amount of food at each food source
               [B, I] = sort(move_to(1, :));
               move_to(1, :) = B;
               move_to(2, :) = move_to(2, I); % "shuffle" the second row to match the sorting order
               steps_per_food = bsxfun(@rdivide,move_to(2,:),move_to(1,:)); % divides the second row by the first 
               [~, index] = max(steps_per_food); % picks the max steps per 'food'
               path = shortestpath(G,positions_chickens(i,(time_gone)),d(index), 'Method','unweighted'); % finds shortest path to selcted food position

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
end 
 
    end 

        %% Finds the current health of all chickens
        current_health = health(:, (time_gone+1));
        all_current_health = find(current_health < 2);    
        dead = sum(current_health(:)==0);


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
if graphing == 1
    % Saves the movie.
    close(writerObj); 
end 


    eating(end+1) = percentage_eating;
            variances(end+1)= variance;
            movings_on(end+1)= moving_on;
          
            if min_health > 1
                min_healths(end +1) = min_health;
            end 
            if dead > 0
                deaths(end+1) = dead;
            end 
        
     
        
        average_min_health(end +1) = mean(min_healths);
        average_movings_on(end +1) = mean(movings_on);
        percentage_of_eating(end +1) = mean(eating); % the average percentage of time a singualr chciken spends eating 
        percentage_of_deaths(end +1) = mean(deaths)*100/chickens; % the percentage of deaths of all chcikens
        variances(isnan(variances)) = []; % gets rid of nan values
        average_variance(end +1) = mean(variances);
fprintf('Average Minimum Health = %f \n',average_min_health);
fprintf('Average Movings On = %f.\n',average_movings_on);
fprintf('Percentage of Eating = %f.\n',percentage_of_eating);
fprintf('Percentage of Deaths = %f.\n',percentage_of_deaths);
fprintf('Minium Health Variance  = %f.\n',average_variance);