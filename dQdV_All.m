%% Code for Processing Arbin Galvanostatic Cycling Data for dQ/dV plots
% Gives graphs of dQ/dV vs. voltage for galvanostatic cycling data.
% Savinzky-Golay Filter is applied to smooth the data - removed if desired
% (the filter shrinks the peak size slightly, especially for the first
% cycle)
% Calls input scripts: saveloc, figure_param
% Code prepared by Leo W. Gordon

clc; 
close all; 
 if 1
clear all;

valuestr = inputdlg({'Enter File Name','Enter Channel Number','Enter Current Density (mA/g)'},'Input Values'); 

filename = string(valuestr(1,:));
channel = valuestr(2,:);
current_density_num = str2double(valuestr(3,:));

sheet1 = strcat('Channel_',string(channel),'_1');

a = readmatrix(filename,'Sheet',sheet1);
saveloc;
 end

%% Determine Mass of Active Material

avg_C = abs(mean(a(a(:,4)==4,7))); % Find average current applied

mass = avg_C./(current_density_num/1000); % Implies the reverse calculation was done to achieve the correct current density

%% For loop and plot

ccc = a(:,5); % cycle index column

n = max(ccc); % number of cycles

    for i = (1:50:n) % Finds data for every 50th cycle, change 50 to change the step size
    
        cn = a(ccc==i,:); % Redefines the table according to the cycle corresponding to i
        si = cn(:,4); % finds the step indices
        
        if cn(si==2,7)<0
            dischargecap = cn(si==2,9)*1000/mass;
            dischargevoltage = cn(si==2,6);
            chargecap = cn(si==4,8)*1000/mass;
            chargevoltage = cn(si==4,6);
        else
            dischargecap = cn(si==4,9)*1000/mass;
            dischargevoltage = cn(si==4,6);
            chargecap = cn(si==2,8)*1000/mass;
            chargevoltage = cn(si==2,6);
        end
        
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
        xlabel('Voltage (V)');
        ylabel('^{dQ}/_{dV} (mA h g^{-1} V^{-1})');
        hold on
        p2 = plot(chargevoltage,sgf1,'color',c(i,:),'linewidth',2);%,chargevoltage,dydx1);
        axis([0 2.2 -120 850]); % add to fix axes, noisy data shrinks the rest
        
        
        legend location 'northwest'
        set(get(get(p2,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Omits the legend entries for the charge cycle
        figure_param

    end
hold off

%% Save Data
if 1
fileminustext = erase(filename,'.xlsx'); % Removes the .xlsx from the filename string for figure names without extra full stops

name = strcat(fileminustext,'_dQdV.pdf');

orient(figure(1),'landscape')
print('-f1',name,'-dpdf','-bestfit')
    movefile(name,savelocation);
end
