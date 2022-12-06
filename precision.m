function real = precision(result, ground_truth)
    segmented_pixels_result = find(result == 1);
    segmented_pixels_gt = find(ground_truth == 1);
    true_positive = length(intersect(segmented_pixels_result, segmented_pixels_gt));
    false_positive = length(segmented_pixels_result) - true_positive;
    real = true_positive / (true_positive + false_positive);
end