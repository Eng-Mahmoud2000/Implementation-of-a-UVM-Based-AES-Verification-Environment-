class my_sequence_item extends uvm_sequence_item;

`uvm_object_utils(my_sequence_item)
typedef enum { 
    ZERO_DATA, ONES_DATA, ALT_DATA1, ALT_DATA2, 
    MSB_SET, LSB_SET, INC_PATTERN, DEC_PATTERN, RANDOM_DATA 
} data_pattern_t;
typedef enum { 
    ZERO_KEY, ONES_KEY, ALT_KEY1, ALT_KEY2, 
    MSB_SET1, LSB_SET1, INC_PATTERN1, DEC_PATTERN1, RANDOM_KEY 
} key_pattern_t;
  // Inputs & outputs as random variables
rand logic          [127:0]     Data_in;
rand logic          [127:0]     key;
rand data_pattern_t             pattern_data;       // Select which pattern to use for data
rand key_pattern_t              pattern_key;        // Select which pattern to use for key
logic               [127:0]     Data_out;


    constraint pattern_data_select {
        pattern_data dist {
            RANDOM_DATA := 60,  // 50% probability
            ZERO_DATA   := 5,    // 5% probability
            ONES_DATA   := 5,    // 5% probability
            ALT_DATA1   := 5,    // 5% probability
            ALT_DATA2   := 5,    // 5% probability
            MSB_SET     := 5,    // 5% probability
            LSB_SET     := 5,    // 5% probability
            INC_PATTERN := 5,    // 5% probability
            DEC_PATTERN := 5     // 5% probability
        };
    }

    constraint pattern_key_select {
        pattern_key dist {
            RANDOM_KEY   := 60,  // 60% probability
            ZERO_KEY     := 5,    // 5% probability
            ONES_KEY     := 5,    // 5% probability
            ALT_KEY1     := 5,    // 5% probability
            ALT_KEY2     := 5,    // 5% probability
            MSB_SET1     := 5,    // 5% probability
            LSB_SET1     := 5,    // 5% probability
            INC_PATTERN1 := 5,    // 5% probability
            DEC_PATTERN1 := 5     // 5% probability
        };
    }

    constraint data_constraints {
        (pattern_data == ZERO_DATA)   -> Data_in == 128'b0;
        (pattern_data == ONES_DATA)   -> Data_in == 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        (pattern_data == ALT_DATA1)   -> Data_in == 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
        (pattern_data == ALT_DATA2)   -> Data_in == 128'h55555555555555555555555555555555;
        (pattern_data == MSB_SET)     -> Data_in == 128'h80000000000000000000000000000000;
        (pattern_data == LSB_SET)     -> Data_in == 128'h00000000000000000000000000000001;
        (pattern_data == INC_PATTERN) -> Data_in == 128'h0123456789ABCDEF0123456789ABCDEF;
        (pattern_data == DEC_PATTERN) -> Data_in == 128'hFEDCBA9876543210FEDCBA9876543210;
    }


    constraint key_constraints {
        (pattern_key == ZERO_KEY)      -> key == 128'b0;
        (pattern_key == ONES_KEY)      -> key == 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        (pattern_key == ALT_KEY1)      -> key == 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
        (pattern_key == ALT_KEY2)      -> key == 128'h55555555555555555555555555555555;
        (pattern_key == MSB_SET1)      -> key == 128'h80000000000000000000000000000000;
        (pattern_key == LSB_SET1)      -> key == 128'h00000000000000000000000000000001;
        (pattern_key == INC_PATTERN1)  -> key == 128'h0123456789ABCDEF0123456789ABCDEF;
        (pattern_key == DEC_PATTERN1)  -> key == 128'hFEDCBA9876543210FEDCBA9876543210;
    }

function new (string name = "my_sequence_item");
  super.new(name);
endfunction

endclass