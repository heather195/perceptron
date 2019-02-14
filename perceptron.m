input = csvread("syntheticData.csv");
%length_file = length(input); % how many rows in the csv
x1 = input(:,1);
x2 = input(:,2);
y = input(:,3);

w0 = -10+rand()*(10-(-10));
w1 = -10+rand()*(10-(-10));
w2 = -10+rand()*(10-(-10));
w = [w0; w1; w2];
b = 1;

bestw = w; % pocket
most_correct = 0;

lr = 0.2;

maxx1 = max(x1);
maxx2 = max(x2);
maxes = ceil(max(maxx1, maxx2));

plotBoth(w,x1,x2,y,maxes);

its = 1;
MAX_ITS = 500;
err = 1;
method="online";

if method == "online"
    while(its < MAX_ITS && err > 0)
        for z=1:length(x2)
            x = [b; x1(z);x2(z)];
            %disp("round " + z + ": calculated = " + sign(w'*x) + "; expected = " + y(z));
            %disp(w);
            s = sign(w'*x);
            if s~=y(z)
                w(1) = w(1)+b*y(z)*lr;
                w(2) = w(2)+x1(z)*y(z)*lr;
                w(3) = w(3)+x2(z)*y(z)*lr;
                %disp("record " + z + "err: " + err);
            end
        end

        correct = checkClassification(w,x1,x2,y);

        if correct > most_correct
            disp("Reached here")
            most_correct = correct;
            bestw = w;
        end
        %{
        if(mod(its, 100)==0)
            plotBoth(w,x1,x2,y,maxes);
        end
        %}
        its=its+1;
    end

elseif method == "batch"
    output = zeros([1,length(input)]);
    while(its < MAX_ITS && most_correct < length(x1));
        for z=1:length(x2) 
            count = 0;
            x = [b; x1(z);x2(z)];
            temp=(w'*x);
            output(z) = sign(temp);
        end
        
        for k=1:length(x2)
            if output(k)~=y(k)
                w(1) = w(1)+b*y(k)*lr;
                w(2) = w(2)+x1(k)*y(k)*lr;
                w(3) = w(3)+x2(k)*y(k)*lr;
                %disp("record " + z + "err: " + err);
            end
        end

        correct = checkClassification(w,x1,x2,y);

        if correct > most_correct
            disp("Reached here")
            most_correct = correct;
            bestw = w;
        end
        %{
        if(mod(its, 100)==0)
            plotBoth(w,x1,x2,y,maxes);
        end
        %}
        its=its+1;
    end
end
    

% Create final graph
disp(w);
plotBoth(w,x1,x2,y,maxes);

% Create pocket graph
disp(bestw);
plotBoth(bestw,x1,x2,y,maxes);

