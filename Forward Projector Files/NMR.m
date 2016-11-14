function RADON = NMR(num,th,den)
p=zeros(num*1.5);
p(ceil(num*0.25):ceil(num*0.25)+num-1,ceil(num*0.25):ceil(num*0.25)+num-1)=phantom(100);
RADON=zeros(num,length(th));
count=0;
x=repmat(25.01:den:125,num,1);
y=repmat((25.5:124.5)',1,num/den);
tic
for theta=th
    count=count+1;
    rad=theta*pi/180;
    x_rot=cos(rad)*(x-75)-sin(rad)*(y-75)+75;
    y_rot=sin(rad)*(x-75)+cos(rad)*(y-75)+75;
    RADON(:,count)=sum(p(ceil(x_rot),ceil(y_rot)),2)*den;
end
toc
end