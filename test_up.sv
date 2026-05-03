`include "environment.sv"

program test_up(interface_in in_intf, interface_out out_intf);

    environment env;

    initial begin
        env = new(in_intf, out_intf);

        // Setăm limita la 10 pentru ca numărarea să fie ușor de observat
        // addr 2 = registrul LIMIT
        env.gen.write_register(2, 8'd10);

        // Setăm valoarea de start la 0
        // addr 3 = registrul DATA_IN
        env.gen.write_register(3, 8'd0);

        // Activăm numărătorul, selectăm numărare crescătoare și încărcăm valoarea de start
        //
        // Bit 7: EN = 1              -> numărător activ
        // Bit 6: UP_DOWN = 1         -> numărare crescătoare
        // Biții 5:4: CLK_DIV = 00    -> numărare la fiecare tact
        // Bit 3: continue_at_ovf = 0 -> fără wrap-around
        // Biții 2:1: nefolosiți = 00
        // Bit 0: LOAD = 1            -> se încarcă valoarea din DATA_IN
        //
        // CTL = 8'b1100_0001
        env.gen.write_register(0, 8'b1100_0001);

        // După încărcare, dezactivăm bitul LOAD și lăsăm numărătorul să numere crescător
        //
        // Bit 7: EN = 1
        // Bit 6: UP_DOWN = 1
        // Biții 5:4: CLK_DIV = 00
        // Bit 3: continue_at_ovf = 0
        // Bit 0: LOAD = 0
        //
        // CTL = 8'b1100_0000
        env.gen.write_register(0, 8'b1100_0000);

        // Citim valoarea curentă a numărătorului
        // addr 1 = COUNTER_VALUE
        env.gen.read_register(1);

        env.gen.trans_cnt = 0;
        env.run();
    end

endprogram
