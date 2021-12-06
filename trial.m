
% Arrays
all_food_eaten = [];
number = [];
health = [];
deaths = [];
percentage = [];
% Values
dead = 0;
% Inputs
n = 5; % square matrix dimensions
time = 5; % time to run for 
food_source = 1; % number of positons of food
starting_chicken_health = 50; % How long the chciken will live for
food_amount = [10, 20]; % amount of food generated 
chickens = 2;


for i = 1:5

    [positions_chickens, percentage_eating, food_eaten] = foraging_unknown_food(chickens, n, time, food_source, starting_chicken_health, food_amount);
    percentage(end+1) = percentage_eating;
    all_food_eaten(end+1) = food_eaten;

end

mean(percentage) % the average percentage of time a singualr chciken spends eating 
mean(all_food_eaten) % by all chickens avergaed over x simulations
