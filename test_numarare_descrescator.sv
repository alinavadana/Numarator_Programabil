`include "environment.sv"

program test_numarare_descrescator(interface_in in_intf, interface_out out_intf);

    environment env;

    initial begin
        env = new(in_intf, out_intf);

        // Setăm valoarea de start la 20
        // addr 3 = registrul DATA_IN
        env.gen.write_register(3, 8'd20);

        // Încărcăm valoarea de start și activăm numărarea descrescătoare
        //
        // Bit 7: EN = 1
        // Bit 6: UP_DOWN = 0         -> numărare descrescătoare
        // Biți 5:4: CLK_DIV = 00     -> numărare la fiecare tact
        // Bit 3: continue_at_ovf = 0 -> fără reluare la underflow
        // Biți 2:1: nefolosiți = 00
        // Bit 0: LOAD = 1            -> încarcă DATA_IN în count_o
        //
        // CTL = 8'b1000_0001
        env.gen.write_register(0, 8'b1000_0001);

        // Dezactivăm LOAD, dar păstrăm EN activ și direcția descrescătoare
        //
        // Bit 7: EN = 1
        // Bit 6: UP_DOWN = 0
        // Biți 5:4: CLK_DIV = 00
        // Bit 3: continue_at_ovf = 0
        // Bit 0: LOAD = 0
        //
        // CTL = 8'b1000_0000
        env.gen.write_register(0, 8'b1000_0000);

        // Lăsăm numărătorul să scadă câteva tacte
        repeat(10) @(posedge in_intf.clk);

        // Citim COUNTER_VALUE
        // addr 1 = registrul COUNTER_VALUE
        env.gen.read_register(1);

        env.gen.trans_cnt = 0;
        env.run();
    end

endprogram