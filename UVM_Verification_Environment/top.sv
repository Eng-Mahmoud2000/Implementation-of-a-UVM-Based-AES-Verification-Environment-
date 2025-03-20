module top();
  import uvm_pkg::*;
  import pack1::*;
  intf intf1 ();
  // Instantiate the AES and connect interface signals to the AES module
 AES_Encrypt #(.N(128),.Nr(10),.Nk(4)) AES_inst(
    .in(intf1.Data_in),
    .key(intf1.key),
    .out(intf1.Data_out)
  );

  initial begin
    // set interface in configuration database 
    uvm_config_db #(virtual intf)::set(null,"uvm_test_top.my_env_insta.my_agent_insta.*","my_vif",intf1); // keep tracking in hierarchical name
    run_test("my_test");
  end

endmodule
