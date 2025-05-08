\m5_TLV_version 1d: tl-x.org
\m5
\SV
   m5_makerchip_module   // (Expanded in Nav-TLV pane.)
\TLV
   $reset = *reset;
   
   $val1[31:0] = >>1$mem[31:0];
   $val2[31:0] = $rand2[3:0];
   
   $sum[31:0] = $val1 + $val2;
   $diff[31:0] = $val1 - $val2;
   $prod[31:0] = $val1 * $val2;
   $quot[31:0] = $val1 / $val2;
   
   $tmp[31:0] = ($op[1]) ? (($op[0] ? $quot[31:0] : $prod[31:0]) : (($op[0] ? $diff[31:0] : $sum[31:0]) ;
   $mem[31:0] = $reset ? 32'b0 : $tmp;
   
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule

