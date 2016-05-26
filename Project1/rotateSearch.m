function angles = rotateSearch(Image, subSampFlag)

[height, width, dim]=size(Image);

if subSampFlag == 1
    startH = height/2;
    startW = width/2;
    endW = 512+startW ;
    endH = 512+startH ;
else
    startW = 1;
    startH = 1;
    endW = width;
    endH = height;
end
    
edgeR = double(edge(Image(startH:endH, startW:endW, 1),'canny'));  
edgeG = double(edge(Image(startH:endH, startW:endW, 2),'canny')); 
edgeB = double(edge(Image(startH:endH, startW:endW, 3),'canny')); 

edgeImage = cat(3, edgeR,edgeG);

angles = zeros(1,2);    
for channel = 1:2
    nxcMax = 0;
    for angle = -1:0.01:1
        temp = imrotate(edgeImage(:,:,channel), angle, 'nearest', 'crop');
        nxc = sum(temp(:).*edgeB(:))/(norm(temp(:))*norm(edgeB(:))); 
            if nxc > nxcMax
                angles(channel) = angle;
                nxcMax = nxc;
            end
    end
end