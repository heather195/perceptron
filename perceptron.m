input = csvread("syntheticData.csv");
%length_file = length(input); % how many rows in the csv
x1 = input(:,1);
x2 = input(:,2);
y = input(:,3);

w0 = rand();
w1 = rand();
w2 = rand();
w = [w0; w1; w2];
b = 1;
bestw = w;
besterr = length(x2);

maxx1 = max(x1);
maxx2 = max(x2);
maxes = ceil(max(maxx1, maxx2));

its = 1;
MAX_ITS = 3000;
err = 1;
while(its < MAX_ITS && err > 0)
    err = 0;
    for z=1:length(x2)
        x = [b; x1(z);x2(z)];
        if sign(w'*x)~=y(z)
            err=err+1;
            w(1) = w(1)+b*y(z);
            w(2) = w(2)+x1(z)*y(z);
            w(3) = w(3)+x2(z)*y(z);
        end
    end
    its=its+1;
    %disp(w);
end 
disp(w);
plotBoth(w,x1,x2,y,maxes);

%{
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% PLOTTING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m = -(w(1)/w(3))/(w(1)/w(2));
int = -w(1)/w(3);

plotx = zeros([1,maxes]);
ploty = zeros([1,maxes]);

hold on;
for k=1:maxes
   ploty(k) = (m*k) + int 
   plotx(k) = k
end

figure;
grid;
plot(plotx, ploty);
hold on;

for i=1:length(x2)
    %Select color
    if y(i)<0
        mycolor = 'r';
    else
        mycolor = 'g';
    end
    scatter(x1(i),x2(i), mycolor) % graphs all the data points
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%}