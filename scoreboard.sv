class scoreboard;
   
  mailbox mon_in2scb;
  mailbox mon_out2scb;
  
  int no_transactions;
  bit [7:0] local_mem[4]; // Memorie interna pentru verificare
  
  coverage_in  cov_in;
  coverage_out cov_out;

  function new(mailbox mon_in2scb, mailbox mon_out2scb);
    this.mon_in2scb  = mon_in2scb;
    this.mon_out2scb = mon_out2scb;
    foreach(local_mem[i]) local_mem[i] = 8'h00;
    cov_in  = new();
    cov_out = new();
  endfunction
  
  task main;
    transaction_in  trans_in;
    transaction_out trans_out;
    
    forever begin
      // Preluam comanda de intrare
      mon_in2scb.get(trans_in);
      
      // Daca este operatie de scriere, actualizam memoria locala
      if (trans_in.rd_wr_i == 1'b0) begin
        local_mem[trans_in.addr_i] = trans_in.d_in;
        $display("[SCB-WRITE] Adresa %0d a fost scrisa cu valoarea %0h", trans_in.addr_i, trans_in.d_in);
      end 
      
      // Indiferent daca e citire sau scriere, asteptam raspunsul de la iesire (DUT)
      mon_out2scb.get(trans_out);
      
      // Colectam statistici (Coverage)
      cov_in.sample(trans_in);
      cov_out.sample(trans_out);

      // Verificam daca DUT-ul a scos ce trebuie (Exemplu: verificam ovf_o sau count_o)
      if (trans_in.rd_wr_i == 1'b1) begin // La citire
        if(local_mem[trans_in.addr_i] != trans_out.count_o) begin // Exemplu de comparatie
           $error("[SCB-FAIL] Eroare la adresa %0h! In memorie: %0h | La iesire: %0h", 
                  trans_in.addr_i, local_mem[trans_in.addr_i], trans_out.count_o);
        end else begin
           $display("[SCB-PASS] Citire corecta la adresa %0h: %0h", trans_in.addr_i, trans_out.count_o);
        end
      end

      no_transactions++;
    end
  endtask
  
endclass