module pipeline_proc_chip
(
    input logic clk,
    input logic reset,
    output logic [3:0] arr0, arr1, arr2, arr3
);

    // -------------------------------------------------------------------------
    // 1. Internal Signals (Core <-> Pad connection)
    // -------------------------------------------------------------------------
    logic chip_clk;
    logic chip_reset;
    logic [3:0] chip_arr0, chip_arr1, chip_arr2, chip_arr3;

    // -------------------------------------------------------------------------
    // 2. Input Pads
    // -------------------------------------------------------------------------
    sg13g2_IOPadIn pad_clk   (.pad(clk),   .p2c(chip_clk));
    sg13g2_IOPadIn pad_reset (.pad(reset), .p2c(chip_reset));

    // -------------------------------------------------------------------------
    // 3. Output Pads (Optimized for Power: 16mA -> 4mA)
    // -------------------------------------------------------------------------
    // Using 4mA drive strength to save power and reduce switching noise.
    
    // Array 0
    sg13g2_IOPadOut4mA pad_arr0_0 (.pad(arr0[0]), .c2p(chip_arr0[0]));
    sg13g2_IOPadOut4mA pad_arr0_1 (.pad(arr0[1]), .c2p(chip_arr0[1]));
    sg13g2_IOPadOut4mA pad_arr0_2 (.pad(arr0[2]), .c2p(chip_arr0[2]));
    sg13g2_IOPadOut4mA pad_arr0_3 (.pad(arr0[3]), .c2p(chip_arr0[3]));

    // Array 1
    sg13g2_IOPadOut4mA pad_arr1_0 (.pad(arr1[0]), .c2p(chip_arr1[0]));
    sg13g2_IOPadOut4mA pad_arr1_1 (.pad(arr1[1]), .c2p(chip_arr1[1]));
    sg13g2_IOPadOut4mA pad_arr1_2 (.pad(arr1[2]), .c2p(chip_arr1[2]));
    sg13g2_IOPadOut4mA pad_arr1_3 (.pad(arr1[3]), .c2p(chip_arr1[3]));

    // Array 2
    sg13g2_IOPadOut4mA pad_arr2_0 (.pad(arr2[0]), .c2p(chip_arr2[0]));
    sg13g2_IOPadOut4mA pad_arr2_1 (.pad(arr2[1]), .c2p(chip_arr2[1]));
    sg13g2_IOPadOut4mA pad_arr2_2 (.pad(arr2[2]), .c2p(chip_arr2[2]));
    sg13g2_IOPadOut4mA pad_arr2_3 (.pad(arr2[3]), .c2p(chip_arr2[3]));

    // Array 3
    sg13g2_IOPadOut4mA pad_arr3_0 (.pad(arr3[0]), .c2p(chip_arr3[0]));
    sg13g2_IOPadOut4mA pad_arr3_1 (.pad(arr3[1]), .c2p(chip_arr3[1]));
    sg13g2_IOPadOut4mA pad_arr3_2 (.pad(arr3[2]), .c2p(chip_arr3[2]));
    sg13g2_IOPadOut4mA pad_arr3_3 (.pad(arr3[3]), .c2p(chip_arr3[3]));

    // -------------------------------------------------------------------------
    // 4. Power Pads
    // -------------------------------------------------------------------------
    // Core Power (Logic)
    (* dont_touch = "true" *) sg13g2_IOPadVdd pad_vdd0();
    (* dont_touch = "true" *) sg13g2_IOPadVdd pad_vdd1();
    (* dont_touch = "true" *) sg13g2_IOPadVss pad_vss0();
    (* dont_touch = "true" *) sg13g2_IOPadVss pad_vss1();

    // IO Power (Pad Ring)
    (* dont_touch = "true" *) sg13g2_IOPadIOVdd pad_vddio0();
    (* dont_touch = "true" *) sg13g2_IOPadIOVdd pad_vddio1();
    (* dont_touch = "true" *) sg13g2_IOPadIOVss pad_vssio0();
    (* dont_touch = "true" *) sg13g2_IOPadIOVss pad_vssio1();

    // -------------------------------------------------------------------------
    // 5. Corner Pads (CRITICAL ADDITION)
    // -------------------------------------------------------------------------
    // These close the power rings at the 4 corners of the chip.
    sg13g2_Corner corner_ll (); // Lower Left
    sg13g2_Corner corner_lr (); // Lower Right
    sg13g2_Corner corner_ul (); // Upper Left
    sg13g2_Corner corner_ur (); // Upper Right

    // -------------------------------------------------------------------------
    // 6. Core Instantiation
    // -------------------------------------------------------------------------
    pipeline_proc i_pipeline_proc (
        .clk    (chip_clk),
        .reset  (chip_reset),
        .arr0   (chip_arr0),
        .arr1   (chip_arr1),
        .arr2   (chip_arr2),
        .arr3   (chip_arr3)
    );

endmodule