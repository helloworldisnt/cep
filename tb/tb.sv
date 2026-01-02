module TB;

logic clk;
logic reset1;
logic clk100Hz;
logic clk1Hz;
logic reset;
logic [ 3:0] arr0, arr1, arr2, arr3;
logic an0, an1, an2, an3, an4, an5, an6, an7;
logic segA, segB, segC, segD, segE, segF, segG;
logic [ 7:0] countq_clk, countd_clk;

pipeline_proc_chip MEA (.*);

initial begin
    clk = 1'b1;
    forever #5 clk = ~clk;
end

initial begin
    //$readmemh("InstMemoryContents.txt", MEA.dut.imem.memory);
    reset1 = 1'b1;
    #10;
    reset1 = 1'b0;

    @(posedge clk1Hz);
    reset = 1'b1;
    @(posedge clk1Hz);
    reset = 1'b0;

    // 3. START VCD DUMP (Start of Active Window)
    // We start here to exclude reset/startup as per guidelines 
    $display("State: Reset complete. Starting VCD dump.");
    $dumpfile("proc.vcd");
    $dumpvars(0, MEA);

    // 4. Run Simulation for Workload Duration
    // Adjust this delay to cover your assembly program's execution time
  #200000; 

    // 5. STOP VCD DUMP (End of Active Window)
    $display("State: Workload complete. Stopping VCD dump.");
    $dumpoff;
    $finish;
end

endmodule