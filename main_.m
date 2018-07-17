 clear;
 close all;
 clc;
 tic
 
% ��ȡԭ��Ƶ
avi = VideoReader('mice2.mp4');
%ֻ����һ�εĳ���
net=load('C:\Users\Even\Desktop\matconvnet-1.0-beta25\data\plate-baseline\imagenet-vgg-f.mat');
%avi.NumberOfFrames
% ��ʾԭ��Ƶ
for bi = 600:850
      RGBCurrent=read(avi, bi);
      currentImg=rgb2gray(RGBCurrent);
      figure(1);
      imshow(RGBCurrent);         %��ʾԭ��Ƶ
    
 if rem(bi,1)==0    
     
  if max(max(currentImg))-min(min(currentImg))>30   %�޳��Ҷ��ޱ仯��ͼ��   
    I=currentImg; 

I1=imbinarize(255-I,0.7)-imbinarize(255-I,0.9);
%imwrite(I1,'spliteImg.bmp');
imLabel = bwlabel(I1,8);% ����ͨ������б��  
stats = regionprops(imLabel,'Area');  
[b,index]=sort([stats.Area],'descend');  %b���������
[m1 n1]=size(b);
itemp=1;
for i=1:n1
    if b(m1,i)>2000 && b(m1,i)<15000
        Df(itemp)=i;  %Df�洢������Ч��ͨ�������ֵ
        itemp=itemp+1;
    end
end

[r,c]=size(currentImg);
bw=zeros(r,c);
if exist('Df','var')
    n2=length(Df);
    rt=cell(1,n2);
    for j=1:n2    %�������е���ͨ��
    %��j����Ч��ͨ��
    dj=ismember(imLabel,index(Df(j)));
    dj=imfill(dj,'holes');  %�׶����
    bw=bw+dj;
    %��ȡ�����'basic'���ԣ� 'Area', 'Centroid', and 'BoundingBox'   
    stats = regionprops(dj, 'basic');  
    rt{1,j}=[stats(1).BoundingBox];
    end
    hold on  
    

   % imwrite(bw,'fillholes.jpg');
    %���Ƹ���Ȥ����
    for i=1:n2   
    
     left=abs(int16(rt{1,i}(1,1)));  %��ȡѡȡ�ֲ�ͼ��ķ�Χ
     right=int16(left+rt{1,i}(1,3));
     bottom=abs(int16(rt{1,i}(1,2)));
     top=int16(bottom+rt{1,i}(1,4));
    if top>r 
        top=r;
    end
    if right>c
        right=c;
    end
     Ix=RGBCurrent(bottom:top,left:right);
     Ix=single(Ix);
     im_=imresize(Ix,net.meta.normalization.imageSize(1:2));
     
     
     im_=im_ - net.meta.normalization.averageImage;
     net.layers{end}.type = 'softmax';


      res=vl_simplenn(net,im_);
      scores=squeeze(gather(res(end).x));
      [bestScore,best]=max(scores);
 
     
    
    if bestScore>0.42
              text(rt{1,i}(1,1),rt{1,i}(1,2)-15, sprintf('Mice��%.1f%%',bestScore*100), 'FontWeight', 'Bold', 'Color', 'b');
           rectangle('Position',rt{1,i},'LineWidth',2,'LineStyle','--','EdgeColor','r');
    else
    rectangle('Position',rt{1,i},'LineWidth',2,'LineStyle',':','EdgeColor','y');  
    end
     bestScore=0;     
  end 
    hold off  
end

    clear Df;
    
  end
  
  if ~exist('n2','var')
      n2=0;
  end
 hold on
 text(3, 15, sprintf('������Ƶ��%d֡', bi), 'FontWeight', 'Bold', 'Color', 'r');
 text(3, 35, sprintf('����������%d��', n2), 'FontWeight', 'Bold', 'Color', 'r');
 hold off
  n2=0;
  
end
end
tim=toc















