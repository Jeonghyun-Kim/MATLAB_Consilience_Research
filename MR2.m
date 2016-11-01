function RADON = MR2(num,th)
p=phantom(num);
RADON=zeros(num,length(th));
count=0;
% load index_para.mat
for theta=th
    
    rad=theta*pi/180;
    
    count=count+1;
    if rem(theta,360)~=90 && rem(theta,360)~=270
        x=0.01:0.01:num;
        for n=1:num
            y=tan(rad)*(x-num/2)+num/2+(n-num/2-0.5)/cos(rad);
            index=find(y>0 & y<=num);
            RADON(n,count)=sum(p(ceil(x(index))+num*(ceil(y(index))-1)))./abs(cos(rad))/100;
        end
    elseif rem(theta,360)==270
        RADON(:,count)=sum(p,2)';
    else
        RADON(:,count)=fliplr(sum(p,2)');
    end
%     index_array{count}=index;
end

% save('index_para.mat','index_array','-v7.3');
end