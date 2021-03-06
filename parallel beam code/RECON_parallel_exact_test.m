clc
clear

DID=40; SID=-45;
source_spacing=0.1; source_number=256; det_number=source_number;

sy = source_spacing*(source_number/2-0.5):-source_spacing:-source_spacing*(source_number/2-0.5);
sy=sy+source_spacing/4;

sx=SID;
det_spacing=0.1; dy=sy ; dx=DID; view=300;

r=0.1; xc=4; yc=0;

proj=parallel_proj_ideal(sx,sy,dx,dy,det_spacing,xc,yc,r,view);
sample=det_spacing;

m=0;
for n=-(det_number-1):det_number-1
    if n==0
        weight(det_number)=1/4/det_spacing^2;
        m=m+1;
    end
    if mod(n,2)==0 & n~=0
        m=m+1;
        weight(m)=0;
    elseif mod(n,2)~=0 & n~=0
        m=m+1;
        weight(m)=-1/pi^2/n^2/det_spacing^2;
    end
end
weight=weight';

%weight=convn(weight,hanning(3),'same')/sum(hanning(3));
proj_filtered=det_spacing*convn(proj, weight);
det_size=det_spacing;
row=1; multi=1; size_proj=(3*det_number-2);

dy=(det_number/2-0.5)*det_size:-det_size/multi:-(det_number/2-0.5)*det_size-det_size/multi*(multi-1);
dy=dy+det_size/4;


sy=dy;

start_temp=size_proj/2-(det_number/2-1);
start=(start_temp*multi-(multi-1));
z_bound=max(size(det_size*(row-1)/2:-det_size/multi:-det_size*(row-1)/2));
dy=dy(1:z_bound,:);

img_size=256;

pixel_size=sample/2;

recon_x_temp=repmat(-(img_size/2-0.5)*pixel_size:pixel_size:(img_size/2-0.5)*pixel_size,img_size,1);
recon_y_temp=(img_size/2-0.5)*pixel_size:-pixel_size:-(img_size/2-0.5)*pixel_size;
recon_y_temp=repmat(recon_y_temp',1,img_size);

tic
viewcount=0;
matrix=zeros(img_size,img_size);
for theta=0:2*pi/view:(1-1/view)*2*pi
    viewcount=viewcount+1;
    proj_filtered1=interpft(proj_filtered(:,viewcount),size_proj*multi);
    proj_filtered1=proj_filtered1(start:start+multi*det_number-1);
    recon_y=-recon_x_temp.*sin(theta)+recon_y_temp.*cos(theta);
    y_mapped=recon_y(:);

    recon_value=interp1(dy,proj_filtered1,y_mapped);
    recon=reshape(recon_value,img_size,img_size);
    index=find(isnan(recon)==1);
    recon(index)=0;
    matrix=matrix+recon;
end

matrix=matrix*pi/view;

figure
subplot(1,2,1);imshow(matrix,[-0.1 0.1])
subplot(1,2,2); plot(matrix(round(img_size/2),:))
grid


