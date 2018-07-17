

 clear;
 close all;
 clc;

 tic
 
% 读取原视频
avi = VideoReader('mice2.mp4');
%im = imread('rbt.jpg');
% setup MatConvNet  
%run  matlab/vl_setupnn   
% load the pre-trained CNN  
% net = load('imagenet-vgg-f.mat') ;  
% net = vl_simplenn_tidy(net) ;  

%avi.NumberOfFrames
% 显示原视频
for bi = 1:1000
      currentImg=rgb2gray(read(avi, bi));
      figure(1);
      imshow(currentImg);         %显示原视频
 if rem(bi,1)==0    
     
  if max(max(currentImg))-min(min(currentImg))>30   %剔除灰度无变化的图像   
    I=currentImg; 

I1=im2bw(255-I,0.7)-im2bw(255-I,0.9);
imLabel = bwlabel(I1,8);% 对连通区域进行标记  
stats = regionprops(imLabel,'Area');  
[b,index]=sort([stats.Area],'descend');  %b代表着面积
[m1 n1]=size(b);
itemp=1;
for i=1:n1
    if b(m1,i)>3000 && b(m1,i)<20000
        Df(itemp)=i;  %Df存储所有有效连通域的索引值
        itemp=itemp+1;
    end
end

bw=zeros(720,1280);
if exist('Df','var')
    n2=length(Df);
    rt=cell(1,n2);
    for j=1:n2    %遍历所有的连通域
    %第j个有效连通域
    dj=ismember(imLabel,index(Df(j)));
    %bw=bw+dj;
    %获取区域的'basic'属性， 'Area', 'Centroid', and 'BoundingBox'   
    stats = regionprops(dj, 'basic');  
    rt{1,j}=[stats(1).BoundingBox];
    end

    hold on  
    %绘制感兴趣区域
    for i=1:n2   
     left=abs(int16(rt{1,i}(1,1))-15);  %稍微扩大截选区域，但是为防止出现负值取绝对值
     right=int16(left+rt{1,i}(1,3))+15;
     bottom=abs(int16(rt{1,i}(1,2))-15);
     top=int16(bottom+rt{1,i}(1,4))+15;
  %   Ix=currentImg(bottom:top,left:right);
     
%      im = imread('rbt.jpg');
%      im_ = single(im) ; % note: 0-255 range  
%      im_ = imresize(im_, net.meta.normalization.imageSize(1:2)) ;  
%      im_ = bsxfun(@minus, im_, net.meta.normalization.averageImage) ;  
%      % run the CNN  
%      res = vl_simplenn(net, im_) ;  
%      % show the classification result  
%      scores = squeeze(gather(res(end).x)) ;  
%      [bestScore, best] = max(scores) ;  
%      des=net.meta.classes.description{best};
     
     
     text(rt{1,i}(1,1),rt{1,i}(1,2)-15, sprintf('mice：%d%%', bi), 'FontWeight', 'Bold', 'Color', 'b');
     rectangle('Position',rt{1,i},'LineWidth',2,'LineStyle','--','EdgeColor','r');
     
    end 
    hold off  
end
clear Df;
  end
  
  if ~exist('n2','var')
      n2=0;
  end
 hold on
 text(3, 15, sprintf('跟踪视频：%d帧', bi), 'FontWeight', 'Bold', 'Color', 'r');
 text(3, 35, sprintf('生物数量：%d个', n2), 'FontWeight', 'Bold', 'Color', 'r');
 hold off
  
  
end
end
tim=toc




%%  程序结束










