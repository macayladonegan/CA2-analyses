function v = velocityLinear(x,t)

N = length(x);
v = zeros(N,1);

for ii = 2:N-1
    v(ii) = abs(x(ii+1)-x(ii-1))/(t(ii+1)-t(ii-1));
end