%% Code for Processing Arbin Galvanostatic Cycling Data for dQ/dV plots
% Gives graphs of dQ/dV vs. voltage for galvanostatic cycling data.
% Savinzky-Golay Filter is applied to smooth the data - removed if desired
% (the filter shrinks the peak size slightly, especially for the first
% cycle)
% Code prepared by Leo W. Gordon

clc; 
close all; 
clear all;

valuestr = inputdlg({'Enter Filepath','Enter Channel Number','Enter Current Density (mA/g)'},'Input Values'); 
% enter full filepath in the dialogue box, or have the file in the same directory as the code file and use only file name

filename = string(valuestr(1,:));
channel = valuestr(2,:);
current_density_num = str2double(valuestr(3,:));

sheet1 = strcat('Channel_',string(channel),'_1');

a = readmatrix(filename,'Sheet',sheet1);

%% Determine Mass of Active Material

avg_C = mean(a(a(:,4)==4,7)); % Find average current applied

mass = avg_C./(current_density_num/1000); % Implies the reverse calculation was done to achieve the correct current density

%% For loop and plot

ccc = a(:,5); % cycle index column

n = max(ccc); % number of cycles

    for i = (1:25:n) % Finds data for every 25th cycle, change second entry to change the step size
    
        cn = a(ccc==i,:); % Redefines the table according to the cycle corresponding to i
        si = cn(:,4); % finds the step indices
        
        dischargecap = cn(si==2,9)*1000/mass;
        dischargevoltage = cn(si==2,6);
        chargecap = cn(si==4,8)*1000/mass;
        chargevoltage = cn(si==4,6);
        
        dydx = gradient(dischargecap(:))./gradient(dischargevoltage(:)); % dQ/dV = mAh/g/V == A.s/V
        dydx1 = gradient(chargecap(:))./gradient(chargevoltage(:));
        
        % Savitzky-Golay filter to smooth the data
        % Increase 3rd entry to smooth more, or vice versa
        sgf0 = sgolayfilt(dydx,1,11); 
        sgf1 = sgolayfilt(dydx1,1,11);
        
        % Plot figure
        txt = ['Cycle ',num2str(i)];
        c = jet(n);
        
        figure(1)
        p1 = plot(dischargevoltage,sgf0,'color',c(i,:),'displayname',txt,'linewidth',2);%,dischargevoltage,dydx);
        %axis([0 2.2 -100 500]); % add to fix axes, noisy data shrinks the rest
        xlabel('Voltage (V)','fontsize',16);
        ylabel('^{dQ}/_{dV} (mA h g^{-1} V^{-1})','fontsize',16);
        hold on
        p2 = plot(chargevoltage,sgf1,'color',c(i,:),'linewidth',2);%,chargevoltage,dydx1);
        %axis([0 2.2 -100 500]); % add to fix axes, noisy data shrinks the rest
        
        
        legend location 'northwest'
        legend box off
        set(get(get(p2,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Omits the legend entries for the charge cycle

        box on
        ax = gca;
        size = ax.FontSize;
        ax.FontSize = 18;
        weight = ax.FontWeight;
        ax.FontWeight = 'bold';
        ax.LineWidth = 2;

    end
hold off

%% Save Data

fileminustext = erase(filename,'.xlsx'); % Removes the .xlsx from the filename string for figure names without extra full stops

name = strcat(fileminustext,'_dQdV.pdf');
savelocation = '/Users/lgordon/Documents/All Figures/'; % change to desired save location

orient(figure(1),'landscape')
print('-f1',name,'-dpdf','-bestfit')
    movefile(name,savelocation);

