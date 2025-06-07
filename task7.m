clc; clear;

run("units.m")

% symbolic definitions
syms theta_1 theta_3 phi x_b y_b a_1 a_3 d_2
sym_d_2 = sqrt(x_b^2+y_b^2-a_1^2);
sym_theta_1 = atan2((a_1*y_b - d_2*x_b)/(d_2^2 + a_1^2),(d_2*y_b + a_1*x_b)/(a_1^2 + d_2^2));
sym_theta_3 = phi - atan2(a_1*y_b - d_2*x_b, d_2*y_b + a_1*x_b);

% Define constants
a_1_val = 40*cm; % 40 cm
a_3_val = 20*cm; % 20 cm
phi_val = deg2rad(60); % 60deg

% define start and end points
x_1_val = 0;
x_2_val = 120*cm;

y_1_val = 120*cm;
y_2_val = 0;

% Preallocate arrays for joint variables
theta_1_vals = zeros(1, 121);
d_2_vals = zeros(1, 121);
theta_3_vals = zeros(1, 121);

% calculate x and y pos for end effector
x_vals = linspace(x_1_val, x_2_val, 121);
y_vals = linspace(y_1_val, y_2_val, 121);

for i = 1:length(x_vals)

    keys = {x_b, y_b, phi, a_1, a_3};
    values = {x_vals(i), y_vals(i), phi_val, a_1_val, a_3_val};


    d_2_vals(i) = double(subs(sym_d_2, keys, values));
    keys = {keys{:}, d_2};
    values = {values{:}, d_2_vals(i)};

    theta_1_vals(i) = double(subs(sym_theta_1, keys, values));
    theta_3_vals(i) = double(subs(sym_theta_3, keys, values));
end

% Plot C: θ1 and θ3 (degrees) versus x (cm)
figure;
plot(x_vals, rad2deg(theta_1_vals), 'b-', 'DisplayName', '\theta_1');
hold on;
plot(x_vals, rad2deg(theta_3_vals), 'r-', 'DisplayName', '\theta_3');
hold off;
xlabel('x (m)');
ylabel('Angle (degrees)');
title('\theta_1 and \theta_3 vs x');
legend('Location', 'NorthEast');
grid on;

% Plot D: d2 (cm) versus x (cm)
figure;
plot(x_vals, d_2_vals, 'g-');
xlabel('x (m)');
ylabel('d_2 (m)');
title('d_2 vs x');
grid on;

save('task7_results.mat', 'theta_1_vals', 'd_2_vals', 'theta_3_vals');
