clc; clear;

run("units.m")
syms a_1 d_2 a_3 theta_1 theta_3 t

% Define the constants
a_1_val = 40*cm;
a_3_val = 20*cm;

% Define the joint equations
theta_1 = pi*sin(t);
d_2 = 20*cm * sin(2 * t) + + 30*cm;
theta_3 = pi*(1 - sin(t));

% Define the DH table (symbolic)
DH_table_sym = [
    a_1_val, 0, -pi/2, theta_1;
    0, d_2, pi/2, 0;
    a_3_val, 0, 0, theta_3
];

% Number of frames
num_frames = 501;
time = linspace(0, 5, num_frames);

% Function to compute the transformation matrix
function T = dh_to_transformation(a, d, alpha, theta)
    T = [
        cos(theta), -sin(theta)*cos(alpha), sin(theta)*sin(alpha), a*cos(theta);
        sin(theta), cos(theta)*cos(alpha), -cos(theta)*sin(alpha), a*sin(theta);
        0, sin(alpha), cos(alpha), d;
        0, 0, 0, 1
    ];
end

% Precompute positions and orientation angles for each frame
positions = zeros(3, num_frames);
link1_positions = zeros(3, num_frames);
link2_positions = zeros(3, num_frames);
phi = zeros(1, num_frames);

T_matrices = cell(num_frames, 3);
theta_1_vals = zeros(1, num_frames);
d_2_vals = zeros(1, num_frames);
theta_3_vals = zeros(1, num_frames);

for i = 1:num_frames
    theta_1_current = double(subs(theta_1, t, time(i)));
    d_2_current = double(subs(d_2, t, time(i)));
    theta_3_current = double(subs(theta_3, t, time(i)));

    theta_1_vals(i) = theta_1_current;
    d_2_vals(i) = d_2_current;
    theta_3_vals(i) = theta_3_current;

    % Create the DH table with current values
    DH_table = [
        a_1_val, 0, -pi/2, theta_1_current;
        0, d_2_current, pi/2, 0;
        a_3_val, 0, 0, theta_3_current
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
end


phi = zeros(1, num_frames);
phi(1) = rad2deg(atan2(T_matrices{1, 3}(2, 1), T_matrices{1, 3}(1, 1)));

for i = 2:num_frames
    phi(i) = rad2deg(atan2(T_matrices{i, 3}(2, 1), T_matrices{i, 3}(1, 1)));

    % Unwrap the phase to avoid jumps
    delta_phi = phi(i) - phi(i-1);
    if delta_phi > 180
        phi(i) = phi(i) - 360;
    elseif delta_phi < -180
        phi(i) = phi(i) + 360;
    end
end


% Plot A: Trajectory of point (x E, yE) (cm) from 0 to 5 seconds
figure;
plot(positions(1, :), positions(2, :), 'LineWidth', 2);
title('Trajectory of End-Effector (x_E, y_E)');
xlabel('x_E (m)');
ylabel('y_E (m)');
axis equal;
grid on;

% Plot B: Orientation angle phi versus time
% This is a good trick question as...
    % in this case phi = theta_1 + theta_3 = pi*sin(t) + pi*(1 - sin(t)) = pi*(sin(t) + 1 - sin(t)) = pi = 180 deg
    % very clever u had me questioning myself
figure;
plot(time, phi, 'LineWidth', 2);
title('Orientation Angle \phi versus Time');
xlabel('Time (s)');
ylabel('\phi (degrees)');
grid on;

run("visualiser.m");