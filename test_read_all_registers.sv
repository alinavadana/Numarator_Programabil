`include "environment.sv"

program test_read_all_registers(interface_in in_intf, interface_out out_intf);

    environment env;

    initial begin
        env = new(in_intf, out_intf);

        // Test de bază: citirea tuturor registrelor DUT-ului
        //
        // addr 0 = CTL
        // addr 1 = COUNTER_VALUE
        // addr 2 = LIMIT
        // addr 3 = DATA_IN

        env.gen.read_register(0); // citire registru CTL
        env.gen.read_register(1); // citire registru COUNTER_VALUE
        env.gen.read_register(2); // citire registru LIMIT
        env.gen.read_register(3); // citire registru DATA_IN

        // Scriem valori cunoscute în registrele configurabile
        // pentru a avea apoi citiri diferite pe d_out

        env.gen.write_register(0, 8'b1100_0000); // CTL: EN=1, UP_DOWN=1
        env.gen.write_register(2, 8'd255);       // LIMIT: valoare maximă
        env.gen.write_register(3, 8'd127);       // DATA_IN: valoare medie

        // Citim din nou toate registrele
        env.gen.read_register(0);
        env.gen.read_register(1);
        env.gen.read_register(2);
        env.gen.read_register(3);

        env.gen.trans_cnt = 0;
        env.run();
    end

endprogram