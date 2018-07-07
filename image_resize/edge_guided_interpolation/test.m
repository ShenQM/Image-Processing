a = [1 2 3 4; 5 6 7 8; 9 10 11 12; 13 14 15 16];
b = [0.25, 0.25; 0.25 0.25];

pad_a = padarray(a,[0,2],'symmetric','both')

conv_a_b = conv2(pad_a,b,'valid')