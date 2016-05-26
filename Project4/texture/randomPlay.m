function newV = randomPlay(v, primloops)

lengths = primloops(1,:) + 1 - primloops(2,:);
[h, w, c, l] = size(v);
frame = 1;
i = 1;
threshold = median(primloops(3,:));

while (frame < l)
   display(frame);
   newV(:,:,:,i) = v(:,:,:,frame);
   if (any(primloops(1,:) == frame) && rand(1) < 0.25)
       if (size(find(primloops(1,:) == frame), 2) > 1)
           potLoops = primloops(:, find(primloops(1,:) == frame));
           theLoop = potLoops(:,1);
           for x = 1:size(potLoops,2)
               if (potLoops(3,x) < theLoop(3,1))
                   theLoop = potLoops(:,x);
               end;
           end;
       else
           theLoop = primloops(:, find(primloops(1,:) == frame));
       end;
       if (theLoop(3,1) < threshold && ...
           lengths(find(primloops(3,:) == theLoop(3,1))) > mean(lengths))
           frame = theLoop(2,1);
       else
           frame = frame + 1;
       end;
   else
       frame = frame + 1;
   end;
   i = i + 1;
end;