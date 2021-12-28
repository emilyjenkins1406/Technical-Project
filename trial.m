
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
n = 10; % square matrix dimensions
time = 100; % time to run for 
food_source = 5; % number of positons of food
starting_chicken_health = 10; % How long the chciken will live for
food_amount = [10, 20]; % amount of food generated 
chickens = 5;
dominance_hierachy = 1; % 1 = present 


for i = 1:10

    [positions_chickens, percentage_eating, dead, min_health, variance, moving_on] = foraging_unknown_food(dominance_hierachy, chickens, n, time, food_source, starting_chicken_health, food_amount);
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
percentage_of_eating = mean(eating); % the average percentage of time a singualr chciken spends eating 
percentage_of_deaths = mean(deaths)*100/chickens; % the percentage of deaths of all chcikens
variances(isnan(variances)) = []; % gets rid of nan values
average_variance = mean(variances);

fprintf('Average Minimum Health = %f \n',average_min_health);
fprintf('Average Movings On = %f.\n',average_movings_on);
fprintf('Percentage of Eating = %f.\n',percentage_of_eating);
fprintf('Percentage of Deaths = %f.\n',percentage_of_deaths);
fprintf('Minium Health Variance  = %f.\n',average_variance);

