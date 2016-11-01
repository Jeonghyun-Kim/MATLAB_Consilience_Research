function RADON=MR5(num,th)
p=phantom(num);
RADON=zeros(num,length(th));
count1=0;
tic
for theta=th
    count1=count1+1;
    if rem(theta,360)~=90 && rem(theta,360)~=270
        x1=repmat((0:num)',1,num);
        y2=repmat((0:num)',1,num);
        n=repmat(1:num,num+1,1);
        y1=tan(theta*pi/180)*(x1-num/2)+num/2+(n-num/2-0.5)/cos(theta*pi/180);
        x2=(y2-(n-num/2-0.5)/cos(theta*pi/180)-num/2)/tan(theta*pi/180)+num/2;
        x=[x1;x2];
        y=[y1;y2];
        for tmp=1:num
            K(:,2*tmp-1)=x(:,tmp);
            K(:,2*tmp)=y(:,tmp);
            K(:,2*tmp-1:2*tmp)=sortrows(K(:,2*tmp-1:2*tmp));
        end
        keyboard
    end
end
toc
end