%% Makes tables
% Arrays
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

% Values
dead = 0;

% Inputs
n = 10; % square matrix dimensions
time = 100; % time to run for 
food_source = 5; % number of positons of food
starting_chicken_health = 10; % How long the chciken will live for
food_amount = [10, 20]; % amount of food generated 
chickens = 10;
graphing = 0; % 1 = present 


%% UNKNOWN
    for dominance_hierachy = 0:1

        for runs = 1:50
              
            [positions_chickens, percentage_eating, dead, min_health, variance, moving_on] = foraging_unknown_food(graphing, dominance_hierachy, chickens, n, time, food_source, starting_chicken_health, food_amount);
            eating(end+1) = percentage_eating;
            variances(end+1)= variance;
            movings_on(end+1)= moving_on;
          
            if min_health > 1
                min_healths(end +1) = min_health;
            end 
            if dead > 0
                deaths(end+1) = dead;
            end 
        
        end
        
        average_min_health(end +1) = mean(min_healths);
        average_movings_on(end +1) = mean(movings_on);
        percentage_of_eating(end +1) = mean(eating); % the average percentage of time a singualr chciken spends eating 
        percentage_of_deaths(end +1) = mean(deaths)*100/chickens; % the percentage of deaths of all chcikens
        variances(isnan(variances)) = []; % gets rid of nan values
        average_variance(end +1) = mean(variances);

    end


%% KNOWN
    for dominance_hierachy = 0:1

        for runs = 1:50
        
            [positions_chickens, percentage_eating, dead, min_health, variance, moving_on] = foraging_known_food(graphing, dominance_hierachy, chickens, n, time, food_source, starting_chicken_health, food_amount);
            eating(end+1) = percentage_eating;
            variances(end+1)= variance;
            movings_on(end+1)= moving_on;
          
            if min_health > 1
                min_healths(end +1) = min_health;
            end 
            if dead > 0
                deaths(end+1) = dead;
            end 
        
        end
        
        average_min_health(end +1) = mean(min_healths);
        average_movings_on(end +1) = mean(movings_on);
        percentage_of_eating(end +1) = mean(eating); % the average percentage of time a singualr chciken spends eating 
        percentage_of_deaths(end +1) = mean(deaths)*100/chickens; % the percentage of deaths of all chcikens
        variances(isnan(variances)) = []; % gets rid of nan values
        average_variance(end +1) = mean(variances);

    end

%% MAKING  A TABLE
model = ["Unknown food"; "Unknown food and Hierachy"; "Known food"; "Known food and Hierachy"];
average_min_health = transpose(average_min_health);
average_movings_on = transpose(average_movings_on);
percentage_of_eating = transpose(percentage_of_eating);
percentage_of_deaths = transpose(percentage_of_deaths);
average_variance = transpose(average_variance);
table_outcomes = table(model, average_min_health, average_movings_on, percentage_of_eating, percentage_of_deaths, average_variance);

