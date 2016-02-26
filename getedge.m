function h = getedge(n1,s1,n2,s2,theta)
% d2dgauss  Canny edge detection but without suppressing edges
r=[cos(theta) -sin(theta); sin(theta) cos(theta)];

for i = 1:n2 
  for j = 1:n1
    u = r * [j-(n1+1)/2 i-(n2+1)/2]';
    
    g  = exp(-u(1)^2/(2*s1^2)) / (s1*sqrt(2*pi));
    dg = -u(2) * (exp(-u(2)^2/(2*s2^2)) / (s2*sqrt(2*pi))) /s2^2;
    
    h(i,j) = g * dg;
  end
end

h = h / sqrt(sum(sum(abs(h).*abs(h))));

end
