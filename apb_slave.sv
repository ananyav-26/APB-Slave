//------------------------------------------------------------------------------
// APB Slave Module
// - Supports 4 registers mapped to addresses 0x0, 0x4, 0x8, and 0xC
// - Write on (PSEL && PENABLE && PWRITE)
// - Read on (PSEL && !PWRITE)
//------------------------------------------------------------------------------

module apb_slave #(
  parameter ADDR_WIDTH = 4,     // Address width (e.g., 4 bits for 16 locations)
  parameter DATA_WIDTH = 32     // Data width (default 32-bit)
)(
  input  logic                  PCLK,       // APB clock
  input  logic                  PRESETn,    // Active-low reset
  input  logic                  PSEL,       // Select signal
  input  logic                  PENABLE,    // Enable signal
  input  logic                  PWRITE,     // Write signal
  input  logic [ADDR_WIDTH-1:0] PADDR,      // Address bus
  input  logic [DATA_WIDTH-1:0] PWDATA,     // Write data bus
  output logic [DATA_WIDTH-1:0] PRDATA,     // Read data bus
  output logic                  PREADY      // Slave ready signal
);

  // Internal register file: 4 registers of DATA_WIDTH each
  logic [DATA_WIDTH-1:0] registers[4];

  // Always ready to accept transfers
  assign PREADY = 1'b1;

  // Write logic: Triggered on rising edge of clock or falling edge of reset
  always_ff @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
      // Reset all registers
      registers[0] <= '0;
      registers[1] <= '0;
      registers[2] <= '0;
      registers[3] <= '0;
    end else if (PSEL && PENABLE) begin
      if (PWRITE) begin
        // Address decode and write
        case (PADDR)
          4'h0: registers[0] <= PWDATA;
          4'h4: registers[1] <= PWDATA;
          4'h8: registers[2] <= PWDATA;
          4'hC: registers[3] <= PWDATA;
          default: ; // Ignore writes to undefined addresses
        endcase
      end
    end
  end

  // Read logic: Combinational block
  always_comb begin
    if (PSEL && !PWRITE) begin
      // Address decode and read
      case (PADDR)
        4'h0: PRDATA = registers[0];
        4'h4: PRDATA = registers[1];
        4'h8: PRDATA = registers[2];
        4'hC: PRDATA = registers[3];
        default: PRDATA = '0; // Return 0 on invalid address
      endcase
    end else begin
      PRDATA = '0;
    end
  end

endmodule
