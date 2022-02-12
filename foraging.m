%% Makes tables
average_min_health = [];
average_movings_on = [];
percentage_of_eating = []; 
percentage_of_deaths = []; 
average_variance = [];
average_dominant_health = [];
avergae_subordinate_health = [];
agents_health = [];
percentage_of_agents_deaths = [];
all_agents_eating = [];

% Inputs
amount_of_runs = 50;
n = 10; % square matrix dimensions
time = 100; % time to run for 
food_source = 5; % number of positons of food
starting_chicken_health = 10; % How long the chciken will live for
food_amount = [10, 20]; % amount of food generated 
chickens = 10;
graphing = 0; % 1 = present graph


%% UNKNOWN
    for dominance_hierachy = 0:1
        % Arrays
        all_food_eaten = [];
        number = [];
        health = [];
        deaths = [];
        eating = [];
        min_healths = [];
        variances = [];
        movings_on = [];
        all_agents_health = [];
        dead = 0;
        agents_dead = [];
        agents_eating = [];

        for runs = 1:amount_of_runs
              
            [positions_chickens, percentage_eating, dead, min_health, variance, moving_on, all_agent_health, deadness, agent_eating] = foraging_unknown_food(graphing, dominance_hierachy, chickens, n, time, food_source, starting_chicken_health, food_amount);
            eating(end+1) = percentage_eating;
            variances(end+1)= variance;
            movings_on(end+1)= moving_on;
          
            if min_health > 1
                min_healths(end +1) = min_health;
            end 
            if dead > 0
                deaths(end+1) = dead;
            end 
    
           all_agents_health = [all_agents_health; all_agent_health];
           agents_dead = [agents_dead; deadness];
           agents_eating = [agents_eating; transpose(agent_eating)];          
                   
        end
        
        all_agents_eating = [all_agents_eating; mean(agents_eating)];
        agents_health = [agents_health; mean(all_agents_health)];
        sum_of_agents_dead = (sum(agents_dead)./amount_of_runs).*100;
        percentage_of_agents_deaths = [percentage_of_agents_deaths; sum_of_agents_dead];
        average_min_health(end +1) = mean(min_healths);
        average_movings_on(end +1) = mean(movings_on);
        percentage_of_eating(end +1) = mean(eating); % the average percentage of time a singualr chciken spends eating 
        percentage_of_deaths(end +1) = mean(deaths)*100/chickens; % the percentage of deaths of all chcikens
        variances(isnan(variances)) = []; % gets rid of nan values
        average_variance(end +1) = mean(variances);

    end


%% KNOWN
    for dominance_hierachy = 0:1
        % Arrays
        all_food_eaten = [];
        number = [];
        health = [];
        deaths = [];
        eating = [];
        min_healths = [];
        variances = [];
        movings_on = [];
        all_agents_health = [];
        dead = 0;
        agents_dead = [];
        agents_eating = [];


        for runs = 1:amount_of_runs
        
            [positions_chickens, percentage_eating, dead, min_health, variance, moving_on, all_agent_health, deadness, agent_eating] = foraging_known_food(graphing, dominance_hierachy, chickens, n, time, food_source, starting_chicken_health, food_amount);
            eating(end+1) = percentage_eating;
            variances(end+1)= variance;
            movings_on(end+1)= moving_on;
          
            if min_health > 1
                min_healths(end +1) = min_health;
            end 
            if dead > 0
                deaths(end+1) = dead;
            end     

           all_agents_health = [all_agents_health; all_agent_health];
           agents_dead = [agents_dead; deadness];
           agents_eating = [agents_eating; transpose(agent_eating)];          
                   
        end

        all_agents_eating = [all_agents_eating; mean(agents_eating)];
        agents_health = [agents_health; mean(all_agents_health)];
        sum_of_agents_dead = (sum(agents_dead)./amount_of_runs).*100;
        percentage_of_agents_deaths = [percentage_of_agents_deaths; sum_of_agents_dead];
        average_min_health(end +1) = mean(min_healths);
        average_movings_on(end +1) = mean(movings_on);
        percentage_of_eating(end +1) = mean(eating); % the average percentage of time a singualr chciken spends eating 
        percentage_of_deaths(end +1) = mean(deaths)*100/chickens; % the percentage of deaths of all chcikens
        variances(isnan(variances)) = []; % gets rid of nan values
        average_variance(end +1) = mean(variances);

    end

%% KNOWN + WEIGHTINGS
for dominance_hierachy = 0:1
        % Arrays
        all_food_eaten = [];
        number = [];
        health = [];
        deaths = [];
        eating = [];
        min_healths = [];
        variances = [];
        movings_on = [];
        all_agents_health = [];
        dead = 0;
        agents_dead = [];
        agents_eating = [];

        for runs = 1:amount_of_runs
              
            [positions_chickens, percentage_eating, dead, min_health, variance, moving_on, all_agent_health, deadness, agent_eating] = foraging_known_food_weights(graphing, dominance_hierachy, chickens, n, time, food_source, starting_chicken_health, food_amount);
            eating(end+1) = percentage_eating;
            variances(end+1)= variance;
            movings_on(end+1)= moving_on;
          
            if min_health > 1
                min_healths(end +1) = min_health;
            end 
            if dead > 0
                deaths(end+1) = dead;
            end 
           
           all_agents_health = [all_agents_health; all_agent_health];
           agents_dead = [agents_dead; deadness];
           agents_eating = [agents_eating; transpose(agent_eating)];          
                   
        end
        all_agents_eating = [all_agents_eating; mean(agents_eating)];
        agents_health = [agents_health; mean(all_agents_health)];
        sum_of_agents_dead = (sum(agents_dead)./amount_of_runs).*100;
        percentage_of_agents_deaths = [percentage_of_agents_deaths; sum_of_agents_dead];
        average_min_health(end +1) = mean(min_healths);
        average_movings_on(end +1) = mean(movings_on);
        percentage_of_eating(end +1) = mean(eating); % the average percentage of time a singualr chciken spends eating 
        percentage_of_deaths(end +1) = mean(deaths)*100/chickens; % the percentage of deaths of all chcikens
        variances(isnan(variances)) = []; % gets rid of nan values
        average_variance(end +1) = mean(variances);
end 

%% MAKING  A TABLE
model = ["Unknown food"; "Unknown food and Hierachy"; "Known food"; "Known food and Hierachy"; "Known food + weights"; "Known food and Hierachy + weights"];
average_min_health = transpose(average_min_health);
average_movings_on = transpose(average_movings_on);
percentage_of_eating = transpose(percentage_of_eating);
percentage_of_deaths = transpose(percentage_of_deaths);
average_variance = transpose(average_variance);
table_outcomes = table(model, average_min_health, average_movings_on, percentage_of_eating, percentage_of_deaths, average_variance, agents_health);
X = categorical({'Unknown food','Unknown food and Hierachy','Known food','Known food and Hierachy','Known food + weights' ,'Known food and Hierachy + weights'});
X = reordercats(X,{'Unknown food','Unknown food and Hierachy','Known food','Known food and Hierachy','Known food + weights' ,'Known food and Hierachy + weights'});

% figure()
% % eating 
% subplot(2,2,1)
% bar(X,percentage_of_eating)
% ylim([(min(percentage_of_eating) - 10) (max(percentage_of_eating + 5))])
% 
% % deaths
% subplot(2,2,2)
% bar(X,percentage_of_deaths)
% ylim([(min(percentage_of_deaths) - 10) (max(percentage_of_deaths + 5))])
% 
% % average min health 
% subplot(2,2,3)
% bar(X,average_min_health)
% ylim([(0) (max(average_min_health + 2))])
% 
% % variance
% subplot(2,2,4)
% bar(X,average_variance)
% ylim([(0) (max(average_variance + 2))])


%% Calculating avergae of dominant and subordinate agents
top_10_values = [];
bottom_10_values = [];
% find the top 10% of agents and round
top_10 = round(chickens*0.1);
if top_10 < 1
    top_10 = 1;
end 
for agents = 1:top_10
    top_10_values = horzcat(top_10_values, agents_health(:,agents));
end 

% find the bottom 10% of agents and round  
bottom_10 = round(chickens*0.1);
if bottom_10 < 1
    bottom_10 = 1;
end 
for agents = 1:bottom_10
    bottom_10_values = [bottom_10_values, agents_health(:,chickens +1 - agents)];
end 

top_10_mean = mean(top_10_values,2);
bottom_10_mean = mean(bottom_10_values,2);

figure()
% top_10
subplot(1,2,1)
bar(X,transpose(top_10_mean))
ylim([(0) (20)])

% bottom_10
subplot(1,2,2)
bar(X,transpose(bottom_10_mean))
ylim([0 (20)])