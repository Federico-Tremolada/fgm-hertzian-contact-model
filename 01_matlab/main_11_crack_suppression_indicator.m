%% main_11_crack_suppression_indicator.m
% -------------------------------------------------------------------------
% Project: Micromechanics Project - Hertzian Contact in FG Ceramics
% Author: Federico Tremolada
%
% Purpose:
% Build a qualitative analytical indicator related to Hertzian cone-crack
% suppression.
%
% IMPORTANT:
% This is NOT a complete fracture criterion.
% Cone-crack initiation depends on the maximum principal tensile stress
% field. Here we use contact pressure reduction as a comparative proxy,
% coherent with the paper discussion.
%
% Indicators:
% S_p  = p0_FGM / p0_HOM
% I_cc = 1 - S_p
%
% where:
% S_p  < 1 means reduced contact severity
% I_cc > 0 means beneficial crack-suppression tendency
% -------------------------------------------------------------------------

clear; clc; close all;

addpath("functions");

%% 1. Output folders

figures_folder = "../02_results/figures/";
tables_folder  = "../02_results/tables/";
data_folder    = "../02_results/data/";

if ~exist(figures_folder, 'dir'); mkdir(figures_folder); end
if ~exist(tables_folder,  'dir'); mkdir(tables_folder);  end
if ~exist(data_folder,    'dir'); mkdir(data_folder);    end

%% 2. Reference parameters

params = get_reference_parameters();

P = params.load.P;

R = params.indenter.R;
D = params.indenter.D;

E_i  = params.indenter.E;
nu_i = params.indenter.nu;

E_s  = params.homogeneous.E;
nu_s = params.homogeneous.nu;

E0_ref = params.graded.E0;
k_ref  = params.graded.k;
nu     = params.graded.nu;

%% 3. Homogeneous reference

hom = hertz_classic(P, R, E_s, nu_s, E_i, nu_i);

a_hom  = hom.a;
h_hom  = hom.h;
p0_hom = hom.p0;

%% 4. Graded reference case

a_fgm = graded_contact_radius_gamma(P, D, E0_ref, k_ref, nu);
fgm   = graded_contact_from_radius(P, D, k_ref, a_fgm);

a_fgm_ref  = fgm.a;
h_fgm_ref  = fgm.h;
p0_fgm_ref = fgm.p0;

%% 5. Crack-suppression indicators

S_p_ref = p0_fgm_ref / p0_hom;
I_cc_ref = 1 - S_p_ref;

contact_spreading_ratio = a_fgm_ref / a_hom;
pressure_reduction_percent = I_cc_ref * 100;

%% 6. k-dependent crack-suppression indicator

k_values = linspace(0.01, 0.99, 250);

S_p_k  = zeros(size(k_values));
I_cc_k = zeros(size(k_values));
a_k    = zeros(size(k_values));
p0_k   = zeros(size(k_values));

for i = 1:length(k_values)

    k = k_values(i);

    a = graded_contact_radius_gamma(P, D, E0_ref, k, nu);
    res = graded_contact_from_radius(P, D, k, a);

    a_k(i)    = res.a;
    p0_k(i)   = res.p0;
    S_p_k(i)  = res.p0 / p0_hom;
    I_cc_k(i) = 1 - S_p_k(i);

end

%% 7. E0-dependent crack-suppression indicator

E0_values = linspace(0.5*E0_ref, 1.5*E0_ref, 250);

S_p_E0  = zeros(size(E0_values));
I_cc_E0 = zeros(size(E0_values));
a_E0    = zeros(size(E0_values));
p0_E0   = zeros(size(E0_values));

for i = 1:length(E0_values)

    E0 = E0_values(i);

    a = graded_contact_radius_gamma(P, D, E0, k_ref, nu);
    res = graded_contact_from_radius(P, D, k_ref, a);

    a_E0(i)    = res.a;
    p0_E0(i)   = res.p0;
    S_p_E0(i)  = res.p0 / p0_hom;
    I_cc_E0(i) = 1 - S_p_E0(i);

end

%% 8. Display results

fprintf('\nCRACK-SUPPRESSION INDICATOR\n');
fprintf('--------------------------------------------------\n');
fprintf('Homogeneous contact radius a       = %.4f mm\n', a_hom);
fprintf('Graded contact radius a            = %.4f mm\n', a_fgm_ref);
fprintf('Contact spreading ratio a_FGM/a_HOM= %.3f\n', contact_spreading_ratio);
fprintf('\n');
fprintf('Homogeneous maximum pressure p0    = %.2f GPa\n', p0_hom/1000);
fprintf('Graded maximum pressure p0         = %.2f GPa\n', p0_fgm_ref/1000);
fprintf('Pressure severity S_p              = %.3f\n', S_p_ref);
fprintf('Crack-suppression indicator I_cc   = %.3f\n', I_cc_ref);
fprintf('Pressure reduction                 = %.2f %%\n', pressure_reduction_percent);
fprintf('--------------------------------------------------\n\n');

%% 9. Save reference summary table

summary_table = table(P, k_ref, E0_ref, ...
    a_hom, a_fgm_ref, contact_spreading_ratio, ...
    h_hom, h_fgm_ref, ...
    p0_hom, p0_fgm_ref, p0_hom/1000, p0_fgm_ref/1000, ...
    S_p_ref, I_cc_ref, pressure_reduction_percent, ...
    'VariableNames', {'P_N', ...
                      'k_reference', ...
                      'E0_reference_GPa_mm_minus_k', ...
                      'a_hom_mm', ...
                      'a_fgm_mm', ...
                      'contact_spreading_ratio', ...
                      'h_hom_mm', ...
                      'h_fgm_mm', ...
                      'p0_hom_MPa', ...
                      'p0_fgm_MPa', ...
                      'p0_hom_GPa', ...
                      'p0_fgm_GPa', ...
                      'pressure_severity_index', ...
                      'crack_suppression_indicator', ...
                      'pressure_reduction_percent'});

writetable(summary_table, ...
    tables_folder + "table_11_crack_suppression_indicator_reference.csv");

%% 10. Save k-dependent data

k_table = table(k_values', a_k', p0_k', p0_k'/1000, S_p_k', I_cc_k', ...
    'VariableNames', {'k', ...
                      'a_mm', ...
                      'p0_MPa', ...
                      'p0_GPa', ...
                      'pressure_severity_index', ...
                      'crack_suppression_indicator'});

writetable(k_table, ...
    data_folder + "data_11_crack_suppression_vs_k.csv");

%% 11. Save E0-dependent data

E0_table = table(E0_values', a_E0', p0_E0', p0_E0'/1000, S_p_E0', I_cc_E0', ...
    'VariableNames', {'E0_GPa_mm_minus_k', ...
                      'a_mm', ...
                      'p0_MPa', ...
                      'p0_GPa', ...
                      'pressure_severity_index', ...
                      'crack_suppression_indicator'});

writetable(E0_table, ...
    data_folder + "data_11_crack_suppression_vs_E0.csv");

%% 12. Plot crack-suppression indicator vs k

fig1 = figure('Color', 'w');
set(fig1, 'Position', [100 100 1000 620]);

plot(k_values, I_cc_k, 'LineWidth', 3);
hold on;

yline(0, '--', 'No benefit threshold', ...
    'LineWidth', 1.6, ...
    'LabelHorizontalAlignment', 'left');

xline(k_ref, '--', sprintf('k_{ref} = %.3f', k_ref), ...
    'LineWidth', 1.6, ...
    'LabelOrientation', 'horizontal', ...
    'LabelVerticalAlignment', 'bottom');

scatter(k_ref, I_cc_ref, 90, 'filled');

xlabel('Grading exponent k [-]');
ylabel('Crack-suppression indicator I_{cc} = 1 - S_p [-]');
title('Effect of Grading Exponent k on Crack-Suppression Indicator');

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

exportgraphics(fig1, ...
    figures_folder + "fig_11a_crack_suppression_indicator_vs_k.png", ...
    'Resolution', 300);

%% 13. Plot crack-suppression indicator vs E0

fig2 = figure('Color', 'w');
set(fig2, 'Position', [100 100 1000 620]);

plot(E0_values, I_cc_E0, 'LineWidth', 3);
hold on;

yline(0, '--', 'No benefit threshold', ...
    'LineWidth', 1.6, ...
    'LabelHorizontalAlignment', 'left');

xline(E0_ref, '--', sprintf('E_{0,ref} = %.3f', E0_ref), ...
    'LineWidth', 1.6, ...
    'LabelOrientation', 'horizontal', ...
    'LabelVerticalAlignment', 'bottom');

scatter(E0_ref, I_cc_ref, 90, 'filled');

xlabel('Grading coefficient E_0 [GPa mm^{-k}]');
ylabel('Crack-suppression indicator I_{cc} = 1 - S_p [-]');
title('Effect of Grading Coefficient E_0 on Crack-Suppression Indicator');

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

exportgraphics(fig2, ...
    figures_folder + "fig_11b_crack_suppression_indicator_vs_E0.png", ...
    'Resolution', 300);

%% 14. Plot pressure severity vs crack-suppression indicator

fig3 = figure('Color', 'w');
set(fig3, 'Position', [100 100 1000 620]);

plot(S_p_k, I_cc_k, 'LineWidth', 3);
hold on;

scatter(S_p_ref, I_cc_ref, 90, 'filled');

xline(1, '--', 'S_p = 1', ...
    'LineWidth', 1.6, ...
    'LabelOrientation', 'horizontal');

yline(0, '--', 'I_{cc} = 0', ...
    'LineWidth', 1.6, ...
    'LabelHorizontalAlignment', 'left');

xlabel('Pressure severity index S_p = p_{0,FGM}/p_{0,HOM} [-]');
ylabel('Crack-suppression indicator I_{cc} = 1 - S_p [-]');
title('Relationship Between Contact Severity and Crack-Suppression Indicator');

apply_plot_style();

ax = gca;
ax.Toolbar.Visible = 'off';

exportgraphics(fig3, ...
    figures_folder + "fig_11c_severity_vs_crack_suppression_indicator.png", ...
    'Resolution', 300);

%% 15. Final message

fprintf('Saved:\n');
fprintf('- fig_11a_crack_suppression_indicator_vs_k.png\n');
fprintf('- fig_11b_crack_suppression_indicator_vs_E0.png\n');
fprintf('- fig_11c_severity_vs_crack_suppression_indicator.png\n');
fprintf('- table_11_crack_suppression_indicator_reference.csv\n');
fprintf('- data_11_crack_suppression_vs_k.csv\n');
fprintf('- data_11_crack_suppression_vs_E0.csv\n\n');