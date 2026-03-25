
class coverage_in;

  transaction_in trans_covered;

  covergroup transaction_cg;

    option.per_instance = 1;



   // tip operatie (0=scriere, 1=citire)

    rd_wr_cp: coverpoint trans_covered.rd_wr_i {
      bins scriere = {0};
      bins citire  = {1};
    }

    address_cp: coverpoint trans_covered.addr_i {
      bins addr_reg_0 = {0};
      bins addr_reg_1 = {1};
      bins addr_reg_2 = {2};
      bins addr_reg_3 = {3};
    }

    write_data_cp: coverpoint trans_covered.d_in {
      bins highest_value  = {255};
      bins big_values     = {[191:254]};
      bins medium_values  = {[127:190]};
      bins low_values     = {[1:126]};
      bins lowest_value   = {0};
    }


    read_data_cp: coverpoint trans_covered.d_out {
      
      bins range[4]      = {[1:$]};
      bins lowest_value  = {0};
      bins highest_value = {255};
    }


    delay_cp: coverpoint trans_covered.delay {
	bind fara_delay = {0};
      bins delay_mic    = {[1:3]};
      bins delay_mediu  = {[4:6]};
      bins delay_mare   = {[7:9]};
	  bins delay_foarte_mare = {[9:$]};
	  illegal_bins delay_negativ = default;
    }


    // vrem sa vedem ca am testat atat citiri cat si scrieri
    // la FIECARE adresa din DUT
    rd_wr_x_addr: cross rd_wr_cp, address_cp;

  endgroup

  function new();
    transaction_cg = new();
  endfunction

  // Esantionarea se face la fiecare tranzactie primita
  task sample(transaction_in trans_covered);
    this.trans_covered = trans_covered;
    transaction_cg.sample();
  endtask : sample

  // Afisarea valorilor de coverage pentru fiecare grup in parte
  function void print_coverage();
    $display("----------------------------------------");
    $display("[COVERAGE] Rd/Wr coverage      = %.2f%%", transaction_cg.rd_wr_cp.get_coverage());
    $display("[COVERAGE] Address coverage    = %.2f%%", transaction_cg.address_cp.get_coverage());
    $display("[COVERAGE] Write data coverage = %.2f%%", transaction_cg.write_data_cp.get_coverage());
    $display("[COVERAGE] Read data coverage  = %.2f%%", transaction_cg.read_data_cp.get_coverage());
    $display("[COVERAGE] Delay coverage      = %.2f%%", transaction_cg.delay_cp.get_coverage());
    $display("[COVERAGE] Overall coverage    = %.2f%%", transaction_cg.get_coverage());
    $display("----------------------------------------");
  endfunction

endclass : coverage_in