%% Makes tables
average_min_health = [];
average_movings_on = [];
percentage_of_eating = []; 
percentage_of_deaths = []; 
average_variance = [];
average_dominant_health = [];
avergae_subordinate_health = [];

% Inputs
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
        dom = [];
        sub = [];
        dead = 0;

        for runs = 1:50
              
            [positions_chickens, percentage_eating, dead, min_health, variance, moving_on, dominant_health, subordinate_health] = foraging_unknown_food(graphing, dominance_hierachy, chickens, n, time, food_source, starting_chicken_health, food_amount);
            eating(end+1) = percentage_eating;
            variances(end+1)= variance;
            movings_on(end+1)= moving_on;
          
            if min_health > 1
                min_healths(end +1) = min_health;
            end 
            if dead > 0
                deaths(end+1) = dead;
            end 
       
            dom(end+ 1) = dominant_health;
            sub(end + 1) = subordinate_health;
        
        end
            
        average_dominant_health(end + 1) = mean(dom);
        avergae_subordinate_health(end + 1) = mean(sub);
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
        dom = [];
        sub = [];
        dead = 0;


        for runs = 1:50
        
            [positions_chickens, percentage_eating, dead, min_health, variance, moving_on, dominant_health, subordinate_health] = foraging_known_food(graphing, dominance_hierachy, chickens, n, time, food_source, starting_chicken_health, food_amount);
            eating(end+1) = percentage_eating;
            variances(end+1)= variance;
            movings_on(end+1)= moving_on;
          
            if min_health > 1
                min_healths(end +1) = min_health;
            end 
            if dead > 0
                deaths(end+1) = dead;
            end 
                
            dom(end+ 1) = dominant_health;
            sub(end + 1) = subordinate_health;
        
        end
         
        average_dominant_health(end + 1) = mean(dom);
        avergae_subordinate_health(end + 1) = mean(sub);
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
        dom = [];
        sub = [];
        dead = 0;

        for runs = 1:50
              
            [positions_chickens, percentage_eating, dead, min_health, variance, moving_on, dominant_health, subordinate_health] = foraging_known_food_weights(graphing, dominance_hierachy, chickens, n, time, food_source, starting_chicken_health, food_amount);
            eating(end+1) = percentage_eating;
            variances(end+1)= variance;
            movings_on(end+1)= moving_on;
          
            if min_health > 1
                min_healths(end +1) = min_health;
            end 
            if dead > 0
                deaths(end+1) = dead;
            end 
           
            dom(end+ 1) = dominant_health;
            sub(end + 1) = subordinate_health;
                   
        end

        average_dominant_health(end + 1) = mean(dom);
        avergae_subordinate_health(end + 1) = mean(sub);
        average_min_health(end +1) = mean(min_healths);
        average_movings_on(end +1) = mean(movings_on);
        percentage_of_eating(end +1) = mean(eating); % the average percentage of time a singualr chciken spends eating 
        percentage_of_deaths(end +1) = mean(deaths)*100/chickens; % the percentage of deaths of all chcikens
        variances(isnan(variances)) = []; % gets rid of nan values
        average_variance(end +1) = mean(variances);
end 

% %% MAKING  A TABLE
model = ["Unknown food"; "Unknown food and Hierachy"; "Known food"; "Known food and Hierachy"; "Known food + weights"; "Known food and Hierachy + weights"];
average_min_health = transpose(average_min_health);
average_movings_on = transpose(average_movings_on);
percentage_of_eating = transpose(percentage_of_eating);
percentage_of_deaths = transpose(percentage_of_deaths);
average_variance = transpose(average_variance);
average_dominant_health = transpose(average_dominant_health);
avergae_subordinate_health= transpose(avergae_subordinate_health);
table_outcomes = table(model, average_min_health, average_movings_on, percentage_of_eating, percentage_of_deaths, average_variance, average_dominant_health, avergae_subordinate_health);


