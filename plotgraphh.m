
% %grid space
% figure
% yyaxis left
% x = [5,7,9,11,13,15,17,19,21,23,25];
% y = [45.8, 37.04, 29.56, 16.16, 12.08, 8.32, 4.84, 3.08, 2.16, 1.56, 1.16];
% plot(x,y,'-*', 'LineWidth',2)
% yyaxis right
% y2 = [0,2,14,38,54,64,76,86,96,96,98];
% plot(x, y2, '-*', 'LineWidth',2) % Plot training data.
% legend('Deaths','Health', 'Location','best')
% 
% 
% xlabel('Grid Dimensions') % x-axis label
% yyaxis left
% ylabel('Percentage of Deaths [%]') % y-axis label
% yyaxis right
% ylabel('Health') % y-axis label

% % food sources
% figure
% yyaxis left
% x = [1,2,3,4,5,6,7,8,9,10, 11, 12, 13, 14, 15];
% y = [100,96,84,82,68,64,50,40,28,28,24,20,10,12,6];
% 
% plot(x,y,'-*', 'LineWidth',2)
% yyaxis right
% y2 = [1, 1.44, 3.64, 4.32, 6.72, 10.08, 12.96, 13.48, 24.16, 24.1, 24.08, 25.88, 26.2, 28.28, 30.68];
% plot(x, y2, '-*', 'LineWidth',2) % Plot training data.
% legend('Deaths','Health', 'Location','best')
% 
% 
% xlabel('Number of Food Sources') % x-axis label
% yyaxis left
% ylabel('Percentage of Deaths [%]') % y-axis label
% yyaxis right
% ylabel('Health') % y-axis label

% precetnage eating
food = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
percents = [4.6592,8.3983,10.1371, 14.5568, 19.5559,   22.1581,  23.3675, 29.6192, 28.7541, 33.9048,  33.9834,  33.2965, 36.3073, 39.8199, 39.1677];
plot(food,percents,'-*', 'LineWidth',2)
xlabel('Number of Food Sources') % x-axis label
ylabel('Percentage of Time Spent Eating [%]') % y-axis label


