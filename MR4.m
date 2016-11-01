function RADON=MR4(num,th)
p=phantom(num);
RADON=zeros(num,length(th));
count1=0;
tic
for theta=th
    count1=count1+1;
    if rem(count1/10,1)==0
        disp('Â¥ÀÜ');
    end 
    if rem(theta,360)~=90 && rem(theta,360)~=270
        for n=1:num
            K=zeros(1,2);
            count2=0;
            for x=0:num
                y=tan(theta*pi/180)*(x-num/2)+num/2+(n-num/2-0.5)/cos(theta*pi/180);
                if y>=0 && y<=100
                    count2=count2+1;
                    K(count2,1)=x;
                    K(count2,2)=y;
                end
            end
            for y=0:num
                x=(y-(n-num/2-0.5)/cos(theta*pi/180)-num/2)/tan(theta*pi/180)+num/2;
                if x>=0 && x<=100
                    count2=count2+1;
                    K(count2,1)=x;
                    K(count2,2)=y;
                end
            end
            K=sortrows(K);
            for tmp=2:size(K,1)
                RADON(n,count1)=RADON(n,count1)+dist(K(tmp-1,:),K(tmp,:)')*p(ceil(K(tmp,1)),max(ceil(K(tmp,2)),ceil(K(tmp-1,2))));
            end
        end
    elseif rem(theta,360)==270
        RADON(:,count1)=sum(p,2)';
    else
        RADON(:,count1)=fliplr(sum(p,2)');
    end
end
toc
end