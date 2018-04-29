function [ kernel_res ] = cubic_kernel( s )
    kernel_res = zeros(size(s));
    kernel_res(abs(s)<eps) = 1;
    kernel_res(abs(s-1)<eps) = 0;
    kernel_res(abs(s-2)<eps) = 0;
    kernel_res((s>0 & s < 1)) = kernel_0_1(s(s>0 & s < 1));
    kernel_res((s>1 & s < 2)) = kernel_1_2(s(s>1 & s < 2));
end

function [ kernel_res ] = kernel_0_1( s )
    s2 = s.*s;
    s3 = s2.*s;
    kernel_res = 1.5*s3 - 2.5*s2 + 1;
end

function [ kernel_res ] = kernel_1_2( s )
    s2 = s.*s;
    s3 = s2.*s;
    kernel_res = -0.5*s3 + 2.5*s2 - 4*s + 2;
end
