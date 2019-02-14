%{
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Heather Craddock
Submitted to Dr. Holness, DSU for Machine Learning Assignment 2 on
13/2/2019

This perceptron can use a pseudo inverse to initialise the weights of a
pocket PLA.

The pocket PLA can store the best performing solution to counter any steps
taken that decrease performance.

The PLA has been modified with a learning rate (lr) to limit step size and
can use batch modifications (when method = "batch") or weight modifications
can be done for each input data point (when method = "online").

Thoughts:
The pseudo-inverse hypothesis consistently separates the data, and with the
data set given there is no improvement in terms of generating a binary
classification hypothesis that is more accurate. The addition of a learning
rate seems to allow the PLA to reach a more accurate solution more quickly
and deviates less from a good solution.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%}


%Input data: ensure file in the same folder
input = csvread("syntheticData.csv");
%length_file = length(input); % how many rows in the csv
x1 = input(:,1);
x2 = input(:,2);
y = input(:,3);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% comment this section and uncomment w random initialisation below to
% swap between pseudo-inverse initialisation and random initialisation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rows = length(input);
cols = 3;
big_x = zeros(rows, cols);
for i=1:rows
    big_x(i,1) = b;
    big_x(i,2) = x1(i);
    big_x(i,3) = x2(i);
end

psuedo_inv_x = ((big_x'*big_x)^(-1))*big_x';
p_method_w = psuedo_inv_x*y;
plotBoth(p_method_w,x1,x2,y,maxes);
w = p_method_w;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%
%{
w0 = -10+rand()*(10-(-10));
w1 = -10+rand()*(10-(-10));
w2 = -10+rand()*(10-(-10));
w = [w0; w1; w2];
%}
%%%%%%%%%%%%
b = 1;

bestw = w; % pocket
most_correct = checkClassification(w,x1,x2,y);
best_found_it = 1;

lr = 0.02; %learning rate

maxx1 = max(x1);
maxx2 = max(x2);
maxes = ceil(max(maxx1, maxx2));

plotBoth(w,x1,x2,y,maxes); % Plot the starting hypothesis

its = 1;
MAX_ITS = 1000;
method="batch";

% Online method where as an incorrectly classified data point is found, the
% weights are updated. These new weights are then used for the next data
% point.
if method == "online"
    
    while(its < MAX_ITS && correct < length(input))
        for z=1:length(x2)
            x = [b; x1(z);x2(z)]; % augment with x0 = b = 1
            s = sign(w'*x);
            if s~=y(z) % If misclassified, update weights
                %Weight update formula: wi = wi + xi*yi*lr
                w(1) = w(1)+b*y(z)*lr;
                w(2) = w(2)+x1(z)*y(z)*lr;
                w(3) = w(3)+x2(z)*y(z)*lr;
            end
        end

        correct = checkClassification(w,x1,x2,y);

        if correct > most_correct
            %disp("Reached here")
            most_correct = correct;
            bestw = w;
        end
        %{
        % Use to plot the graph every 100 iterations (to see improvement)
        if(mod(its, 100)==0)
            plotBoth(w,x1,x2,y,maxes);
        end
        %}
        its=its+1;
    end

elseif method == "batch"
    output = zeros([1,length(input)]);
        
    while(its < MAX_ITS && most_correct < length(x1))
        for z=1:length(x2) 
            count = 0;
            x = [b; x1(z);x2(z)]; % augment with x0 = b = 1
            temp=(w'*x);
            output(z) = sign(temp); % iterate through whole input set
                                    % save sign outputs to compare all at
                                    % once (ensures all data points in an
                                    % iteration are examined on same weight
                                    % vector)
        end
        
        for k=1:length(x2)
            if output(k)~=y(k)  % compare each row expected vs calculated
                                % and if wrong, update weights using
                                % formula: wi = wi + xi*yi*lr
                w(1) = w(1)+b*y(k)*lr;
                w(2) = w(2)+x1(k)*y(k)*lr;
                w(3) = w(3)+x2(k)*y(k)*lr;
            end
        end

        correct = checkClassification(w,x1,x2,y);

        if correct > most_correct
            disp("Reached here")
            most_correct = correct;
            bestw = w;
            best_found_it = its;
        end
        %{
        % Use to plot the graph every 100 iterations (to see improvement)
        if(mod(its, 100)==0)
            plotBoth(w,x1,x2,y,maxes);
        end
        %}
        its=its+1;
    end
end
disp(best_found_it);

% Create final graph
disp(w);
plotBoth(w,x1,x2,y,maxes);

% Create pocket graph
disp(bestw);
plotBoth(bestw,x1,x2,y,maxes);


