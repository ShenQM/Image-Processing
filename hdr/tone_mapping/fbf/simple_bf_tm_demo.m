close all;
dbstop if error;
filename = 'E:\Projects\data\hdr\office.hdr';
out_range = 30;
wsize = 2;
sigma_s = 8;
sigma_r = 0.2;
num_seg = 64;
scale = 1;

hdr_img = hdrread(filename);

figure('name', 'hdr_linear');
min_hdr = min(hdr_img(:));
max_hdr = max(hdr_img(:));
linear_hdr = (hdr_img - min_hdr) ./ (max_hdr - min_hdr) + min_hdr;
imshow(linear_hdr);
ldr_img = simple_bf_tm(hdr_img, out_range, wsize, sigma_s, sigma_r, num_seg, scale);
%ldr_img = tonemap(hdr_img);
figure('name','hdr image');
imshow(hdr_img, []);
imwrite(hdr_img, 'hdr_img.jpeg');
figure('name','ldr image');
imshow(ldr_img, []);
imwrite(ldr_img, ['ldr_img_', num2str([out_range, wsize, sigma_s, sigma_r, num_seg, scale]),'.jpeg']);
imwrite(ldr_img, [filename,  num2str([out_range, wsize, sigma_s, sigma_r, num_seg, scale]),'.jpeg']);


