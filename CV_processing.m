%% Code for Processing Cyclic Voltammetry Data
% Gives graphs of voltage vs. current for all cycles
% All graphs should save automatically into the folder specific by variable
% savelocation.
% Input scripts: saveloc.m, colourmapfigure.m, figure_param.m
% Code prepared by Leo W. Gordon

clc;
close all;
clear all;

valuestr = inputdlg({'Enter File Name','Enter Scan Rate (µV/s)'},'Input Values'); 

filename = string(valuestr(1,:));
rate = str2double(valuestr(2,:));

a = readtable(filename);
M = table2array(a);

saveloc;
%%
area = pi*0.3^2; % 0.3 as the radius of the cathode (6 mm swagelok cells)

cn = M(:,11);
num_cycles = max(cn);
n = num_cycles;

for i=(1:1:n)
    a1 = M(cn==i,:);
    V = a1(:,9);
    I = a1(:,10)/area;
    
    num = ['Cycle ', num2str(i)];
    colourmapfigure
    plot(V,I,'color',cmapfig(i,:),'linewidth',3,'DisplayName',num)%
    hold on
end
hold off
%title(strcat('Cyclic Voltammograms at', '{ }', rate, '{ }','µV s^{-1}'),'fontsize',18)
xlabel('Voltage (V)')
ylabel('Current Density (mA cm^{-2})')
legend show
lgd = legend('location','northwest');
%grid on
%grid minor
figure_param

%%
shortfilename = erase(filename,'.txt'); % remove .txt from the filename
% name = strcat(shortfilename,'_CV.pdf');
name = strcat(shortfilename,'_CV.png');
% 
% orient(figure(1),'landscape')
% print('-f1',name,'-dpdf','-bestfit')
%     movefile(name,savelocation);

orient(figure(1),'landscape')
paper_settings_figure
print('-f1',name,'-dpng','-r1000');
    movefile(name,savelocation);
    
    
