class generator_in;

rand transaction_in trans, tr;

int trans_cnt = 10;

mailbox gen2driv;

event ended;

function new(mailbox gen2driv, event ended);

    this.gen2driv = gen2driv;
    this.ended    =ended;
    trans = new();

endfunction

task main();
$display("%0t trans_cnt este %0d", $time(), trans_cnt);
 repeat(trans_cnt) begin
    if (!trans.randomize())
        $error("Generator failed to randomize");
    tr = trans.do_copy();
    gen2driv.put(tr);
 end
 -> ended;
endtask

task write_register(bit [1:0] addr, bit [7:0] data );

    if (!trans.randomize() with {d_in ==data; addr_i==addr; valid_i==1; rd_wr==0;})
        $error("Generator failed to randomize");
    tr = trans.do_copy();
    gen2driv.put(tr);

endtask

task read_register(bit [1:0] addr );

    if (!trans.randomize() with { addr_i==addr; valid_i==1; rd_wr==1;})
        $error("Generator failed to randomize");
    tr = trans.do_copy();
    gen2driv.put(tr);

endtask



endclass
