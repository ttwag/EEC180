function [categories] = create_categories(n_bins)
    categories = strings(n_bins, 1);
    pixel_vals_per_bin = round(256/n_bins);
    for i=1:n_bins
        upper = i*pixel_vals_per_bin-1;
        lower = (i-1)*pixel_vals_per_bin;
        categories(i) = "Bin 0x" + dec2hex(lower) + "-0x" +dec2hex(upper);
    end
end