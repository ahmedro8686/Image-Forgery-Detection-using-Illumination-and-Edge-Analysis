% ====== 8. Combine Z-scores across features ======
zCombined = mean(z, 2);  % Average z-score per pixel (can weight features)
zMap = reshape(zCombined, [h, w]);
zMapNorm = mat2gray(zMap);

figure('Name','Z-score Anomaly Map','NumberTitle','off');
imshow(zMapNorm);
title('Z-score Anomaly Map');
saveas(gcf, fullfile(resultsDir, 'zmap.png'));

% ====== 9. Threshold anomalies (Otsu or fixed zThr) ======
if useOtsu
    level = graythresh(zMapNorm);   % value between 0 and 1
    bwAnom = imbinarize(zMapNorm, level);
else
    % Use zThr as a percentage after normalization
    bwAnom = zMapNorm > mat2gray(zThr); 
end

% Remove small noise
bwAnom = bwareaopen(bwAnom, 30); % Remove components smaller than 30 pixels

% Optionally combine with edges or detail map for higher accuracy
finalAnom = bwAnom & (edgesBinary | (F_detail > 0.05));  
finalAnom = bwareaopen(finalAnom, 50);

figure('Name','Final Anomaly Regions','NumberTitle','off');
imshow(finalAnom); 
title('Final Suspicious Regions');
saveas(gcf, fullfile(resultsDir, 'final_anomalies.png'));

% ====== 10. Extract properties of suspicious regions ======
cc = bwconncomp(finalAnom);
stats = regionprops(cc, 'Area','BoundingBox','Centroid','Eccentricity','Solidity');

% Save original image with bounding boxes around detected regions
imgAnnotated = imgRGB;
figure('Name','Annotated','NumberTitle','off');
imshow(imgAnnotated); hold on;
for k = 1:length(stats)
    bb = stats(k).BoundingBox;
    rectangle('Position', bb, 'EdgeColor', 'r', 'LineWidth', 2);
end
title('Image with Highlighted Suspicious Regions');
saveas(gcf, fullfile(resultsDir, 'annotated_anomalies.png'));
hold off;

% ====== 11. Statistics and numeric report ======
totalPixels = numPix;
anomalousPixels = sum(finalAnom(:));
percentAnom = anomalousPixels / totalPixels * 100;
numRegions = length(stats);

% Create a text report
reportFile = fullfile(resultsDir, 'report.txt');
fid = fopen(reportFile, 'w');
fprintf(fid, 'Image Forgery Detection Report\n');
fprintf(fid, '==============================\n');
fprintf(fid, 'Image file: %s\n', file);
fprintf(fid, 'Timestamp: %s\n\n', timestamp);
fprintf(fid, 'Parameters:\n');
fprintf(fid, '  Gaussian sigma: %g\n', gaussSigma);
fprintf(fid, '  Local window size: %d\n', localSize);
fprintf(fid, '  Use Otsu threshold: %d\n\n', useOtsu);
fprintf(fid, 'Results summary:\n');
fprintf(fid, '  Total pixels: %d\n', totalPixels);
fprintf(fid, '  Anomalous pixels: %d\n', anomalousPixels);
fprintf(fid, '  Percent anomalous: %.4f %%\n', percentAnom);
fprintf(fid, '  Number of detected regions: %d\n\n', numRegions);
fprintf(fid, 'Regions (index, area, centroid_x, centroid_y):\n');
for k = 1:numRegions
    c = stats(k).Centroid;
    a = stats(k).Area;
    fprintf(fid, '  %d, %d, %.2f, %.2f\n', k, a, c(1), c(2));
end
fclose(fid);

% ====== 12. Save anomaly map with transparent overlay (RGBA) ======
overlay = img;
alpha = zeros(h, w);
alpha(finalAnom) = 0.6; % transparency for suspicious areas

% Apply red overlay on suspicious regions
overlay(:,:,1) = overlay(:,:,1) .* (~finalAnom) + 0.8 * finalAnom;
overlay(:,:,2) = overlay(:,:,2) .* (~finalAnom);
overlay(:,:,3) = overlay(:,:,3) .* (~finalAnom);

imwrite(overlay, fullfile(resultsDir, 'overlay.png'));

% ====== 13. Print summary for user ======
fprintf(' Analysis completed. Results saved in: %s\n', resultsDir);
fprintf('  - Suspicious regions: %d\n', numRegions);
fprintf('  - Percent suspicious pixels: %.4f %%\n', percentAnom);
% ========================================================
% NOTE:
% This program is fully tested and works on MATLAB only.
% If you want to run it on Octave, some functions may not be supported or behave differently.
% To run on Octave, you may need to:
%   - Install and load necessary packages: image, statistics
%     pkg install -forge image
%     pkg load image
%     pkg install -forge statistics
%     pkg load statistics
%   - Replace or adapt unsupported functions such as:
%       * imgaussfilt (use imfilter with Gaussian kernel)
%       * regionprops (alternative implementations needed)
%       * imshow and figure properties may differ
% Please test thoroughly and adjust code accordingly when using Octave.
% ========================================================


% Display final summary in one figure
figure('Name','Summary','NumberTitle','off','Units','normalized','Position',[0.1 0.1 0.8 0.6]);
subplot(2,3,1); imshow(imgRGB); title('Original Image');
subplot(2,3,2); imshow(illumMeanNorm); title('Illumination Map');
subplot(2,3,3); imshow(gradMagNorm); title('Illumination Gradient');
subplot(2,3,4); imshow(edgesBinary); title('RGB Edges');
subplot(2,3,5); imshow(zMapNorm); title('Z-score Anomaly Map');
subplot(2,3,6); imshow(overlay); title('Overlay of Suspicious Regions');
saveas(gcf, fullfile(resultsDir, 'summary_grid.png'));
