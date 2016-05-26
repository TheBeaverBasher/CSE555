
video = VideoReader('swingShort3.mp4');
v = im2double(read(video));

[h, w, c, l] = size(v);

D = frame2frameDist(v);                 % Distances to each frame    lxl
P = probMat(D);
Dp = preserveDyn(D);                    % Filtered Distances         (l-3)x(l-3)
Pp = probMat(Dp);                       
Dpp = AFC(Dp, rand(1)*.009+.99, 2);     % Anticipated future cost    (l-3)x(l-3)
Ppp = probMat(Dpp);

subplot(2,3,1), imshow(uint8(D))        %
subplot(2,3,4), imshow(P)               %   imregionalmin(D)
subplot(2,3,2), imshow(uint8(Dp))       %                       For pruning transitions
subplot(2,3,5), imshow(Pp)              %   imregionalmax(P)
subplot(2,3,3), imshow(uint8(Dpp))      %
subplot(2,3,6), imshow(Ppp)             %

trans = find(tril(imregionalmax(Ppp),-1))';
primloops = zeros(3,size(trans,2));

for i = 1:size(trans,2)
    primloops(1,i) = mod(trans(i),l-4);
        if (primloops(1,i) == 0) 
            primloops(1,i) = l-4;
        end;
    primloops(2,i) = ceil(trans(i)/(l-3));
    primloops(3,i) = Dp(primloops(1,i),primloops(2,i));
end;

table = loopTable(l*2,primloops);



newV = randomPlay(v,primloops);

rdp = VideoWriter('randplaywaterfall.mp4', 'MPEG-4');
open(rdp);
writeVideo(rdp,newV);
close(rdp);

