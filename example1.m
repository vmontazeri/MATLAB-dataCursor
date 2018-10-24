% Example usage of the dataCursor function. 
% The following data is a subset of the Hillenbrand 
% data set. http://homepages.wmich.edu/~hillenbr/voweldata.html
% Make sure to have this file, 'vowdata.txt', and the folder 'stimuli' in the same 
% directory. 

%% Example 1:

clear; 
close all; 

addpath( ['.' filesep 'stimuli'] );

vowdata = readtable('vowdata.txt');
% set the column names 
vowdata.Properties.VariableNames= ...
    {'filenames', 'dur', 'f0s', 'F1s', 'F2s', 'F3s', 'F4s', 'F1_20', 'F2_20', 'F3_20', 'F1_50', 'F2_50', 'F3_50', 'F1_80', 'F2_80', 'F3_80', 'undefined' };

% plot the column F1_50 versus column F2_50
fig = figure;
plot( vowdata.F1_50, vowdata.F2_50, '.', 'MarkerSize', 10 )
title('A subset of Hillenbrand dataset. Click on any data-point')
xlabel('F1(Hz)');
ylabel('F2(Hz)');
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')

% Customize the data cursor behavior using the 
% dataCursor function.
% In addition to the F1_50 and F2_50 values, the
% data tip shows the 'filenames' and 'dur' columns corresponding
% to each clicked data point. 
% In addition, the wavfile corresponding to each clicked point is
% played. 
dataCursor(fig, vowdata, {'F1_50', 'F2_50'}, {'filenames', 'dur'}, ...
    'file_name=vowdata.filenames(selected_point); [d,fs] = audioread([char(file_name) ''.wav'']); soundsc(d,fs);');
