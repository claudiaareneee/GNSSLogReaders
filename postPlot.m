function postPlot(legend_strings, session_name)
ylim([0 60]);
legend(legend_strings);
legend('location','northeastoutside');
title(session_name, 'Interpreter', 'none');
end
