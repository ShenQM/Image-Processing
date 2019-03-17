%  Created by  Shen Quanmin on 2019/03/17.
%  Copyright ? 2019 Shen Quanmin. All rights reserved.
function [F, inlierIndex, n] = estimateFundamentalMatrixRANSAC(matchPoints1,matchPoints2,varargin)
%ESTIMATE FUNDAMENTAL MATRIX RANSAC: Estimate fundamental matrix through
%RANSAC method. 
%Reference: 
% 1.Richard Hartley etc. Multiple View Geometry in computer.
% 2.Matlab implementation document of estimateFundamentalMatrix.

% Input:
% matchPoints1 - input points in first image.
% matchPoints2 - input points in second image.
% option:
% confidence - the confidence that we find a sample with all points are
% inliers.
% maxIter - input max iteration number. If not set, we will calculate one.
% inlierPercentage - inlier match percentage.
% distanceThreshold - distance threshold to judge outliers.
% Output:
% F - output fundamental matrix for the two image.
% inlierIndex - inlier of matched points.

% Created by  Shen Quanmin on 2019/03/17.

    matchPointsNum = size(matchPoints1,1);
    n = 0;
    t = 0.01;
    p = 0.99;
    r = 0.5;
    Nmax = 500;
    
    opt_num = nargin - 2;
    if opt_num > 0
        for i = 1:opt_num-1
            name = varargin{i}; 
            value = varargin{i+1};
            if strcmp(name, 'confidence')
                p = value;
            elseif strcmp(name, 'maxIter')
                Nmax = value;
            elseif strcmp(name, 'inlierPercentage')
                r = value;
            elseif strcmp(name, 'distanceThreshold')
                t = value;
            else
                disp(['Unknow parameter name: ', name]);
            end
        end
    end
    
    N = min(Nmax,log(1-p)/log(1-r^8));
    F = zeros(3,3);
    inlierIndex = zeros(matchPointsNum,1);
    
    inlierNum = 0;
    
    %1.Normalize the coordinates.
    x1 = matchPoints1;
    x2 = matchPoints2;
    T1 = NormMatrix(x1);
    T2 = NormMatrix(x2);
    normX1 = (T1*[x1';ones(1,size(x1,1))])';
    normX2 = (T2*[x2';ones(1,size(x2,1))])';
    
    while n < N
        n = n+1;
        index = randperm(matchPointsNum,8);
        Ftemp = estimateFundamentalMatrixNorm8Points(normX1(index,1:2),normX2(index,1:2));
        %dist = diag(normX2*Ftemp*normX1').^2;
        dist = sampsonDistance(normX1, Ftemp, normX2);
        inlierIndexTemp = (dist < t);
        inlierNumTemp = sum(inlierIndexTemp);
        if inlierNumTemp > inlierNum
            inlierNum = inlierNumTemp;
            inlierIndex = inlierIndexTemp;
            r = inlierNumTemp/matchPointsNum;
            NTemp = log(1-p)/log(1-r^8);
            N = min(N, NTemp);
        end
    end
    
   %3.Calculate the Fundamental Matrix for original coordinates.
   F = estimateFundamentalMatrixNorm8Points(normX1(inlierIndex,1:2),normX2(inlierIndex,1:2));
   F = T2'*F*T1;
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

function [ dist ] = sampsonDistance(x1, F, x2)
    dist = diag(x2*F*x1').^2;
    Fx1 = F*x1';
    Ftx2 = F'*x2';
    nominator = Fx1(1,:).^2 + Fx1(2,:).^2 + Ftx2(1,:).^2 + Ftx2(2,:).^2;
    dist = dist(:) ./ nominator(:);
end