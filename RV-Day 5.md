# RV Day 5 - Complete Pipelined RISC-V CPU micro-architecture
## 1) Pipelining the CPU
### L1_Introduction To Control Flow Hazard And Read After Write Hazard
### L2_Lab To Create 3-Cycle Valid Signal
  ![Screenshot 2025-04-30 231510](https://github.com/user-attachments/assets/732a1fb7-9ae7-4284-8da5-c76781847c08)

### L3_Lab To Code 3-Cycle RISC-V To Take Care Of Invalid Cycles
  ![Screenshot 2025-04-30 231921](https://github.com/user-attachments/assets/d3880e0c-68d1-4371-b483-e3054916e945)

### L4_Lab To Modify 3-Cycle RISC-V To Distribute Logic
  ![Screenshot 2025-04-30 232059](https://github.com/user-attachments/assets/bf729518-751c-439c-9015-d1ef59803ba8)

## 2) Solutions to Pipeline Hazards
### L1_Lab For Register File Bypass To Address Rd-After-Wr Hazard
  - Introduces a bypass path from the ALU output of the previous instruction to the input of the current instruction.
  - Allows immediate use of results without waiting for them to be written and read from the register file.
  - Uses a multiplexer to choose between bypassed value and register file value.
  ![Screenshot 2025-04-30 232250](https://github.com/user-attachments/assets/5a666d66-4c34-459a-b9f0-e6266e20096c)

### L2_Lab For Branches To Correct The Branch Target Path
On taking a branch, the CPU must redirect the PC correctly and invalidate speculative instructions.
- Due to three-cycle latency in decoding, reading, and computing the target, a two-cycle penalty is unavoidable.
- The PC redirection path remains a three-cycle loop.
- Valid signal logic is updated to allow valid instructions only when prior branches are not taken.
- PC loop is updated to a 1-cycle loop for normal execution, retaining a 3-cycle loop for branch redirection.
- Simulate with the near one-instruction-per-cycle model.
- Validate the bypass and branch handling logic.
  ![Screenshot 2025-04-30 232925](https://github.com/user-attachments/assets/930e650e-5c1d-4d4d-95c8-ed6a8472c26f)
  ![Screenshot 2025-04-30 233008](https://github.com/user-attachments/assets/6bda6101-8742-4d90-a4d2-f0c81ae696bf)

### L3_Lab To Complete Instruction Decode Except Fence, Ecall, Ebreak
- Decode logic interprets machine instructions into control signals.
- Implement remaining instructions of **RV32I base set**, except for:
  - `fence`, `ecall`, and `ebreak`.
- Introduce `is_load` signal to simplify decoding of all load instructions.

### L4_Lab To Code Complete ALU
  ![Screenshot 2025-04-30 232925](https://github.com/user-attachments/assets/930e650e-5c1d-4d4d-95c8-ed6a8472c26f)

-----
  
## 3) Load/Store Instructions and Completing RISC-V CPU
### L1. Introduction To Load Store Instructions And Lab To Redirect Loads
### L2_Lab To Load Data From Memory To Register File
### L3_Lab To Instantiate Data Memory To The CPU
### L4_Lab To Add Stores And Loads To The Test Program
### L5_Lab To Add Control Logic For Jump Instructions

-----

**Code**

  \m4_TLV_version 1d: tl-x.org
  \SV
   // This code can be found in: https://github.com/stevehoover/RISC-V_MYTH_Workshop
   
   m4_include_lib(['https://raw.githubusercontent.com/BalaDhinesh/RISC-V_MYTH_Workshop/master/tlv_lib/risc-v_shell_lib.tlv'])

  \SV
     m4_makerchip_module   // (Expanded in Nav-TLV pane.)
  \TLV

   // /====================\
   // | Sum 1 to 9 Program |
   // \====================/
   //
   // Program for MYTH Workshop to test RV32I
   // Add 1,2,3,...,9 (in that order).
   //
   // Regs:
   //  r10 (a0): In: 0, Out: final sum
   //  r12 (a2): 10
   //  r13 (a3): 1..10
   //  r14 (a4): Sum
   // 
   // External to function:
   m4_asm(ADD, r10, r0, r0)             // Initialize r10 (a0) to 0.
   // Function:
   m4_asm(ADD, r14, r10, r0)            // Initialize sum register a4 with 0x0
   m4_asm(ADDI, r12, r10, 1010)         // Store count of 10 in register a2.
   m4_asm(ADD, r13, r10, r0)            // Initialize intermediate sum register a3 with 0
   // Loop:
   m4_asm(ADD, r14, r13, r14)           // Incremental addition
   m4_asm(ADDI, r13, r13, 1)            // Increment intermediate register by 1
   m4_asm(BLT, r13, r12, 1111111111000) // If a3 is less than a2, branch to label named <loop>
   m4_asm(ADD, r10, r14, r0)            // Store final result to register a0 so that it can be read by main program
   
   m4_asm(SW, r0, r10, 10000)
   m4_asm(LW, r17, r0, 10000)
   // Optional:
   // m4_asm(JAL, r7, 00000000000000000000) // Done. Jump to itself (infinite loop). (Up to 20-bit signed immediate plus implicit 0 bit (unlike JALR) provides byte address; last immediate bit should also be 0)
   m4_define_hier(['M4_IMEM'], M4_NUM_INSTRS)

   |cpu
      @0
         $reset = *reset;
         //$start = !$reset && >>1$reset;
         //$valid = $start || >>3$valid; //might need to include reset check here
         //$valid = $reset ? '0 : 
         //         >>3$valid ? '1 : $start;
         
         $pc[31:0] = >>1$reset ? '0:
                     (>>3$valid_taken_br || (>>3$is_jal && >>3$valid_jump)) ? >>3$br_tgt_pc :
                     (>>3$is_jalr && >>3$valid_jump) ? >>3$jalr_tgt_pc :
                     >>3$valid_load?  >>3$inc_pc:
                     >>1$inc_pc;
                     
         $imem_rd_addr[M4_IMEM_INDEX_CNT - 1:0] = $pc[M4_IMEM_INDEX_CNT + 1:2];
         $imem_rd_en = !$reset;
      @1
         $instr[31:0] = $imem_rd_data;
         $inc_pc[31:0] = $pc + 4;
         $is_i_instr = $instr[6:2] ==? 5'b0000x ||
                       $instr[6:2] ==? 5'b001x0 ||
                       $instr[6:2] ==  5'b11001 ||
                       $instr[6:2] ==  5'b11100;
         
         $is_r_instr = $instr[6:2] ==? 5'b011x0 ||
                       $instr[6:2] ==  5'b01011 ||
                       $instr[6:2] ==  5'b10100;

         $is_s_instr = $instr[6:2] ==? 5'b0100x;
         
         $is_b_instr = $instr[6:2] == 5'b11000;
         
         $is_u_instr = $instr[6:2] ==? 5'b0x101;
         
         $is_j_instr = $instr[6:2] == 5'b11011;
         
         $imm[31:0] = $is_i_instr ? {{21{$instr[31]}},$instr[30:20]} :
                      $is_s_instr ? {{21{$instr[31]}},$instr[30:25],$instr[11:8],$instr[7:7]} :
                      $is_b_instr ? {{19{$instr[31]}},$instr[7],$instr[30:25],$instr[11:8],'0} :
                      $is_u_instr ? {$instr[31],$instr[30:20],$instr[19:12],'0} :
                      $is_j_instr ? {{12{$instr[31]}},$instr[19:12],$instr[20],$instr[30:25],$instr[24:21],'0} : '0;
         
         $opcode[6:0] = $instr[6:0];
         
         $rd_valid = $is_r_instr || $is_i_instr || $is_u_instr || $is_j_instr;
         ?$rd_valid
            $rd[4:0] = $instr[11:7];
       
         $funct3_valid = $is_r_instr || $is_i_instr || $is_s_instr || $is_b_instr;
         ?$funct3_valid
            $funct3[2:0] = $instr[14:12];
            
         $rs1_valid = $is_r_instr || $is_i_instr || $is_s_instr || $is_b_instr; 
         ?$rs1_valid
            $rs1[4:0] = $instr[19:15];
            
         $rs2_valid = $is_r_instr || $is_s_instr || $is_b_instr; 
         ?$rs2_valid
            $rs2[4:0] = $instr[24:20];
         
         $funct7_valid = $is_r_instr; 
         ?$funct7_valid
            $funct7[6:0] = $instr[31:25];
            
         $dec_bits[11:0] = {$funct7[5],$funct3,$opcode};
         
         $is_beq = $dec_bits ==?  11'bx_000_1100011;
         $is_bne = $dec_bits ==?  11'bx_001_1100011;
         $is_blt = $dec_bits ==?  11'bx_100_1100011;
         $is_bge = $dec_bits ==?  11'bx_101_1100011;
         $is_bltu = $dec_bits ==? 11'bx_110_1100011;
         $is_bgeu = $dec_bits ==? 11'bx_111_1100011;
         $is_addi = $dec_bits ==? 11'bx_000_0010011;
         $is_add = $dec_bits ==   11'b0_000_0110011;
         //$is_load = $opcode == 7'b0000011;
         $is_load = $dec_bits ==?   11'bx_xxx_0000011;
         //$is_lui = $opcode == 7'b0110111;
         $is_lui = $dec_bits ==?   11'bx_xxx_0110111;
         //$is_auipac = $opcode == 7'b0010111;
         $is_auipc = $dec_bits ==?   11'bx_xxx_0010111;
         //$is_jal = $opcode == 7'b1101111;
         $is_jal = $dec_bits ==?   11'bx_xxx_1101111;
         $is_jalr = $dec_bits ==?  11'bx_000_1100111;
         $is_sb = $dec_bits ==?  11'bx_000_0100011;
         $is_sh = $dec_bits ==?  11'bx_001_0100011;
         $is_sw = $dec_bits ==?  11'bx_010_0100011;
         $is_slti = $dec_bits ==?  11'bx_010_0010011;
         $is_sltiu = $dec_bits ==?  11'bx_011_0010011;
         $is_xori = $dec_bits ==?  11'bx_100_0010011;
         $is_ori = $dec_bits ==?  11'bx_110_0010011;
         $is_andi = $dec_bits ==?  11'bx_111_0010011;
         $is_slli = $dec_bits ==?  11'b0_001_0010011;
         $is_srli = $dec_bits ==?  11'b0_101_0010011;
         $is_srai = $dec_bits ==?  11'b1_101_0010011;
         $is_sub = $dec_bits ==?  11'b1_000_0110011;
         $is_sll = $dec_bits ==?  11'b0_001_0110011;
         $is_slt = $dec_bits ==?  11'b0_010_0110011;
         $is_sltu = $dec_bits ==?  11'b0_011_0110011;
         $is_xor = $dec_bits ==?  11'b0_100_0110011;
         $is_srl = $dec_bits ==?  11'b0_101_0110011;
         $is_sra = $dec_bits ==?  11'b1_101_0110011;
         $is_or = $dec_bits ==?  11'b0_110_0110011;
         $is_and = $dec_bits ==?  11'b0_111_0110011;
         

      @2
         $br_tgt_pc[31:0] = $pc + $imm;
         
         $rf_rd_en1 = $rs1_valid;
         $rf_rd_index1[4:0] = $rs1;
         
         $rf_rd_en2 = $rs2_valid;
         $rf_rd_index2[4:0] = $rs2;
         //(>>1$rd_valid && >>1$rd == $rs1)
         $src1_value[31:0] = (>>1$rf_wr_index == $rf_rd_index1) && >>1$rf_wr_en  ?
                              >>1$rf_wr_data : $rf_rd_data1;
         $src2_value[31:0] = (>>1$rf_wr_index == $rf_rd_index2) && >>1$rf_wr_en  ?
                              >>1$rf_wr_data : $rf_rd_data2;
         
      @3
         $sltu_rslt = $src1_value < $src2_value;
         $sltiu_rslt = $src1_value < $imm;
         
         $result[31:0] = $is_addi || $is_load || $is_s_instr? $src1_value + $imm :
                         $is_add ? $src1_value + $src2_value:
                         $is_andi ? $src1_value & $imm:
                         $is_ori ? $src1_value | $imm:
                         $is_xori ? $src1_value ^ $imm:
                         $is_slli ? $src1_value << $imm[5:0]:
                         $is_srli ? $src1_value >> $imm[5:0]:
                         $is_and ? $src1_value & $src2_value:
                         $is_or ? $src1_value | $src2_value:
                         $is_xor ? $src1_value ^ $src2_value:
                         $is_sub ? $src1_value - $src2_value:
                         $is_sll ? $src1_value << $src2_value[4:0]:
                         $is_srl ? $src1_value >> $src2_value[4:0]:
                         $is_sltu ? $src1_value < $src2_value:
                         $is_sltiu ? $src1_value < $imm:
                         $is_lui ? {$imm[31:12],'0}:
                         $is_auipc ? $pc + $imm :
                         $is_jal ? $pc + 4 :
                         $is_jalr ? $pc + 4 :
                         $is_srai ? { {32{$src1_value[31]}}, $src1_value} >> $imm[4:0]:
                         $is_slt ? ($src1_value[31] == $src2_value[31]) ? $sltu_rslt : {31'b0, $src1_value[31]}:
                         $is_slti ? ($src1_value[31] == $imm[31]) ? $sltiu_rslt : {31'b0, $src1_value[31]}:
                         $is_sra ? { {32{$src1_value[31]}}, $src1_value} >> $src2_value[4:0]:
                         'x;
                         
         $taken_br = $is_beq ? ($src1_value == $src2_value) :
                     $is_bne ? ($src1_value != $src2_value) :
                     $is_blt ? (($src1_value < $src2_value) ^ ($src1_value[31] != $src2_value[31])) :
                     $is_bge ? (($src1_value >= $src2_value) ^ ($src1_value[31] != $src2_value[31])) :
                     $is_bltu ? ($src1_value < $src2_value) :
                     $is_bgeu ? ($src1_value >= $src2_value) : 1'b0;
         
         $valid_taken_br = $valid && $taken_br;
         $valid_load = $valid && $is_load;
         
         $is_jump = $is_jal || $is_jalr;
         $valid_jump = $is_jump && $valid;
         
         $valid = !(>>1$valid_taken_br || >>2$valid_taken_br
                     || >>1$valid_load || >>2$valid_load
                     || >>1$valid_jump || >>2$valid_jump) ;
         
         $jalr_tgt_pc[31:0] = $src1_value + $imm; 
         
         $rf_wr_en = ($rd!='0 && $rd_valid && $valid) || >>2$valid_load; // add >>2$rd!=0 for load? 
         $rf_wr_index[4:0] = >>2$valid_load ? >>2$rd : $rd;
         $rf_wr_data[31:0] = >>2$valid_load ? >>2$ld_data: $result ; //result is combinational, so can be written in same cycle?
      @4
         $dmem_wr_en = $is_s_instr && $valid;
         $dmem_addr[3:0] = $result[5:2];
         $dmem_wr_data[31:0] = $src2_value;
         $dmem_rd_en = $is_load;
         
      @5
         $ld_data[31:0] = $dmem_rd_data;
      
   *passed = |cpu/xreg[17]>>5$value == 45;
   *failed = 1'b0;
   
   |cpu
      m4+imem(@1)    // Args: (read stage)
      m4+rf(@2, @3)  // Args: (read stage, write stage) - if equal, no register bypass is required
      m4+dmem(@4)    // Args: (read/write stage)
      m4+cpu_viz(@4)    // For visualisation, argument should be at least equal to the last stage of CPU logic. @4 would work for all labs.
  \SV
     endmodule

-----

![Screenshot 2025-05-01 001312](https://github.com/user-attachments/assets/0e542f37-5923-4137-b509-9004dc7a3fb7)
![Screenshot 2025-05-01 001422](https://github.com/user-attachments/assets/c6be10f7-7298-40bc-9c1b-203989170a2a)

