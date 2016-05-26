function align(img)
close all
tic

M = imread(img);

[height, width] = size(M);
 
height=height/3;
B = M(1:height,:);
G = M(height+1:2*height,:);
R = M(2*height+1:end,:);
 
preAlignCol = cat(3,R,G,B);
imwrite(preAlignCol, strcat(img(1:end-4),'_prealigned.jpg'));
subSampFlag = 0;

%figure
%imshow(preAlignCol);

if height > 512 && width > 512
    scale= 512/width;
    subSamp = imresize(preAlignCol,scale,'bilinear');
    subSampFlag = 1;
else 
    subSamp = preAlignCol;
    scale = 1;
end

search=10;

chanShift = zeros(2,2);
chanShift = shiftSearch(subSamp,search,chanShift,1); 
shift = search+1;
 
if subSampFlag == 1
    kprev = scale;
    chanShiftUpdate = 0*chanShift;
    for k=[.5,1]
        finerSearch = ceil(k/kprev)+1;
        chanShift = ceil((k/kprev)*chanShift)+chanShiftUpdate;    
        chanShiftUpdate = shiftSearch(imresize(preAlignCol,k,'bilinear'),finerSearch,chanShift,k);
        kprev = k;
    end
    chanShift = chanShift+chanShiftUpdate; 
    shift=ceil((1/scale)*(search+1))+finerSearch+1;
    
    preAlignCol(shift:end-chanShift(1,1), shift:end-chanShift(1,2), 1) = preAlignCol(shift+chanShift(1,1):end, shift+chanShift(1,2):end, 1);
    preAlignCol(shift:end-chanShift(2,1), shift:end-chanShift(2,2), 2) = preAlignCol(shift+chanShift(2,1):end, shift+chanShift(2,2):end, 2);
    
    %figure
    %imshow(preAlignCol);
    imwrite(preAlignCol, strcat(img(1:end-4),'_postshift.jpg'));
else
    preAlignCol=subSamp;
end

angles = rotateSearch(preAlignCol, subSampFlag);

preAlignCol(:,:,1) = imrotate(preAlignCol(:,:,1), angles(1), 'nearest', 'crop');
preAlignCol(:,:,2) = imrotate(preAlignCol(:,:,2), angles(2), 'nearest', 'crop');
 
%figure
%imshow(preAlignCol);
imwrite(preAlignCol, strcat(img(1:end-4),'_postrotate.jpg'));

[sPixI, sPixJ] = subPixSearch(preAlignCol,subSampFlag);
 
preAlignCol(:,:,1) = conv2(conv2(preAlignCol(:,:,1), sPixJ(:,:,1), 'same'), sPixI(:,:,1), 'same');
preAlignCol(:,:,2) = conv2(conv2(preAlignCol(:,:,2), sPixJ(:,:,2), 'same'), sPixI(:,:,2), 'same');
    
%figure
%imshow(preAlignCol);
imwrite(preAlignCol, strcat(img(1:end-4),'_postsubpixshift.jpg'));
 
[height, width, dim] = size(preAlignCol);
outImage = preAlignCol(height*.075:height*.925, width*.075:width*.925,:);

%figure
%imshow(outImage);
imwrite(outImage, strcat(img(1:end-4),'_aligned.jpg'));
toc