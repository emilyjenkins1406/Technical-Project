
% Inputs into the Overarching Model
amount_of_runs = 10; % amount of simulations
grid_dimensions = 10; % square matrix dimensions
time = 100; % time to run for 
number_of_food_sources = 10; % number of positons of food
inital_agent_health = 50; % Inital health
food_amount = [10, 20]; % amount of food generated 
number_of_agents = 10; % number of agents 
graphing = 0; % 1 = present graph
dominance_hierachy = 1; % 1 = present.
penalites = 1; % 1 for penalties to be present
knowledge = 2; % 0 - no knowledge, 1 = partial knowledgeof food sources, 2 = knowledge of all food source locations  
radius_of_knowledge = 5; % how far an agent can be away to be alerted that an agent has found a food source if partial kowlegde is chosen


%% Make Arrays
average_min_health = [];
average_dominant_health = [];
avergae_subordinate_health = [];
agents_health = [];
all_alive_agents_health = [];
percentage_of_agents_deaths = [];
all_agents_eating = [];
all_deaths = [];
percentage_of_food_sources_visited = [];
percentage_food_sources_visited = [];
percentage_of_nodes_visited = [];
average_agents_nodes = [];


for runs = 1:amount_of_runs

         % Arrays
        all_food_eaten = [];
        number = [];
        health = [];
        deaths = [];
        eating = [];
        min_healths = [];
         alive_agents_health = [];
        variances = [];
        movings_on = [];
        all_agents_health = [];
        agents_dead = [];
        agents_eating = [];
        percentage_nodes_visited = [];
        agents_nodes = [];
        if knowledge == 2
           [positions_chickens, percentage_eating, dead, min_health, variance, moving_on, all_agent_health, alive_agent_health, deadness, eating, percentage_visited, number_of_nodes, number_of_nodes_agents] = informed(graphing, dominance_hierachy, number_of_agents, grid_dimensions, time, number_of_food_sources, inital_agent_health, food_amount);
        else 
             [positions_chickens, percentage_eating, dead, min_health, variance, moving_on, all_agent_health, alive_agent_health, deadness, eating, percentage_visited,  number_of_nodes, number_of_nodes_agents] = uninformed(graphing, dominance_hierachy, number_of_agents, grid_dimensions, time, number_of_food_sources, inital_agent_health, food_amount);
        end 
            
            eating(end+1) = percentage_eating;
            variances(end+1)= variance;
            movings_on(end+1)= moving_on;
          
            if min_health > 1
                min_healths(end +1) = min_health;
            end 
            if dead > 0
                deaths(end+1) = dead;
            end 
          
           agents_nodes = [agents_nodes, number_of_nodes_agents]; 
           all_agents_health = [all_agents_health; all_agent_health];
           agents_dead = [agents_dead; deadness];
            alive_agents_health = [alive_agents_health, alive_agent_health];
           agents_eating = [agents_eating; transpose(eating)]; 
           percentage_food_sources_visited = [percentage_food_sources_visited; percentage_visited];
           percetnage_of_nodes = 100*length(number_of_nodes)/(grid_dimensions*grid_dimensions);
           
                   
end
  
% Table of Results
average_health = mean(all_agent_health);
average_movings_on = mean(movings_on);
percentage_of_eating = (mean(eating)/time)*100;
percentage_of_deaths = (dead/number_of_agents)*100;
health_variance = var(all_agent_health);
percent_sources_visited = mean(percentage_food_sources_visited);
percent_space_visited = mean(percetnage_of_nodes);
simulation_data = table(average_health, average_movings_on, percentage_of_eating, percentage_of_deaths, health_variance, percent_sources_visited, percent_space_visited)
