% Kernel shape
% nearest kernel
nn_kernel_x = -2:0.01:2;
nn_kernel_y = ones(size(nn_kernel_x));
nn_kernel_y(abs(nn_kernel_x ) > 0.5) = 0;

% linear kernel
linear_x_neg = -2:0.01:0;
linear_y_neg = linear_x_neg + 1;
linear_x_pos = 0.01:0.01:2;
linear_y_pos = 1 - linear_x_pos;
linear_x = [linear_x_neg, linear_x_pos];
linear_y = [linear_y_neg, linear_y_pos];
linear_y(abs(linear_x) > 1) = 0;

% cubic convolution kernel
cubic_conv_x = -2:0.01:2;
cubic_conv_y = cubic_kernel(abs(cubic_conv_x));

figure('Name', 'Interpolation kernels');
subplot(2,2,1);
plot(nn_kernel_x, nn_kernel_y);
ylim([0,1.5]);
title('Nearest-neighbor');
subplot(2,2,2);
plot(linear_x, linear_y);
ylim([0,1.5]);
title('Linear interpolation');
subplot(2,2,3);
plot(cubic_conv_x, cubic_conv_y);
ylim([-0.2,1.5]);
title('Cubic convolution');

% Frequence response
figure('Name', 'Kernel response');
u = 0:0.01:2;
nn_response = abs(sinc(u));
% linear_response = (1 - cos(2*pi*u)) ./ (2*(pi*u).^2);
linear_response = abs(sinc(u).^2);
f0 = 3*(sinc(u).^2 - sinc(2*u))./(pi*u).^2;
f1 = 2*(3*sinc(2*u).^2 - 2*sinc(2*u) - sinc(4*u)) ./ (pi*u).^2;
a = -0.5;
cubic_conv_response = abs(f0 + a*f1);
ideal_x = 0:0.01:0.5;
ideal_y = ones(size(ideal_x));
ideal_yy = 0:0.01:1;
ideal_xx = ones(size(ideal_yy))*0.5;
plot(u, nn_response, u, linear_response, u, cubic_conv_response, ideal_x, ideal_y,'r--', ideal_xx, ideal_yy,'r--');
ylim([0,1.1]);
%plot(u, abs(linear_response));
legend('nearest neighbor', 'linear interpolation', 'cubic convolution','ideal');