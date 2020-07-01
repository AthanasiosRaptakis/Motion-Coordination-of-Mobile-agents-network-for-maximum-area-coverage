%################################
%#      Voronoi algorithm      ##
%################################

function [voronoi_x,voronoi_y,X_perp,Y_perp] = calc_voronoi(Xb,Yb,Xr,Yr)

    x_perp=zeros(1,12); %blepe parakatw
    y_perp=zeros(1,12); %blepe parakatw
    m_perp=zeros(1,12); %klisi tis eutheias metaksi 2 robot
    X_perp=zeros(12,300); %sintetagmeni x twn simeiwn pou apartizoun tis mesokathetous
    Y_perp=zeros(12,300); %sintetagmeni y twn simeiwn pou apartizoun tis mesokathetous
    inters_perp_x=NaN(15); %simeia tomis twn mesokathetwn metaksi tous
    inters_perp_y=NaN(15);
    inters_border_x=zeros(12,2); %simeia tomis twn mesokathetwn me ta oria tou xwrou
    inters_border_y=zeros(12,2);
    x_left_of=NaN(12,10); %NaN gia na apofigw na exw automata midenika parakatwta opoia mporw na mperdepsw me to simeio (0,0)
    y_left_of=NaN(12,10); %simeia aristera tis kathe mesokathetou
    x_right_of=NaN(12,10);%simeia deksia tis kathe mesokathetou
    y_right_of=NaN(12,10);
    polygon_x=cell(4,3); %kratane ta halfplanes(blepe parakatw) pou aforoun kathe robot
    polygon_y=cell(4,3);
    voronoi_x=NaN(4,20); %ta simeia pou apoteloun to poligwno voronoi kathe robot
    voronoi_y=NaN(4,20);
    left=zeros(4,3);
    x={1:12}; %boithitikoi pinakes
    y={1:12};
    
    
    %Ypologismos mesokathetwn
    for i=1:3
        for j=2:4
            if j>i
                m=(Yr(j)-Yr(i))/(Xr(j)-Xr(i)); %upologismos klisis eutheias metaksi 2 robot
            
                %parakatw oi deiktes i*j deixnoun ta apotelesmata gia tin
                %eutheia metaksi tou i kai tou j robot, seira pou kathorizetai
                %apo ta Xr, Yr dianismata
                x_perp(i*j)=(Xr(i)+Xr(j))/2; %upologismos mesou simeiou metaksi 2 robot
                y_perp(i*j)=(Yr(i)+Yr(j))/2;
                m_perp(i*j)=-1/m; %i klisi tis mesokathetou

                for k=1:1:300 %upologismos simeiwn tis mesokathetou
                    X_perp(i*j,k)=k/100;
                    Y_perp(i*j,k)=m_perp(i*j)*(k/100-x_perp(i*j))+y_perp(i*j);                
                end
            end
        end
    end


    %Ypologismos  simeiwn tomis mesokathetwn
    i=0; 
    
    for p=[2 3 4 6 8 12] %to p deixnei tin mesokatheto twn robot i,j me i*j=p
        for q=[2 3 4 6 8 12] 
            if q>p
                i=i+1;                
                [z c] = unique(polyxpoly(X_perp(p,:),Y_perp(p,:),X_perp(q,:),Y_perp(q,:)));
                if not(isempty(z) || size(z,1)>2)
                    inters_perp_x(i,:)=z;
                    inters_perp_y(i,:)=c;
                end
            end
        end
    end

    %Ypologismos simeiwn tomis mesokathetwn me oria xwrou
    for p=2:12
        [x{p},y{p}]=polyxpoly(X_perp(p,:),Y_perp(p,:),[Xb 0],[Yb 0],'unique');
        inters_border_x(p,1:numel(x{p}))=x{p};
        inters_border_y(p,1:numel(y{p}))=y{p};
    end

    %#############################################
    %Dimiourgia half planes gia kathe mesokatheto#
    %#############################################
    
    %Euresi tmimatos(simeiwn) tou pediou drasis aristera tis kathe mesokathetou
    x(:)=[];
    y(:)=[];
    
    for p=[2 3 4 6 8 12] 

        w=0; %boithitika
        z=0;

        for b=1:size(Xb,2)
            D=[inters_border_x(p,2)-inters_border_x(p,1)   Xb(b)-inters_border_x(p,1); %ipologismo orizousas pinaka
               inters_border_y(p,2)-inters_border_y(p,1)   Yb(b)-inters_border_y(p,1)];

            if (det(D)>=0) % tote to simeio tha einai "aristera" tis mesokathetou
                w=w+1; %metraei ta simeia apo ta Xb,Yb pou einai aristera tis mesokathetou
                x_left_of(p,w)=Xb(b); %to aristera/deksia edw den exei noima ws aristera/deksia kiriolektika.
                y_left_of(p,w)=Yb(b);
            else
                z=z+1;
                x_right_of(p,z)=Xb(b);
                y_right_of(p,z)=Yb(b);
            end
        end
        
        %prosthiki twn simeiwn tomis twn mesokathetwn me ta oria tou xwrou
        x_left_of(p,w+1:w+2)=inters_border_x(p,:);
        y_left_of(p,w+1:w+2)=inters_border_y(p,:);
        x_right_of(p,z+1:z+2)=inters_border_x(p,:);
        y_right_of(p,z+1:z+2)=inters_border_y(p,:);
        
        %afairesi twn NaN apo tous pinakes gia na doulepsei i convhull
        %swsta
        sxl=x_left_of(p,:);
        syl=y_left_of(p,:);
        sxr=x_right_of(p,:);
        syr=y_right_of(p,:);

        sxl=sxl(isfinite(sxl(1,:)));
        syl=syl(isfinite(syl(1,:)));
        sxr=sxr(isfinite(sxr(1,:)));
        syr=syr(isfinite(syr(1,:)));
        
        %taksinomisi se swsti seira twn stoixeiwn (pou logw tis prosthikis twn
        %inters_border xalase
        el=convhull(sxl,syl);
        er=convhull(sxr,syr);
        
        [sxl syl]=poly2cw(sxl(el),syl(el));
        [sxr syr]=poly2cw(sxr(er),syr(er));
        
        x_left_of(p,1:numel(sxl))=sxl;
        y_left_of(p,1:numel(syl))=syl;
        x_right_of(p,1:numel(sxr))=sxr;
        y_right_of(p,1:numel(syr))=syr;
        
    end
    
    %euresi twn (simeiwn) tomwn twn halfplanes
    x(:)=[];
    y(:)=[];
    ind=[2 3 4;
         2 6 8;
         3 6 12;
         4 8 12];
     
    for i=1:4 % gia kathe robot
        for j=1:3 %elegxos se poio halfplane poias mesokathetou anikei
            lxp=x_left_of(ind(i,j),:);
            lyp=y_left_of(ind(i,j),:);
            lxp=lxp(isfinite(lxp(1,:)));
            lyp=lyp(isfinite(lyp(1,:)));
            
            if inpolygon(Xr(i),Yr(i),lxp,lyp)
                left(i,j)=1;
            end
        end

        for j=1:3
            if left(i,j)==1 %an to robot einai deksia tis ind(i*j) mseokathetou
                polygon_x{i,j}=x_left_of(ind(i,j),:);
                polygon_y{i,j}=y_left_of(ind(i,j),:);
            else
                polygon_x{i,j}=x_right_of(ind(i,j),:);
                polygon_y{i,j}=y_right_of(ind(i,j),:);
            end
        end
    end

    %kataskeui twn voronoi
    for i=1:4
        [b d]=polybool('and',polygon_x{i,1},polygon_y{i,1},polygon_x{i,2},polygon_y{i,2});
        [x{i},y{i}]=polybool('and',polygon_x{i,3},polygon_y{i,3},b,d);
        voronoi_x(i,1:numel(x{i}))=x{i};
        voronoi_y(i,1:numel(y{i}))=y{i};        
    end
end