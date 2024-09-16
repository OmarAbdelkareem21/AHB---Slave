library verilog;
use verilog.vl_types.all;
entity RegFile is
    generic(
        width           : integer := 8;
        depth           : integer := 4
    );
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        Wren            : in     vl_logic;
        Rden            : in     vl_logic;
        WrData          : in     vl_logic_vector;
        Adresse         : in     vl_logic_vector;
        RdData_Valid    : out    vl_logic;
        RdData          : out    vl_logic_vector;
        StopOp          : out    vl_logic;
        ReadyToWork     : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
    attribute mti_svvh_generic_type of depth : constant is 1;
end RegFile;
