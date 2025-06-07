# mechanism-visualiser

This document provides a brief overview of the files included in this submission and instructions for running the code.

## Files Included
- `task6.m`: Generates trajectory and orientation plots for a 3-link manipulator with time-varying joint angles. It also calls the visualiser.
- `task7.m`: Calculates inverse kinematics for a 3-link manipulator to follow a straight-line path, and generates plots of joint variables vs. x position.
- `visualiser.m`: Visualizes the manipulator's movement based on joint positions. Requires `positions`, `link1_positions`, `link2_positions`, `theta_1_vals`, `d_2_vals`, `theta_3_vals` and `time` to be in the workspace.
- `tester.m`:  Verifies the inverse kinematics calculated in `task7.m` by computing the forward kinematics and visualizing the results.
- `units.m`: Defines unit conversions (cm to meters).
- `task7_results.mat`: Contains results from task7.m used by other files.
- `kinematic_results.mat`: Contains results from tester.m used by other files.
## Instructions

1.  Ensure that all `.m` files are in the same directory.
2.  Run `task6.m` to generate trajectory plots and visualize the arm motion. Data needed for the visualisation is generated inside the file.
3.  Run `task7.m` to calculate inverse kinematics and generate joint variable plots.  This will also save `task7_results.mat`.
4.  Run `tester.m` to verify inverse kinematics and visualize the arm motion. This script loads 'task7_results.mat', computes forward kinematics, generates a plot of orientation angle vs x, saves  `kinematic_results.mat` and visualizes the results.

## Dependencies

-   MATLAB

## Donations

* monero:83B495T1N3sje9vXMqNShbSx99g1QjKyL8YKjvU6rt6hAkmwbVUrQ65QGEUsL3QxVPdtiK91GnCP7bG2oCz7h1PDKsoCPB1
* ![monero:83B495T1N3sje9vXMqNShbSx99g1QjKyL8YKjvU6rt6hAkmwbVUrQ65QGEUsL3QxVPdtiK91GnCP7bG2oCz7h1PDKsoCPB1](https://raw.githubusercontent.com/pjn388/mechanism-visualiser/refs/heads/main/images/uni_recieve.png?raw=true)
