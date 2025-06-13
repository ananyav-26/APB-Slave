module apb_slave #(
  parameter ADDR_WIDTH = 4,
  parameter DATA_WIDTH = 32
)(
  input  logic                  PCLK,       // Clock signal
  input  logic                  PRESETn,    // Active-low reset
  input  logic                  PSEL,       // Peripheral select
  input  logic                  PENABLE,    // Transfer enable
  input  logic                  PWRITE,     // Write control
  input  logic [ADDR_WIDTH-1:0] PADDR,      // Address bus
  input  logic [DATA_WIDTH-1:0] PWDATA,     // Write data bus
  output logic [DATA_WIDTH-1:0] PRDATA,     // Read data bus
  output logic                  PREADY      // Transfer ready
);

  // Internal register file (4 registers of DATA_WIDTH each)
  logic [DATA_WIDTH-1:0] registers [0:3];

  // Synchronous write/reset logic
  always_ff @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
      registers[0] <= 0;
      registers[1] <= 0;
      registers[2] <= 0;
      registers[3] <= 0;
    end else begin
      if (PSEL && PENABLE && PWRITE)
        registers[PADDR[1:0]] <= PWDATA;  // Write to selected register
    end
  end

  // Combinational read logic and ready signal
  always_comb begin
    PREADY = 1;  // Always ready
    if (PSEL && PENABLE && !PWRITE)
      PRDATA = registers[PADDR[1:0]];  // Read from selected register
    else
      PRDATA = 0;
  end

endmodule
