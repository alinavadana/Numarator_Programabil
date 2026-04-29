`include "environment.sv"

program test_limita(intf_in in_intf, intf_out out_intf);

    environment env;

    initial begin
    env = new(in_intf, out_intf);
    
    //  Setăm limita la 67 
    env.gen.write_register(2, 8'd67); 

    //  Setăm valoarea de start (Load Value) la 103 
    env.gen.write_register(3, 8'd103);

    // Activăm numărarea și încărcarea valorii (Load)
    // Bit 7: Enable = 1
    // Bit 0: Load = 1
    // 8'b10000001 
    env.gen.write_register(0, 8'b10000001);

    env.gen.trans_cnt = 0;
    env.run();
end
endprogram