function y = dgauss(x,std)
y = -x * gauss(x,std) / std^2;