%% ELE306 arm kinematikk

import ETS3.*
syms q1 q2 q3 q4 q5

L(1) = Link('revolute', 'd', 0.2, 'a', 0, 'alpha', pi/2);
L(2) = Link('revolute', 'd', 0, 'a', 0.5, 'alpha', 0, 'offset', pi/2);
L(3) = Link('revolute', 'd', 0, 'a', 0.5, 'alpha', 0);
L(4) = Link('revolute', 'd', 0, 'a', 0, 'alpha', pi/2, 'offset', pi/2);
L(5) = Link('revolute', 'd', 0.2, 'a', 0, 'alpha', 0);
robot = SerialLink(L,'name', 'robot manipulator');
robot.qlim = [-pi, pi; 0, pi/2; -pi/2, pi/2; 0, pi; -pi, pi];

%%

% robot.fkine([q1 q2 q3 q4 q5])
% tr = [1 0 0 0.1; 0 1 0 0.3; 0 0 1 0.2; 0 0 0 1];
t = [0:0.05:2]';
t1 = SE3(0.4, -0.4, 0.2);
t2 = SE3(1.0, 0.4, 0.2);
q1 = robot.ikine(t1, 'mask', [1 1 1 0 0 0]);
% robot.teach
robot.plot(q1)
pause(5)
q2 = robot.jtraj(t1, t2, t, 'mask', [1 1 1 0 0 0]);
% plot(t, q);
robot.plot(q2)


