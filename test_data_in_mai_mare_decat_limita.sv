`include "environment.sv"

program test_data_in_mai_mare_decat_limita(interface_in in_intf, interface_out out_intf);

    environment env;

    initial begin
        env = new(in_intf, out_intf);

        // Oprim tranzacțiile randomizate
        env.gen.trans_cnt = 0;

        // Setăm limita la 5
        // addr 2 = registrul LIMIT
        env.gen.write_register(2, 8'd5);

        // Încercăm să setăm DATA_IN la o valoare mai mare decât limita
        // addr 3 = registrul DATA_IN
        env.gen.write_register(3, 8'd200);

        // Citim registrul DATA_IN pentru a observa valoarea memorată
        // Conform specificației, dacă DATA_IN > LIMIT,
        // în DATA_IN ar trebui să fie reținută valoarea LIMIT
        env.gen.read_register(3);

        // Activăm numărătorul și comanda LOAD
        //
        // Bit 7: EN = 1
        // Bit 6: UP_DOWN = 0         -> nu contează pentru LOAD
        // Biți 5:4: CLK_DIV = 00
        // Bit 3: continue_at_ovf = 0
        // Biți 2:1: nefolosiți = 00
        // Bit 0: LOAD = 1
        //
        // CTL = 8'b1000_0001
        env.gen.write_register(0, 8'b1000_0001);

        // Citim COUNTER_VALUE pentru a observa valoarea încărcată în numărător
        // addr 1 = registrul COUNTER_VALUE
        env.gen.read_register(1);

        env.run();
    end

endprogram