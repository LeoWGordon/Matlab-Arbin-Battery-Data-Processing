%% Arbin Variable Rate Cycling Data
% Gives graphs of the last cycle for every rate, and gives graph of
% charge/discharge capacity and coulombic efficiency vs. cycle number
% Code prepared by Leo W. Gordon

clear all; 
clc;
close all;

%% Inputting Filename, Sheetnames, and Current Density
% Ensure code saves in the same folder as the excel file or use full path
% Input file name, and change number on the sheet names 
% (should be in the file name typically)


valuestr = inputdlg({'Enter File Name', 'Enter Channel Number', 'Enter Active Mass (mg)', 'Enter Number of Cycles per Rate'},'Input Values');
values = str2double(valuestr);

filename = string(valuestr(1,:));

channel = valuestr(2,:);
sheet1 = strcat('Channel_',string(channel),'_1'); % Chooses main sheet
sheet2 = strcat('Statistics_',string(channel)); % Chooses statistics sheet

massmg = values(3,:);
mass = massmg/1000;

P = values(4,:); % For loop step size, e.g. number of cycles per rate

%% Read Sheets and Obtain Variables in 2018 and before

% [a] = xlsread(filename,sheet1);
% [b] = xlsread(filename,sheet2);

%% For matlab 2019 use these readmatrix commands instead

a = readmatrix(filename,'Sheet',sheet1);
b = readmatrix(filename,'Sheet',sheet2);

%% For loop to plot specific cycles at ramping step indices

% 17,19,12,14,7,9,2,4
% discharge 2, 7, 12, 17
% charge 4, 9, 14, 19

cycnum = b(:,5);

n = length(cycnum); % Number of cycles from the statistics tab
m = (((n-1)/10)+1)*5-3; % Step number corresponding to discharge
     
ccc = a(:,5);
si = a(:,4);

    for i = (P:P:n) % Finds 10th cycle of each rate - could change the 10 to use a different cycle in the section
    % Can remove the dialogue entry if a set number used every time -
    % replace second number for the intervals
    
    cn = a(ccc==i,:);
    si1 = cn(:,4); % Redefines the table according to the cycle corresponding to i
    
        for j = (2:5:m) % j starts at the first discharge step and assumes 5 steps between discharges
    
        current = mean(cn(si1==j+2,7));
        currentdensity = round(current*1000/mass,2,'significant'); % Finds current density rounded to 2 significant figures
        
        dischargecap = cn(si1==j,9)*1000/mass;
        dischargevoltage = cn(si1==j,6);
        chargecap = cn(si1==(j+2),8)*1000/mass;
        chargevoltage = cn(si1==(j+2),6);
        txt = [num2str(currentdensity),' mA/g (Cycle ',num2str(i),')']; % Concatenates the current density value with the unit and cycle number for use in the legend
    
        figure(1)
        c = jet(n); % Uses the jet colour style, makes a vector of length n, c(i,:) uses specific colours for both charge and discharge
        p1 = plot(dischargecap,dischargevoltage,'color',c(i,:),'DisplayName',txt,'linewidth',2);
        hold on
        p2 = plot(chargecap,chargevoltage,'color',c(i,:),'linewidth',2);
        %title('Variable Rate Cycle Data','fontsize',24);
        xlabel('Specific Capacity (mA h g^{-1})','fontsize',20,'FontWeight','bold');
        ylabel('Cell Voltage (V)','fontsize',20,'FontWeight','bold');
    
        legend location 'east'
        legend box 'off'
        set(get(get(p2,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Omits the legend entries for the charge cycle
    
        ax = gca;
        size = ax.FontSize;
        ax.FontSize = 18;
        weight = ax.FontWeight;
        ax.FontWeight = 'bold';
        ax.LineWidth = 2;
    
        hold on
    
        end
    end

hold off

% This shrinks the whitespace on the charge/discharge plot for better
% autosaving style
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];



%% Statistics Plot
Cd = (b(:,9)).*1000./mass; % Discharge Capacity (mAh/g)
Cc = (b(:,8)).*1000./mass; % Charge Capacity (mAh/g)
E = Cc./Cd*100; % Charge over discharge = efficiency (ions out/ions in)

fig = figure;
left_color = [0 0 0];
right_color = [0 0 0];
set(fig,'defaultAxesColorOrder',[left_color; right_color]); % Keeps both axes black

figure(2)
yyaxis left

scatter(cycnum,Cd,75,'ko');
hold on
scatter(cycnum,Cc,75,'ro');


%title('Capacity and Coulombic Efficiency','fontsize',24)
xlabel('Cycle Number','fontsize',20,'FontWeight','bold')
ylabel('Specific Capacity (mA h g^{-1})','fontsize',20,'FontWeight','bold')
%axis([0 inf 0 1000]) % Can add if there is a massive outlier which would give a zoomed out graph
box on
ax = gca;
size = ax.FontSize;
ax.FontSize = 18;
weight = ax.FontWeight;
ax.FontWeight = 'bold';
ax.LineWidth = 2;

yyaxis right

scatter(cycnum,E,100,'filled');
%title('Coulombic Efficiency and Cycle Life','fontsize',24)
xlabel('Cycle Number','fontsize',20,'FontWeight','bold')
ylabel('Coulombic Efficiency (%)','fontsize',20,'FontWeight','bold')
axis([0 inf 0 120]) % Can change accordingly to data

ax = gca;
size = ax.FontSize;
ax.FontSize = 18;
weight = ax.FontWeight;
ax.FontWeight = 'bold';
ax.LineWidth = 2;

legend('Discharge Capacity','Charge Capacity','Coulombic Efficiency','fontsize',24,'location','southeast')
legend box 'off'

hold off

% grid on       % Add for major gridlines
% grid minor    % Add for minor gridlines

%% Saving Statistics Graph

fileminustext = erase(filename,'.xlsx'); % Removes the .xlsx from the filename string for figure names without extra full stops

name1 = strcat(fileminustext,'_Cycling_Performance_Select.pdf');
name2 = strcat(fileminustext,'_Statistics.pdf');
savelocation = '/Users/lgordon/Documents/All Figures/'; % change to desired save location

orient(figure(2),'landscape')
print('-f2',name2,'-dpdf','-bestfit')
        movefile(name2,savelocation); 

%% Saving Cycling Performance Graph

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];

orient(figure(1),'landscape')
print('-f1',name1,'-dpdf','-fillpage')
    movefile(name1,savelocation); 
