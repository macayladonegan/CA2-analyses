function [r,edge_corrector] = rate_estimator(spkx,spky,x,y,invh,posx,posy,post)
% edge-corrected kernel density estimator

conv_sum = sum(gaussian_kernel(((spkx-x)*invh),((spky-y)*invh)));
edge_corrector =  trapz(post,gaussian_kernel(((posx-x)*invh),((posy-y)*invh)));
%edge_corrector(edge_corrector<0.15) = NaN;
r = (conv_sum / (edge_corrector + 0.0001)) + 0.0001; 