`include "intf_in.sv"
`include "intf_out.sv"

`include "random_test.sv"
//`include "wr_rd_test.sv"
`include "default_test.sv"

module testbench;

    bit clk;
    bit reset;

    always #5 clk = ~clk;

    initial begin
        reset = 1;
        #15 reset = 0;
    end

    intf_in in_intf(clk, reset);
    intf_out out_intf(clk, reset);

    default_test t1(in_intf, out_intf);

    counter_programabil DUT (
        .clk_i(clk),
        .rst_ni(reset),
        .valid_i(in_intf.valid_i),
        .rd_wr_i(in_intf.rd_wr_i),
        .addr_i(in_intf.addr_i),
        .d_in(in_intf.d_in),
        .d_out(in_intf.d_out),
        .count_o(out_intf.count_o),
        .ovf_o(out_intf.ovf_o)
    );

    initial begin 
        $dumpfile("dump.vcd"); $dumpvars;
    end

endmodule