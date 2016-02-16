function [ im_out ] = toy_reconstruct( s )
%TOY_RECONSTRUCT 

[height, width] = size(s);
pixel_count = height*width;
im2var = zeros(height, width);
im2var(1:pixel_count) = 1:pixel_count; 

% 2 equations for each pixel + the extra objective 3 for pix(1,1)
num_equations = 2*pixel_count + 1;
%                       m equations   n variables
A = sparse([], [], [], num_equations, pixel_count);
b = zeros(num_equations, 1);

% Objective 1
e = 1; % equation counter
for y = 1:height
    for x = 1:width-1
        A(e, im2var(y,x+1)) = 1;
        A(e, im2var(y,x)) = -1;
        b(e) = s(y,x+1)-s(y,x);  
        e = e+1;
    end  
end

% Objective 2
for y = 1:height-1
    for x = 1:width
        A(e, im2var(y+1,x)) = 1;
        A(e, im2var(y,x)) = -1;
        b(e) = s(y+1,x)-s(y,x);  
        e = e+1;
    end  
end

% Objective 3
A(e, im2var(1,1)) = 1;
b(e) = s(1,1);

% Solve
v = A\b;
im_out = reshape(v, [height width]);
imshow(im_out);

end

