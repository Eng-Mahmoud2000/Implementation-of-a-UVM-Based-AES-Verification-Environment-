class my_scoreboard extends uvm_scoreboard;

`uvm_component_utils(my_scoreboard)
my_sequence_item my_sequence_item_insta;
uvm_analysis_imp #(my_sequence_item, my_scoreboard) get_port;   // declaring port for retriving the transaction from monitor
int i = 0;
int fd;

logic [127:0] expected_output;

// the constractor
function new (string name = "scoreboard", uvm_component parent = null);
  super.new(name,parent);
endfunction

function void build_phase (uvm_phase phase);
  super.build_phase(phase);
  get_port = new("get_port",this);
endfunction

function void connect_phase (uvm_phase phase);
  super.connect_phase(phase);
endfunction

task run_phase (uvm_phase phase);
  super.run_phase(phase);
endtask

virtual function void write (my_sequence_item t);   
  my_sequence_item_insta = t;
  i = i+1;

  // Open file "key.txt" for writing

  fd = $fopen("Path to key file -------------","w");

  if (fd == 0) begin
    $error("Error: Unable to open file 'key.txt' for writing.");
  end

  // Writing to file : First line writing the data , Second line writing the key

  $fdisplay(fd,"%h \n%h",t.Data_in , t.key);

  // Close the "key.txt"

  $fclose(fd);

  // "$system" task to run the python code and interact with SCOREBOARD through I/O files

  $system("python Path to python file -------------");

  // Open file "output.txt" for reading

  fd = $fopen("Path to output file -------------","r");

  if (fd == 0) begin
    $error("Error: Unable to open file 'output.txt' for reading.");
  end

  // Reading the output of python code through "output.txt" file

  $fscanf(fd,"%h",expected_output);

  // Close the "output.txt"

  $fclose(fd);

  $display("Scoreboard: Received transaction No.[%0d]: Data_in=%0h, key=%0h, Data_out=%0h",
            i ,my_sequence_item_insta.Data_in, my_sequence_item_insta.key, my_sequence_item_insta.Data_out); // for debugging
    // Compare AES output with expected data
  if (t.Data_out == expected_output) begin
      $display("PASS: Actual Out =%0h matched the Expected Out =%0h", t.Data_out, expected_output);
    end
    else begin
      $error("FAIL: Actual Out =%0h didn't matche the Expected Out =%0h", t.Data_out, expected_output);
    end
endfunction

endclass