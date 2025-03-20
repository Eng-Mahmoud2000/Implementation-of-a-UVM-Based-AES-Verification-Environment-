class my_driver extends uvm_driver #(my_sequence_item);

`uvm_component_utils(my_driver)           // registering
my_sequence_item my_sequence_item_insta;
virtual intf v_intf;                      // declaring virtual interface
int i = 0;                                // transaction index

// the constructor
function new (string name = "my_driver", uvm_component parent = null);
  super.new(name,parent);
endfunction

function void build_phase (uvm_phase phase);
  super.build_phase(phase);
  my_sequence_item_insta = my_sequence_item::type_id::create("my_sequence_item_insta",this);
  if(uvm_config_db #(virtual intf)::get(this,"","my_vif",v_intf))      // retrive the virtual interface from configuration database
  	`uvm_info ("Driver", $sformatf ("[%s] found %p", this.get_name(), v_intf), UVM_MEDIUM)

endfunction

task run_phase (uvm_phase phase);
  super.run_phase(phase);
  while (1) begin
  seq_item_port.get_next_item(my_sequence_item_insta);
  //Drive the transaction to dut
    v_intf.Data_in <= my_sequence_item_insta.Data_in;
    v_intf.key     <= my_sequence_item_insta.key; 
    i               = i+1;
    $display("Driver: Received transaction No.[%0d]: Data_in=%0h, key=%0h",
                i ,my_sequence_item_insta.Data_in, my_sequence_item_insta.key); // for debugging
    #1step;    
  seq_item_port.item_done();
  end
endtask

endclass