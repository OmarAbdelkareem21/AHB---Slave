library verilog;
use verilog.vl_types.all;
entity Top is
    generic(
        AddresseWidth   : integer := 4;
        DataWidth       : integer := 8;
        InWidth         : integer := 8;
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
        HRDATA          : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of AddresseWidth : constant is 1;
    attribute mti_svvh_generic_type of DataWidth : constant is 1;
    attribute mti_svvh_generic_type of InWidth : constant is 1;
    attribute mti_svvh_generic_type of ControlWidth : constant is 1;
end Top;
