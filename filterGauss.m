
% usage: out = filterGauss(in, SD);
%
% Filters a spiketrain (ones and zeros, one element per ms) with a gaussian.
% The output is rate (in spikes per ms).
% To convert to spikes/s, multiply by 1000.
%
% For convenience, the output is the same length as the input, but of 
% course the very early and late values are not 'trustworthy'.
%
% same filtering as in 'FilterSpikes' except the output is the same orientation as the input
% also more robust if SD is not an integer
% the input arguments are reversed relative to FilterSpikes
%
function out = filterGauss(in, SD)


%% whatever orientation it cam in, make it a row vector
s = size(in);

if s(1) > 1 && s(2) > 1
    disp('You sent in an array rather than a vector');
    return
end
    
if s(1) > 1   % if it came in as a column vector
    in = in';  % make it a row vector
    flip = true;  % and remember to flip back at the very end
else
    flip = false;
end


%% compute the normalized gaussian kernel
SDrounded = 2 * round(SD/2);  % often we just need SD to set the number of points we keep and so forth, so it needs to be an integer.
gausswidth = 8*SDrounded;  % 2.5 is the default for the function gausswin
F = normpdf(1:gausswidth, gausswidth/2, SD);
F = F/(sum(F));

%% pad, filter
shift = floor(length(F)/2); % this is the amount of time that must be added to the beginning and end;
last = length(in); % length of incoming data
prefilt = [zeros(1,shift)+mean(in(1:SDrounded)), in, (zeros(1,shift)+mean(in(last-SDrounded:last)))]; % pads the beginning and end with copies of first and last value (not zeros)
postfilt = filter(F,1,prefilt); % filters the data with the impulse response in Filter

%% trim, flip orientation if necessary, and send out
if ~flip  % if it came in as a row vector
    out = postfilt(2*shift:length(postfilt)-1);  % Shifts the data back by 'shift', half the filter length
else
    out = postfilt(2*shift:length(postfilt)-1)';  % if it was a column vector flip back.
end
                                               
                                                
