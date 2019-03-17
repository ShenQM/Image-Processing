%  Created by  Shen Quanmin on 2019/03/16.
%  Copyright ? 2019 Shen Quanmin. All rights reserved.
function [ F ] = estimateFundamentalMatrixNorm8Points(matchPoints1,matchPoints2)
% Estimate the fundamental matrix through two group of matched points.
% Reference: Richard Hartley etc. Multiple View Geometry in computer
% vision. Page 282: Algorithm 11.1: The normalized 8-point algorithm for F.
% Main algorithm steps:
% 1. Normalize the matched points separately.
% 2. Compose the matrix A according to x2'*F*x1=0. And solve this for
% Fnorm.
% 3. Get result F from Fnorm. Remember to norm the matrix F because of the
% norm of the two normalization matrix are not 1.

% matchPoints1 - input points in first image.
% matchPoints2 - input points in second image.
% F - output fundamental matrix for the two image.

% Created by  Shen Quanmin on 2019/03/16.

    
    %1.Normalize the coordinates.
    x1 = matchPoints1;
    x2 = matchPoints2;
    T1 = NormMatrix(x1);
    T2 = NormMatrix(x2);
    normX1 = (T1*[x1';ones(1,size(x1,1))])';
    normX2 = (T2*[x2';ones(1,size(x2,1))])';
    
    %2.Solve the Fundamental Matrix for normalized coordinates.
    A = [normX1(:,1).*normX2(:,1),normX1(:,2).*normX2(:,1),normX2(:,1),...
         normX1(:,1).*normX2(:,2),normX1(:,2).*normX2(:,2),normX2(:,2),...
                      normX1(:,1),             normX1(:,2),ones(size(normX1,1),1)];
   [U,S,V]=svd(A);
   Fnorm = V(:,end);
   Fnorm = reshape(Fnorm,3,3)';
   [Unorm, Snorm, Vnorm] = svd(Fnorm);
   Snorm(3,3) = 0;
   Fnorm = Unorm*Snorm*Vnorm';
   
   %3.Calculate the Fundamental Matrix for original coordinates.
   F = T2'*Fnorm*T1;
   F = F/norm(F); % For the norm of T1 and T2 are not eaqual to 1.
end

function [ T ] = NormMatrix(points)
    center = mean(points, 1);
    centeredPoints = [points(:,1)-center(1),points(:,2)-center(2)];
    rVec = centeredPoints.^2;
    rVec = mean(sqrt(rVec(:,1)+rVec(:,2)));
    s = sqrt(2)/rVec;
    T = [s, 0, -s*center(1);
         0, s, -s*center(2);
         0, 0,          1];
end