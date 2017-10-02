% This is a template for a random image structure evolution (RISE)
% experiment. Although philosophically inspired by Sadr and Sinha, this
% algorithm will use the minimal phase interpolation technique of Ales,
% Norcia et al so control for contrast transients. Please feel free to
% alter the remainder of this text to give more specifics about your
% experiment.

% Started on XX/XX/20XX
% Current XX/XX/20XX
% <<Current author name>>

% Based on riseTemplate.m
% Michelle Greene
% October 2017

% Basic housekeeping and setup
clear Screen; % important for saving memory
clear all; close all; % memory management and prevents current workspace 
                        % influencing current exp.
rand('twister',sum(100*clock)); % resets random number generator

% Get variable input from participant
prompt = {'Subject number: ', 'Another variable: '}; % fill in as desired
def={'1', 'xxx'};
title = 'Input Variables';
lineNo = 1;
userinput = inputdlg(promp, title, lineNo, def, 'on');

% Interpret participant's entered input
subNum = str2num(userinput{1,1});
otherStuff = userinput{2,1}; % for string inputs
% etc. continue below until all variables are initialized

% Fill in hard coded experimental parameters that do not require
% participant input
presentationTime = % in seconds
blankTime = % for 3 Hz stimulation, presentationTime and blankTime should
            % sum to 333 ms.
numInSeries = % number of RISE images to be presented per trial
experimentalTrials = % how many experimental trials?
catchTrialProp = % proportion of catch trials (0.5 = 50%)

% Define where stimuli are located
sceneDirectory = [pwd, filesep, %%fill this in%%];
sceneList = dir([sceneDirectory, filesep, '*.jpg']); % creates struct of all images
practiceDirectory = %fill in as above. Always good to have a separate ...
% directory of images for practice. This experiment probably only needs 1.
practiceList = % also fill this in
    
% Set up display
window = OpenMainScreen; % function at bottom. This will need to be saved 
% as its own file, or this template will need to be made into a function.
stimRect = CenterRect([0 0 XXX XXX]); % fill in image dimensions. Note that
% the phase interpolation requires square images
Screen('TextFont', window.onScreen, 'Helvetica');
Screen('TextStyle', window.onScreen, 1);
topPriorityLevel = MaxPriority(window.onScreen);
AssertOpenGL;
% This sets a PTB preference to skip some timing tests. A value
% of 0 runs these tests, and a value of 1 inhibits them. This
% should be set to 0 for actual experiments, since it can detect
% timing problems.
Screen('Preference', 'SkipSyncTests', 0);
Screen('Preference', 'VisualDebugLevel', 3);

% Define response keys
KbName('UnifyKeyNames');
responseKey = % fill this in after getting help on KbName

% Set up behavioral data file
dataFileName = 'xxxxxx.csv'; % fill this in with a sensible name!
if ~exist(dataFileName, 'file')
    % add headers
    fileID = fopen(dataFileName, 'a+');
    fprintf(fileID,'%s \n',['xxx, xxx, xxx, xxx, xxx, '...
        'xxx']); % etc: fill in with all variables to save on each trial
    fclose(fileID);
end
dataFormatString = '%d, %s, %6.3f, %d, %s, %2.4f \n'; % change and append

% Write the experimental instructions
instructionString = ['In this experiment, you will see xxx ',...
    'xxx. Your task is to xxxxxxxxxxx ',...
    'xxxxx \n',...
    'If the images are xxxx, press the "', KbName(keys(1)), '" key. If the ',...
    'images are xxxx, press the "', KbName(keys(2)), '" key. ',...
    'Please respond as quickly and accurately as possible. \n\n'...
    'Press the space bar when you are ready to continue'];
% note: participants don't have to press space bar. Any key but escape
% is fine. However, it keeps things simple and keeps folks from searching
% for the "any key". Don't laugh - it's absolutely happened!

% Note: Up until this point, the participant has not seen anything except
% for the gray screen that opens in the OpenMainScreen function. We need
% to send our instructions to the main screen.
DrawFormattedText(window.onScreen, instructionString, 'center', 'center', [0 0 0], 48);
Screen('Flip', window.onScreen,[],1); % instructions on screen now
FlushEvents('KeyDown');
GetChar; % upon key press, instructions go away
Screen('FillRect',window.onScreen,window.bcolor);
Screen('Flip', window.onScreen); % back to gray screen

message = [' XXX tell participant to press key to start practice'];

DrawFormattedText(window.onScreen, message, 'center', 'center', [0 0 0], 70);
Screen('Flip', window.onScreen);
FlushEvents('KeyDown');
GetChar;
WaitSecs(.3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main experimental loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

HideCursor;
Priority(topPriorityLevel); % to ensure the most accurate timing
ListenChar(2);    %  suppress output of keypresses in the command window
% Note: it's good to comment out the previous line when debugging because
% if your program crashes, you will have a "dead" keyboard that you'll need
% to CTRL-C and SCA out of.
clearTextureFlag = 0; % memory management: do we have to clear the background texture?

% start with a practice trial
for practice = 1:-1:0 % boolean toggle
    if practice
        blockMessage = 'practice ';
        nTrials = legnth(practiceList);
        stimDirectory = practiceDirectory;
        thisList = practiceList;
        presTime = presentationTime; % change if slower practice desired
    else
        blockMessage = 'experimental ';
        nTrials = experimentalTrials;
        stimDirectory = sceneDirectory;
        thisList = sceneList;
        presTime = presentationTime;
    end
    
    % screen goes blank
    Screen('FillRect',window.onScreen,window.bcolor);
    Screen('Flip',window.onScreen);
    
    % ready, set, go!
    nTrialString = num2str(nTrials);
    message = [' Press any key to begin ', nTrialString, ' ', blockMessage, 'trials'];
    DrawFormattedText(window.onScreen, message, 'center', 'center', [0 0 0], 70);
    Screen('Flip', window.onScreen);
    FlushEvents('KeyDown');
    GetChar;
    WaitSecs(.3);
    
    % randomize the images
    % Note: this assumes that all conditions within a directory are
    % balanced (for example, if task is categorization that there are equal
    % numbers of images in each category). If this is not the case, come
    % talk to me about how to balance the experiment.
    thisList = Shuffle(thisList);
    
    while nTrials>0 % counts down
        if rand<catchTrialProp
            trialType = 0; % this is a catch trial
        else
            trialType = 1;
        end
        
        if trialType
        
        % load the appropriate image
        imname = thisList(trial).name;
        thisImage = imread([sceneDirectory, filesep, imname]);
        
        % process the image
        thisImage = % here make square and equal to size in line 53
        thisImage = % make the image grayscale
        
        % create the RISE sequence
        % minPhaseInterp needs a start point and an end point. The start
        % point is a fully phase-randomized version of the image. Create a
        % function that will do this and this will be your start. thisImage
        % will be your end point, and you will also give a sequence vector
        % indicating your step sizes.
        
        % first, get a starting image
        % now call minPhaseInterp.m calling the sequence trialSequence
        else % these are the catch trials
            trialSequence(:,:,num) = % call phasescramble. Note: num is number of steps
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%
        % Trial sequence
        %%%%%%%%%%%%%%%%%%%%%
        response = 9000; % default value until real response given
        
        % show a fixation point for 200 msec
        Screen('FillRect',window.onScreen,0,[window.centerX-5 window.centerY-5 window.centerX+5 window.centerY+5]); % fixation pt
        Screen('Flip', window.onScreen,[],1);
        WaitSecs(.2); % deterministic
        
        % screen goes blank
        Screen('FillRect',window.onScreen,window.bcolor);
        Screen('Flip',window.onScreen);
        
        % first, clear any existing textures to save memory
        if clearTextureFlag
            Screen('Close',imageTexture);
            Screen('Close',maskTexture);
        else
            clearTextureFlag = 1;
        end
        
        % loop through all images in the RISE sequence
        for image = 1:size(trialSequence,3)
            thisImage = trialSequence(:,:,image);
            imageTexture = Screen('MakeTexture', window.onScreen, thisImage);
            for repeat = 1:3 % repeat the same level 3x
                Screen('DrawTexture',window.onScreen,imageTexture,[],stimRect);
                [onTime]=Screen('Flip',window.onScreen);
                WaitSecs(presentationTime);
                Screen('FillRect',window.onScreen,window.bcolor);
                [offTime] = Screen('Flip',window.onScreen);
                WaitSecs(blankTime)
                % check to see if participant made a response
                FlushEvents('keyDown');
                [keyIsDown,secs,keyCode]=KbCheck;
                responseImage = image; % denotes which step was recognizable
            end
        end
        
        % screen goes blank
        Screen('FillRect',window.onScreen,window.bcolor);
        Screen('Flip',window.onScreen);
 
        
        % save the data on each trial
        dataFile = fopen(dataFileName, 'a');
        fprintf(dataFile, dataFormatString, xxx, xxx, xxx, xxx,...
            xxx, xxx, totalxxxTime, xxx, xxx); % fill in based on above
        fclose('all');
        
        if trialType
            numTrials = numTrials - 1; % counting down the number of real trials
        end
        
    end
end

DrawFormattedText(window.onScreen, 'Thanks for participating!', 'center', 'center', [0 0 0]);
Screen('Flip', window.onScreen);
WaitSecs(2);
Screen('CloseAll');

% Close it out
Screen('CloseAll');

function window = openMainScreen

% display requirements (resolution and refresh rate)
window.requiredRes  = [];
window.requiredRefreshrate = [];

%basic drawing and screen variables
window.gray        = 127;
window.black       = 0;
window.white       = 255;
window.fontsize    = 32;
window.bcolor      = window.gray;

%open main screen, get basic information about the main screen
screens=Screen('Screens'); % how many screens attached to this computer?
window.screenNumber=max(screens); % use highest value (usually the external monitor)
window.onScreen=Screen('OpenWindow',window.screenNumber, 0, [], 32, 2); % open main screen
[window.screenX, window.screenY]=Screen('WindowSize', window.onScreen); % check resolution
window.screenDiag = sqrt(window.screenX^2 + window.screenY^2); % diagonal size
window.screenRect  =[0 0 window.screenX window.screenY]; % screen rect
window.centerX = window.screenRect(3)*.5; % center of screen in X direction
window.centerY = window.screenRect(4)*.5; % center of screen in Y direction

% set some screen preferences
[sourceFactorOld, destinationFactorOld]=Screen('BlendFunction', window.onScreen, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
Screen('Preference','VisualDebugLevel', 0);

% get screen rate
[window.frameTime nrValidSamples stddev] =Screen('GetFlipInterval', window.onScreen, 60);
window.monitorRefreshRate=1/window.frameTime;

% paint mainscreen bcolor, show it
Screen('FillRect', window.onScreen, window.bcolor);
Screen('Flip', window.onScreen);
Screen('FillRect', window.onScreen, window.bcolor);
Screen('TextSize', window.onScreen, window.fontsize);
