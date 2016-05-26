run matlab/vl_compilenn

% setup MatConvNet
run  matlab/vl_setupnn

% load the pre-trained CNN
net = load('imagenet-vgg-f.mat') ;

train = dir('PNetData/train/*.jpg');
test = dir('PNetData/test/*.jpg');
Xtr17 = zeros(4096, size(train,1));
Xtr18 = zeros(4096, size(train,1));
Xtr19 = zeros(4096, size(train,1));
Xtr20 = zeros(4096, size(train,1));
Xtr21 = zeros(1000, size(train,1));
Xtr22 = zeros(1000, size(train,1));
Ytr = cell(1, size(train,1));
Xte17 = zeros(4096, size(test,1));
Xte18 = zeros(4096, size(test,1));
Xte19 = zeros(4096, size(test,1));
Xte20 = zeros(4096, size(test,1));
Xte21 = zeros(1000, size(test,1));
Xte22 = zeros(1000, size(test,1));
Yte = cell(1, size(test,1));
i = 1;
tic
for file = train'
    im = imread(strcat('PNetData/train/',file.name));
    [pathstr,name,ext] = fileparts(file.name);
    im_ = single(im);
    im_ = imresize(im_, net.meta.normalization.imageSize(1:2)) ;
    im_ = im_ - net.meta.normalization.averageImage;
    res = vl_simplenn(net, im_);
    s = xml2struct(strcat('PNetData/train/',name,'.xml'));
    Ytr{i} = {s.Image(1).MediaId(1).Text; s.Image(1).Content(1).Text; ...
        s.Image(1).Genus(1).Text; s.Image(1).Species(1).Text; ...
        s.Image(1).Family(1).Text};
    Xtr17(:,i) = reshape(res(17).x, [4096,1]);
    Xtr18(:,i) = reshape(res(18).x, [4096,1]);
    Xtr19(:,i) = reshape(res(19).x, [4096,1]);
    Xtr20(:,i) = reshape(res(20).x, [4096,1]);
    Xtr21(:,i) = reshape(res(21).x, [1000,1]);
    Xtr22(:,i) = reshape(res(22).x, [1000,1]);
    i = i+1;
end
toc
i = 1;
tic
for file = test'
    im = imread(strcat('PNetData/test/',file.name));
    [pathstr,name,ext] = fileparts(file.name);
    im_ = single(im);
    im_ = imresize(im_, net.meta.normalization.imageSize(1:2)) ;
    im_ = im_ - net.meta.normalization.averageImage;
    res = vl_simplenn(net, im_);
    s = xml2struct(strcat('PNetData/test/',name,'.xml'));
    Yte{i} = {s.Image(1).MediaId(1).Text; s.Image(1).Content(1).Text};
    Xte17(:,i) = reshape(res(17).x, [4096,1]);
    Xte18(:,i) = reshape(res(18).x, [4096,1]);
    Xte19(:,i) = reshape(res(19).x, [4096,1]);
    Xte20(:,i) = reshape(res(20).x, [4096,1]);
    Xte21(:,i) = reshape(res(21).x, [1000,1]);
    Xte22(:,i) = reshape(res(22).x, [1000,1]);
    i = i+1;
end
toc

Ytr = horzcat(Ytr{:});
Yte = horzcat(Yte{:});

save('PNetData.mat', 'Xtr17', 'Xtr18', 'Xtr19', 'Xtr20', 'Xtr21', 'Xtr22', ...
    'Xte17', 'Xte18', 'Xte19', 'Xte20', 'Xte21', 'Xte22', 'Ytr', 'Yte');
