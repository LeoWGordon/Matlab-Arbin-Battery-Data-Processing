%% Code for Processing Variable Rate Cyclic Voltammetry Data
% Gives graphs of voltage vs. current for all cycles
% All graphs should save automatically into the folder specific by variable
% savelocation.
% Input scripts: saveloc.m, figure_param.m
% Code prepared by Leo W. Gordon

clc;
close all;
clear all;

valuestr = inputdlg({'Enter File Name','Enter Number of Cycles per Rate'},'Input Values'); 

filename = string(valuestr(1,:));
f = str2double(valuestr(2,:));

a = readtable(filename);
M = table2array(a);
saveloc;

cn = M(:,11);
num_cycles = max(cn);
n = num_cycles;
area = pi*0.3^2; % Assuming 6 mm swagelok

for i = (f:f:n)
    a1 = M(cn==i,:);
    V = a1(:,9);
    I = a1(:,10)/area;
    cV = a1(:,8);
    t = a1(:,7);
    
    for j = (20:1:21)
        deltaV = cV(j)-cV(j+1);
        deltat = t(j+1)-t(j);
        r = round(deltaV/deltat,1,'significant');
        num = [num2str(r), ' V/s'];
    end
    plot(V,I,'linewidth',3,'DisplayName',num)
    hold on
    
end

% Rate = change in control V(column 8)/change in time

hold off
% title('Variable Rate Cyclic Voltammograms','fontsize',18)
xlabel('Voltage (V)')
ylabel('Current Density (mA cm^{-2})')
legend('location','northwest');
% grid on
% grid minor
figure_param


%% Save Files 
shortfilename = erase(filename,'.txt'); % remove .txt from the filename
% name = strcat(shortfilename,'_CV.pdf');
name = strcat(shortfilename,'_CV.png');

orient(figure(1),'landscape')
% print('-f1',name,'-dpdf','-bestfit')
print('-f1',name,'-dpng','-r1000')
    movefile(name,savelocation);
