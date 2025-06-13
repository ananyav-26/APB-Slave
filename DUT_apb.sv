module apb_slave #(parameter ADDR_WIDTH = 4, DATA_WIDTH = 32)(
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

  logic [DATA_WIDTH-1:0] registers [0:3];

  always_ff @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
      registers[0] <= 0;
      registers[1] <= 0;
      registers[2] <= 0;
      registers[3] <= 0;
    end else begin
      if (PSEL && PENABLE && PWRITE)
        registers[PADDR[1:0]] <= PWDATA;
    end
  end

  always_comb begin
    PREADY = 1;
    if (PSEL && PENABLE && !PWRITE)
      PRDATA = registers[PADDR[1:0]];
    else
      PRDATA = 0;
  end

endmodule
