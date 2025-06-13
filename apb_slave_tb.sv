`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Testbench for APB Slave Module
//------------------------------------------------------------------------------
module apb_slave_tb;

  //--------------------------------------------------------------------------
  // Parameters
  //--------------------------------------------------------------------------
  parameter ADDR_WIDTH = 4;
  parameter DATA_WIDTH = 32;

  //--------------------------------------------------------------------------
  // Signal Declarations
  //--------------------------------------------------------------------------
  logic clk;
  logic PRESETn;

  logic PSEL, PENABLE, PWRITE;
  logic [ADDR_WIDTH-1:0] PADDR;
  logic [DATA_WIDTH-1:0] PWDATA;
  logic [DATA_WIDTH-1:0] PRDATA;
  logic PREADY;

  //--------------------------------------------------------------------------
  // Clock Generation (100 MHz = 10ns period)
  //--------------------------------------------------------------------------
  always #5 clk = ~clk;

  //--------------------------------------------------------------------------
  // DUT Instantiation
  //--------------------------------------------------------------------------
  apb_slave #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) dut (
    .PCLK   (clk),
    .PRESETn(PRESETn),
    .PSEL   (PSEL),
    .PENABLE(PENABLE),
    .PWRITE (PWRITE),
    .PADDR  (PADDR),
    .PWDATA (PWDATA),
    .PRDATA (PRDATA),
    .PREADY (PREADY)
  );

  //--------------------------------------------------------------------------
  // APB Write Task
  //--------------------------------------------------------------------------
  task automatic apb_write(input [ADDR_WIDTH-1:0] addr, input [DATA_WIDTH-1:0] data);
    @(posedge clk);
    PSEL    <= 1;
    PENABLE <= 0;
    PWRITE  <= 1;
    PADDR   <= addr;
    PWDATA  <= data;

    @(posedge clk);
    PENABLE <= 1;

    @(posedge clk);
    PSEL    <= 0;
    PENABLE <= 0;
    PWRITE  <= 0;
    $display("WRITE @ %0t ns: addr = 0x%0h, data = 0x%0h", $time, addr, data);
  endtask

  //--------------------------------------------------------------------------
  // APB Read Task
  //--------------------------------------------------------------------------
  task automatic apb_read(input [ADDR_WIDTH-1:0] addr);
    @(posedge clk);
    PSEL    <= 1;
    PENABLE <= 0;
    PWRITE  <= 0;
    PADDR   <= addr;

    @(posedge clk);
    PENABLE <= 1;

    @(posedge clk);
    PSEL    <= 0;
    PENABLE <= 0;
    $display("READ  @ %0t ns: addr = 0x%0h, data = 0x%0h", $time, addr, PRDATA);
  endtask

  //--------------------------------------------------------------------------
  // Simulation Sequence
  //--------------------------------------------------------------------------
  initial begin
    // Initialize all signals
    clk     = 0;
    PRESETn = 0;
    PSEL    = 0;
    PENABLE = 0;
    PWRITE  = 0;
    PADDR   = 0;
    PWDATA  = 0;

    // Apply reset
    repeat(2) @(posedge clk);
    PRESETn = 1;

    // Wait for a few cycles after reset
    repeat(2) @(posedge clk);

    // Write to two registers
    apb_write(4'h1, 32'hDEADBEEF);
    apb_write(4'h2, 32'h12345678);

    // Read back from those registers
    apb_read(4'h1);
    apb_read(4'h2);

    // Finish simulation
    repeat(5) @(posedge clk);
    $finish;
  end

  //--------------------------------------------------------------------------
  // VCD Dump for GTKWave
  //--------------------------------------------------------------------------
  initial begin
    $dumpfile("apb_dump.vcd");
    $dumpvars(0, apb_slave_tb);
  end

endmodule
