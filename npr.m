function [ im_npr ] = npr( im )
%NPR

% Inputs
im_gray = rgb2gray(im);
[ux, uy] = imgradientxy(im_gray);

% Application specific filtering: non-photo realism
% e = edge(im_gray, 'canny', 0.3, 4);
e = edge(im_gray, 'canny');

gx = e .* ux; % Desired pixel-differences: x dir
gy = e .* uy; % Desired pixel-differences: y dir
d  = im;      % Desired pixel values
% wx = 1;       % Weights
% wy = 1;
% wd = 1;

% Using the above constraints, the goal is to solve
%   min_{f} { wx(fx - gx)^2 + wy(fy - gy)^2 + wd(f - d)^2
% to find the output image, f

[height, width, ~] = size(im);
pixel_count = height * width;
num_equations = 5 * pixel_count;
im2var = zeros(height, width);
im2var(1:pixel_count) = 1:pixel_count;

f_rgb = {}; % Output filtered image

for channel = 1:3
  sparse_i = [];
  sparse_j = [];
  sparse_k = [];
  b = zeros(num_equations, 1);
  
  e = 1; % Equation counter
  
  for y = 1:height
    for x = 1:width
      % Up
      if y ~= 1
        sparse_i = [sparse_i e];
        sparse_j = [sparse_j im2var(y,x)];
        sparse_k = [sparse_k 1];
        
        sparse_i = [sparse_i e];
        sparse_j = [sparse_j im2var(y-1,x)];
        sparse_k = [sparse_k -1];
        
        b(e) = (gy(y-1,x));
        e = e + 1;
      end
      
      % Down
      if y ~= height
        sparse_i = [sparse_i e];
        sparse_j = [sparse_j im2var(y,x)];
        sparse_k = [sparse_k 1];
        
        sparse_i = [sparse_i e];
        sparse_j = [sparse_j im2var(y+1,x)];
        sparse_k = [sparse_k -1];
        
        b(e) = (gy(y+1,x));
        e = e + 1;
      end
      
      % Right
      if x ~= width
        sparse_i = [sparse_i e];
        sparse_j = [sparse_j im2var(y,x)];
        sparse_k = [sparse_k 1];
        
        
        sparse_i = [sparse_i e];
        sparse_j = [sparse_j im2var(y,x+1)];
        sparse_k = [sparse_k -1];
        
        b(e) = (gx(y,x+1));
        e = e + 1;
      end
      
      % Left
      if x ~= 1
        sparse_i = [sparse_i e];
        sparse_j = [sparse_j im2var(y,x)];
        sparse_k = [sparse_k 1];
        
        sparse_i = [sparse_i e];
        sparse_j = [sparse_j im2var(y,x-1)];
        sparse_k = [sparse_k -1];
        
        b(e) = (gx(y,x-1));
        e = e + 1;
      end
      
      % wd(f - d)^2
      sparse_i = [sparse_i e];
      sparse_j = [sparse_j im2var(y,x)];
      sparse_k = [sparse_k 1];
      
      b(e) = d(y,x,channel);
      e = e + 1;
    end
  end
  
  A = sparse(sparse_i, sparse_j, sparse_k, num_equations, pixel_count);
  f_rgb{channel} = A\b;
  
end

for c = 1:3
  im_npr(:,:,c) = reshape(f_rgb{c}, [height width]);
end

end

