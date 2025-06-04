% Load data
data = readtable('SED_Bishop_572m_9.xlsx');

% Extract the first column (SED in mm)
SED = data{:,1};

% Basic histogram
figure;
histogram(SED, 'BinWidth', 0.1, 'FaceColor', [0.3 0.6 0.8], 'EdgeColor', 'none');
xlabel('Spherical Equivalent Diameter (mm)');
ylabel('Frequency');
set(gca, 'FontSize', 12, 'Box', 'off');

% Log-scale histogram
figure;
% Filter out non-positive values
SED_pos = SED(SED > 0);
histogram(SED_pos, 'BinEdges', logspace(log10(min(SED_pos)), log10(max(SED_pos)), 30), ...
    'FaceColor', [0.2 0.5 0.7], 'EdgeColor', 'none');
set(gca, 'XScale', 'log');
xlabel('Spherical Equivalent Diameter (mm, log scale)');
ylabel('Frequency');
set(gca, 'FontSize', 12, 'Box', 'off');

% CDF plot
figure;
% Sort SED values and remove NaNs
SED_sorted = sort(SED(~isnan(SED)));
n = numel(SED_sorted);
cdf_vals = (1:n) / n;

plot(SED_sorted, cdf_vals, 'LineWidth', 2, 'Color', [0.1 0.4 0.7]);
xlabel('Spherical Equivalent Diameter (mm)');
ylabel('Cumulative Probability');
ylim([0 1]);
grid on;
set(gca, 'FontSize', 12, 'Box', 'off');
title('CDF of SED');

% Population density histogram (linear scale)
figure;
histogram(SED, 'BinWidth', 0.1, ...
    'Normalization', 'pdf', ...  % This normalizes the histogram to probability density
    'FaceColor', [0.5 0.2 0.6], ...
    'EdgeColor', 'none');
xlabel('Spherical Equivalent Diameter (mm)');
ylabel('Probability Density');
set(gca, 'FontSize', 12, 'Box', 'off');
title('Population Density Histogram (Linear Scale)');

% Population density histogram (log scale)
figure;
histogram(SED_pos, ...
    'BinEdges', logspace(log10(min(SED_pos)), log10(max(SED_pos)), 30), ...
    'Normalization', 'pdf', ...
    'FaceColor', [0.4 0.3 0.8], ...
    'EdgeColor', 'none');
set(gca, 'XScale', 'log');
xlabel('Spherical Equivalent Diameter (mm, log scale)');
ylabel('Probability Density');
set(gca, 'FontSize', 12, 'Box', 'off');
title('Population Density Histogram (Log Scale)');

% === Overlay new SED data on log-scale PDF histogram ===

% Load new data from CSV
newData = readtable('Bishop_SED_318_10.xlsx');

% Extract the grain sizes
new_SED = newData{:,1};

% Filter out non-positive values
new_SED_pos = new_SED(new_SED > 0);

% Use the same bin edges as before (based on combined range)
all_SED = [SED_pos; new_SED_pos];
binEdges = logspace(log10(min(all_SED)), log10(max(all_SED)), 30);

% Plot original histogram
figure;
histogram(SED_pos, ...
    'BinEdges', binEdges, ...
    'Normalization', 'pdf', ...
    'FaceColor', [0.4 0.3 0.8], ...
    'EdgeColor', 'none', ...
    'FaceAlpha', 0.6);  % transparent
hold on;

% Overlay new histogram
histogram(new_SED_pos, ...
    'BinEdges', binEdges, ...
    'Normalization', 'pdf', ...
    'FaceColor', [0.9 0.3 0.2], ...
    'EdgeColor', 'none', ...
    'FaceAlpha', 0.6);  % transparent

% Formatting
set(gca, 'XScale', 'log');
xlabel('Spherical Equivalent Diameter (mm, log scale)');
ylabel('Probability Density');
legend('Original Data', 'New SED Data');
set(gca, 'FontSize', 12, 'Box', 'off');
title('Overlayed PDF Histograms (Log Scale)');

% Load volume data (no conversion needed)
volData = readtable('AB-XX02-4.5um-Pamukcu2010-SED.xlsx');

% Extract columns 1 and 3
vol1 = volData{:,1};
vol3 = volData{:,2};

% Filter out non-positive entries
vol1_pos = vol1(vol1 > 0);
vol3_pos = vol3(vol3 > 0);

% Combine to get shared bin edges
all_vol = [vol1_pos; vol3_pos];
binEdges = logspace(log10(min(all_vol)), log10(max(all_vol)), 30);

% Plot first volume histogram
figure;
histogram(vol1_pos, ...
    'BinEdges', binEdges, ...
    'Normalization', 'pdf', ...
    'FaceColor', [0.3 0.6 0.8], ...
    'EdgeColor', 'none', ...
    'FaceAlpha', 0.6);  % transparency
hold on;

% Plot second volume histogram
histogram(vol3_pos, ...
    'BinEdges', binEdges, ...
    'Normalization', 'pdf', ...
    'FaceColor', [0.9 0.4 0.3], ...
    'EdgeColor', 'none', ...
    'FaceAlpha', 0.6);  % transparency

% Formatting
set(gca, 'YScale', 'log');
xlabel('Spherical Equivalent Diameter (log scale, mm)');
ylabel('Probability Density');
legend('Ward et al. U-Net', 'Pamukcu & Gualda (2010) Blob 3D');
set(gca, 'FontSize', 22, 'Box', 'off');


