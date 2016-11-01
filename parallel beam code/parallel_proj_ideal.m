function proj=parallel_proj_ideal(base_dx,base_dy,base_sx,base_sy,det_spacing,xc,yc,r,view)

source_let=det_spacing/5;
det_let=det_spacing/5;

n=0;

for theta=0:2*pi/view:(1-1/view)*pi*2
    n=n+1;
    for m=1:max(size(base_sy))
        base_sy1=-2*source_let+base_sy(m):source_let:2*source_let+base_sy(m);
        base_dy1=-2*det_let+base_dy(m):det_let:base_dy(m)+2*det_let;
        %keyboard
        for k=1:5
            [sx1,sy1]=rotation(base_sx,base_sy1(k),theta);
            sx(k)=sx1;
            sy(k)=sy1;
            [dx1,dy1]=rotation(base_dx,base_dy1(k),theta);
            dx(k)=dx1;
            dy(k)=dy1;
        end
        count=0;
        for nn=1:5
            for mm=1:5
                count=count+1;
                temp(count)=projection(dx(mm),dy(mm),sx(nn),sy(nn),xc,yc,r);
            end
        end
        
        proj(m,n)=mean(temp);
        %mean(temp)
        %keyboard
    end
end
