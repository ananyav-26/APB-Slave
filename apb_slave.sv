module apb_slave #(
  parameter ADDR_WIDTH = 4,
  parameter DATA_WIDTH = 32
)(
  input  logic                  PCLK,
  input  logic                  PRESETn,
  input  logic                  PSEL,
  input  logic                  PENABLE,
  input  logic                  PWRITE,
  input  logic [ADDR_WIDTH-1:0] PADDR,
  input  logic [DATA_WIDTH-1:0] PWDATA,
  output logic [DATA_WIDTH-1:0] PRDATA,
  output logic                  PREADY
);

  logic [DATA_WIDTH-1:0] registers[4];

  assign PREADY = 1'b1;

  always_ff @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
      registers[0] <= 0;
      registers[1] <= 0;
      registers[2] <= 0;
      registers[3] <= 0;
    end else if (PSEL && PENABLE) begin
      if (PWRITE) begin
        case (PADDR)
          4'h0: registers[0] <= PWDATA;
          4'h4: registers[1] <= PWDATA;
          4'h8: registers[2] <= PWDATA;
          4'hC: registers[3] <= PWDATA;
        endcase
      end
    end
  end

  always_comb begin
    if (PSEL && !PWRITE) begin
      case (PADDR)
        4'h0: PRDATA = registers[0];
        4'h4: PRDATA = registers[1];
        4'h8: PRDATA = registers[2];
        4'hC: PRDATA = registers[3];
        default: PRDATA = '0;
      endcase
    end else begin
      PRDATA = '0;
    end
  end
endmodule
