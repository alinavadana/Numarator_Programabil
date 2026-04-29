
`include "environment.sv"

program test_simplu(interface_in in_intf, interface_out out_intf);

    environment env;

    initial begin
    $error("%0t a inceput testul", $time);
        // Instanțiem mediul trecând ambele interfețe către constructorul clasei environment 
        env = new(in_intf, out_intf);
        
        // Setăm numărul de tranzacții ce urmează a fi generate de generator_in 
        env.gen.trans_cnt = 4;

        env.gen.write_register(0, 8'b11001000);
        env.gen.read_register(0);
        
        // Pornim execuția fluxului de test 
        env.run();
    end

endprogram
