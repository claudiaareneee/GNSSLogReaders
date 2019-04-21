function postPlot(legend_strings, session_name)
% ylim([-2*pi 2*pi]);
% yticks([-pi pi])

ylim([-200 200]);
yticks(-180:30:180)
ytickformat('degrees');

legend(legend_strings);
legend('location','northeastoutside');
title(session_name, 'Interpreter', 'none');
end
