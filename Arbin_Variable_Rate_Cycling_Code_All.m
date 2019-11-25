%% Code for Processing Arbin Variable Rate Cycling Data
% Gives graphs of the last cycle for every rate, and gives graph of
% charge/discharge capacity and coulombic efficiency vs. cycle number
% Calls input scripts: saveloc, colourmapfigure, figure_param, paper_settings_figure
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

fileminustext = erase(filename,'.xlsx'); % Removes the .xlsx from the filename string for figure names without extra full stops

name1 = strcat(fileminustext,'_Cycling_Performance_Select.png');
name2 = strcat(fileminustext,'_Statistics.png');
saveloc; % change to desired save location

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



curr_dens=[];
    for i = (P:P:n-1) % Finds Pth cycle of each rate - could change the P to use a different cycle in the section
    % Can remove the dialogue entry if a set number used every time -
    % replace second number for the intervals
    
    cn = a(ccc==i,:);
    si1 = cn(:,4); % Redefines the table according to the cycle corresponding to i
    
    maxcap = max(cn(:,9)*1000/mass);
    
        for j = (2:5:m) % j starts at the first discharge step and assumes 5 steps between discharges
    
        current= abs(mean(cn(si1==j+2,7)));
        currentdensity = round(current*1000/mass,2,'significant'); % Finds current density rounded to 2 significant figures
        
        if cn(si1==j,7)<0
            dischargecap = cn(si1==j,9)*1000/mass;
            dischargevoltage = cn(si1==j,6);
            chargecap = cn(si1==(j+2),8)*1000/mass;
            chargevoltage = cn(si1==(j+2),6);
        else
            dischargecap = cn(si1==(j+2),9)*1000/mass;
            dischargevoltage = cn(si1==(j+2),6);
            chargecap = cn(si1==j,8)*1000/mass;
            chargevoltage = cn(si1==j,6);
        end
        
        txt = [num2str(currentdensity,3),' mA/g (Cycle ',num2str(i),')']; % Concatenates the current density value with the unit and cycle number for use in the legend
        
        figure(1)
%         c = lines(n); % Uses the jet colour style, makes a vector of length n, c(i,:) uses specific colours for both charge and discharge
        colourmapfigure
        p1 = plot(dischargecap,dischargevoltage,'color',cmapfig(i/10,:),'DisplayName',txt,'linewidth',2);
        hold on
        p2 = plot(chargecap,chargevoltage,'color',cmapfig(i/10,:),'linewidth',2);
        %title('Variable Rate Cycle Data','fontsize',24);
        xlabel('Specific Capacity (mA h g^{-1})');
        ylabel('Cell Voltage (V)');
        set(get(get(p2,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Omits the legend entries for the charge cycle
        legend box 'off'
        box on
        set(gca,'FontName','Helvetica','FontWeight', 'bold')
        set(gca,'fontsize',28)
        ax = gca;
        ax.LineWidth = 2;
        lgd = legend('-DynamicLegend');
        set(lgd,'fontsize',22,'fontweight','normal','position',[0.6 0.625 0.3 0.001]) % puts legend in the right place
%         set(lgd,'fontsize',8)
        xticks(0:20:((ceil(maxcap/20))*20+20));
        
        hold on
        curr_dens=[curr_dens currentdensity];
        
        end
    end
curr_dens=rmmissing(curr_dens);
hold off

if 0
orient(figure(1),'landscape')
paper_settings_figure
print('-f1',name1,'-dpng');
    movefile(name1,savelocation); 
end
%cut_whitespace

%% Statistics Plot
Cd = (b(:,9)).*1000./mass; % Discharge Capacity (mAh/g)
Cc = (b(:,8)).*1000./mass; % Charge Capacity (mAh/g)
Cc = Cc(1:end-1);
Cd = Cd(1:end-1);
E = Cc./Cd*100; % Charge over discharge = efficiency (ions out/ions in)
Esort = sort(E,'descend');
cycnum1 = cycnum(1:end-1);
axmax1 = max(Cc)+30;
axmax2 = Esort(2)+10;

fig = figure;
left_color = [0 0 0];
right_color = [0 0 0];
set(fig,'defaultAxesColorOrder',[left_color; right_color]); % Keeps both axes black

figure(2)
yyaxis left

scatter(cycnum1,Cd,75,'ko');
hold on
scatter(cycnum1,Cc,75,'ro');

%title('Capacity and Coulombic Efficiency','fontsize',24)
xlabel('Cycle Number')
ylabel('Specific Capacity (mA h g^{-1})')

axis([0 n-1 0 axmax1])
figure_param

yyaxis right

scatter(cycnum1,E,100,'filled');
%title('Coulombic Efficiency and Cycle Life','fontsize',24)
xlabel('Cycle Number')
ylabel('Coulombic Efficiency (%)')
axis([0 n-1 0 axmax2])
for T = 1:1:length(curr_dens)
text((T-1)*P+0.75,E(P)+15,[num2str(curr_dens(T)) ' (mA g^{-1})'],'fontsize',16);%,'fontweight','bold');
end
figure_param
legend('Discharge Capacity','Charge Capacity','Coulombic Efficiency','fontsize',24,'fontweight','normal','location','southeast')
xticks(0:P:n)
ax.XGrid = 'on';

hold off

%% Saving Statistics Graph
if 0
paper_settings_figure
print('-f2',name2,'-dpng');
% print('-f2',name2,'-dpdf','-fillpage')
    movefile(name2,savelocation); 

% grid on       % Add for major gridlines
% grid minor    % Add for minor gridlines

%% Saving Cycling Performance Graph

% fig = gcf;
% fig.PaperPositionMode = 'auto';
% fig_pos = fig.PaperPosition;
% fig.PaperSize = [fig_pos(3) fig_pos(4)];
% 
% orient(figure(1),'landscape')
% print('-f1',name1,'-dpdf','-fillpage')
%     movefile(name1,savelocation); 
end
