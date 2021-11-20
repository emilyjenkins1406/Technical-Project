
% Arrays
all_food_eaten = [];
number = [];
health = [];
% Values
dead = 0;
% Inputs
n = 10; % square matrix dimensions
time = 50; % time to run for 
food_source = 3; % number of positons of food
starting_chicken_health = 42; % How long the chciken will live for
food_amount = [10, 20];

for i = 1:10
    [chicken_health, food_eaten, number_of_nodes_visited] = foraging_known_food(n, time, food_source, starting_chicken_health, food_amount);
    all_food_eaten(end+1) = food_eaten;
    number(end+1) = number_of_nodes_visited;
    if chicken_health == 1 
        dead = dead + 1;
    end 
    health(end+1) = chicken_health;
end

% % Get coefficients of a line fit through the data.
% coefficients = polyfit(number, all_food_eaten, 1);
% % Create a new x axis with exactly 1000 points (or whatever you want).
% xFit = linspace(min(number), max(number), 1000);
% % Get the estimated yFit value for each of those 1000 new x locations.
% yFit = polyval(coefficients , xFit);
% % Plot everything.
% plot(number, all_food_eaten, 'b.', 'MarkerSize', 15); % Plot training data.
% hold on; % Set hold on so the next plot does not blow away the one we just drew.
% plot(xFit, yFit, 'r-', 'LineWidth', 2); % Plot fitted line.
% plot(number, all_food_eaten,'.')
% title('Number of nodes visited against food eaten') % title for plot
% xlabel('Number of unique nodes visited') % x-axis label
% ylabel('Food Eaten') % y-axis label