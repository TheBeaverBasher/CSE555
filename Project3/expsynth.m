texture = imread('small_crazy.jpg');
k=1.5;
l=1.6;
for i = 1:4
    k = k*2;
    l = l/2;
    for j = 1:4
        %if (i==4) 
        %    [synth, blocksize] = synthesize(texture, k, l, 0, 2^(j-1));
        %else
        [synth, blocksize] = synthesize(texture, k, l, 1, 2^(j-1));
        %end
        s1 = 'oil';
        s2 = num2str(blocksize);
        s3 = '_';
        s4 = num2str(24/(2^(j-1)));
        s5 = '.jpg';
        imwrite(synth, strcat(s1, s2, s3, s4, s5));
    end;
end;