%将下面的路径设置为你的MatconvNet安装路径
addpath C:\Users\Even\Desktop\matconvnet-1.0-beta25\matlab
run vl_setupnn;
datadir='data';
opts.expDir = fullfile(vl_rootnn, 'data', 'plate-baseline') ;
opts.imdbPath = fullfile(opts.expDir, 'imdb.mat');