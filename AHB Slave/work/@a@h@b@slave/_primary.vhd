library verilog;
use verilog.vl_types.all;
entity AHBSlave is
    generic(
        AddresseWidth   : integer := 32;
        DataWidth       : integer := 32;
        InWidth         : integer := 32;
        ControlWidth    : integer := 16
    );
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        HWDATA          : in     vl_logic_vector;
        HADDR           : in     vl_logic_vector;
        HWRITE          : in     vl_logic;
        HSIZE           : in     vl_logic_vector(2 downto 0);
        HBURST          : in     vl_logic_vector(2 downto 0);
        HTRANS          : in     vl_logic_vector(1 downto 0);
        HREADY          : in     vl_logic;
        HSELx           : in     vl_logic;
        HREADYOUT       : out    vl_logic;
        HRESP           : out    vl_logic;
        HRDATA          : out    vl_logic_vector;
        Write           : out    vl_logic;
        Read            : out    vl_logic;
        AddressOUT      : out    vl_logic_vector;
        OutputData      : out    vl_logic_vector;
        InData          : in     vl_logic_vector;
        ValidRead       : in     vl_logic;
        StopOp          : in     vl_logic;
        ReadyToWork     : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of AddresseWidth : constant is 1;
    attribute mti_svvh_generic_type of DataWidth : constant is 1;
    attribute mti_svvh_generic_type of InWidth : constant is 1;
    attribute mti_svvh_generic_type of ControlWidth : constant is 1;
end AHBSlave;
