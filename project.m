%grab image directories
addpath("UNL-CPPD");
addpath("Ground Truths");
imStruct = dir("UNL-CPPD/Original Image/Plant_001-9/SideView0");
imStruct = imStruct(~ismember({imStruct.name},{'.','..'}));
gtStruct = dir("Ground Truths");
gtStruct = gtStruct(~ismember({gtStruct.name},{'.','..'}));
%create directories to save images
mkdir Team2Proj;
mkdir Team2Proj/Binary050_Imgs;
mkdir Team2Proj/Binary100_Imgs;
mkdir Team2Proj/Binary150_Imgs;
mkdir Team2Proj/Binary200_Imgs;
mkdir Team2Proj/Otsu_Imgs;
mkdir Team2Proj/Multilevel_Imgs;
mkdir Team2Proj/Adaptive_Imgs;
addpath("Team2Proj");
results = struct("Day", {}, ...
    "Binary50_Jaccard", {}, "Binary50_Precision", {}, ...
    "Binary100_Jaccard", {}, "Binary100_Precision", {}, ...
    "Binary150_Jaccard", {}, "Binary150_Precision", {}, ...
    "Binary200_Jaccard", {}, "Binary200_Precision", {}, ...
    "Otsu_Jaccard", {}, "Otsu_Precision", {}, ...
    "Multi_Jaccard", {}, "Multi_Precision", {}, ...
    "Adaptive_Jaccard", {}, "Adaptive_Precision", {});
row = 1;
for i = 1:numel(imStruct)
   image = imread([imStruct(i).folder '/' imStruct(i).name]);
   gT = imread([gtStruct(i).folder '/' gtStruct(i).name]);
   %gimp is weird, photoshop worked though
   %the ground truth images done in gimp, for whatever reason,
   %read in as type 'uint8' while the ones done in Photoshop read in as the
   %correct 'logical' type
   gT = logical(gT);
   %grayscale image
   image = im2gray(image);
   %binary thresholded image at 50 pixel intensity
       binary50 = imcomplement(imbinarize(image, .2));
       results(i).Day = i + 1;
       results(i).Binary50_Jaccard = jaccard(binary50, gT);
       results(i).Binary50_Precision = precision(binary50, gT);
   %binary thresholded image at 100 pixel intensity
       binary100 = imcomplement(imbinarize(image, .4));
       results(i).Day = i + 1;
       results(i).Binary100_Jaccard = jaccard(binary100, gT);
       results(i).Binary100_Precision = precision(binary100, gT);
   %binary thresholded image at 150 pixel intensity
       binary150 = imcomplement(imbinarize(image, .6));
       results(i).Day = i + 1;
       results(i).Binary150_Jaccard = jaccard(binary150, gT);
       results(i).Binary150_Precision = precision(binary150, gT);
   %binary thresholded image at 150 pixel intensity
       binary200 = imcomplement(imbinarize(image, .8));
       results(i).Day = i + 1;
       results(i).Binary200_Jaccard = jaccard(binary200, gT);
       results(i).Binary200_Precision = precision(binary200, gT);
   %otsu thresholded image
       %first step is to get image histogram
       [counts,x] = imhist(image,16);
       %get threshold level based on histogram
       otsuThreshold = otsuthresh(counts);
       %finally, threshold
       otsu = imcomplement(imbinarize(image, otsuThreshold));
       results(i).Day = i + 1;
       results(i).Otsu_Jaccard = jaccard(otsu, gT);
       results(i).Otsu_Precision = precision(otsu, gT);
   %multi-otsu thresholded image with 3 levels
       threshLevels = multithresh(image, 3);
       multi = imcomplement(imquantize(image, threshLevels));
       plant = multi == 0;
       background = multi < 0;
       multi(plant) = 1;
       multi(background) = 0;
       multiInt = logical(im2uint8(multi));
       results(i).Day = i + 1;
       results(i).Multi_Jaccard = jaccard(multiInt, gT);
       results(i).Multi_Precision = precision(multiInt, gT);
   %adaptive otsu thresholding
       adapt = imcomplement(imbinarize(image, 'adaptive'));
       results(i).Day = i + 1;
       results(i).Adaptive_Jaccard = jaccard(adapt, gT);
       results(i).Adaptive_Precision = precision(adapt, gT);
    
%%% DISPLAY AND SAVE IMAGES %%%
   %show all in an array, save all images to respective directories
   imageArr = [binary50, binary100, binary150, binary200, otsu, multiInt, adapt, gT];
   montage(imageArr);
   %save binary 50
   if i < 9
       imwrite(binary50, ['Team2Proj/Binary050_Imgs/binary050_00' int2str(i+1) '.png']);
   elseif i >= 9
       imwrite(binary50, ['Team2Proj/Binary050_Imgs/binary050_0' int2str(i+1) '.png']);
   end
   %save binary 100
   if i < 9
       imwrite(binary100, ['Team2Proj/Binary100_Imgs/binary100_00' int2str(i+1) '.png']);
   elseif i >= 9
       imwrite(binary100, ['Team2Proj/Binary100_Imgs/binary100_0' int2str(i+1) '.png']);
   end
   %save binary 150
   if i < 9
       imwrite(binary150, ['Team2Proj/Binary150_Imgs/binary150_00' int2str(i+1) '.png']);
   elseif i >= 9
       imwrite(binary150, ['Team2Proj/Binary150_Imgs/binary150_0' int2str(i+1) '.png']);
   end
   %save binary 200
   if i < 9
       imwrite(binary200, ['Team2Proj/Binary200_Imgs/binary200_00' int2str(i+1) '.png']);
   elseif i >= 9
       imwrite(binary200, ['Team2Proj/Binary200_Imgs/binary200_0' int2str(i+1) '.png']);
   end
   %save Otsu
   if i < 9
       imwrite(otsu, ['Team2Proj/Otsu_Imgs/otsu_00' int2str(i+1) '.png']);
   elseif i >= 9
       imwrite(otsu, ['Team2Proj/Otsu_Imgs/otsu_0' int2str(i+1) '.png']);
   end
   %save multi-level
   if i < 9
       imwrite(multiInt, ['Team2Proj/Multilevel_Imgs/multilevel_00' int2str(i+1) '.png']);
   elseif i >= 9
       imwrite(multiInt, ['Team2Proj/Multilevel_Imgs/multilevel_0' int2str(i+1) '.png']);
   end
   %save adaptive
   if i < 9
       imwrite(adapt, ['Team2Proj/Adaptive_Imgs/adaptive_00' int2str(i+1) '.png']);
   elseif i >= 9
       imwrite(adapt, ['Team2Proj/Adaptive_Imgs/adaptive_0' int2str(i+1) '.png']);
   end
end

writetable(struct2table(results), "Team2Proj/results.xlsx")
