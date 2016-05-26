%NF = imread('toysnoflash.png');
NF = imread('http://www.mathworks.com/help/releases/R2015b/examples/images/PerformFlashNoflashDenoisingWithGuidedFilterExample_01.png');
%F  = imread('toysflash.png');
F = imread('http://www.mathworks.com/help/releases/R2015b/examples/images/PerformFlashNoflashDenoisingWithGuidedFilterExample_02.png');
%%
filt = fspecial('Gaussian',[21 21], 7);   %make a pretty big Gaussian Filter
NFblur = imfilter(NF,filt);               % Blur the No Flash Image
Fblur = imfilter(F,filt);                 % Blur the Flash Image
Flap = F-Fblur;                           % Compute the High-Freq (Laplacian) of the Flash image
imagesc(NFblur+Flap);                     % Add that back to the no-flash image.

%% Code for explicitly constructing matrix A, b such that 
% minimizing Ax -b solves for an x that is a representation of an image
% that is close to image NF, but has gradients close to image F.

[gx gy] = gradient(double(F));                            % compute gradiants of image F.

% make an "index image" that maps pixels in the image to the column of A that
% constrains that pixel
% Do this by giving every pixel a number from 1 to 706*774 and shape that
% into an image.
indexIm = reshape(1:706*774,size(gx(1:706,1:774,1)));     % this is the mapping for the red-channel
indexIm(:,:,2) = 546444+indexIm(:,:,1);                   % the blue channel
indexIm(:,:,3) = 546444+indexIm(:,:,2);                   % the green channel 546444 = 706*774

b = [];                                                   % make sure we initialiaze A,b
A = sparse([]);                                           % make sure A is sparse or we will die of too much memory
whichEquation = 1;                                        % keep track of which row of A,b we are filling in.

for cx = 1:3                                              % Loop over color channel
    for ax = 1:774
        for bx = 1:706
            index = indexIm(bx,ax,cx);                    % First set of rows says that each pixel should look like NF
            A(whichEquation,index) = 1;
            b(whichEquation) = NF(bx,ax,cx);
            whichEquation = whichEquation+1;
        end
    end
    disp('phew');
    for ax = 1:774                                            % Second set says that x derivatives should match
        for bx = 1:706
            if ~(bx == 706)
                indexMe = indexIm(bx,ax,cx);                  % compute location of my column in A and column of pixel to my right.
                indexRight = indexIm(bx+1,ax,cx);
                A(whichEquation,indexMe) = -1;                % set values in A
                A(whichEquation,indexRight) = 1;
                b(whichEquation) = F(bx+1,ax,cx)-F(bx,ax,cx); % those values should differ by whatever they differed in in Fa
                whichEquation = whichEquation+1;
            end
        end
    end
    disp('hi');
    for ax = 1:774                                            % Third set says that y derivatives should match
        for bx = 1:706
            if ~(ax == 774)
                indexMe = indexIm(bx,ax,cx);                    
                indexDown = indexIm(bx,ax+1,cx);
                A(whichEquation,indexMe) = -1;
                A(whichEquation,indexDown) = 1;
                b(whichEquation) = F(bx,ax+1,cx)-F(bx,ax,cx);
                whichEquation = whichEquation+1;
            end
        end
    end
    disp(cx);
end
