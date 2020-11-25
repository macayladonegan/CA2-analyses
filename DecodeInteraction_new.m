function [CorrectTrain,CorrectT,CorrectT_sh] = DecodeInteraction_new(evsmatrixLInt,Labels,numChunks,optimize)
            
            if optimize==1
                group1=evsmatrixLInt(:,Labels==4);labels1=Labels(:,Labels==4);
                group2=evsmatrixLInt(:,Labels==5);labels2=Labels(:,Labels==5);
                trainChunk=horzcat(group1,group2);
                trainGs=horzcat(labels1,labels2);
                c = cvpartition(size(trainChunk',1),'KFold');
                sigma = optimizableVariable('sigma',[1e-5,1e5],'Transform','log');
                box = optimizableVariable('box',[1e-5,1e5],'Transform','log');
                
                minfn = @(z)kfoldLoss(fitcsvm(trainChunk',trainGs','CVPartition',c,...
                    'KernelFunction','linear','BoxConstraint',z.box,...
                    'KernelScale',z.sigma));
                
                results = bayesopt(minfn,[sigma,box],'IsObjectiveDeterministic',true,...
                    'AcquisitionFunctionName','expected-improvement-plus','Verbose',0,'PlotFcn',[])
                
                z(1) = results.XAtMinObjective.sigma;
                z(2) = results.XAtMinObjective.box;
                clear trainChunk
            


for ii=1:max(Labels)
    for jj=1:max(Labels)
        if ii==jj
        else
        
        group1=evsmatrixLInt(:,Labels==ii);labels1=Labels(:,Labels==ii);
        group2=evsmatrixLInt(:,Labels==jj);labels2=Labels(:,Labels==jj);
        
%         if length(group1) > length(group2)
%             group1=group1(:,1:length(group2));
%             labels1=labels1(:,1:length(labels2));
%         elseif length(group2) > length(group1)
%             group2=group2(:,1:length(group1));
%             labels2=labels2(:,1:length(labels1));
%         end
        
        if isempty(group2)
            CorrectTrain=[NaN NaN NaN NaN NaN];
            CorrectTest=[NaN NaN NaN NaN NaN;
                NaN NaN NaN NaN NaN;
                NaN NaN NaN NaN NaN;
                NaN NaN NaN NaN NaN;
                NaN NaN NaN NaN NaN];
            model=NaN;
        else
            
            DIV=floor(length(group1)/numChunks);
            for cc=1:numChunks
                Chunks1{cc}=group1(:,DIV*cc-DIV+1:DIV*cc);
                Labels1{cc}=labels1(:,DIV*cc-DIV+1:DIV*cc);
            end
            DIV=floor(length(group2)/numChunks);
            for cc=1:numChunks
                Chunks2{cc}=group2(:,DIV*cc-DIV+1:DIV*cc);
                Labels2{cc}=labels2(:,DIV*cc-DIV+1:DIV*cc);
            end
            
            group1_sh=group1(:,randperm(size(group1,2)));
            group2_sh=group2(:,randperm(size(group2,2)));
            
            DIV=floor(length(group1)/numChunks);
            for cc=1:numChunks
                Chunks1_sh{cc}=group1_sh(:,DIV*cc-DIV+1:DIV*cc);
                Labels1{cc}=labels1(:,DIV*cc-DIV+1:DIV*cc);
            end
            DIV=floor(length(group2)/numChunks);
            for cc=1:numChunks
                Chunks2_sh{cc}=group2_sh(:,DIV*cc-DIV+1:DIV*cc);
                Labels2{cc}=labels2(:,DIV*cc-DIV+1:DIV*cc);
            end
            
            end
                for uu=1:numChunks
                    tmp1=Chunks1;tmp2=Chunks2;
                    %% change this to be 4 of the sessions
                    catmat=[1:numChunks];catmat(uu)=[];
                    trainChunk=horzcat(Chunks1{catmat},Chunks2{catmat});trainGs=horzcat(Labels1{catmat},Labels2{catmat});
                    trainChunk_sh=horzcat(Chunks1_sh{catmat},Chunks2_sh{catmat});
                    
                    model = fitcsvm(trainChunk',trainGs,'KernelFunction','linear',...
                        'KernelScale',z(1),'BoxConstraint',z(2));
                    model_sh = fitcsvm(trainChunk_sh',trainGs,'KernelFunction','linear');
                    
                
                for yy=1:numChunks
                    if yy==uu
                        [Labels_mdl, Scores]=predict(model,trainChunk');
                        numCorrect=find(Labels_mdl==trainGs');
                        CorrectTrain(uu)=length(numCorrect)/length(trainGs);
                    else
                        testChunk=horzcat(Chunks1{yy},Chunks2{yy});
                        testChunk_sh=horzcat(Chunks1_sh{yy},Chunks2_sh{yy});
                        testGs=horzcat(Labels1{yy},Labels2{yy});
                        [Labels_mdl, Scores]=predict(model,testChunk');
                        numCorrect=find(Labels_mdl==testGs');
                        [Labels_sh, Scores]=predict(model_sh,testChunk_sh');
                        numCorrect_sh=find(Labels_sh==testGs');
                        CorrectTest(uu,yy)=length(numCorrect)/length(testGs);
                        CorrectTest_sh(uu,yy)=length(numCorrect_sh)/length(testGs);
                    end
                end
                end
                
            CorrectT{ii,jj}=CorrectTest;CorrectT_sh{ii,jj}=CorrectTest_sh;
        end
        clearvars -except evsmatrixLInt Labels numChunks results CorrectT CorrectT_sh z ii jj CorrectTrain
    end
    end
end
clear memory

else
    

end
