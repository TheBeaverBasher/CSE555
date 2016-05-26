function [subPixShiftI,subPixShiftJ] = subPixSearch(Image, subSampFlag )
 
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

ImageSmall = single(Image(startH:endH, startW:endW,:));
smallB = ImageSmall(:,:,3);
  
subPixShiftI = zeros(1,3,2);
subPixShiftJ = zeros(3,1,2);
tempI = subPixShiftI;
tempJ = subPixShiftJ;
 
for channel = 1:2
    nxcMax = 0;
    for i = -0.75:0.05:0.75
        for j = -0.75:0.05:0.75  
            tempJ = 0*tempJ;
            tempI = 0*tempI;
            if i < 0
                tempI(1,3,channel) = -i;
                tempI(1,2,channel) = 1+i;
            else
                tempI(1,1,channel) = i;
                tempI(1,2,channel) = 1-i;
            end
            if j < 0
                tempJ(3,1,channel) = -j;
                tempJ(2,1,channel) = 1+j;
            else
                tempJ(1,1,channel) = j;
                tempJ(2,1,channel) = 1-j;
            end      
            temp = conv2(conv2(ImageSmall(:,:,channel),tempJ(:,:,channel),'same'),tempI(:,:,channel),'same');
            nxc = sum(temp(:).*smallB(:))/(norm(temp(:))*norm(smallB(:))); 
            if nxc > nxcMax 
                nxcMax = nxc;
                subPixShiftI(:,:,channel) = tempI(:,:,channel);
                subPixShiftJ(:,:,channel) = tempJ(:,:,channel);
            end
        end       
    end
end 