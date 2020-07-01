%#######################################
%#             Sxediasmos             ##
%#######################################

function [circle_x,circle_y] = event_plot(Xb,Yb,Xr,Yr,R,voronoi_x,voronoi_y,Cx,Cy,flag)
    circle_x=zeros(3,629); %ta simeia pou apoteloun tous kiklous drasis twn robot
    circle_y=zeros(3,629);

%     subplot(1,3,1)

    %Pedio drasis kai robot    
    hold off;
    plot([Xb 0],[Yb 0],'k',Xr,Yr,'.k');
    hold on;

    %Aktina drasis robot
    for i=1:4
        [circle_x(i,:) circle_y(i,:)]=circle(Xr(i),Yr(i),R,flag);
    end

    if flag==1 %an exei energopoihthei o sxediasmos

        %Ta simeia twn voronoi keliwn
        plot(voronoi_x(1,:),voronoi_y(1,:),'r-');
        plot(voronoi_x(2,:),voronoi_y(2,:),'c-');
        plot(voronoi_x(3,:),voronoi_y(3,:),'m-');
        plot(voronoi_x(4,:),voronoi_y(4,:),'b-');

        %Ta kentra twn voronoi keliwn
        plot(Cx(:),Cy(:),'r.');

        %eutheia apo ta robot pros to kentro tou voronoi cell tous
        for i=1:4
            h1=line([Xr(i) Cx(i)],[Yr(i) Cy(i)]);
            set(h1,'Color','k');
        end

        %Rithmiseis grafikwn
        xlim([-1 3.5]);
        ylim([-1 3.5]);
        axis square;
        set(gcf,'Color',[1 1 1])
        set(gca,'Color',[.95 .95 .95]);
    end
end