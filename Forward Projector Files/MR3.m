function RADON = MR3(num,th)
p=phantom(num);
RADON=zeros(num,length(th));
count=0;

x=repmat((0.01:0.01:num)',1,num);
n=repmat(1:num,num*100,1);

%load y_index_para.mat

%disp('load completed');
tic
for theta=th
    
    rad=theta*pi/180;
    num2=num/2;
    costh=cos(rad);
    tanth=tan(rad);
    q=num2+(n-num2-0.5)/costh;
    
    count=count+1;
    if rem(theta,360)~=90 && rem(theta,360)~=270
%         tic
        A=zeros(num*100,num);
%         toc
%         tic
        y=tanth*(x-num2)+q;
%         toc
%         tic
        index=find(y>0 & y<=100);
%         toc
%         tic
        A(index)=p(ceil(x(index))+num*(ceil(y(index))-1));
%         toc
%         tic
        RADON(:,count)=sum(A)'./abs(costh)/100;
%         toc
    elseif rem(theta,360)==270
        RADON(:,count)=sum(p,2)';
    else
        RADON(:,count)=fliplr(sum(p,2)');
    end
    %index_array{count}=index;
    %y_array{count}=y;
end
toc
%save('y_index_para.mat','index_array','y_array','-v7.3');

end