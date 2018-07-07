close all;
dbstop if error;
file_name = '..\temp\data\kodak_image_set\kodim07.png';
file_name = '..\temp\data\lena.jpg';

rgb_image = imread(file_name);
cfa_pattern = [1 2 2 3];
cfa_image = mosaic(rgb_image, cfa_pattern);
imwrite(uint8(cfa_image), '..\temp\data\mosaic_image.jpg');

demosaiced_image_linear = demosaic_bilinear(cfa_image, cfa_pattern);
biliner_snr = psnr(uint8(demosaiced_image_linear), rgb_image)
figure('name', 'bilinear demosaic');
imshow(uint8(demosaiced_image_linear));
imwrite(uint8(demosaiced_image_linear), '..\temp\data\demosaic_bilinear.png');

demosaiced_image_grad = grad_bilinear_demosaic(cfa_image, cfa_pattern);
figure('name', 'grad based bilinear demosaic');
grad_biliner_snr = psnr(uint8(demosaiced_image_grad), rgb_image)
imshow(uint8(demosaiced_image_grad));
imwrite(uint8(demosaiced_image_grad), '..\temp\data\demosaic_grad_bilinear.png');

demosaiced_matlab = demosaic(uint8(cfa_image), 'rggb');
demosaiced_matlab_snr = psnr(uint8(demosaiced_matlab), rgb_image)
figure('name', 'matlab demosaic');
imshow(uint8(demosaiced_matlab));
imwrite(uint8(demosaiced_matlab), '..\temp\data\demosaic_matlab.png');
