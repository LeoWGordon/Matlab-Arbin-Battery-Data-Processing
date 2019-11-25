%% Code for Processing Arbin Galvanostatic Cycling Data
% Gives graphs of cycling performance, and Coulombic efficiency with charge/discharge capacity
% All graphs should save automatically into the folder specific by variable
% savelocation.
% Calls input scripts: saveloc, figure_param, paper_settings_figure.
% Code prepared by Leo W. Gordon
if 1
clear all; 
clc;
close all;

%% Inputting Filename, Sheetnames, and Current Density
% Ensure code saves in the same folder as the excel file
% Input file name, and change number on the sheet names 
% (should be in the file name typically)

valuestr = inputdlg({'Enter File Name','Enter Channel Number','Enter Current Density (mA/g)'},'Input Values'); 

filename = string(valuestr(1,:));
channel = valuestr(2,:);
current_density_num = str2double(valuestr(3,:));

sheet1 = strcat('Channel_',string(channel),'_1');
sheet2 = strcat('Statistics_',string(channel)); % Choose Statistics Sheet

cyc_num = inputdlg({'1st Cycle to Plot', '2nd Cycle to Plot', '3rd Cycle to Plot'},'Choose 3 Cycles to Plot');
Cycle_Number = str2double(cyc_num);

% Read Sheets and Obtain Variables

% For Matlab 2018 and before:
% [a] = xlsread(filename,sheet1);
% [b] = xlsread(filename,sheet2);

% For Matlab 2019 and after:
a = readmatrix(filename,'Sheet',sheet1);
b = readmatrix(filename,'Sheet',sheet2);
saveloc; % change to desired save location
end
%% Determine Mass of Active Material

avg_C = abs(mean(a(a(:,4)==4,7))); % Find average current applied

m = avg_C./current_density_num; % Implies the reverse calculation was done to achieve the correct current density

%% Calling Variables for Figures

%% Figure 1 - Select Cycling Performance

% 3 Cycles
cc1 = Cycle_Number(1,:);
cc2 = Cycle_Number(2,:);
cc3 = Cycle_Number(3,:);

% Step Index Column
ccc = a(:,5);
si = a(:,4);
for j=1:1:length(Cycle_Number)
    for i=Cycle_Number(j)%[cc1 cc2 cc3]

        eval(sprintf('cn%d=a(ccc==i,:);',i));
        eval(sprintf('si%d=cn%d(:,4);',i,i));

        if a(si==2,7)<0
            eval(sprintf('ds%d = cn%d(si%d==2,9)./m;',i,i,i)); % discharge capacity discharge first
            eval(sprintf('Vd%d = cn%d(si%d==2,6);',i,i,i)); % discharge voltage discharge first
            eval(sprintf('c%d = cn%d(si%d==4,8)./m;',i,i,i)); % charge capacity discharge first
            eval(sprintf('Vc%d = cn%d(si%d==4,6);',i,i,i)); % charge voltage discharge first
        else
            eval(sprintf('ds%d = cn%d(si%d==4,9)./m;',i,i,i)); % discharge capacity charge first
            eval(sprintf('Vd%d = cn%d(si%d==4,6);',i,i,i)); % discharge voltage charge first
            eval(sprintf('c%d = cn%d(si%d==2,8)./m;',i,i,i)); % charge capacity charge first
            eval(sprintf('Vc%d = cn%d(si%d==2,6);',i,i,i)); % charge voltage charge first
            pause
        end
    end
end
%% Figure 2 - Full Cycling Performance
if a(si==2,7)<0
    dn = a(si==2,9)./m; % discharge capacity (mA h/g)
    Vd = a(si==2,6); % discharge voltage
    cn = a(si==4,8)./m; % charge capacity (mA h/g)
    Vc = a(si==4,6); % Charge voltage
    
    % Cycle Number - Discharge
    Nd = a(si==2,5);
    Gd = findgroups(Nd); % Segregates Cycles
    % Cycle Number - Charge
    Nc = a(si==4,5);
    Gc = findgroups(Nc); % Segregates Cycles
else
    dn = a(si==4,9)./m; % discharge capacity (mA h/g)
    Vd = a(si==4,6); % discharge voltage
    cn = a(si==2,8)./m; % charge capacity (mA h/g)
    Vc = a(si==2,6); % Charge voltage
    
    % Cycle Number - Discharge
    Nd = a(si==4,5);
    Gd = findgroups(Nd); % Segregates Cycles
    % Cycle Number - Charge
    Nc = a(si==2,5);
    Gc = findgroups(Nc); % Segregates Cycles
end



%% Figure 3 - Capacity per Cycle

cycnum = b(:,5); % Cycle Number
Cd = (b(:,9))./m; % Discharge Capacity (mAh/g)
Cc = (b(:,8))./m; % Charge Capacity (mAh/g)
Cc = Cc(1:end-1); % Remove last point
Cd = Cd(1:end-1); % Remove last point
E = Cc./Cd*100; % Charge over discharge = efficiency (ions out/ions in)
% For plotting, getting good axis limits
Esort = sort(E,'descend');
cycnum1 = cycnum(1:end-1);
axmax1 = max(Cc)+30;
axmax2 = Esort(2)+10;
n = length(cycnum1);
col = ceil((n+1)/20);

%% Plotting Data

% Voltage vs. Capacity
figure (1)

leg1 = strcat('Cycle',{' '},string(cc1));
leg2 = strcat('Cycle',{' '},string(cc2));
leg3 = strcat('Cycle',{' '},string(cc3));



% p1 = plot(ds1,Vd1,'-b',ds2,Vd2,'-r',ds3,Vd3,'-g','LineWidth',2);
p1 = plot(eval(sprintf('ds%d',cc1)),eval(sprintf('Vd%d',cc1)),'-b',eval(sprintf('ds%d',cc2)),eval(sprintf('Vd%d',cc2)),'-r',eval(sprintf('ds%d',cc3)),eval(sprintf('Vd%d',cc3)),'-g','LineWidth',2);

hold on

% p2 = plot(cs1,Vc1,'-b',cs2,Vc2,'-r',cs3,Vc3,'-g','LineWidth',2);

p2 = plot(eval(sprintf('c%d',cc1)),eval(sprintf('Vc%d',cc1)),'-b',eval(sprintf('c%d',cc2)),eval(sprintf('Vc%d',cc2)),'-r',eval(sprintf('c%d',cc3)),eval(sprintf('Vc%d',cc3)),'-g','LineWidth',2);

legend([p1],{leg1,leg2,leg3},'location','east');

xlabel('Specific Capacity (mA h g^{-1})');
ylabel('Voltage (V)');
figure_param

figure(2)
gscatter(dn,Vd,Gd);
hold on
gscatter(cn,Vc,Gc);
%title('Battery Cycling Data','fontsize',18);
xlabel('Capacity (mA h g^{-1})');
ylabel('Voltage (V)');
leg = legend('show');
title(leg,'Cycle Number');
set(legend, 'NumColumns' ,col);
figure_param
set(leg,'fontsize',8,'location','east');

% Coulombic Efficiency and Capacity as a Function of Cycle Number
% Plotted on the same graph

fig = figure;
left_color = [0 0 0];
right_color = [0 0 0];
set(fig,'defaultAxesColorOrder',[left_color; right_color]);

figure(3)
yyaxis left

scatter(cycnum1,Cd,75,'ko')
hold on
scatter(cycnum1,Cc,75,'ro')
%title('Capacity and Coulombic Efficiency','fontsize',18)
xlabel('Cycle Number')
ylabel('Capacity (mA h g^{-1})')
axis([0 n 0 axmax1])
figure_param

yyaxis right

scatter(cycnum1,E,100,'filled')
%title('Coulombic Efficiency and Cycle Life','fontsize',18)
xlabel('Cycle Number')
ylabel('Coulombic Efficiency (%)')
axis([0 n 0 axmax2])
legend('Discharge Capacity','Charge Capacity','Coulombic Efficiency','location','southeast')
figure_param

%grid on
%grid minor

%% Save Files
if 1
fileminustext = erase(filename,'.xlsx'); % Removes the .xlsx from the filename string for figure names without extra full stops

name1 = strcat(fileminustext,'_Cycling_Performance_Select.png');
name2 = strcat(fileminustext,'_Cycling_Performance_Full.png');
name3 = strcat(fileminustext,'_Statistics.png');
% name1 = strcat(fileminustext,'_Cycling_Performance_Select.pdf');
% name2 = strcat(fileminustext,'_Cycling_Performance_Full.pdf');
% name3 = strcat(fileminustext,'_Statistics.pdf');

orient(figure(1),'landscape')
paper_settings_figure
print('-f1',name1,'-dpng','-r1000')
    movefile(name1,savelocation);

orient(figure(2),'landscape')
paper_settings_figure
print('-f2',name2,'-dpng','-r1000')
    movefile(name2,savelocation);

orient(figure(3),'landscape')
paper_settings_figure
print('-f3',name3,'-dpng','-r1000')
    movefile(name3,savelocation);

% orient(figure(1),'landscape')
% print('-f1',name1,'-dpdf','-bestfit')
%     movefile(name1,savelocation);
% 
% orient(figure(2),'landscape')
% print('-f2',name2,'-dpdf','-bestfit')
%     movefile(name2,savelocation);
% 
% orient(figure(3),'landscape')
% print('-f3',name3,'-dpdf','-bestfit')
%     movefile(name3,savelocation);
end
