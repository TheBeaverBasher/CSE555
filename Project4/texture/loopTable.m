function table = loopTable(L, primloops)

table = zeros(L,size(primloops,2),size(primloops,2));
lengths = primloops(1,:) + 1 - primloops(2,:);

overlap = zeros(size(primloops,2));

for jump1 = 1:size(primloops,2)
    for jump2 = 1:size(primloops,2)
        range1 = primloops(2,jump1):primloops(1,jump1);
        range2 = primloops(2,jump2):primloops(1,jump2);
        if (size(intersect(range1,range2),2) > 0)
            overlap(jump1,jump2) = 1;
        end;
    end;
end;

for i = 2:L
    for j = 1:size(primloops,2)
        cost = inf;
        if all(table(1:i-1,j,j) < 1)
            if (lengths(j) == i)
                table(i,j,j) = 1;
            end;
        else
            loops = ind2sub(size(table),find(table(:,j,j)==1));
            entry1 = [loops(1), j, j];
            for k = 1:size(primloops,2)
                if (overlap(j,k) > 0 && table(i-entry1(1),k,k) > 0)
                    potLoopCost = sum(reshape(table(i-entry1(1),k,:),[1, size(primloops,2)]).*primloops(3,:)) + primloops(3,j);
                    if (cost > potLoopCost)
                        table(i,j,:) = table(i-entry1(1),k,:);
                        table(i,j,j) = table(i,j,j) + 1;
                        cost = potLoopCost;
                    end;
                end;
            end;
        end;
    end;
end;