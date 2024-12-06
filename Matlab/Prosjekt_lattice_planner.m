%% Lattice planer prosjekt
%clear, close all
%clc

% Laster inn kart
load occupancyGrid.mat; % elv er kart over elveutløp hvor hver pixel er ca. 1m
%% 
% Genererer lattice planner objekt
lp = Lattice(elvMap, 'grid', 20, 'root', [250,350], 'iterations', 29, 'cost', [1 50 50], 'inflate', 1);

lp.plan();

lp.plot();

%% 
p1 = lp.query([30,50,pi/2],[70,610,3*pi/2]);
p2 = lp.query([70,610,3*pi/2],[110,70,pi/2]);
% p3 = lp.query([110,70,pi/2],[150,650,3*pi/2]);
% p4 = lp.query([150,650,3*pi/2],[190,150,pi/2]);
% p5 = lp.query([190,150,pi/2],[230,650,3*pi/2]);
% p6 = lp.query([230,650,3*pi/2],[270,190,pi/2]);
% p7 = lp.query([30,50,pi/2],[70,610,3*pi/2]);
% p8 = lp.query([30,50,pi/2],[70,610,3*pi/2]);
% p9 = lp.query([30,50,pi/2],[70,610,3*pi/2]);
% p10 = lp.query([30,50,pi/2],[70,610,3*pi/2]);
% p11 = lp.query([30,50,pi/2],[70,610,3*pi/2]);
p = [p1];
lp.plot();

%% 