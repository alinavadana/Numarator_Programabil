`include "environment.sv"

program test_overflow_up(interface_in in_intf, interface_out out_intf);

    environment env;

    initial begin
        env = new(in_intf, out_intf);

        // Setăm limita la 3 pentru a ajunge rapid la overflow
        // addr 2 = registrul LIMIT
        env.gen.write_register(2, 8'd3);

        // Setăm valoarea de start la 2
        // addr 3 = registrul DATA_IN
        env.gen.write_register(3, 8'd2);

        // Încărcăm valoarea de start și activăm numărarea crescătoare cu overflow permis
        //
        // Bit 7: EN = 1
        // Bit 6: UP_DOWN = 1         -> numărare crescătoare
        // Biți 5:4: CLK_DIV = 00     -> numărare la fiecare tact
        // Bit 3: continue_at_ovf = 1 -> permite wrap-around
        // Biți 2:1: nefolosiți = 00
        // Bit 0: LOAD = 1            -> încarcă DATA_IN în count_o
        //
        // CTL = 8'b1100_1001
        env.gen.write_register(0, 8'b1100_1001);

        // Dezactivăm LOAD, dar păstrăm EN, UP_DOWN și continue_at_ovf active
        //
        // Bit 7: EN = 1
        // Bit 6: UP_DOWN = 1
        // Biți 5:4: CLK_DIV = 00
        // Bit 3: continue_at_ovf = 1
        // Bit 0: LOAD = 0
        //
        // CTL = 8'b1100_1000
        env.gen.write_register(0, 8'b1100_1000);

        // Citim de mai multe ori counter_value pentru a lăsa numărătorul să ajungă la limită
        // și apoi să facă wrap-around.
        env.gen.read_register(1);
        env.gen.read_register(1);
        env.gen.read_register(1);
        env.gen.read_register(1);
        env.gen.read_register(1);

        env.gen.trans_cnt = 0;
        env.run();
    end

endprogram