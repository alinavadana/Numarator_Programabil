
`include "environment.sv"

program default_test(intf_in in_intf, intf_out out_intf);

    environment env;

    initial begin
        // Instanțiem mediul trecând ambele interfețe către constructorul clasei environment 
        env = new(in_intf, out_intf);
        
        // Setăm numărul de tranzacții ce urmează a fi generate de generator_in 
        env.gen.trans_cnt = 4;
        
        // Pornim execuția fluxului de test 
        env.run();
    end

endprogram