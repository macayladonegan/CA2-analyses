function [Avs, StdErr]=timetriggeredraster_nancy(TimeStampsCell,EventTimeStampsON,xlims,binsize,h,option)
if nargin<6
    option=1;
end
if nargin<4 || isempty(binsize)
    binsize=.45;
end

if nargin<5 || isempty(h)
    h=zeros(1,2);
h(1)=subplot(2,1,1);
else
subplot(h(1))
end
[binnedspikedata]=histc(TimeStampsCell, min(TimeStampsCell):binsize:max(TimeStampsCell));
[Avs, StdErr] = TimeTriggeredAv(binnedspikedata, min(TimeStampsCell):binsize:max(TimeStampsCell), 1./binsize, abs(xlims(1))*1e3, xlims(2)*1e3,EventTimeStampsON);
 bar(linspace(xlims(1),xlims(2),length(Avs)),Avs/binsize)%original line,
% bar([xlims(1):binsize:xlims(2)],Avs/binsize, 'histc')%replacing line above to avoid having a bar with - and + value centered in 0

box off
set(gca,'TickDir','out')
xlim(xlims)
% ylim([5 23]);
ylabel('Firing Rate (Hz)')
xlabel('time (s)')
title('Time Triggered Average')
if nargin<5
h(2)=subplot(2,1,2);
else
subplot(h(2))
end
% for trialnum=1:length(EventTimeStampsON)
%     zeroedraster=TimeStampsCell(1:option:end)-EventTimeStampsON(trialnum);
%     rasterplot_atheir(trialnum,zeroedraster(zeroedraster<xlims(2) & zeroedraster>xlims(1)));
% end
box off
axis off
set(gca,'TickDir','out')
set(gca,'YTick',[])
linkaxes(h,'x')
xlim(xlims)
end