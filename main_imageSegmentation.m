

 clear;
 close all;
 clc;

 tic
 
% ��ȡԭ��Ƶ
avi = VideoReader('mice2.mp4');
%im = imread('rbt.jpg');
% setup MatConvNet  
%run  matlab/vl_setupnn   
% load the pre-trained CNN  
% net = load('imagenet-vgg-f.mat') ;  
% net = vl_simplenn_tidy(net) ;  

%avi.NumberOfFrames
% ��ʾԭ��Ƶ
for bi = 1:1000
      currentImg=rgb2gray(read(avi, bi));
      figure(1);
      imshow(currentImg);         %��ʾԭ��Ƶ
 if rem(bi,1)==0    
     
  if max(max(currentImg))-min(min(currentImg))>30   %�޳��Ҷ��ޱ仯��ͼ��   
    I=currentImg; 

I1=im2bw(255-I,0.7)-im2bw(255-I,0.9);
imLabel = bwlabel(I1,8);% ����ͨ������б��  
stats = regionprops(imLabel,'Area');  
[b,index]=sort([stats.Area],'descend');  %b���������
[m1 n1]=size(b);
itemp=1;
for i=1:n1
    if b(m1,i)>3000 && b(m1,i)<20000
        Df(itemp)=i;  %Df�洢������Ч��ͨ�������ֵ
        itemp=itemp+1;
    end
end

bw=zeros(720,1280);
if exist('Df','var')
    n2=length(Df);
    rt=cell(1,n2);
    for j=1:n2    %�������е���ͨ��
    %��j����Ч��ͨ��
    dj=ismember(imLabel,index(Df(j)));
    %bw=bw+dj;
    %��ȡ�����'basic'���ԣ� 'Area', 'Centroid', and 'BoundingBox'   
    stats = regionprops(dj, 'basic');  
    rt{1,j}=[stats(1).BoundingBox];
    end

    hold on  
    %���Ƹ���Ȥ����
    for i=1:n2   
     left=abs(int16(rt{1,i}(1,1))-15);  %��΢�����ѡ���򣬵���Ϊ��ֹ���ָ�ֵȡ����ֵ
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
     
     
     text(rt{1,i}(1,1),rt{1,i}(1,2)-15, sprintf('mice��%d%%', bi), 'FontWeight', 'Bold', 'Color', 'b');
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
 text(3, 15, sprintf('������Ƶ��%d֡', bi), 'FontWeight', 'Bold', 'Color', 'r');
 text(3, 35, sprintf('����������%d��', n2), 'FontWeight', 'Bold', 'Color', 'r');
 hold off
  
  
end
end
tim=toc




%%  �������










