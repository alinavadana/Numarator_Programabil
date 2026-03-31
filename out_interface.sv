  interface interface_in(input logic clk, rst_n);
  logic [7:0] count_o;
  logic ovf_o;

  
  //monitor clocking block
  clocking monitor_cb @(posedge clk);
    default input #1 output #1;
    input count_o;
    input ovf_o;  
  endclocking
  
  
  //monitor modport  
  modport MONITOR (clocking monitor_cb,input clk,rst_n);

  

//-------------Asertii_ovf_o-----------------
   property ovf_asserted;
    @(posedge clk) disable iff (rst_n==0)//daca avem reset, nu se executa asertia
    ovf_o |-> ((count_o==0) or ($past(count_o)==0)) ; 
   endproperty
  
  asertia_ovf_asserted assert property (ovf_asserted) 
    else $error("INTERFATA_IESIRE: a picat asertia asertia_ovf_assertedn");
    ovf_asserted: cover property (ovf_asserted);//ne asiguram ca proprietatea a fost accesata macar o data



//-------------Asertii_count_o-----------------
   property count_asserted;
    @(posedge clk) disable iff (rst_n==0)//daca avem reset, nu se executa asertia
     ($past(count_o)==255) and (count_o==0) ||
      ($past(count_o)==0) and (count_o==255)     |-> ovf_o;
   endproperty
  
  asertia_count_asserted assert property (count_asserted) 
    else $error("INTERFATA_IESIRE: a picat asertia count_asserted");
    count_asserted: cover property (count_asserted);



  
endinterface