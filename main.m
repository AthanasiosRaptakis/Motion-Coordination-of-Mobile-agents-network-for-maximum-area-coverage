%################################# 
%#             MAIN             ##
%#################################

%EKKINISI

max_runs=50; %gia na min pesw se atermoni antallagi thesewn gia kapoio robot

close all

for r=3
    
    Trajectory_Video = avifile(['Trajectory_Video',num2str(r),'.avi']);
    
    runs=0; %metraei twn arithmo twn epanalipsewn
    area=zeros(100,1); %apothikeuei to embadon kalipsis se kathe epanalipsi
    history_x=NaN(100,4); %gia na sxediastei i troxia tou kathe robot
    history_y=NaN(100,4);

    [Xb Yb Xr Yr R ds]=conf(); %arxikopoihsh

    
    while runs>-1 %main loop
        clc
        r
        runs=runs+1

        if runs>1
            %Treksimo tou algorithmou beltistis kalipsis
            [Xr,Yr,dist_flag]=move(Cx,Cy,Xr(1,:),Yr(1,:),ds);
            history_x(runs,1:4)=Xr(1:4);
            history_y(runs,1:4)=Yr(1:4);

            [voronoi_x voronoi_y X_perp Y_perp]=calc_voronoi(Xb(1,:),Yb(1,:),Xr(1,:),Yr(1,:));
            [Cx,Cy]=voronoi_centers(voronoi_x(1:4,:),voronoi_y(1:4,:));
        else
            %gia na sxediastei kai i arxiki katastasi
            [voronoi_x voronoi_y]=calc_voronoi(Xb(1,:),Yb(1,:),Xr(1,:),Yr(1,:));
            [Cx,Cy]=voronoi_centers(voronoi_x(1:4,:),voronoi_y(1:4,:));
            history_x(runs,1:4)=Xr(1:4);
            history_y(runs,1:4)=Yr(1:4);
        end

        [circle_x circle_y] = event_plot(Xb,Yb,Xr,Yr,R(r),voronoi_x(1:4,:),voronoi_y(1:4,:),Cx,Cy,1);
        
        s=0;
        for s=1:15
            s
            frame = getframe(gcf);
            Trajectory_Video = addframe(Trajectory_Video ,frame);
        end
%         pause(3)
        
        [area(runs) check_overlap] = calc_area(Xb,Yb,Xr,Yr,R(r),circle_x(1:4,:),circle_y(1:4,:));

        %Elegxos termatismou tou programmatos
        check_x=isequal(Cx,Xr);
        check_y=isequal(Cy,Yr);
       
        if (check_x && check_y) || (runs>max_runs && dist_flag) || runs>max_runs*2  || check_overlap==0
            total=runs;
            break
        end
    end
    
    Trajectory_Video= close(Trajectory_Video);
    
    system(['ffmpeg -i Trajectory_Video',num2str(r),'.avi -sameq Trajectory_Video',num2str(r),'_comp.avi'])
    
    
%     event_plot(Xb,Yb,Xr,Yr,R(r),voronoi_x(1:4,:),voronoi_y(1:4,:),Cx,Cy,1);
%     plot(history_x(:,1),history_y(:,1),'r',history_x(1,1),history_y(1,1),'rx');
%     plot(history_x(:,2),history_y(:,2),'c',history_x(1,2),history_y(1,2),'cx');
%     plot(history_x(:,3),history_y(:,3),'m',history_x(1,3),history_y(1,3),'mx');
%     plot(history_x(:,4),history_y(:,4),'b',history_x(1,4),history_y(1,4),'bx');
% 
%     subplot(1,3,3)
% 
%     plot(1:runs,area(1:runs),'b',1:runs,area(1:runs),'r.')
% 
%     xlim([0 70]);
%     ylim([0 6]);
%     axis square
%     set(gcf,'Color',[1 1 1])
%     set(gca,'Color',[.95 .95 .95]);
%     saveas(gca,['graph',num2str(r)],'png')
end