%#############################################
%#    Ypologismos kentrwn voronoi keliwn    ##
%#############################################

function [Cx,Cy] = voronoi_centers(voronoi_x,voronoi_y)

    %Ypologsismos twn kentrwn twn poligwnwn (gewmetria...)
    A=zeros(1,4); 
    Cx=zeros(1,4);
    Cy=zeros(1,4);
    
    for i=1:4
        x=voronoi_x(i,:);
        x=x(isfinite(x(1,:)));
        y=voronoi_y(i,:);
        y=y(isfinite(y(1,:)));
        s=size(x,2);
        for k=1:s-1
            Cx(i)=Cx(i)+(x(k)+x(k+1))*(x(k)*y(k+1)-x(k+1)*y(k));
            Cy(i)=Cy(i)+(y(k)+y(k+1))*(x(k)*y(k+1)-x(k+1)*y(k));
        end

        Cx(i)=Cx(i)+(x(s)+x(1))*(x(s)*y(1)-x(1)*y(s));
        Cy(i)=Cy(i)+(y(s)+y(1))*(x(s)*y(1)-x(1)*y(s));

        A(i)=-polyarea(x,y);
        Cx(i)=(1/(6*A(i)))*Cx(i);
        Cy(i)=(1/(6*A(i)))*Cy(i);
    end
end