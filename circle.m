function [circle_x, circle_y] = circle(x,y,r,flag)
    circle_x=zeros(1,360);
    circle_y=zeros(1,360);
    
    for th=0:0.01:2*pi;

        xp=r*cos(th);
        yp=r*sin(th);        

        circle_x(round(th*100+1))=x+xp;
        circle_y(round(th*100+1))=y+yp;
            
        if flag==1
            plot(x+xp,y+yp,'k');
        end
    end
end