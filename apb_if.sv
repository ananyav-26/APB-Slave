interface apb_if(input logic clk);
  logic PRESETn;
  logic PSEL, PENABLE, PWRITE;
  logic [3:0] PADDR;
  logic [31:0] PWDATA;
  logic [31:0] PRDATA;
  logic PREADY;
endinterface
