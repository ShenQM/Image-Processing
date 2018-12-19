xy=[0 0; 1 0; 0.5 0.866];
col=[1 0 0; 0 1 0; 0 0 1];
patch('Vertices',xy, 'Faces',[1:size(xy,1)],...
'EdgeColor','none','FaceVertexCData',...
col,'FaceColor','interp');
axis off

figure(2)
red = [30.24 17.30 2.03];
green = [30.19 61.00 10.81];
blue = [18.62 8.99 100.82];
white = [77.00 85.40 108.72];
w = [1 1 1];
r = [1 0 0];
g = [0 1 0];
b = [0 0 1];
k = [0 0 0];
rxy = [red(1)/sum(red) red(2)/sum(red) red(2)];
gxy = [green(1)/sum(green) green(2)/sum(green) green(2)];
bxy = [blue(1)/sum(blue) blue(2)/sum(blue) blue(2)];
wxy = [white(1)/sum(white) white(2)/sum(white) white(2)];
kxy = [white(1)/sum(white) white(2)/sum(white) 0];
v = [rxy; gxy; bxy; wxy; kxy];
c = [r; g; b; w; k];
f = [1 2 4; 1 2 5; 1 3 4; 1 3 5; 2 3 4; 2 3 5];
patch('Vertices',v, 'Faces',f, 'EdgeColor','none',...
'FaceVertexCData',c,'FaceColor','interp')