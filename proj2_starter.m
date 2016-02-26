% starter script for project 2
DO_TOY = false;
DO_BLEND = false;
DO_MIXED  = true;
DO_COLOR2GRAY = false;
DO_NPR = false;

if DO_TOY
    toyim = im2double(imread('./samples/toy_problem.png')); 
    % im_out should be approximately the same as toyim
    im_out = toy_reconstruct(toyim);   % you need to write this function, toy_reconstruct
    disp(['Error: ' num2str(sqrt(sum((toyim(:)-im_out(:)).^2)))])
end

if DO_BLEND
    % do a small one first, while debugging
   
    im_background = imresize(im2double(imread('./samples/mill-valley.jpg')), 0.25, 'bilinear');
    im_object = imresize(im2double(imread('./samples/shiba.jpg')), 0.35, 'bilinear');

    % get source region mask from the user
    objmask = getMask(im_object);
    % align im_s and mask_s with im_background
    [im_s, mask_s] = alignSource(im_object, objmask, im_background);

    % blend
    im_blend = poissonBlend(im_s, mask_s, im_background);   % you need to write this.
    figure(3), hold off, imshow(im_blend)
end

if DO_MIXED
    im_background = imresize(im2double(imread('./samples/mill-valley.jpg')), 0.25, 'bilinear');
    im_object = imresize(im2double(imread('./samples/shiba.jpg')), 0.35, 'bilinear');

    % get source region mask from the user
    objmask = getMask(im_object);
    % align im_s and mask_s with im_background
    [im_s, mask_s] = alignSource(im_object, objmask, im_background);
    
    % blend
    im_blend = mixedBlend(im_s, mask_s, im_background);     % you need to write this.
    figure(3), hold off, imshow(im_blend);
end

if DO_COLOR2GRAY
    % also feel welcome to try this on some natural images and compare to rgb2gray
    im_rgb = im2double(imread('./samples/colorBlindTest35.png'));
    im_gr = color2gray(im_rgb);
    figure(4), hold off, imagesc(im_gr), axis image, colormap gray
end

if DO_NPR
  im_input = im2double(imread('./samples/dog.JPG'));
  im_npr = npr(im_input);
  imshow(im_npr);
%   imwrite(im_npr, './samples/output/asdf.jpg');
end

