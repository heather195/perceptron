function plotBoth(w, x1, x2, y, maxes) 
    m = -(w(1)/w(3))/(w(1)/w(2));
    int = -w(1)/w(3);

    plotx = zeros([1,maxes]);
    ploty = zeros([1,maxes]);

    hold on;
    for k=1:maxes
        ploty(k) = (m*k) + int; 
        plotx(k) = k;
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