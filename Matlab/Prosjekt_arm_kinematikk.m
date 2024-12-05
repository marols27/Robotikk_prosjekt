%% ELE306 arm kinematikk

import ETS3.*

% Setting up the environment: you have to define YOUR ros domain id 
setenv("ROS_DOMAIN_ID", "30")

% Setting up the environment: you have to define YOUR ros domain id 
rosDomainID = 30;

% Initializing a ros node
rosNode = ros2node("/prosjekt_planner_node", rosDomainID);

%%
pause(3);

% Creating a publisher
jointPub = ros2publisher(rosNode, "/arm_controller/joint_trajectory", "trajectory_msgs/JointTrajectory");
jointMsg = ros2message(jointPub);
joints = {'arm_base_joint' 'arm_1_joint' 'arm_2_joint' 'wrist_joint_joint' 'gripper_joint'};
jointMsg.joint_names = joints;

% Creating a subscriber
% jointStateSub = ros2subscriber(rosNode, "/arm_controller/state", "control_msgs/JointTrajectoryControllerState");
% jointStateMsg = ros2message(jointStateSub);

%%

syms q1 q2 q3 q4 q5

L(1) = Link('revolute', 'd', 0.2, 'a', 0, 'alpha', pi/2);
L(2) = Link('revolute', 'd', 0, 'a', 0.5, 'alpha', 0);
L(3) = Link('revolute', 'd', 0, 'a', 0.5, 'alpha', 0);
L(4) = Link('revolute', 'd', 0, 'a', 0, 'alpha', pi/2);
L(5) = Link('revolute', 'd', 0.2, 'a', 0, 'alpha', 0);
robot = SerialLink(L,'name', 'robot manipulator');
robot.qlim = [-pi, pi; 0, pi/2; -pi/2, pi/2; 0, pi; -pi, pi];

%%

% robot.fkine([q1 q2 q3 q4 q5])
% tr = [1 0 0 0.1; 0 1 0 0.3; 0 0 1 0.2; 0 0 0 1];
tr = SE3(0.6, 0.0, 0.2)*SE3.Rz(0, 'deg')*SE3.Ry(0, 'deg')*SE3.Rx(180, 'deg')
q = robot.ikine(tr, 'mask', [1 1 1 0 1 1])
% robot.teach
robot.plot(q)

%%
currentPositions = [0 0 0 0 0];

%%
% [jointStates, status, statustext] = receive(jointStateSub, 10);
% jointStates
newPositions = [0 0 0 0 0];
for i = 1:5
    if (newPositions(i) ~= currentPositions(i))
        for j = currentPositions(i):pi/8:newPositions(i)
            jointMsg.points.positions = currentPositions;
            jointMsg.points.positions(i) = j;
            jointMsg.points.velocities = [0.01 0.01 0.01 0.01 0.01];
            jointMsg.points.accelerations = [0.01 0.01 0.01 0.01 0.01];
            jointMsg.points.effort = [0.01 0.01 0.01 0.01 0.01];
            jointMsg.points.time_from_start.sec = int32(5);
            send(jointPub, jointMsg);
            pause(1);
            currentPositions(i) = j;
        end
    end
end

