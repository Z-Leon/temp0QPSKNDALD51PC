onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Analog-Step -height 200 -max 10000000.0 -min -10000000.0 -radix decimal /timerecoveryp8_tb/dut/tedloopfilter/saccumulator
add wave -noupdate -format Analog-Step -height 50 -max 512.0 -radix unsigned /timerecoveryp8_tb/dut/tedcontrol_v2/smu0
add wave -noupdate -format Analog-Step -height 50 -max 512.0 -radix unsigned /timerecoveryp8_tb/dut/tedcontrol_v2/smu1
add wave -noupdate -format Analog-Step -height 50 -max 512.0 -radix unsigned /timerecoveryp8_tb/dut/tedcontrol_v2/smu2
add wave -noupdate -format Analog-Step -height 50 -max 512.0 -radix unsigned /timerecoveryp8_tb/dut/tedcontrol_v2/smu3
add wave -noupdate -format Analog-Step -height 50 -max 512.0 -radix unsigned /timerecoveryp8_tb/dut/tedcontrol_v2/smu4
add wave -noupdate -format Analog-Step -height 50 -max 512.0 -radix unsigned /timerecoveryp8_tb/dut/tedcontrol_v2/smu5
add wave -noupdate -format Analog-Step -height 50 -max 512.0 -radix unsigned /timerecoveryp8_tb/dut/tedcontrol_v2/smu6
add wave -noupdate -format Analog-Step -height 50 -max 512.0 -radix unsigned /timerecoveryp8_tb/dut/tedcontrol_v2/smu7
add wave -noupdate -format Analog-Step -height 200 -max 10000000.0 -min -10000000.0 -radix decimal /timerecoveryp8_tb/dut/tedloopfilter/spropte
add wave -noupdate /timerecoveryp8_tb/dut/entity_gardnerted/clk_in
add wave -noupdate /timerecoveryp8_tb/dut/entity_gardnerted/d_interptype0
add wave -noupdate /timerecoveryp8_tb/dut/entity_gardnerted/d_interptype1
add wave -noupdate /timerecoveryp8_tb/dut/entity_gardnerted/d_interptype2
add wave -noupdate /timerecoveryp8_tb/dut/entity_gardnerted/d_interptype3
add wave -noupdate /timerecoveryp8_tb/dut/entity_gardnerted/d_interptype4
add wave -noupdate /timerecoveryp8_tb/dut/entity_gardnerted/d_interptype5
add wave -noupdate /timerecoveryp8_tb/dut/entity_gardnerted/d_interptype6
add wave -noupdate /timerecoveryp8_tb/dut/entity_gardnerted/d_interptype7
add wave -noupdate -divider {New Divider}
add wave -noupdate /timerecoveryp8_tb/dut/entity_gardnerted/d_interptype_ori
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/d_sinphase0
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/d_sinphase1
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/d_sinphase2
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/d_sinphase3
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/d_sinphase4
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/d_sinphase5
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/d_sinphase6
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/d_sinphase7
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/d_squadphase0
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/d_squadphase1
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/d_squadphase2
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/d_squadphase3
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/d_squadphase4
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/d_squadphase5
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/d_squadphase6
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/d_squadphase7
add wave -noupdate /timerecoveryp8_tb/dut/entity_gardnerted/flag
add wave -noupdate /timerecoveryp8_tb/dut/entity_gardnerted/flag_d
add wave -noupdate -divider {New Divider}
add wave -noupdate /timerecoveryp8_tb/dut/entity_gardnerted/interptype0
add wave -noupdate /timerecoveryp8_tb/dut/entity_gardnerted/interptype1
add wave -noupdate /timerecoveryp8_tb/dut/entity_gardnerted/interptype2
add wave -noupdate /timerecoveryp8_tb/dut/entity_gardnerted/interptype3
add wave -noupdate /timerecoveryp8_tb/dut/entity_gardnerted/interptype4
add wave -noupdate /timerecoveryp8_tb/dut/entity_gardnerted/interptype5
add wave -noupdate /timerecoveryp8_tb/dut/entity_gardnerted/interptype6
add wave -noupdate /timerecoveryp8_tb/dut/entity_gardnerted/interptype7
add wave -noupdate -divider {New Divider}
add wave -noupdate /timerecoveryp8_tb/dut/entity_gardnerted/interptype_ori
add wave -noupdate /timerecoveryp8_tb/dut/entity_gardnerted/kinsize
add wave -noupdate /timerecoveryp8_tb/dut/entity_gardnerted/koutsize
add wave -noupdate /timerecoveryp8_tb/dut/entity_gardnerted/senable
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/sinphase0
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/sinphase1
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/sinphase2
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/sinphase3
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/sinphase4
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/sinphase5
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/sinphase6
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/sinphase7
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/squadphase0
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/squadphase1
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/squadphase2
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/squadphase3
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/squadphase4
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/squadphase5
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/squadphase6
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/squadphase7
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix decimal -expand -subitemconfig {/timerecoveryp8_tb/dut/entity_gardnerted/sinphase_inter(3) {-height 15 -radix decimal} /timerecoveryp8_tb/dut/entity_gardnerted/sinphase_inter(2) {-height 15 -radix decimal} /timerecoveryp8_tb/dut/entity_gardnerted/sinphase_inter(1) {-height 15 -radix decimal} /timerecoveryp8_tb/dut/entity_gardnerted/sinphase_inter(0) {-height 15 -radix decimal}} /timerecoveryp8_tb/dut/entity_gardnerted/sinphase_inter
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/sinphase_mult0
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/sinphase_mult1
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/sinphase_reg0
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/sinphase_reg1
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/sinphase_reg2
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/sinphase_reg3
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/sinphase_reg4
add wave -noupdate -radix decimal -expand -subitemconfig {/timerecoveryp8_tb/dut/entity_gardnerted/squadphase_inter(3) {-height 15 -radix decimal} /timerecoveryp8_tb/dut/entity_gardnerted/squadphase_inter(2) {-height 15 -radix decimal} /timerecoveryp8_tb/dut/entity_gardnerted/squadphase_inter(1) {-height 15 -radix decimal} /timerecoveryp8_tb/dut/entity_gardnerted/squadphase_inter(0) {-height 15 -radix decimal}} /timerecoveryp8_tb/dut/entity_gardnerted/squadphase_inter
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/squadphase_mult0
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/squadphase_mult1
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/squadphase_reg0
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/squadphase_reg1
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/squadphase_reg2
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/squadphase_reg3
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/squadphase_reg4
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/stimingerror0
add wave -noupdate -radix decimal /timerecoveryp8_tb/dut/entity_gardnerted/stimingerror1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {336360000 ps} 0}
configure wave -namecolwidth 385
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {283860 ns} {388860 ns}
