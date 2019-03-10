clear;
close all;

%Example 1: Rosenbrock's Valley
rosen = @(x) [10*(x(2)-x(1)^2)
                     1-x(1)];
rosen_jac = @(x) [-20*x(1), 10;
                        -1,  0];
x0 = [1.2; -0.8];                    
maxiter = 100;
tao = 0.001;
ks1 = 1e-7; 
ks2 = 1e-7;
%[x_res, x_iter, f_iter, cnt] = lmlsq(rosen, rosen_jac, x0, maxiter, tao, ks1, ks2);
[x_res, x_iter, f_iter, cnt] = lmlsq(rosen, x0); %without analyze jacobian
%[x_res, x_iter, f_iter, cnt] = lmlsq(rosen, x0, 'jacobian', rosen_jac);

x = -2:0.01:2;
y = -1:0.01:3;
[X,Y] = meshgrid(x,y);
Z = zeros(size(X));
for i = 1:size(x,2)
    for j = 1:size(y,2)
        f = feval(rosen, [x(i),y(j)]);
        Z(i,j) = 0.5*(f'*f);
    end
end
contour(X,Y,Z);
rosen_val = sum(f_iter.^2,1);
hold on;
plot(x_iter(1,1:cnt),x_iter(2,1:cnt),'ro-');