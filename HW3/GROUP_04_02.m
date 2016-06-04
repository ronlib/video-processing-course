%% MAIN FUNCTION HW 3, COURSE 0512-4263, TAU 2016
%
%
% PARTICLE FILTER TRACKING
%
% THE PURPOSE OF THIS ASSIGNMENT IS TO IMPLEMENT A PARTICLE FILTER TRACKER
% IN ORDER TO TRACK A RUNNING PERSON IN A SERIES OF IMAGES.
%
% IN ORDER TO DO THIS YOU WILL WRITE THE FOLLOWING FUNCTIONS:
%
% compNormHist.m
% INPUT  = I (image) AND s (1x6 STATE VECTOR, CAN ALSO BE ONE COLUMN FROM S)
% OUTPUT = normHist (NORMALIZED HISTOGRAM 16x16x16 SPREAD OUT AS A 4096x1
%                    VECTOR. NORMALIZED = SUM OF TOTAL ELEMENTS IN THE HISTOGRAM = 1)
%
%
% predictParticles.m
% INPUT  = S_next_tag (previously sampled particles)
% OUTPUT = S_next (predicted particles. weights and CDF not updated yet)
%
%
% compBatDist.m
% INPUT  = p , q (2 NORMALIZED HISTOGRAM VECTORS SIZED 4096x1)
% OUTPUT = THE BHATTACHARYYA DISTANCE BETWEEN p AND q (1x1)
%
% IMPORTANT - YOU WILL USE THIS FUNCITON TO UPDATE THE INDIVIDUAL WEIGHTS
% OF EACH PARTICLE. AFTER YOU'RE DONE WITH THIS YOU WILL NEED TO COMPUTE
% THE 100 NORMALIZED WEIGHTS WHICH WILL RESIDE IN VECTOR W (1x100)
% AND THE CDF (CUMULATIVE DISTRIBUTION FUNCTION, C. SIZED 1x100)
% NORMALIZING 100 WEIGHTS MEANS THAT THE SUM OF 100 WEIGHTS = 1
%
%
% sampleParticles.m
% INPUT  = S_prev (PREVIOUS STATE VECTOR MATRIX), C (CDF)
% OUTPUT = S_next_tag (NEW X STATE VECTOR MATRIX)
%
%
% showParticles.m
% INPUT = I (current frame), S (current state vector)
%         W (current weight vector), i (number of current frame)
%         ID (GROUP-XX-YY as set in line #48)
%
% CHANGE THE CODE IN LINES 48, THE SPACE SHOWN IN LINES 73-74 AND 91-92
%
%
%%
close all; clc; clearvars;
ID = 'GROUP-XX-YY'; % FIX THIS LINE - LEAVE IT AS A STRING!

% SET NUMBER OF PARTICLES
N = 100;

% Initial Settings
% Using fullfile in order to support Matlab under Linux
images = dir(fullfile('Images', '*.png'));
s_initial = [297   % x center
    139    % y center
    16     % half width
    43     % half height
    0      % velocity x
    0   ]; % velocity y

% CREATE INITIAL PARTICLE MATRIX 'S' (SIZE 6xN)
S = predictParticles(repmat(s_initial, 1, N));

% LOAD FIRST IMAGE
I = imread([fullfile('Images', images(1).name)]);
S = filterParticles(I, S);

% COMPUTE NORMALIZED HISTOGRAM
q = compNormHist(I,s_initial);

% COMPUTE NORMALIZED WEIGHTS (W) AND PREDICTOR CDFS (C)
% YOU NEED TO FILL THIS PART WITH CODE LINES:
[C,W] = compute_weight_cdf(q,S,I);

%% MAIN TRACKING LOOP

for i=2:length(images)
    S_prev = S;
    % LOAD NEW IMAGE FRAME
    I = imread([fullfile('Images', images(i).name)]);

    % SAMPLE THE CURRENT PARTICLE FILTERS
    S_next_tag = sampleParticles(S_prev,C);

    % PREDICT THE NEXT PARTICLE FILTERS (YOU MAY ADD NOISE)
    S_next = predictParticles(S_next_tag);
    S_next = filterParticles(I, S_next);

    % COMPUTE NORMALIZED WEIGHTS (W) AND PREDICTOR CDFS (C)
    % YOU NEED TO FILL THIS PART WITH CODE LINES:
    [C,W] = compute_weight_cdf(q,S_next,I);

    % SAMPLE NEW PARTICLES FROM THE NEW CDF'S
    S = sampleParticles(S_next,C);

    % CREATE DETECTOR PLOTS
    if (mod(i,10)==0)
        showParticles(I,S_next,W,i,'GROUP-04-02');
    end
end
