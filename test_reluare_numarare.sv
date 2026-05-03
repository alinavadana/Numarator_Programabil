`include "environment.sv"

program test_reluare_numarare(interface_in in_intf, interface_out out_intf);

    environment env;

    initial begin
        env = new(in_intf, out_intf);
        
        // Configurări pentru testul de reluare 
        env.gen.trans_cnt = 0;

        //  Setăm limita la 15 (Adresa 2)
        env.gen.write_register(2, 8'd15); 

        //  Pornim de la 10
        env.gen.write_register(3, 8'd10);

        //  Activăm numărarea crescătoare cu reluare (Adresa 0)
        // EN=1, UP=1, CONTINUE_AT_OVF=1, LOAD=1 => 8'b11001001
        env.gen.write_register(0, 8'b11001001);

        env.run();
    end

endprogram