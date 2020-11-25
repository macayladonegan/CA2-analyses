%  Script for importing Nlx CSC files into MATLAB; works for up to 24
%  channels

fields = [1 0 1 0 1];
extractHeader = 1;
extractMode = 1;

if isindir('CSC1.ncs')
    [R.CSC.CSC1_TimeStamps,R.CSC.CSC1_SampleFrequencies,R.CSC.CSC1_Samples, R.CSC.CSC1_Header]=Nlx2MatCSC('CSC1.ncs',fields,extractHeader,extractMode);
    R.CSC.CSC1_TimeStamps = R.CSC.CSC1_TimeStamps./1000000;
end
if isindir('CSC2.ncs')
    [R.CSC.CSC2_TimeStamps,R.CSC.CSC2_SampleFrequencies,R.CSC.CSC2_Samples, R.CSC.CSC2_Header]=Nlx2MatCSC('CSC2.ncs',fields,extractHeader,extractMode);
    R.CSC.CSC2_TimeStamps = R.CSC.CSC2_TimeStamps./1000000;
end
if isindir('CSC3.ncs')
    [R.CSC.CSC3_TimeStamps,R.CSC.CSC3_SampleFrequencies,R.CSC.CSC3_Samples, R.CSC.CSC3_Header]=Nlx2MatCSC('CSC3.ncs',fields,extractHeader,extractMode);
    R.CSC.CSC3_TimeStamps = R.CSC.CSC3_TimeStamps./1000000;
end
if isindir('CSC4.ncs')
    [R.CSC.CSC4_TimeStamps,R.CSC.CSC4_SampleFrequencies,R.CSC.CSC4_Samples, R.CSC.CSC4_Header]=Nlx2MatCSC('CSC4.ncs',fields,extractHeader,extractMode);
    R.CSC.CSC4_TimeStamps = R.CSC.CSC4_TimeStamps./1000000;
end
if isindir('CSC5.ncs')
    [R.CSC.CSC5_TimeStamps,R.CSC.CSC5_SampleFrequencies,R.CSC.CSC5_Samples, R.CSC.CSC5_Header]=Nlx2MatCSC('CSC5.ncs',fields,extractHeader,extractMode);
    R.CSC.CSC5_TimeStamps = R.CSC.CSC5_TimeStamps./1000000;
end
if isindir('CSC6.ncs')
    [R.CSC.CSC6_TimeStamps,R.CSC.CSC6_SampleFrequencies,R.CSC.CSC6_Samples, R.CSC.CSC6_Header]=Nlx2MatCSC('CSC6.ncs',fields,extractHeader,extractMode);
    R.CSC.CSC6_TimeStamps = R.CSC.CSC6_TimeStamps./1000000;
end
if isindir('CSC7.ncs')
    [R.CSC.CSC7_TimeStamps,R.CSC.CSC7_SampleFrequencies,R.CSC.CSC7_Samples, R.CSC.CSC7_Header]=Nlx2MatCSC('CSC7.ncs',fields,extractHeader,extractMode);
    R.CSC.CSC7_TimeStamps = R.CSC.CSC7_TimeStamps./1000000;
end
if isindir('CSC8.ncs')
    [R.CSC.CSC8_TimeStamps,R.CSC.CSC8_SampleFrequencies,R.CSC.CSC8_Samples, R.CSC.CSC8_Header]=Nlx2MatCSC('CSC8.ncs',fields,extractHeader,extractMode);
    R.CSC.CSC8_TimeStamps = R.CSC.CSC8_TimeStamps./1000000;
end


clear fields extractHeader extractMode;

