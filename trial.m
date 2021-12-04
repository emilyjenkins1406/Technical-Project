
% Arrays
all_food_eaten = [];
number = [];
health = [];
deaths = [];
percentage = [];
% Values
dead = 0;
% Inputs
n = 25; % square matrix dimensions
time = 100; % time to run for 
food_source = 10; % number of positons of food
starting_chicken_health = 50; % How long the chciken will live for
food_amount = [10, 20]; % amount of food generated 



for i = 1:50
    
    [chicken_health, food_eaten, number_of_nodes_visited, chicken_positions, percentage_eating] = foraging_known_food(n, time, food_source, starting_chicken_health, food_amount);
    percentage(end+1) = percentage_eating;
    all_food_eaten(end+1) = food_eaten;
    number(end+1) = number_of_nodes_visited;
    health(end+1) = chicken_health;

    if chicken_health <= 1
        dead = dead + 1;
    end 

end


