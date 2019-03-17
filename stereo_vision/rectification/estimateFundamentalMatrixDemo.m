close all;

file1 = '../../data/stereo_vision/img1.png';
file2 = '../../data/stereo_vision/img2.png';

img1 = rgb2gray(imread(file1));
img2 = rgb2gray(imread(file2));

points1 = detectSURFFeatures(img1);
points2 = detectSURFFeatures(img2);

[features1, validPoints1] = extractFeatures(img1, points1);
[features2, validPoints2] = extractFeatures(img2, points2);

indexPairs = matchFeatures(features1,features2);
matchedPoints1 = validPoints1(indexPairs(:,1),:);
matchedPoints2 = validPoints2(indexPairs(:,2),:);

figure; showMatchedFeatures(img1,img2,matchedPoints1,matchedPoints2);

if 0
    F = estimateFundamentalMatrix(matchedPoints1.Location, matchedPoints2.Location, 'Method', 'Norm8Point')
    F1 = estimateFundamentalMatrixNorm8Points(matchedPoints1.Location, matchedPoints2.Location)
else
    [F,inliersIndex] = estimateFundamentalMatrix(matchedPoints1.Location, matchedPoints2.Location, 'Method',...
        'RANSAC', 'DistanceType', 'Algebraic');
    [F1,inliersIndex1, n] = estimateFundamentalMatrixRANSAC(double(matchedPoints1.Location), double(matchedPoints2.Location));
end
x1 = [matchedPoints1.Location';ones(1, size(matchedPoints1.Location,1))];
x2 = [matchedPoints2.Location';ones(1,size(matchedPoints2.Location,1))];
a = diag(x2'*F*x1);
b = diag(x2'*(-F1)*x1);
a42 = x2(:,42)'*F*x1(:,42)
b42 = x2(:,42)'*F1*x1(:,42)
inliersIndex(42)
inliersIndex1(42)
sum(inliersIndex)
sum(inliersIndex1)
error1 = sum((a.^2))
error2 = sum((b.^2))
 F , F1

 n
% FF = estimateFundamentalMatrix(matchedPoints1.Location(inliersIndex,:), matchedPoints2.Location(inliersIndex,:), 'Method', 'Norm8Point')
% FF1 = estimateFundamentalMatrixNorm8Points(matchedPoints1.Location(inliersIndex,:), matchedPoints2.Location(inliersIndex,:))