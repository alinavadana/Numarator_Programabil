`include "interface_in.sv"
`include "interface_out.sv"
`include "counter_programabil.v"

`include "test_simplu.sv"
//`include "test.sv"
//`include "random_test.sv"
//`include "wr_rd_test.sv"
//`include "default_test.sv"

module testbench;

    bit clk;
    bit reset;

    always #5 clk = ~clk;

    initial begin
        reset = 0;
        #15 reset = 1;
    end

    interface_in in_intf(clk, reset);
    interface_out out_intf(clk, reset);

    test_simplu t1(in_intf, out_intf);

    counter_programabil DUT (
        .clk_i(clk),
        .rst_ni(reset),
        .valid_i(in_intf.valid_i),
        .rd_wr_i(in_intf.rd_wr),
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
