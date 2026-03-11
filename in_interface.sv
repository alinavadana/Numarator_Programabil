interface interface_in(input logic clk, rst_n);

  logic valid_i;
  logic rd_wr_i;
  logic [1:0] addr_i;
  logic [7:0] d_in;
  logic [7:0] d_out;

  
  clocking driver_cb @(posedge clk);
    //semnalele de intrare sunt citite o unitate de timp inainte frontului de ceas, iar semnalele de iesire sunt citite o unitate de timp dupa frontul de ceas; astfel se elimina situatiile in care se fac scrieri sau citiri in acelasi timp
  input d_out;
  output d_in;
  output addr_i;
  output rd_wr_i;
  output valid_i;
  endclocking
  
  //monitor clocking block
  clocking monitor_cb @(posedge clk);
    default input #1 output #1;
    input addr_i;
    input d_in;
    input d_out;
    input rd_wr_i;
    input valid_i;  
  endclocking
  
  //driver modport
  modport DRIVER  (clocking driver_cb,input clk,rst_n);
  
  //monitor modport  
  modport MONITOR (clocking monitor_cb,input clk,rst_n);

          //asertii pe interfata
	//nu avem voie sa avem si read si write in acelai timp


  //-------------Asertii_addr-----------------
   property steady_addr_during_transaction;
     @(posedge clk) disable iff (rst_n==0)//daca avem reset, nu se executa asertia
     valid_i |-> (addr_i != 'bz) and (addr_i != 'bx);
  endproperty
  
  asertia_steady_addr_during_transaction assert property (steady_addr_i_during_transaction) 
    else $error("INTERFATA_INTRARE: a picat asertia asertia_steady_addr_i_during_transaction");
    steady_addr_i_during_transaction_C: cover property (steady_addr_i_during_transaction);//ne asiguram ca proprietatea a fost accesata macar o data
      



//-------------Asertii_d_in-----------------
   property steady_d_in_during_transaction;
    @(posedge clk) disable iff (rst_n==0)//daca avem reset, nu se executa asertia
    valid_i && !rd_wr_i|-> (d_in != 'bz) and (d_in != 'bx);  // cand scrierea este valida
   endproperty
  
  asertia_steady_d_in_during_transaction assert property (steady_d_in_during_transaction) 
    else $error("INTERFATA_INTRARE: a picat asertia asertia_steady_d_in_during_transaction");
    steady_d_in_during_transaction_C: cover property (steady_d_in_during_transaction);//ne asiguram ca proprietatea a fost accesata macar o data

//-------------Asertii_d_out-----------------
   property steady_d_out_during_transaction;
    @(posedge clk) disable iff (rst_n==0)//daca avem reset, nu se executa asertia
    valid_i && rd_wr_i |=> (d_out != 'bz) and (d_out != 'bx);
   endproperty
  
  asertia_steady_d_out_during_transaction assert property (steady_d_out_during_transaction) 
    else $error("INTERFATA_INTRARE: a picat asertia asertia_steady_d_out_during_transaction");
    steady_d_out_during_transaction_C: cover property (steady_d_out_during_transaction);//ne asiguram ca proprietatea a fost accesata macar o data


//-------------Asertii_rd_wr_i-----------------
   property steady_rd_wr_i_during_transaction;
     @(posedge clk) disable iff (rst_n==0)//daca avem reset, nu se executa asertia
     valid_i |-> (rd_wr_i != 'bz) and (rd_wr_i != 'bx);
  endproperty
  
  asertia_steady_rd_wr_i_during_transaction assert property (steady_rd_wr_i_during_transaction) 
    else $error("INTERFATA_INTRARE: a picat asertia asertia_steady_rd_wr_i_during_transaction");
    steady_rd_wr_i_during_transaction_C: cover property (steady_rd_wr_i_during_transaction);//ne asiguram ca proprietatea a fost accesata macar o data
      
      
  
  
endinterface