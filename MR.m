function RADON = MR(num,th)
p=phantom(num);
RADON=zeros(num,length(th));
count=0;
tic
for theta=th
    count=count+1;
    for n=1:num
        if rem(theta,360)~=90 && rem(theta,360)~=270
            for x=0.01:0.01:num
                y=tan(theta*pi/180)*(x-num/2)+num/2+(n-num/2-0.5)/cos(theta*pi/180);
                if y>0 && y<=num
                    RADON(n,count)=RADON(n,count)+p(min(num,ceil(x)),min(num,ceil(y)))/abs(cos(theta*pi/180))/100;
                end
            end
        elseif rem(theta,360)==270
            RADON(:,count)=sum(p,2)';
        else
            RADON(:,count)=fliplr(sum(p,2)');
        end
    end
end
toc
end