%�������·������Ϊ���MatconvNet��װ·��
addpath C:\Users\Even\Desktop\matconvnet-1.0-beta25\matlab
run vl_setupnn;
datadir='data';
opts.expDir = fullfile(vl_rootnn, 'data', 'plate-baseline') ;
opts.imdbPath = fullfile(opts.expDir, 'imdb.mat');