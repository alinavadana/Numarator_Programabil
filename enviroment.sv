`include "transaction_in.sv"
`include "transaction_out.sv"
`include "generator_in.sv"
`include "driver_in.sv"
`include "monitor_in.sv"
`include "monitor_out.sv"
`include "coverage_in.sv"
`include "coverage_out.sv"
//`include "scoreboard.sv"

class environment;
  
  generator_in  gen;
  driver_in        driv;
  monitor_in    mon_in;
  monitor_out   mon_out;
  
  mailbox gen2driv;
  mailbox mon_in2scb;
  mailbox mon_out2scb;
  
  event gen_ended;
  
  virtual interface_in.DRIVER   in_vif;
  virtual interface_out.MONITOR out_vif;
  
  function new(virtual interface_in.DRIVER in_vif, virtual interface_out.MONITOR out_vif);
    this.in_vif  = in_vif;
    this.out_vif = out_vif;
    
    gen2driv    = new();
    mon_in2scb  = new();
    mon_out2scb = new();
    
    gen     = new(gen2driv, gen_ended);
    driv    = new(in_vif, gen2driv);
    mon_in  = new(in_vif, mon_in2scb);
    mon_out = new(out_vif, mon_out2scb);
 //   scb     = new(mon_in2scb, mon_out2scb);
  endfunction
  
  task pre_test();
    driv.reset();
  endtask
  
  task test();
    fork 
      gen.main();
      driv.main();
      mon_in.monitor();
      mon_out.monitor();
   //   scb.main();      
    join_any
  endtask
  
  task post_test();
    wait(gen_ended.triggered);
    // Asteptam ca toate tranzactiile sa treaca prin driver si scoreboard
    wait(gen.trans_cnt == driv.no_transactions);
   // wait(gen.trans_cnt == scb.no_transactions);
    
    // Afisam raportul final de coverage
//    scb.cov_in.print_coverage();
  //  scb.cov_out.print_coverage();
  endtask  
  
  task run;
    pre_test();
    test();
    post_test();
    $display("--- SIMULARE TERMINATA CU SUCCES ---");
    $finish;
  endtask
  
endclass
