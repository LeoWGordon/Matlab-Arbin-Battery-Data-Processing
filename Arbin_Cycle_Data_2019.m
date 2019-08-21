%% Code for Giving Graphs of Cycling Performance, and Coulombic Efficiency with Charge/Discharge Capacity
% All graphs should save automatically into the folder

clear all; 
clc;
close all;

%% Inputting Filename, Sheetnames, and Current Density
% Ensure code saves in the same folder as the excel file
% Input file name, and change number on the sheet names 
% (should be in the file name typically)
 
file = inputdlg('Enter File Name','File Name');
filename = string(file);

channel = inputdlg('Input Channel Number','Channel Number');
sheet1 = strcat('Channel_',string(channel),'_1');
sheet2 = strcat('Statistics_',string(channel)); % Choose Statistics Sheet

current_density = inputdlg('Enter Current Density (mA/g)','Current Density'); % mA/g
current_density_num = str2double(current_density);

cyc_num = inputdlg({'1st Cycle to Plot', '2nd Cycle to Plot', '3rd Cycle to Plot'},'Choose 3 Cycles to Plot');
Cycle_Number = str2double(cyc_num);

% Read Sheets and Obtain Variables

a = readmatrix(filename,'Sheet',sheet1);
b = readmatrix(filename,'Sheet',sheet2);

%% Determine Mass of Active Material

avg_C = mean(a(a(:,4)==4,7)); % Find average current applied

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

% Redefine tables on a per cycle basis
cn1 = a(ccc==cc1,:);
cn2 = a(ccc==cc2,:);
cn3 = a(ccc==cc3,:);

% Redefine step indices on a per cycle basis
si1 = cn1(:,4);
si2 = cn2(:,4);
si3 = cn3(:,4);

% Discharge Capacity
d1 = cn1(si1==2,9);
ds1 = d1./m;

d2 = cn2(si2==2,9);
ds2 = d2./m;

d3 = cn3(si3==2,9);
ds3 = d3./m;

% Discharge Voltage
Vd1 = cn1(si1==2,6);
Vd2 = cn2(si2==2,6);
Vd3 = cn3(si3==2,6);

% Charge Capacity
c1 = cn1(si1==4,8);
cs1 = c1./m;

c2 = cn2(si2==4,8);
cs2 = c2./m;

c3 = cn3(si3==4,8);
cs3 = c3./m;

% Charge Voltage
Vc1 = cn1(si1==4,6);
Vc2 = cn2(si2==4,6);
Vc3 = cn3(si3==4,6);

%% Figure 2 - Full Cycling Performance

d = a(si==2,9); % Ah
dn = d./m; % mAh/g 

% Charge Capacity
c = a(si==4,8); % Ah
cn = c./m; % mAh/g

% Discharge Voltage
Vd = a(si==2,6);

% Charge Voltage
Vc = a(si==4,6);

% Cycle Number - Discharge
Nd = a(si==2,5);
Gd = findgroups(Nd); % Segregates Cycles

% Cycle Number - Charge
Nc = a(si==4,5);
Gc = findgroups(Nc); % Segregates Cycles

%% Figure 3 - Capacity per Cycle

Cn = b(:,5); % Cycle Number
Cd = (b(:,9))./m; % Discharge Capacity (mAh/g)
Cc = (b(:,8))./m; % Charge Capacity (mAh/g)
E = Cc./Cd*100; % Charge over discharge = efficiency (ions out/ions in)

%% Plotting Data

% Voltage vs. Capacity
figure (1)

plot(ds1,Vd1,'-b',cs1,Vc1,'-b',ds2,Vd2,'-r',cs2,Vc2,'-r',ds3,Vd3,'-g',cs3,Vc3,'-g','LineWidth',1);
leg1 = strcat('Cycle',{' '},string(cc1));
leg2 = strcat('Cycle',{' '},string(cc2));
leg3 = strcat('Cycle',{' '},string(cc3));
legend(leg1,leg1,leg2,leg2,leg3,leg3,'fontsize',16,'location','best');
title('Battery Cycling Data','fontsize',18);
xlabel('Capacity (mAhg^{-1})','fontsize',16);
ylabel('Voltage (V)','fontsize',16);

figure(2)
gscatter(dn,Vd,Gd);
hold on
gscatter(cn,Vc,Gc);
title('Battery Cycling Data','fontsize',18);
xlabel('Capacity (mAhg^{-1})','fontsize',16);
ylabel('Voltage (V)','fontsize',16);
leg = legend('show');
title(leg,'Cycle Number');
set(legend, 'NumColumns' ,2);

% Coulombic Efficiency and Capacity as a Function of Cycle Number
% Plotted on the same graph

fig = figure;
left_color = [0 0 0];
right_color = [0 0 0];
set(fig,'defaultAxesColorOrder',[left_color; right_color]);

figure(3)
yyaxis left

plot(Cn,Cd,'ko',Cn,Cc,'ro')
title('Capacity and Coulombic Efficiency','fontsize',18)
xlabel('Cycle Number','fontsize',16)
ylabel('Capacity (mAhg^{-1})','fontsize',16)

yyaxis right

scatter(Cn,E,'filled')
title('Coulombic Efficiency','fontsize',18)
xlabel('Cycle Number','fontsize',16)
ylabel('Coulombic Efficiency (%)','fontsize',16)
%axis([0 inf 0 105])
legend('Discharge Capacity','Charge Capacity','Coulombic Efficiency','fontsize',16,'location','southeast')


grid on
grid minor

%% Save Files

orient(figure(1),'landscape')
print('-f1',strcat(filename,'.Cycling_Performance_Select.pdf'),'-dpdf','-bestfit')

orient(figure(2),'landscape')
print('-f2',strcat(filename,'.Cycling_Performance_Full.pdf'),'-dpdf','-bestfit')

orient(figure(3),'landscape')
print('-f3',strcat(filename,'.Statistics.pdf'),'-dpdf','-bestfit')
