%% Moving to a pose controller
clear, close all
clc

%%
% Setting up the environment: you have to define YOUR ros domain id 
setenv("ROS_DOMAIN_ID", "30")

% Setting up the environment: you have to define YOUR ros domain id 
rosDomainID = 30;

% Initializing a ros node
rosNode = ros2node("/prosjekt_planner_node", rosDomainID);

%%
pause(3);

% Creating a publisher
cmdVelPub = ros2publisher(rosNode, "/cmd_vel", "geometry_msgs/Twist");

pause(3)
% Creating subscriber 
odomSub = ros2subscriber(rosNode, "/odom", "nav_msgs/Odometry");


%%
pause(3);

% Defining the message type for the publisher
cmdMsg = ros2message(cmdVelPub);

%%
setPos = [10 10 0]; % p(1,:);

%
fremme = false;
while not(fremme)
    fremme = true;
    % henter posisjon
    [poseData, status, statustext] = receive(odomSub, 1);
    [yaw, pitch, roll] = quat2angle([poseData.pose.pose.orientation.w poseData.pose.pose.orientation.x poseData.pose.pose.orientation.y poseData.pose.pose.orientation.z]);
    pose(1) = poseData.pose.pose.position.x;
    pose(2) = poseData.pose.pose.position.y;
    pose(3) = yaw;
    pose;
    theta = setPos(3);

    % setter variabler
    kalpha = 4;
    kbeta = -2;
    krho = 1;
    maxv = 1;
    maxw = pi/4;

    % convert to polar cordinates
    dx = pose(1) - setPos(1);
    dy = pose(2) - setPos(2);
    rho = sqrt(dx^2 + dy^2);
    alpha = -atan2(-dy, -dx) - yaw;
    beta = -yaw - alpha;
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
        beta = -yaw - alpha;
    else
        alpha = -atan2(-dy, -dx);
        beta = -yaw - alpha;
    end

    v = krho * rho * dir;
    w = (kalpha * beta + kbeta * alpha) / v;
    v = min(v, maxv);
    v = max(v, -maxv);
    w = min(w, maxw);
    w = max(w, -maxw);

    cmdMsg.linear.x = v;
    cmdMsg.angular.z = w;
    send(cmdVelPub, cmdMsg);

    % sjekker om fremme
    fremme = rho < 1;
end

cmdMsg.linear.x = 0;
cmdMsg.angular.z = 0;
send(cmdVelPub, cmdMsg);

%%
cmdMsg.linear.x = 0;
cmdMsg.angular.z = 0;
send(cmdVelPub, cmdMsg);



