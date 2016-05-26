texture = imread('toast.png');
constraint = imread('efros.jpg');
alpha = 1;

while 1-alpha < 1 
   trans = transfer(texture,constraint, 1-alpha,1);
   s1 = 'tef';
   s2 = num2str(1-alpha);
   s3 = '.jpg';
   imwrite(trans, strcat(s1, s2, s3));
   alpha = alpha/2;
end