function [data] = read_ntt_files(fname)        


% Step 1: identify file type
L = length(fname);
ftype = lower(fname(L-2:L));

% Step 2: read in data from header
disp(fname);
fid = fopen(fname);
a = fread(fid,771,'char');
header = char(a');
data.header = header;
%k = strfind(header,'ADBitVolts ');
k = strfind(header,'ADBitVolts');

bytes_per_header = 2^14; %default for all Neuralynx files

bytes_per_block = 304;
offset = 8+4+4+4*8;

%read in data
status = fseek(fid,bytes_per_header,'bof');
data.ts = fread(fid,inf,'*uint64',bytes_per_block-8);

status = fseek(fid,bytes_per_header+offset,'bof');
data.waveforms = reshape(fread(fid,inf,'128*int16=>int16',bytes_per_block-128*2),4,[]);

nspikes = length(data.ts); 

data.waveforms = reshape(data.waveforms,4,32,nspikes);

% convert to double and convert to seconds
data.ts = double(data.ts)./1e6;
data.waveforms = double(data.waveforms);

% close file
status = fclose(fid);
end