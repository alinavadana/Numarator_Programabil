class coverage_out;

  transaction_out trans_covered;

  covergroup output_cg;
    option.per_instance = 1;

    // Monitorizam valorile numaratorului de iesire (2 biti: 0, 1, 2, 3)
    count_o_cp: coverpoint trans_covered.count_o {
      bins val_minima = {0};
      bins val_maxima = {255};
      bins valori_intermediare[4] = {[1:254]};//1:63;64:127;128:191;192-254
      bins val_3 = {3};
    }

    // Monitorizam semnalul de overflow (8 biti)
    overflow_o_cp: coverpoint trans_covered.ovf_o {
      bins zero_val     = {0};
      bins one_val   = {1};
    }

  endgroup

  // Constructor
  function new();
    output_cg = new();
  endfunction

  // Esantionarea se face la fiecare tranzactie de iesire captata
  task sample_function(transaction_out trans_covered);
    this.trans_covered = trans_covered;
    output_cg.sample();
  endtask : sample_function

  // Afisarea valorilor de coverage pentru iesire
  function void print_coverage();
    $display("----------------------------------------");
    $display("[COVERAGE_OUT] Count coverage     = %.2f%%", output_cg.count_o_cp.get_coverage());
    $display("[COVERAGE_OUT] Overflow coverage  = %.2f%%", output_cg.overflow_o_cp.get_coverage());
    $display("[COVERAGE_OUT] Cross Count/Ovf    = %.2f%%", output_cg.count_x_ovf.get_coverage());
    $display("[COVERAGE_OUT] Overall Out Cov    = %.2f%%", output_cg.get_coverage());
    $display("----------------------------------------");
  endfunction

endclass : coverage_out