% Turns legend box off, axis box on (linewidth 2), sets font sizes to 28 and makes bold

legend box 'off'
box on
set(gca,'FontName','Helvetica','FontWeight', 'bold')
set(gca,'fontsize',28)
lgd.FontSize = 24;
lgd.FontWeight = 'normal';
ax = gca;
size = ax.FontSize;
ax.FontSize = 28;
weight = ax.FontWeight;
ax.FontWeight = 'bold';
ax.LineWidth = 2;