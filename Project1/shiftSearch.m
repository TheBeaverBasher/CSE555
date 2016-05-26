function chanShift = shiftSearch(Image, search, chanShift, scale)

newSearch = round(1/scale*search);
[height, width, dim] = size(Image);

if width > 512 
    startH = height/2;
    startW = width/2;
    endW = 512+startW ;
    endH = 512+startH ;
else
    startW = 1;
    startH = 1;    
    endW = width;
    endH = height;
    newSearch = 0;
end
     
edgeR = double(edge(Image(startH+newSearch+chanShift(1,1):endH+newSearch+chanShift(1,1), startW+newSearch+chanShift(1,2):endW+newSearch+chanShift(1,2), 1),'canny'));  
edgeG = double(edge(Image(startH+newSearch+chanShift(2,1):endH+newSearch+chanShift(2,1), startW+newSearch+chanShift(2,2):endW+newSearch+chanShift(2,2), 2),'canny')); 
edgeB = double(edge(Image(startH+newSearch+search:endH+newSearch-search, startW+newSearch+search:endW+newSearch-search, 3),'canny')); 

edgeImage = cat(3, edgeR, edgeG);

for channel = 1:2
    nxcMax = 0;
    for i = -search:1:search 
        for j = -search:1:search
            temp = edgeImage(1+i+search:end-search+i,1+j+search:end-search+j,channel);
            nxc = sum(temp(:).*edgeB(:))/(norm(temp(:))*norm(edgeB(:)));
            if nxc > nxcMax
                I = i;
                J = j;
                nxcMax = nxc;
            end
        end 
    end
    chanShift(channel,:)=[I J];
end  