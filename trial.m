
% Arrays
all_food_eaten = [];
number = [];
health = [];
deaths = [];
eating = [];
min_healths = [];
variances = [];
movings_on = [];
% Values
dead = 0;
% Inputs
n = 5; % square matrix dimensions
time = 80; % time to run for 
food_source = 1; % number of positons of food
starting_chicken_health = 5; % How long the chciken will live for
food_amount = [10, 20]; % amount of food generated 
chickens = 2;


for i = 1:3

    [positions_chickens, percentage_eating, dead, min_health, variance, moving_on] = foraging_known_food(chickens, n, time, food_source, starting_chicken_health, food_amount);
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

average_min_health = mean(min_healths);
average_movings_on = mean(movings_on);
percetnage_of_eating = mean(eating); % the average percentage of time a singualr chciken spends eating 
percentage_of_deaths = mean(deaths)*100/chickens; % the percentage of deaths of all chcikens
variances(isnan(variances)) = []; % gets rid of nan values
average_variance = mean(variances);