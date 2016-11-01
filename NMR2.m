function RADON = NMR2(num,th,den)

SIZE=round(num*1.5);
EMP=round(num*0.25);
CEN=round(num*0.75);

p=zeros(SIZE);
p(EMP:EMP+num-1,EMP:EMP+num-1)=phantom(num);
RADON=zeros(num,length(th));
count=0;
x=(EMP+den):den:(EMP+num);
tic
for theta=th
    count=count+1;
    rad=theta*pi/180;
    for n=1:num
        y=repmat(EMP-0.5+n,1,num/den);
        x_rot=cos(rad)*(x-CEN)-sin(rad)*(y-CEN)+CEN;
        y_rot=sin(rad)*(x-CEN)+cos(rad)*(y-CEN)+CEN;
        RADON(n,count)=sum(p(size(p,1)*(floor(y_rot)-1)+floor(x_rot)))*den;
    end
end
toc
end