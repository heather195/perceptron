function count = checkClassification(w, x1, x2, y)
    count = 0;
    for i=1:length(x1)
        x = [1; x1(i);x2(i)];
        temp=(w'*x);
        if sign(temp) == y(i)
            count = count+1;
        end
    end
    disp(count + "/"+length(x2)+" classified correctly.");