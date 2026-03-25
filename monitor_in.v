class monitor_in;

  // Referinta virtuala catre interfata de intrare 
  virtual in_int.MONITOR in_vif;

  // Mailbox catre scoreboard
  mailbox mon2scb;

  // Contor tranzactii monitorizate
  int no_transactions;

  // Constructor
  function new(virtual in_int.MONITOR in_vif, mailbox mon2scb);
    this.in_vif    = in_vif;
    this.mon2scb   = mon2scb;
    no_transactions = 0;
  endfunction


  //   Asteapta activarea si dezactivarea semnalului de reset

  task reset;
    // Asteptam frontul negativ al reset-ului 
    @(negedge in_vif.rst_ni);
    $display("[%0t] ----[MONITOR_IN] RESET START----", $time);

    // Asteptam frontul pozitiv al reset-ului 
    @(posedge in_vif.rst_ni);
    $display("[%0t] ----[MONITOR_IN] RESET END----", $time);
  endtask

  task monitor;

    transaction_in trans;

    forever begin

      // Asteptam un front pozitiv de ceas
      @(posedge in_vif.clk);

      // Verificam daca tranzactia este valida
      if (in_vif.monitor_cb.valid_i === 1'b1) begin

        trans = new();

        // Captura semnalelor de intrare
        
		trans.valid_i = in_vif.monitor_cb.valid_i;
        trans.rd_wr_i = in_vif.monitor_cb.rd_wr_i;
        trans.addr_i  = in_vif.monitor_cb.addr_i;
		 if (trans.rd_wr_i == 1'b0) 
        trans.d_in    = in_vif.monitor_cb.d_in;
       
        // Daca e operatie de citire (rd_wr_i=1), asteptam
        // inca un ciclu ca sa capturam si d_out de la DUT
        if (trans.rd_wr_i == 1'b1) begin
          @(posedge in_vif.clk);
          trans.d_out = in_vif.monitor_cb.d_out;
        end

        // Incrementam contorul si afisam tranzactia
        no_transactions++;
        $display("[%0t] ----[MONITOR_IN] Tranzactie #%0d----",
                  $time, no_transactions);
        trans.display();

        // Trimitem tranzactia catre scoreboard
        mon2scb.put(trans);

      end 

    end 

  endtask

task main;

forever begin
   
  while ( in_vif.rst_ni == 0)
  @(posedge in_vif.clk);
   
  fork
    begin
	  reset();
	end
	
	begin
	  monitor();
	end
	
  join_any;
  disable fork;
  
end

endtask

endclass


