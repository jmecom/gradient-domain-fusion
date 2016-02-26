function [ im_blend ] = poissonBlend( im_source, mask, im_bg )
%POISSONBLEND

[source_h, source_w, ~] = size(im_source);
[bg_h, bg_w, ~] = size(im_bg);

source_pixel_count = source_h * source_w;
bg_pixel_count = bg_h * bg_w;
im2var = zeros(bg_h, bg_w);
im2var(1:bg_pixel_count) = 1:bg_pixel_count;

v_rgb = {};

for c = 1:3
  sparse_i = [];
  sparse_j = [];
  sparse_k = [];
  b = zeros(bg_pixel_count, 1);
  
  e = 1; % Equation counter
  
  for y = 1:bg_h
    for x = 1:bg_w
      if ~mask(y,x)
        % Just background
        sparse_i = [sparse_i e];
        sparse_j = [sparse_j im2var(y,x)];
        sparse_k = [sparse_k 1];
        
        b(e) = im_bg(y, x, c);
        e = e + 1;
      else
        % Neighbor Equations
        
        if mask(y-1, x)
          sparse_i = [sparse_i e];
          sparse_j = [sparse_j im2var(y-1,x)];
          sparse_k = [sparse_k -1];
        end
        
        if mask(y+1, x)
          sparse_i = [sparse_i e];
          sparse_j = [sparse_j im2var(y+1,x)];
          sparse_k = [sparse_k -1];
        end
        
        if mask(y, x-1)
          sparse_i = [sparse_i e];
          sparse_j = [sparse_j im2var(y,x-1)];
          sparse_k = [sparse_k -1];
        end
        
        if mask(y, x+1)
          sparse_i = [sparse_i e];
          sparse_j = [sparse_j im2var(y,x+1)];
          sparse_k = [sparse_k -1];
        end
        
        sparse_i = [sparse_i e];
        sparse_j = [sparse_j im2var(y,x)];
        sparse_k = [sparse_k 4];

        b(e) = 0;
        b(e) = b(e) + im_source(y,x,c) - im_source(y-1,x,c);
        b(e) = b(e) + im_source(y,x,c) - im_source(y+1,x,c);
        b(e) = b(e) + im_source(y,x,c) - im_source(y,x+1,c);
        b(e) = b(e) + im_source(y,x,c) - im_source(y,x-1,c);
       
        if ~mask(y-1,x)
          b(e) = b(e) + im_bg(y-1,x,c);
        end
        
        if ~mask(y+1,x)
          b(e) = b(e) + im_bg(y+1,x,c);
        end
        
        if ~mask(y,x+1)
          b(e) = b(e) + im_bg(y,x+1,c);
        end
        
        if ~mask(y,x-1)
          b(e) = b(e) + im_bg(y,x-1,c);
        end
        
        e = e + 1;
        
      end
    end
  end
  
  A = sparse(sparse_i, sparse_j, sparse_k, bg_pixel_count, bg_pixel_count);
  v_rgb{c} = A\b;
end

for c = 1:3
  im_blend(:,:,c) = reshape(v_rgb{c}, [bg_h bg_w]);
end

end
