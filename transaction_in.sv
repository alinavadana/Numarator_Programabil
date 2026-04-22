class transaction_in;
    rand bit valid_i;
    rand bit rd_wr;  // 0 - scriere
                       // 1 - citire
    rand bit [1:0] addr_i;
    rand bit [7:0] d_in;
         bit [7:0] d_out;
    int cnt;
    rand int delay;

// intarzierile intre tranzactii pot fi intre 0 si 10 tacte 
    constraint delay_constr {delay > 0 && delay < 10;}

    function void display();
        $display("-----Tranzactia nr. %0d randomizata:-----", cnt);
        $display("valid_i = %0b", valid_i);
        $display("rd_wr = %0b", rd_wr);
        $display("addr_i = %0b", addr_i);
        $display("d_in = %0b", d_in);
        $display("d_out = %0b", d_out);
        $display("delay = %0d", delay);
        $display("-------------------------------------");
    endfunction

    function transaction_in do_copy();
        transaction_in trans;
        trans = new();
        trans.valid_i = this.valid_i;
        trans.addr_i = this.addr_i;
        trans.rd_wr = this.rd_wr;
        trans.d_in = this.d_in;
        trans.d_out = this.d_out;
        trans.delay = this.delay;

        return trans;
        endfunction
endclass