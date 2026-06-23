function apply_plot_style()
% -------------------------------------------------------------------------
% Standard plot style for all project figures
% -------------------------------------------------------------------------

font_name = 'Arial';

set(gca, ...
    'FontName', font_name, ...
    'FontSize', 12, ...
    'LineWidth', 1.1);

grid on;
box on;

ax = gca;
ax.Toolbar.Visible = 'off';

end