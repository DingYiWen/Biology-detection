% netpath=[opts.expDir '/net-epoch-50.mat'];
% if not (exist(netpath))
%     cnn_plate;
% end
% class=1;index=1;
% %datadir='data';
% subdir=dir(datadir);
%  imgfiles=dir(fullfile(datadir,subdir(class+2).name));
% img=imread(fullfile(datadir,subdir(class+2).name,imgfiles(index+2).name));
img=imread('C:\Users\Even\Desktop\matconvnet-1.0-beta25\MatConvNet-oneclick-master\data\0\10.jpg');
imshow(img);
net=load('C:\Users\Even\Desktop\matconvnet-1.0-beta25\data\plate-baseline\imagenet-vgg-f.mat');
%net=net.net;
im_=single(img);
im_=imresize(im_,net.meta.normalization.imageSize(1:2));
im_=im_ - net.meta.normalization.averageImage;
%opts.batchNormalization = false ;
net.layers{end}.type = 'softmax';

try
res=vl_simplenn(net,im_);
scores=squeeze(gather(res(end).x));
[bestScore,best]=max(scores);
str=[num2str(bestScore) ':' num2str(bestScore)];
catch
    str="error";
end
title(sprintf('%s %d,%.3f',...
net.meta.classes.description{best},best,bestScore));

%title(str);
disp(str);