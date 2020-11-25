videos=ls('D*.wmv');

for jj=1:length(videos)
    thisvid=videos(jj,1:end);thisvid=strtrim(thisvid);
    [~,baseFile,ext]=fileparts(thisvid);
    a=VideoReader(thisvid);
    mkdir(baseFile);cd(baseFile)
    tic
for img = 1:a.NumberOfFrames
    filename=strcat('frame',num2str(img),'.jpg');
    b = read(a, img);
    imwrite(b,filename);
    clear memory
end
toc
cd ..
end

%% 
function [starttime, xyt] = webcamtest()

folder = '/Users/tobiasbock/Desktop/mousevid/';

filename1 = '2018-04-09 17-29-59.924 ';
filename3 = '.jpg';


    

Scaling  = 1; % Image scaling/binning
MaxFPS = 30; % What is the maximum FPS (if you are not sure, use large value here)
Time = 85; % Time of recording/tracking
BinaryThreshold = 0.5; % the threshold for the binary image, needs to be calibrated to your setup
ref = imread([folder 'reference.jpg']);
ref = ref([40:150],[215:365],:);

fig1 = figure;
figref = figure('visible','off');

xyt = NaN(Time * MaxFPS * 1.2, 3); % set up the output matrix size (1.2 is a margin for error)
Roi = [20,50,20,40]*Scaling; % Boundaries of your region of interest going: [low x, high x, low y, high y] edge coordinates

starttime = datetime; % record starting time
i = 1; % set up the loop counter
fi = 1000;
t0 = clock; % set up clock reference
while etime(clock, t0) < Time
    filenameall = [folder filename1 char(num2str(fi,'%05d')) filename3];
    img = imresize(imread(filenameall),Scaling); % acquire image
    img = img([40:150],[215:365],:);
    img2 = img;
    figref;
    imd = imshowpair(img,ref,'diff');
    img = imd.CData;
    BW = imbinarize(imgaussfilt(adapthisteq(img),2*Scaling),0.7); % image processing

%     ------------- Show Image ------------- Comment out if you don't want to show the image
fig1   ; 
hold off % get rid of last frame
    imshow(imresize(img2,8/Scaling)); % plot image (in the original size)
    hold on
    roiplot = plot([Roi(1),Roi(1),Roi(2),Roi(2),Roi(1)]*8/Scaling,[Roi(3),Roi(4),Roi(4),Roi(3),Roi(3)]*8/Scaling); % plot ROI
    set(roiplot,'LineWidth',3);

%     --------------------------------------
    
    [~,L] = bwboundaries(BW, 'noholes'); % close holes in regions
    stat = table2array(regionprops('table',L,'centroid','MajorAxisLength','MinorAxisLength')); % get centroids and main axis fits for regions
    if ~isempty(stat) % found at least one region
        regsize = mean(stat(:,[3,4]),2); % calculate region diameters
        regmax = find(regsize == max(regsize),1); % get largest region
        xyt(i,:) = [stat(regmax,1), stat(regmax,2), etime(clock, t0)]; % record centroid

%       ------------- Show Image ------------- Comment out if you don't want to show the image
        plot((stat(regmax,1))*8/Scaling, (stat(regmax,2)*8)/Scaling,'-r*'); % plot centroid marker
    drawnow
        %       --------------------------------------
        xyt(i,3) = etime(clock, t0); % record the time in case of tracking failure
        warning(strcat('Could not track at ', num2str(xyt(i,3)), ' seconds!')); % warn about tracking failure
    end
    i = i+1; % iterate counter
    fi = fi+1;

end
clear img % turn camera and arduino off

xytlastrow = ceil(find(~isnan(xyt'),1,'last')/3); % find the las row of xyt that has actual values (needs to be done since during initialization we created a matrix bigger than what we needed)
xyt = xyt(1:xytlastrow,:); % get rid of leftover NaN rows in xyt
xyt(:,[1,2]) = xyt(:,[1,2])/Scaling;

% ------------- Show Image ------------- Comment out if you don't want to show the image
close gcf;
% --------------------------------------
