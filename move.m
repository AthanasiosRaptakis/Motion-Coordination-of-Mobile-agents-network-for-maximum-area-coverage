%#############################################
%#     Algorithmos "beltistis" kalipsis     ##
%#############################################

function [Xr,Yr,dist_flag] = move(Cx,Cy,Xr,Yr,dx)

dist_flag=zeros(1,4); %leei an to kathe robot exei apexei ligotero apo to kentro tou kelioy tou apo oti to dx
dx(1:4)=dx;
dist=zeros(4,1); %boithikos

%Kinisi twn robot elfarws pros to kentro tou voronoi cell tous
    for i=1:4
        
        %Ypologismos tis apostasi tou robot apo to kentro tou keliou tou
        dist(i)=sqrt((Xr(i)-Cx(i))^2+(Yr(i)-Cy(i))^2);
        
        %ektimisi tou dist_flag
        if dist(i)<dx
            dx(i)=dist(i);
            dist_flag(i)=1;
        end
        dist_flag=sum(dist_flag);
        
        %Ypologismos twn newn sintetagmenwn gia ta robot
        switch true
            case Cx(i)>Xr(i)
                th=atan((Cy(i)-Yr(i))/(Cx(i)-Xr(i)));
                Xr(i)=Xr(i)+cos(th)*dx(i);
                Yr(i)=Yr(i)+sin(th)*dx(i);
            case Cx(i)<Xr(i)
                th=atan((Cy(i)-Yr(i))/(Cx(i)-Xr(i)));
                Xr(i)=Xr(i)-cos(th)*dx(i);
                Yr(i)=Yr(i)-sin(th)*dx(i);
            case Cx(i)==Xr(i)
                Yr(i)=Yr(i)+dx(i);
        end
    end
end