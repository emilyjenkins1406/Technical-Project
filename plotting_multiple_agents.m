set(gca, 'DefaultTextInterpreter', 'latex')
set(gca, 'DefaultLegendInterpreter', 'latex')
set(gca, 'TickLabelInterpreter', 'latex')
figtemp = figure('units', 'centimeters');

%percentage of deaths and health for varying number of grid dimensions
% figure
% figtemp = figure('units', 'centimeters');
% x = [5,7,9,11,13,15,17,19,21,23,25];
% unknown = [30,50,62,74,76,87,86,91,91,92,95];
% known = [23,30,24,28,29,34,40,47,44,43,49 ];
% unknown_dom = [34,51,66,74,81,85,92,92,93,94,94];
% known_dom = [26,33,29,36,38,37,46,47,46,51,51];
% plot(x,known_dom,'-*', 'LineWidth',3)
% hold on 
% plot(x, unknown_dom, '-*', 'LineWidth',3) % Plot training data.
% legend('Known Locations + Dom','Unknown Locations + Dom', 'Location','best') 
% xlabel('Grid Dimensions [\(n\)]') % x-axis label
% ylabel('Percentage of Deaths [\%]') % y-axis label
% savepdf()

% percentage of deaths for varying number of food sources
figure
figtemp = figure('units', 'centimeters');
dimensions = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50];
unknown = [100,96,96,89,88,86,80,79,71,75,68,65,61,61,57];
known = [100,92,73,45,39,33,37,36,33,30,29,24,32,25,22];
known_dom = [100,86,70,52,50,43,38,40,37,36,30,32,33,31,37];
unknown_dom = [100,95,93,90,85,86,82,80,78,73,65,61,70,66,54];
plot(dimensions,known_dom,'-*', 'LineWidth',3)
hold on 
plot(dimensions, unknown_dom, '-*', 'LineWidth',3) % Plot training data.
legend('Known Locations + Dom','Unknown Locations + Dom', 'Location','best') 
xlabel('Number of Food Sources') % x-axis label
ylabel('Percentage of Deaths [\%]') % y-axis label
savepdf()