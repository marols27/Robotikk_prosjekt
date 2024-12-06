%% Kode generert av chatGPT og justert for å oppnå ønsket resultat
% Les og bearbeid bildet
filename = 'Skjermbilde2.jpg'; % Endre dette til filnavnet på bildet ditt
img = imread(filename);

% Få størrelse på bildet
[height, width, ~] = size(img);

% Angi ny høyde og beregn bredde for å bevare sideforholdet
newHeight = 700;
newWidth = round((newHeight / height) * width);

% Endre størrelse på bildet
resizedImg = imresize(img, [newHeight, newWidth]);

% Separere fargekanaler
redChannel = resizedImg(:,:,1);
greenChannel = resizedImg(:,:,2);
blueChannel = resizedImg(:,:,3);

% Definere terskler for å finne vann
% F.eks. vann vil ha høyere blå verdi og lavere rød og grønn verdi
waterMask = blueChannel > 230 & redChannel < 150 & greenChannel < 220;

% Oppretter et binært occupancy grid, hvor 0 = vann og 1 = land
binaryImg = waterMask;

% Converterer til double
elvMap = ~binaryImg; % double(binaryImg);

% Vis det bildet
figure;
imshow(resizedImg);
title('Image');

% Vis det binære bildet (occupancy grid)
figure;
imshow(binaryImg);
title('Occupancy Grid');

% Lagre binaryImg som et occupancy grid
save('occupancyGrid.mat', 'elvMap');

disp('Occupancy grid saved to occupancyGrid.mat');