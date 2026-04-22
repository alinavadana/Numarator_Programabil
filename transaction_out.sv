//-------------------------------------------------------------------------
//						www.verificationguide.com 
//-------------------------------------------------------------------------

//aici se declara tipul de data folosit pentru a stoca datele vehiculate intre generator si driver; monitorul, de asemenea, preia datele de pe interfata, le recompune folosind un obiect al acestui tip de data, si numai apoi le proceseaza
class transaction_out;
  //se declara atributele clasei
  //campurile declarate cu cuvantul cheie rand vor primi valori aleatoare la aplicarea functiei randomize()
  bit [7:0] count_o;
  bit ovf_o;
	   
  int cnt; //pt utilizare a tranzactilor ca sa stim cate tranzactii folosim 
  int delay;
  
  
  //aceasta functie este apelata dupa aplicarea functiei randomize() asupra obiectelor apartinand acestei clase
  //aceasta functie afiseaza valorile aleatorizate ale atributelor clasei
  function void display();
    $display("--------- tranzactia nr %d randomizata : ------");
    $display("count_o = %0b",count_o);
	$display("ovf_o = %0b",ovf_o);
	$display("delay = %0d",delay);
	$display("----------------------------------------------------------------------------------------------------------------------");
  endfunction
  
  //operator de copiere a unui obiect intr-un alt obiect (deep copy)
  function transaction_out do_copy();
    transaction_out trans;
    trans = new();
	trans.count_o  = this.count_o;
    trans.ovf_o  = this.ovf_o;
	trans.delay  = this.delay;
	
    return trans;
  endfunction
endclass
