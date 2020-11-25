function [CorrectTrain,CorrectTest,model] = DecodeInteraction(group1,group2,labels1,labels2,numChunks,Optimize)

    if length(group1) > length(group2)
        group1=group1(:,1:length(group2));
        labels1=labels1(:,1:length(labels2));
    elseif length(group2) > length(group1)
        group2=group2(:,1:length(group1));
        labels2=labels2(:,1:length(labels1));
    end
    
    if isempty(group2)
        CorrectTrain=[NaN NaN NaN NaN NaN];
        CorrectTest=[NaN NaN NaN NaN NaN;
                    NaN NaN NaN NaN NaN;
                    NaN NaN NaN NaN NaN;
                    NaN NaN NaN NaN NaN;
                    NaN NaN NaN NaN NaN];
        model=NaN;
    else
    
    
    dd=size(group1);
    cc=size(group2);
    if dd(2)<cc(2)
    DIV=floor(dd(2)/numChunks);
    else
    DIV=floor(cc(2)/numChunks);
    end
    for cc=1:numChunks
        Chunks1{cc}=group1(:,DIV*cc-DIV+1:DIV*cc);
        Labels1{cc}=labels1(:,DIV*cc-DIV+1:DIV*cc);
    end
    %DIV=floor(length(group2)/numChunks);
    for cc=1:numChunks
        Chunks2{cc}=group2(:,DIV*cc-DIV+1:DIV*cc);
        Labels2{cc}=labels2(:,DIV*cc-DIV+1:DIV*cc);
    end
    
for uu=1:numChunks
    tmp1=Chunks1;tmp2=Chunks2;
    %% change this to be 4 of the sessions
    catmat=[1:numChunks];catmat(uu)=[];
    trainChunk=horzcat(Chunks1{catmat},Chunks2{catmat});trainGs=horzcat(Labels1{catmat},Labels2{catmat});

            model = fitcsvm(trainChunk',trainGs,'KernelFunction','linear');
            
        for yy=1:numChunks
        if yy==uu
            [Labels, Scores]=predict(model,trainChunk');
            numCorrect=find(Labels==trainGs');
            CorrectTrain(uu)=length(numCorrect)/length(trainGs);
        else
            testChunk=horzcat(Chunks1{yy},Chunks2{yy});
            testGs=horzcat(Labels1{yy},Labels2{yy});
            [Labels, Scores]=predict(model,testChunk');
            numCorrect=find(Labels==testGs');
            CorrectTest(uu,yy)=length(numCorrect)/length(testGs);
        end
    end
    
    end
end
close all; clear memory
end

