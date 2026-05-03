`include "environment.sv"

program test_data_bins (interface_in in_intf, interface_out out_intf);

    environment env;

    initial begin
        env = new(in_intf, out_intf);

        // Testăm valori din toate intervalele de coverage pentru d_in / d_out:
        // 0       -> valoare minimă
        // 50      -> valoare mică
        // 150     -> valoare medie
        // 220     -> valoare mare
        // 255     -> valoare maximă

        // Scriem și citim registrul DATA_IN, adresa 3
        env.gen.write_register(3, 8'd0);
        env.gen.read_register(3);

        env.gen.write_register(3, 8'd50);
        env.gen.read_register(3);

        env.gen.write_register(3, 8'd150);
        env.gen.read_register(3);

        env.gen.write_register(3, 8'd220);
        env.gen.read_register(3);

        env.gen.write_register(3, 8'd255);
        env.gen.read_register(3);

        // Scriem și citim registrul LIMIT, adresa 2,
        // ca să acoperim și citiri/scrieri pe alt registru configurabil.
        env.gen.write_register(2, 8'd0);
        env.gen.read_register(2);

        env.gen.write_register(2, 8'd50);
        env.gen.read_register(2);

        env.gen.write_register(2, 8'd150);
        env.gen.read_register(2);

        env.gen.write_register(2, 8'd220);
        env.gen.read_register(2);

        env.gen.write_register(2, 8'd255);
        env.gen.read_register(2);

        env.gen.trans_cnt = 0;
        env.run();
    end

endprogram