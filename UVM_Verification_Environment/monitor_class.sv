class my_monitor extends uvm_monitor;

`uvm_component_utils(my_monitor)
my_sequence_item my_sequence_item_insta;
virtual intf v_intf;                                      // declaring virtual interface
uvm_analysis_port #(my_sequence_item) put_port_monitor;   // declare analysis port for communication between monitor and subscriber & scoreboard
int i = 1 ;                                               // transaction index

// the constructor
function new (string name = "my_monitor", uvm_component parent = null);
  super.new(name,parent);
endfunction

function void build_phase (uvm_phase phase);
  super.build_phase(phase);
  my_sequence_item_insta = my_sequence_item::type_id::create("my_sequence_item_insta",this);
  put_port_monitor = new("put_port_monitor",this);
  if(uvm_config_db #(virtual intf)::get(this,"","my_vif",v_intf))
  	`uvm_info ("Monitor", $sformatf ("[%s] found %p", this.get_name(), v_intf), UVM_MEDIUM)
endfunction

function void connect_phase (uvm_phase phase);
  super.connect_phase(phase);
endfunction

task run_phase (uvm_phase phase);

  while (1) begin
    #1step;    
    //monitoring the transaction from dut
    my_sequence_item_insta.Data_in    = v_intf.Data_in;
    my_sequence_item_insta.key        = v_intf.key; 
    my_sequence_item_insta.Data_out   = v_intf.Data_out;

      $display("Monitor: Received transaction No.[%0d]: Data_in=%0h, key=%0h, Data_out=%0h",
              i ,my_sequence_item_insta.Data_in, my_sequence_item_insta.key, my_sequence_item_insta.Data_out); // for debugging
      i = i + 1;
      put_port_monitor.write(my_sequence_item_insta);  // using calling write function to deliver the transaction to scoreboard & subscriber
  end

endtask

endclass