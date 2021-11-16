%% Chicken Foraging Simulation

%% Values 
n = 5; % square matrix dimensions
time = 20; % time to run for 
time_gone = 1;
food_source = 11; % number of positons of food
chicken_health = 30; % Starting health of chicken
nodes_visited = []; % creates an array of nodes visited
health = [];% creates an array of the helath of a chicken


%% Creates food and chicken positions
chicken_position = randi([1 n.^2],1) % picks a random inital position for the chicken
chicken_positions = [chicken_position]; % creates an array of all visited positions
food_position = randi(n.^2,1 , food_source) % picks a random position 4 food sources
amount_of_food = randi([2 3], 1, food_source) % makes amount of food between two values cant be 1 as then for 1:1 doesnt work 
starting_food = sum(amount_of_food);

%% Creates the graph
A = delsq(numgrid('S',n+2)); % generates the grid
G = graph(A,'omitselfloops'); % creates a graph which omits self looping nodes
[x,y] = meshgrid(1:n, 1:n); % to make the graph not 'fishbowl'
p = plot(G, 'XData',x(:), 'YData',y(:)); % plotting the graph


%% Set up the movie.
writerObj = VideoWriter('chicken_video.avi'); % Name it.
writerObj.FrameRate = 1; % How many frames per second.
open(writerObj); % Starts the movie


%% While loop allowing the chicken to travel and eat food 
while time_gone < time && chicken_health > 0  % While there is still time left and chicken is still in health
      

   %% Working out the nodes the chicken can travel to
   neighbours = neighbors(G,chicken_position)
   nodes_visited(end+1) = chicken_position;

   %% If loop so that the chicken doesnt return to the last visited node
   if length(chicken_positions) > 1 % doesnt count the first step
        neighbours(neighbours == chicken_positions(end-1)) = []; % gets rid of last visited node
   end

   %% Randomly picks a node for the chicken to go to

    pick_neighbour=randi(length(neighbours),1);
    chicken_position=neighbours(pick_neighbour);  
    
    %% Highligting nodes on the graph 
      % Makes the chickens route green
        highlight(p,chicken_positions,'NodeColor','green', 'Marker', 'h', 'MarkerSize',8) 
      % Makes a food position yellow if it hasnt been visited
         highlight(p,food_position,'NodeColor','yellow') 
      % Takes a frame
        frame = getframe();
        writeVideo(writerObj, frame);
    
    %% If the chicken is at any of the food sources
    if ~isempty(find(food_position == chicken_position, 1))       
         position = find(food_position == chicken_position); % Finds the amount of food at that food source

        %% If the chicken can graze freely until all food gone
        if time_gone +amount_of_food(position) <= time
 
            while amount_of_food(position) > 0 % the chicken stays there for the amount of food there
                % Updating amount of food
                amount_of_food(position) = amount_of_food(position) - 1; 
                % Updating chicken positon
                chicken_positions(end+1) = chicken_position;
                % Makes a node magenta 
                highlight(p,chicken_position,'NodeColor','magenta')  
                % chicken health 
                chicken_health = chicken_health + 3;
                health(end+1) = chicken_health;
                % Time passing
                time_gone = time_gone +1; 
                % Takes a frame
                frame = getframe();
                writeVideo(writerObj, frame);
            end 

             % Removes the food position when it is all gone
              food_position(position) = [];
              % Removes amount of food when its all gone 
              amount_of_food(position) = [];
             
             

        %% If the chicken can graze but runs out of time   
        elseif (time_gone + amount_of_food(position)) > time 
            time_eating = 0; % So can calucate the amount of food left at the source
            for j = 1:(time-time_gone)
                % Updating time 
                time_gone = time_gone +1; 
                time_eating = time_eating + 1;
                % Updating chicken position
                chicken_positions(end+1) = chicken_position;
                % Makes a node red 
                highlight(p,chicken_position,'NodeColor','red') 
                % chicken health 
                chicken_health = chicken_health + 3;
                health(end+1) = chicken_health;
                % Takes a frame
                frame = getframe();
                writeVideo(writerObj, frame);
            end 

            % Updates how much food is left at the food source
            amount_of_food(position) = amount_of_food(position) - time_eating;
 
        end

    %% If the chicken isnt at any food    
    else 
        % Update chicken position
        chicken_positions(end+1) = chicken_position;
        % Update health
        chicken_health = chicken_health -1;
        health(end+1) = chicken_health;
        % Update time
        time_gone = time_gone +1; 
        % Takes a frame
        frame = getframe();
        writeVideo(writerObj, frame);

    end 
end 


% Saves the movie.
close(writerObj); 
% Outputs
food_eaten = starting_food - sum(amount_of_food);
number_of_nodes_visited = length(nodes_visited);

