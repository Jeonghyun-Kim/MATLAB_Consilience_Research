num=300;
view = 360;
sino = zeros(num,view);
i = 0;
tic
for theta = 0:2*pi/view:2*pi*(view-1)/view
    i = i+1;
    sino(:,i) = NMR3(100,phantom(100),80.7,80.3,num,1,theta);
end
toc
figure,imshow(sino,[]);
