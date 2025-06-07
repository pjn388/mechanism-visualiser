clc; clear;

run("units.m")

% Define constants
a_1_val = 40*cm;
a_3_val = 20*cm;
phi_val = deg2rad(60);

% define start and end points
x_1_val = 0;
x_2_val = 120*cm;

y_1_val = 120*cm;
y_2_val = 0;

% calculate x and y pos for end effector
x_vals = linspace(x_1_val, x_2_val, 121);
y_vals = linspace(y_1_val, y_2_val, 121);

% Load pre-calculated joint variables (assuming task7.m has been run)
load('task7_results.mat', 'theta_1_vals', 'd_2_vals', 'theta_3_vals');

% Function to compute the transformation matrix
function T = dh_to_transformation(a, d, alpha, theta)
    T = [
        cos(theta), -sin(theta)*cos(alpha), sin(theta)*sin(alpha), a*cos(theta);
        sin(theta), cos(theta)*cos(alpha), -cos(theta)*sin(alpha), a*sin(theta);
        0, sin(alpha), cos(alpha), d;
        0, 0, 0, 1
    ];
end

num_frames = length(theta_1_vals);
positions = zeros(3, num_frames);
link1_positions = zeros(3, num_frames);
link2_positions = zeros(3, num_frames);
phi_vals = zeros(1, num_frames);
T_matrices = cell(num_frames, 3);

for i = 1:num_frames
    DH_table = [
        a_1_val, 0, -pi/2, theta_1_vals(i);
        0, d_2_vals(i), pi/2, 0;
        a_3_val, 0, 0, theta_3_vals(i)
    ];

    % Compute transformation matrices
    T0 = eye(4);
    T1 = T0 * dh_to_transformation(DH_table(1,1), DH_table(1,2), DH_table(1,3), DH_table(1,4));
    T2 = T1 * dh_to_transformation(DH_table(2,1), DH_table(2,2), DH_table(2,3), DH_table(2,4));
    T3 = T2 * dh_to_transformation(DH_table(3,1), DH_table(3,2), DH_table(3,3), DH_table(3,4));

    T_matrices{i, 1} = T1;
    T_matrices{i, 2} = T2;
    T_matrices{i, 3} = T3;

    positions(:, i) = T3(1:3, 4);
    link1_positions(:, i) = T1(1:3, 4);
    link2_positions(:, i) = T2(1:3, 4);

    phi_vals(i) = rad2deg(atan2(T3(2, 1), T3(1, 1)));
end

% Plot B: Orientation angle phi versus x
figure;
plot(x_vals, phi_vals, 'LineWidth', 2);
title('Orientation Angle \phi versus x');
xlabel('x (cm)');
ylabel('\phi (degrees)');
grid on;

% Save the results (optional, for use in visualiser.m)
save('kinematic_results.mat', 'positions', 'link1_positions', 'link2_positions');

% Run the visualiser (assuming it uses 'positions', 'link1_positions', 'link2_positions')
time = 1:num_frames;
run("visualiser.m");