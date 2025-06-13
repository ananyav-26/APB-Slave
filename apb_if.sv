// APB Interface Definition
interface apb_if(input logic clk);

  // Active-low reset signal
  logic        PRESETn;

  // APB control signals
  logic        PSEL;       // Select signal
  logic        PENABLE;    // Enable signal
  logic        PWRITE;     // Write control

  // Address and data buses
  logic [3:0]  PADDR;      // 4-bit address bus
  logic [31:0] PWDATA;     // 32-bit write data
  logic [31:0] PRDATA;     // 32-bit read data

  // Ready signal
  logic        PREADY;     // Peripheral ready signal

endinterface
