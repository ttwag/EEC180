function [ret_pixels, o_fpga_hist] = write_readback_col...
    (t, I, ... 
    data_base_addr, ready_base_addr, ...
    start_base_addr, dim_base_addr, ... 
    mode_base_addr, hist_base_addr, ...
    hist_bins_base_addr, ...
    dim, mode, hist_bins)

    len_col = length(I);
    timeout = 10000;
    % Flag not ready
    jtag_write_32(t, ready_base_addr, 0, "1");
    % Write dim
    jtag_write_32(t, dim_base_addr, dim, "2");
    % Write mode
    jtag_write_32(t, mode_base_addr, mode, "3");
    % Write hist bins
    jtag_write_32(t, hist_bins_base_addr, hist_bins, "4");
    % Write data
    jtag_write_bytes(t, data_base_addr, I, 10000);
    % Flag ready
    jtag_write_32(t, ready_base_addr, 1, "5");
    % Wait for accelerator to flag start transfer
    while(timeout > 0)
        % Poll Start
        ret_start = jtag_read_32(t, start_base_addr, 1);
        if(ret_start == 1)
            break
        end
        timeout = timeout - 1;
    end
    if(timeout == 0)
        ret_pixels = 1;
    else
        % Before transferring flag that new data is not available
        jtag_write_32(t, ready_base_addr, 0, "6");
        % Get new data
        ret_pixels = jtag_read_bytes(t, data_base_addr, len_col, 10000);
        o_fpga_hist = zeros(1, hist_bins);
        for i = 1:hist_bins
            o_fpga_hist(i) = jtag_read_32(t, hist_base_addr+4*(i-1), 1);
        end
    end
end