%% Make Arrays
average_min_health = [];
average_movings_on = [];
percentage_of_eating = []; 
percentage_of_deaths = []; 
average_variance = [];
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

% Inputs
amount_of_runs = 10; % amount of simulations
n = 10; % square matrix dimensions
time = 100; % time to run for 
food_source = 10; % number of positons of food
starting_chicken_health = 50; % How long the agent will live for
food_amount = [10, 20]; % amount of food generated 
chickens = 10; % number of agents 
graphing = 0; % 1 = present graph


%% UNKNOWN
    for dominance_hierachy = 0:1 % running through for when the dom is present and not

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
        dead = 0; % counter for how many agents are dead 
        agents_dead = [];
        agents_eating = [];
        percentage_nodes_visited = [];
        agents_nodes = [];

        for runs = 1:amount_of_runs
              
            [positions_chickens, percentage_eating, dead, min_health, variance, moving_on, all_agent_health, alive_agent_health, deadness, agent_eating, percentage_visited,  number_of_nodes, number_of_nodes_agents] = foraging_unknown_food(graphing, dominance_hierachy, chickens, n, time, food_source, starting_chicken_health, food_amount);
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
           agents_eating = [agents_eating; transpose(agent_eating)]; 
           percentage_food_sources_visited = [percentage_food_sources_visited; percentage_visited];
           percetnage_of_nodes = 100*length(number_of_nodes)/(n*n);
           percentage_nodes_visited = [percentage_nodes_visited; percetnage_of_nodes];
                   
        end
  

        average_agents_nodes = [average_agents_nodes, mean(agents_nodes,2)];
        percentage_of_nodes_visited(end+ 1) = mean(percentage_nodes_visited);
        percentage_of_food_sources_visited(end+1) = mean(percentage_food_sources_visited);    
        all_agents_eating = [all_agents_eating; mean(agents_eating)];
        agents_health = [agents_health; mean(all_agents_health)];
        sum_of_agents_dead = (sum(agents_dead)./amount_of_runs).*100;
        all_alive_agents_health = [all_alive_agents_health; mean(alive_agents_health)];
        all_deaths = [all_deaths; sum_of_agents_dead];
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
        alive_agents_health = [];
        dead = 0;
        agents_dead = [];
        agents_eating = [];
        percentage_nodes_visited = [];
         agents_nodes = [];


        for runs = 1:amount_of_runs
        
            [positions_chickens, percentage_eating, dead, min_health, variance, moving_on, all_agent_health, alive_agent_health, deadness, agent_eating, percentage_visited,  number_of_nodes, number_of_nodes_agents] = foraging_known_food(graphing, dominance_hierachy, chickens, n, time, food_source, starting_chicken_health, food_amount);
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
           alive_agents_health =[alive_agents_health, alive_agent_health];
           agents_dead = [agents_dead; deadness];
           agents_eating = [agents_eating; transpose(agent_eating)];  
           percentage_food_sources_visited = [percentage_food_sources_visited; percentage_visited];
           percetnage_of_nodes = 100*length(number_of_nodes)/(n*n);
           percentage_nodes_visited = [percentage_nodes_visited; percetnage_of_nodes];
                   
        end
          
        average_agents_nodes = [average_agents_nodes, mean(agents_nodes,2)];
        percentage_of_nodes_visited(end+ 1) = mean(percentage_nodes_visited);
        percentage_of_food_sources_visited(end+1) = mean(percentage_food_sources_visited);
        all_agents_eating = [all_agents_eating; mean(agents_eating)];
        agents_health = [agents_health; mean(all_agents_health)];
        all_alive_agents_health = [all_alive_agents_health; mean(alive_agents_health)];
        sum_of_agents_dead = (sum(agents_dead)./amount_of_runs).*100;
        all_deaths = [all_deaths; sum_of_agents_dead];
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
        alive_agents_health = [];
        dead = 0;
        agents_dead = [];
        agents_eating = [];
        percentage_nodes_visited = [];
         agents_nodes = [];

        for runs = 1:amount_of_runs
              
            [positions_chickens, percentage_eating, dead, min_health, variance, moving_on, all_agent_health, alive_agent_health, deadness, agent_eating, percentage_visited,  number_of_nodes, number_of_nodes_agents] = foraging_known_food_weights(graphing, dominance_hierachy, chickens, n, time, food_source, starting_chicken_health, food_amount);
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
           alive_agents_health = [alive_agents_health, alive_agent_health];
           agents_dead = [agents_dead; deadness];
           agents_eating = [agents_eating; transpose(agent_eating)];    
           percentage_food_sources_visited = [percentage_food_sources_visited; percentage_visited];
           percetnage_of_nodes = 100*length(number_of_nodes)/(n*n);
           percentage_nodes_visited = [percentage_nodes_visited; percetnage_of_nodes];
                   
        end

        average_agents_nodes = [average_agents_nodes, mean(agents_nodes,2)];
        percentage_of_food_sources_visited(end+1) = mean(percentage_food_sources_visited);
        percentage_of_nodes_visited(end+ 1) = mean(percentage_nodes_visited);
        all_agents_eating = [all_agents_eating; mean(agents_eating)];
        agents_health = [agents_health; mean(all_agents_health)];
        all_alive_agents_health = [all_alive_agents_health; mean(alive_agents_health)];
        sum_of_agents_dead = (sum(agents_dead)./amount_of_runs).*100;
        all_deaths = [all_deaths; sum_of_agents_dead];
        percentage_of_agents_deaths = [percentage_of_agents_deaths; sum_of_agents_dead];
        average_min_health(end +1) = mean(min_healths);
        average_movings_on(end +1) = mean(movings_on);
        percentage_of_eating(end +1) = mean(eating); % the average percentage of time a singualr chciken spends eating 
        percentage_of_deaths(end +1) = mean(deaths)*100/chickens; % the percentage of deaths of all chcikens
        variances(isnan(variances)) = []; % gets rid of nan values
        average_variance(end +1) = mean(variances);
end 



%% MAKING  A TABLE
model = ["Unknown food"; "Unknown food Hierachy"; "Known food"; "Known food and Hierachy"; "Known food + weights"; "Known food and Hierachy + weights"];
average_health = mean(agents_health,2);
average_min_health = transpose(average_min_health);
average_movings_on = transpose(average_movings_on);
percentage_of_eating = transpose(percentage_of_eating);
percentage_of_deaths = transpose(percentage_of_deaths);
average_variance = var(agents_health,0,2);
table_outcomes = table(model, average_health, average_min_health, average_movings_on, percentage_of_eating, percentage_of_deaths, average_variance);
X = categorical({'Unknown food','Unknown food Hierachy','Known food','Known food and Hierachy','Known food + weights' ,'Known food and Hierachy + weights'});
X = reordercats(X,{'Unknown food','Unknown food Hierachy','Known food','Known food and Hierachy','Known food + weights' ,'Known food and Hierachy + weights'});


%% BAR CHARTS FOR EATING AND DEATHS
% set(0,'defaulttextinterpreter','latex')
% set(0, 'defaultlegendinterpreter', 'latex')
% set(groot,'defaultAxesTickLabelInterpreter','latex');  
% % percentage of deaths for varying number of food sources
% figure
% figtemp = figure('units', 'centimeters');
% plotting_deaths = [percentage_of_deaths(1,1) percentage_of_deaths(2,1); percentage_of_deaths(5,1) percentage_of_deaths(6,1)];
% plotting_eating = [percentage_of_eating(1,1) percentage_of_eating(2,1); percentage_of_eating(5,1) percentage_of_eating(6,1)];
% X = categorical({'U + E','K+P'});
% X = reordercats(X,{'U + E','K+P'});
% bar(X,plotting_eating)
% legend('No Domiance', 'Dominance');
% xlabel('Model') % x-axis label
% ylabel('Percetnage of Eating') % y-axis label
% savepdf()
 

%% BAR CHART FOR AVERAGE NODES VISITED
% set(0,'defaulttextinterpreter','latex')
% set(0, 'defaultlegendinterpreter', 'latex')
% set(groot,'defaultAxesTickLabelInterpreter','latex');  
% % percentage of deaths for varying number of food sources
% figure
% figtemp = figure('units', 'centimeters');
% average_agents_nodes_mean = mean(average_agents_nodes);
% plotting_nodes = [average_agents_nodes_mean(1,1) average_agents_nodes_mean(1,2); average_agents_nodes_mean(1, 3) average_agents_nodes_mean(1,4); average_agents_nodes_mean(1,5) average_agents_nodes_mean(1,6)];
% X = categorical({'U','K','K+P'});
% X = reordercats(X,{'U','K','K+P'});
% bar(X,plotting_nodes)
% legend('No Domiance', 'Dominance');
% xlabel('Model') % x-axis label
% ylabel('Nodes Visited') % y-axis label
% savepdf()

%% FIGURE FOR THE NUMBER OF NODES PER AGENT
% % AVERAGE NUMBER OF NODES 
% % 1-2 = unknown, 3-4 known, 5-6 known + penalties
% set(0,'defaulttextinterpreter','latex')
% set(0, 'defaultlegendinterpreter', 'latex')
% set(groot,'defaultAxesTickLabelInterpreter','latex');  
% figure
% figtemp = figure('units', 'centimeters');
% mean_average_agents_nodes = mean(average_agents_nodes(:,5));
% agents = 1:chickens;
% yline(mean_average_agents_nodes);
% plot(agents,average_agents_nodes(:,6),'-*', 'LineWidth',3)
% yline(mean_average_agents_nodes,'-','No Dominance', 'FontSize', 18)
% xlabel('Agent ') % x-axis label
% ylabel('Number of Nodes Visited') % y-axis label
% title('Known with Penalties')
% savepdf()

%% BAR CHART FOR AVERAGE MIN HEALTH
% set(0,'defaulttextinterpreter','latex')
% set(0, 'defaultlegendinterpreter', 'latex')
% set(groot,'defaultAxesTickLabelInterpreter','latex');  
% figtemp = figure('units', 'centimeters');
% % percentage of deaths for varying number of food sources
% figure
% figtemp = figure('units', 'centimeters');
% average_min_health = transpose(average_min_health);
% plotting_health = [average_min_health(1,1) average_min_health(1,2); average_min_health(1,5) average_min_health(1,6)];
% X = categorical({'U','K+P'});
% X = reordercats(X,{'U','K+P'});
% bar(X,plotting_health)
% legend('No Domiance', 'Dominance');
% ylim([(0) (max(average_min_health + 2))])
% xlabel('Model') % x-axis label
% ylabel('Average Minimum Health') % y-axis label
% savepdf()


%% BAR CHART OF AGENTS HEALTH WITH/WITHOUT DEAD
set(0,'defaulttextinterpreter','latex')
set(0, 'defaultlegendinterpreter', 'latex')
set(groot,'defaultAxesTickLabelInterpreter','latex');  
figtemp = figure('units', 'centimeters');
% percentage of deaths for varying number of food sources
figure
figtemp = figure('units', 'centimeters');
average_min_health = transpose(average_min_health);
plotting_health = [agents_health(2,1) all_alive_agents_health(2,1);agents_health(6,1) all_alive_agents_health(6,1)];
X = categorical({'U','K+P'});
X = reordercats(X,{'U','K+P'});
bar(X,plotting_health)
legend('Inculding Dead', 'Not Including Dead');
xlabel('Model') % x-axis label
ylabel('Average Agent Health') % y-axis label
savepdf()


%% BAR CHART FOR AVERAGE MOVING ON 
% set(0,'defaulttextinterpreter','latex')
% set(0, 'defaultlegendinterpreter', 'latex')
% set(groot,'defaultAxesTickLabelInterpreter','latex');  
% figtemp = figure('units', 'centimeters');
% % percentage of deaths for varying number of food sources
% figure
% figtemp = figure('units', 'centimeters');
% X = categorical({'U','K+P'});
% X = reordercats(X,{'U','K+P'});
% plotting_moving = [average_movings_on(2); average_movings_on(6)];
% bar(X,plotting_moving)
% ylim([(0) (max(plotting_moving + 2))])
% xlabel('Model') % x-axis label
% ylabel('Average Movings On') % y-axis label
% savepdf()


%% Calculating top and bottom ten percetnage of health of agents
% top_10_values = [];
% bottom_10_values = [];
% % find the top 10% of agents and round
% top_10 = round(chickens*0.1);
% if top_10 < 1
%     top_10 = 1;
% end 
% for agents = 1:top_10
%     top_10_values = horzcat(top_10_values, agents_health(:,agents));
% end 
% 
% % find the bottom 10% of agents and round  
% bottom_10 = round(chickens*0.1);
% if bottom_10 < 1
%     bottom_10 = 1;
% end 
% for agents = 1:bottom_10
%     bottom_10_values = [bottom_10_values, agents_health(:,chickens +1 - agents)];
% end   
% top_10_mean = mean(top_10_values,2);
% bottom_10_mean = mean(bottom_10_values,2);
% figure()
% % top_10
% subplot(1,2,1)
% bar(X,transpose(top_10_mean))
% ylim([(0) (20)])
% 
% % bottom_10
% subplot(1,2,2)
% bar(X,transpose(bottom_10_mean))
% ylim([0 (20)])


%% Making a graph comparing a variable for no dom with average health for dominance agaisnt no dom
% health = agents_health
% deaths = all_deaths
% eating =   agents_eating
% 1-2 = unknown, 3-4 known, 5-6 known + penalties
% set(0,'defaulttextinterpreter','latex')
% set(0, 'defaultlegendinterpreter', 'latex')
% set(groot,'defaultAxesTickLabelInterpreter','latex');  
% figtemp = figure('units', 'centimeters');
% figure
% figtemp = figure('units', 'centimeters');
% mean_known_health = mean(agents_health(5,:));
% agents = 1:chickens;
% yline(mean_known_health,'LineWidth',10);
% plot(agents,agents_health(6,:),'-*', 'LineWidth',3)
% yline(mean_known_health,'--r','No Dominance','LineWidth',3)
% legend('Unknown', 'Known', 'location', 'best');
% xlabel('Agent ') % x-axis label
% ylabel('Health') % y-axis label
% title('Unknown')
% savepdf()
% 
% 
% %% COREELATION
% first_corre = corrcoef(agents,agents_health(6,:));
% second_corre = corrcoef(agents,agents_health(2,:));
% first_corre
% second_corre
% 
% 
% 
% 









