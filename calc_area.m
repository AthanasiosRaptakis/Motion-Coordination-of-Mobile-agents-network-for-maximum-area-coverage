%#############################################################
%               Ypologismos Embadou Kalipsis                ##
%#############################################################

function [area,check_overlap] = calc_area(Xb,Yb,Xr,Yr,R,circle_x,circle_y)
    overlaps=eye(4); %pinakas pou leei poianou robot i aktina drasis kaliptei tin aktina drasis allou
    inters_circle_x=cell(4,1); %simeia pou apartizoun tis enwseis twn kiklwn drasis twn robot
    inters_circle_y=cell(4,1);
    check_overlap=0;
    area=0; %to embadon kalipsis
    neg=0; %boithitiko
    
    %gemisma tou cell array
    for i=1:4
        inters_circle_x{i}=0;
        inters_circle_y{i}=0;
    end
    
    %ektimmisi tou overlaps
    for i=1:3
        for j=2:4
            if j>i
                if sqrt(((Xr(i)-Xr(j))^2)+((Yr(i)-Yr(j))^2)) < 2*R
                    overlaps(i,j)=1;
                    check_overlap=1;
                end
            end
        end
    end
    
    out=0; %flag gia break tou ekswterikou for
    %ipologismos twn enwsewn twn kiklwn drasis simfwna me ton overlaps
    %(perissoteres leptomeries proforika, giati thelei olokliri selida gia
    %na to perigrapsw!)
    for i=1:4
        for j=1:4
            if j>=i
                if out==1
                    break
                else
                    if overlaps(i,j)==1
                        [inters_circle_x{i} inters_circle_y{i}] = polybool('or',circle_x(j,:),circle_y(j,:),inters_circle_x{i},inters_circle_y{i});

                        if j>1 && j<4
                            for l=1:(4-j)
                                if overlaps(j,j+l)==1
                                    [inters_circle_x{i} inters_circle_y{i}] = polybool('or',circle_x(j+l,:),circle_y(j+l,:),inters_circle_x{i},inters_circle_y{i});

                                    if i==1 && l==1 && j==2
                                        if overlaps(j+1,j+2)==1
                                            [inters_circle_x{i} inters_circle_y{i}] = polybool('or',circle_x(j+2,:),circle_y(j+2,:),inters_circle_x{i},inters_circle_y{i});
                                            out=1;
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    %afairesi mi xreiazoumenwn enwsewn
    for i=4:-1:2
        for j=1:3
            if j<i
                if inpolygon(inters_circle_x{i},inters_circle_y{i},inters_circle_x{j},inters_circle_y{j})~=0
                    inters_circle_x(i)=[];
                    inters_circle_y(i)=[];
                    break
                end
            end
        end
    end
    
    %Ypolpgismos tomis twn parapanw enwsewn me ta oria tou xwrou
    for k=1:numel(inters_circle_x)
        [x y]=inpolygon(inters_circle_x{k},inters_circle_y{k},Xb,Yb);
        if sum(y)>0 || sum(x)<numel(x)
            [inters_circle_x{k} inters_circle_y{k}] = polybool('and',Xb,Yb,inters_circle_x{k},inters_circle_y{k});
            check_overlap=1;
        end
        
%         subplot(1,3,2)
%         plot([Xb 0],[Yb 0],'k')
%         hold on
        
        if hasInfNaN(inters_circle_x{k}) %an ip;arxoun tripes, ipologismos tou ekswterikou poligwnou
            [temp_x temp_y] = polysplit(inters_circle_x{k},inters_circle_y{k}); 

            for m=1:sum(isnan(inters_circle_x{k}))
                if inpolygon(temp_x{m+1},temp_y{m+1},temp_x{m},temp_y{m})
                    outer=m;
                elseif inpolygon(temp_x{m},temp_y{m},temp_x{m+1},temp_y{m+1})
                    outer=m+1;
                end
            end
            if outer==0
                if inpolygon(temp_x{1},temp_y{1},temp_x{3},temp_y{3})
                    outer=3;
                else
                    outer=1;
                end
            end
            
%             fill(temp_x{outer},temp_y{outer},'r')
            
            %Ypologismos tou embadou kalipsis
            for m=1:numel(temp_x)
                if m~=outer
                    neg=neg+polyarea(temp_x{m},temp_y{m});
%                     fill(temp_x{m},temp_y{m},[.95 .95 .95])
                end
            end
            area=polyarea(temp_x{outer},temp_y{outer})-neg;
        else
            area=area + polyarea(inters_circle_x{k},inters_circle_y{k});
            for n=1:numel(inters_circle_x)
%                 fill(inters_circle_x{n},inters_circle_y{n},'r')
            end
        end
    end
%     
%     xlim([-1 3.5]);
%     ylim([-1 3.5]);
%     axis square;
%     set(gcf,'Color',[1 1 1])
%     set(gca,'Color',[.95 .95 .95]);
%     hold off
end