%% Moving to a pose controller
clear, close all
clc

%%
pos = [0 0 0];
p = [];
setPos = [5 5 0];
maxv = 1;
maxw = pi/4;
dt = 0.1;

%%
% Create a figure and plot the initial position
figure;
plot = plot(pos(1), pos(2), 'ro', 'MarkerSize', 2, 'MarkerFaceColor', 'r');
xlim([-10 10]);
ylim([-10 10]);
axis equal;
title('Moving to a Pose');
xlabel('X');
ylabel('Y');
hold on;

pause(10)

%%
fremme = false;
while not(fremme)
    % henter posisjon
    theta = setPos(3);

    % setter variabler
    kalpha = 4;
    kbeta = -2;
    krho = 1;

    % convert to polar cordinates
    dx = pos(1) - setPos(1);
    dy = pos(2) - setPos(2);
    rho = sqrt(dx^2 + dy^2);
    alpha = -atan2(-dy, -dx) - pos(3);
    beta = -pos(3) - alpha;
    dir = 1;

    if (beta > pi/2) || (beta < -pi/2)
        dir = -1;
    end
    if beta > pi/2
        beta = pi/2;
    end
    if beta < -pi/2
        beta = -pi/2;
    end
    if dir == -1
        alpha = -atan2(dy, dx);
        beta = -pos(3) - alpha;
    else
        alpha = -atan2(-dy, -dx);
        beta = -pos(3) - alpha;
    end

    v = krho * rho * dir;
    w = (kalpha * beta + kbeta * alpha) / v;
    v = min(v, maxv);
    v = max(v, -maxv);
    w = min(w, maxw);
    w = max(w, -maxw);

    % Calculate the velocity components in the x and y directions
    vx = v * cos(pos(3));
    vy = v * sin(pos(3));

    % Update position
    pos = pos + [vx vy w] * dt;
    p = [p; pos];
    
    % Update plot
    set(plot, 'XData', p(:,1), 'YData', p(:, 2));
    drawnow;

    % sjekker om fremme
    fremme = rho <= 0.01;

    pause(dt)
end


