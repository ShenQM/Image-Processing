nn_kernel_x = -0.5:0.01:0.5;
nn_kernel_y = ones(size(nn_kernel_x));
L = size(nn_kernel_y,2);
Y = fft(nn_kernel_y);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
Fs = 100;
f = Fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')