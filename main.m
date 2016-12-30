function demo(no_compile)

startup;

if ~exist('no_compile', 'var')
  fprintf('compiling the code...');
%   compile;
  fprintf('done.\n\n');
end

load('INRIA/inriaperson_final');
model.vis = @() visualizemodel(model, ...
                  1:2:length(model.rules{model.start}));



test('000012.jpg', model, 6);


function test(imname, model, num_dets)
cls = model.class;

fprintf('///// Running demo for %s /////\n\n', cls);

% load and display image
im = imread(imname);
% hog = extractHOGFeatures(im);
% image(hog);
% pause;

clf;
image(im);
axis equal; 
axis on;
title('input image');
disp('input image');
% disp('press any key to continue'); pause;
disp('continuing...');

% load and display model
%model.vis(); % visualize model vs cac parts
%disp([cls ' model visualization']);
% disp('press any key to continue'); pause;
%disp('continuing...');

rhs = model.rules{model.start}(1).rhs;
root = -1;
parts = [];
defs = {};
anchors = {};

layer = 1;

pad = 2;
bs = 20;

if model.symbols(rhs(1)).type == 'T'
  % handle case where there is no deformation model for the root
  root = model.symbols(rhs(1)).filter;
else
  % handle case where there is a deformation model for the root
  root = model.symbols(model.rules{rhs(1)}(layer).rhs).filter;
end

for i = 2:length(rhs)
  defs{end+1} = model_get_block(model, model.rules{rhs(i)}(layer).def);
  anchors{end+1} = model.rules{model.start}(1).anchor{i};
  fi = model.symbols(model.rules{rhs(i)}(layer).rhs).filter;
  parts = [parts fi];
end

w = model_get_block(model, model.filters(parts(1)));
scale = max(w(:));
im = HOGpicture(w, bs);
%image(im);
im = imresize(im, 2);
im = padarray(im, [pad pad], 0);
im = uint8(im * (255/scale));

image(im);

im = color(im); %load hinh truy van
pyra = featpyramid(im, model); 

fprintf('\n');


