`define OUT_IF_MON out_vif.MONITOR.monitor_cb

class monitor_out;

  // Referinta virtuala catre interfata de iesire (out_int)
  virtual interface_out out_vif;

  // Mailbox catre scoreboard pentru datele de iesire
  mailbox mon2scb;

  // Contor pentru tranzactiile de iesire monitorizate
  int no_transactions;

  // Constructor
  function new(virtual interface_out out_vif, mailbox mon2scb);
    this.out_vif     = out_vif;
    this.mon2scb     = mon2scb;
    this.no_transactions = 0;
  endfunction

  // Task pentru gestionarea reset-ului pe interfata de iesire
  task reset;
    // Asteptam ca rst_n sa devina activ (0)
    wait(!out_vif.rst_ni);
    $display("[%0t] ----[MONITOR_OUT] RESET DETECTED (ACTIVE)----", $time);

    // Asteptam ca rst_n sa devina inactiv (1)
    wait(out_vif.rst_ni);
    $display("[%0t] ----[MONITOR_OUT] RESET RELEASED (INACTIVE)----", $time);
  endtask

  // Task-ul principal de monitorizare
  task monitor;
    // Instantiem tranzactia de iesire
    transaction_out trans;

    forever begin
      // Sincronizare cu Clocking Block-ul din interfata de iesire
      @(`OUT_IF_MON);

      // Cream un obiect nou pentru fiecare esantionare
      trans = new();

      // Captura valorilor de la pinii de iesire prin monitor_cb
      trans.count_o = `OUT_IF_MON.count_o;
      trans.ovf_o   = `OUT_IF_MON.ovf_o;

      // Incrementam numarul de iesiri captate
      no_transactions++;

      // Afisare pentru debug
      $display("[%0t] ----[MONITOR_OUT] Iesire #%0d: Count=%0d, Ovf=%0d----", 
                $time, no_transactions, trans.count_o, trans.ovf_o);

      // Trimitem obiectul catre Scoreboard pentru validare
      mon2scb.put(trans);
    end
  endtask

endclass : monitor_out
