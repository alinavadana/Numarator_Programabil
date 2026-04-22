class driver_in;

  int no_transactions;

  virtual interface_in in_vif;
  mailbox gen2driv;

  function new(virtual interface_in in_vif, mailbox gen2driv);
    this.in_vif   = in_vif;
    this.gen2driv = gen2driv;
  endfunction

  task reset;
    // Asteptam front negativ de reset -> activare reset
    
    $display("[%0t] ---- [DRIVER] BEFORE RESET ----", $time);
    @( !in_vif.rst_ni);

    $display("[%0t] ---- [DRIVER] RESET STARTED ----", $time);
    in_vif.driver_cb.valid_i <= 1'b0;
    in_vif.driver_cb.rd_wr <= 1'b0;
    in_vif.driver_cb.addr_i  <= 2'b0;
    in_vif.driver_cb.d_in    <= 8'b0;
  endtask

  task drive;
    transaction_in trans;

    gen2driv.get(trans);
    $display("---- [DRIVER STARTED : %0d] ----", no_transactions);

    // asteptam delay-ul
    repeat (trans.delay)
      @(posedge in_vif.clk);

    // incepe tranzactia
    in_vif.driver_cb.valid_i <= 1'b1;
    in_vif.driver_cb.addr_i  <= trans.addr_i;

    if (trans.rd_wr == 0) begin
      in_vif.driver_cb.rd_wr <= 1'b0;
    end
    else begin
      in_vif.driver_cb.rd_wr <= 1'b1;
    end

    // daca e scriere -> punem date pe d_in
    if (trans.rd_wr == 0) begin
      in_vif.driver_cb.d_in <= trans.d_in;
    end

    @(posedge in_vif.clk);
    in_vif.driver_cb.valid_i <= 1'b0;

    no_transactions++;
  endtask

  task main;
    forever begin

      while (in_vif.rst_ni == 0)
        @(posedge in_vif.clk);

      fork
        begin
          drive();
        end

        begin
          reset();
        end
      join_any

      disable fork;
    end
  endtask

endclass
