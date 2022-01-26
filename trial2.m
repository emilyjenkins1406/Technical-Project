%% Makes graphs 

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
starting_chicken_health = 50; % How long the chciken will live for
food_amount = [10, 20]; % amount of food generated 
chickens = 2;
dominance_hierachy = 0; % 1 = present 
graphing = 0; % 1 = present 

%% NO DOM
for food_source = 1:50

    for i = 1:50
    
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

average_min_health(end + 1) = mean(min_healths);
average_movings_on(end + 1)  = mean(movings_on);
percentage_of_eating(end + 1)  = mean(eating); % the average percentage of time a singualr chciken spends eating 
percentage_of_deaths(end + 1)  = mean(deaths)*100/chickens; % the percentage of deaths of all chcikens
variances(isnan(variances)) = []; % gets rid of nan values
average_variance(end + 1)  = mean(variances);
% No Dom
average_variance = transpose(average_variance);
average_min_health = transpose(average_min_health);
average_movings_on = transpose(average_movings_on);
percentage_of_eating = transpose(percentage_of_eating);
percentage_of_deaths = transpose(percentage_of_deaths);

end 


%% DOM
dominance_hierachy = 0; % 1 = present
% Arrays
all_food_eaten = [];
number = [];
health = [];
deaths = [];
eating = [];
min_healths = [];
variances = [];
movings_on = [];
average_min_health_dom = [];
average_movings_on_dom = [];
percentage_of_eating_dom = [];
percentage_of_deaths_dom = [];


for food_source = 1:50

    for i = 1:50
    
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


% Doms
average_min_health_dom(end + 1) = mean(min_healths);
average_movings_on_dom(end + 1)  = mean(movings_on);
percentage_of_eating_dom(end + 1)  = mean(eating); % the average percentage of time a singualr chciken spends eating 
percentage_of_deaths_dom(end + 1)  = mean(deaths)*100/chickens; % the percentage of deaths of all chcikens
% variances(isnan(variances)) = []; % gets rid of nan values
% average_variance_dom(end + 1)  = mean(variances);

end
average_min_health_dom = transpose(average_min_health_dom);
average_movings_on_dom = transpose(average_movings_on_dom);
percentage_of_eating_dom = transpose(percentage_of_eating_dom);
percentage_of_deaths_dom = transpose(percentage_of_deaths_dom);
% Dimensions
dimensions = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50];
dimensions = transpose(dimensions);

% Table
table_outcomes_unknown = table(dimensions, percentage_of_eating, percentage_of_eating_dom);

% Figure
set(gca, 'DefaultTextInterpreter', 'latex')
set(gca, 'DefaultLegendInterpreter', 'latex')
set(gca, 'TickLabelInterpreter', 'latex')
figtemp = figure('units', 'centimeters');
% percentage of deaths for varying number of food sources
figure
figtemp = figure('units', 'centimeters');
dimensions = transpose(dimensions);
percentage_of_deaths = transpose(percentage_of_deaths);
plot(dimensions,percentage_of_deaths,'-*', 'LineWidth',3)
hold on 
plot(dimensions, percentage_of_deaths_dom, '-*', 'LineWidth',3) % Plot training data.
legend('Known', 'Unknown', 'Location','best') 
xlabel('Number of Food Sources') % x-axis label
ylabel('Percentage of Deaths [\%]') % y-axis label
savepdf()

