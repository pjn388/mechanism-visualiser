

frame_index = 1;

figure;
hold on;
% plot full end effector trajectory path
plot(positions(1, :), positions(2, :), 'k-', 'LineWidth', 0.5);

h_link1 = plot([0, 0], [0, 0], 'b-', 'LineWidth', 2);
h_link2 = plot([0, 0], [0, 0], 'r-', 'LineWidth', 2);
h_link3 = plot([0, 0], [0, 0], 'g-', 'LineWidth', 2);
h_joints = scatter([0,0,0,0], [0,0,0,0], 'k', 'filled');

while true
    O0 = [0; 0; 0];
    O1 = link1_positions(:, frame_index);
    O2 = link2_positions(:, frame_index);
    O3 = positions(:, frame_index);
    
    % draw the mechanism
    set(h_link1, 'XData', [O0(1), O1(1)], 'YData', [O0(2), O1(2)]);
    set(h_link2, 'XData', [O1(1), O2(1)], 'YData', [O1(2), O2(2)]);
    set(h_link3, 'XData', [O2(1), O3(1)], 'YData', [O2(2), O3(2)]);
    set(h_joints, 'XData', [O0(1), O1(1), O2(1), O3(1)], 'YData', [O0(2), O1(2), O2(2), O3(2)]);

    xlim([-1.5, 1.5]);
    ylim([-1.5, 1.5]);
    xlabel('X');
    ylabel('Y');
    axis equal;

    theta_1_current = rad2deg(theta_1_vals(frame_index));
    d_2_current = d_2_vals(frame_index);
    theta_3_current = rad2deg(theta_3_vals(frame_index));
    
    % put useful info in title to verify againts
    title_str = sprintf('Manipulator Visualization\nFrame: %d/%d, Time: %.2f\n\theta_1: %.2f, d_2: %.2f, \theta_3: %.2f', ...
        frame_index, length(time), time(frame_index), theta_1_current, d_2_current, theta_3_current);
    title(title_str);
    grid on;
    drawnow;

    % do keyboard input use left/right arrows to navigate frames
    w = waitforbuttonpress;
    if w == 1
        key = get(gcf,'CurrentCharacter');
        if key == char(29)
            frame_index = frame_index + 1;
        elseif key == char(28)
            frame_index = frame_index - 1;
        elseif key == 'q'
            break;
        end
    end

    set(gcf,'CurrentCharacter',char(0));

    if frame_index > length(time)
        frame_index = 1;
    elseif frame_index < 1
        frame_index = length(time);
    end
end

hold off;