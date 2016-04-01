%% MAIN FUNCTION HW1 Q3, COURSE 0512-4263, TAU 2016
%
%
% YOU ARE REQUIRED TO WRITE THE FUNCTIONS:
%
% myHarrisCornerDetector
% createCornerPlots
%
% myHarrisCornerDetector accepts an image, and returns a binary matrix (same size as
% the original image dimensions) with '1' denoting corner pixels and '0'
% denoting all other pixels.
%
% createCornerPlots creates a plot with 2 subplots (on the left show I_1
% with the corner points and on the right show I2 with the corner points).
%
% IMPORTANT - DO NOT USE ANY FIGURE COMMANDS, ONLY SUBPLOT.
%             SETTING ANOTHER figure COMMAND WILL MESS UP THE SAVING
%             PROCESS AND YOU WILL LOSE POINTS IF THAT HAPPENS!
%
% YOU MUST FILL IN YOUR GROUP ID IN THE FOLLOWING FORMAT: GROUP_XX_YY
% WHERE XX = 02 or 03 or 04
% YY = YOUR COMPUTER NUMBER (01,02,...,12)
% FILL THE VALUE FOR PARAMETER ID IN LINE #29!
% MAKE SURE IT IS IN STRING FORMAT. FOR EXAMPLE: ID = 'GROUP_02_11';
%%
clearvars; clc; close all;

ID = 'GROUP_04_02'; % FILL IN YOUR ID AS A *STRING* OF 9 CHARACTERS

% % CREATE CHECKERBOARD IMAGE
I1 = 255*uint8(checkerboard(50,4,4)>0.5);
% % LOAD ATTACHED IMAGE
I2 = imread('I2.jpg');

% CALL YOUR FUNCTION TO FIND THE CORNER PIXELS
I1_CORNERS = myHarrisCornerDetector(I1,0.05,1e1);
I2_CORNERS = myHarrisCornerDetector(I2,0.05,1e6);

figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'Name','Harris Corner Detection Results');

% CALL YOUR FUNCTION TO CREATE THE PLOT
createCornerPlots(I1 , I1_CORNERS , I2 , I2_CORNERS);

print(1, '-djpeg', '-r300','-noui',strcat('Q3_',ID,'.jpg'));
