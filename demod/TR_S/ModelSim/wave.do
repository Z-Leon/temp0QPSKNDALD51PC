onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /timingrecovery_v2_tb/dut/samplingclk
add wave -noupdate /timingrecovery_v2_tb/dut/sinphase
add wave -noupdate /timingrecovery_v2_tb/dut/squadphase
add wave -noupdate /timingrecovery_v2_tb/dut/sinphaseout
add wave -noupdate /timingrecovery_v2_tb/dut/squadphaseout
add wave -noupdate -format Analog-Step -height 100 -max 2000000.0 -min -2000000.0 -radix decimal /timingrecovery_v2_tb/dut/loopfilterx/caccumulator
add wave -noupdate -format Analog-Step -height 50 -max 70000.0 -radix decimal -subitemconfig {/timingrecovery_v2_tb/dut/smu(15) {-radix decimal} /timingrecovery_v2_tb/dut/smu(14) {-radix decimal} /timingrecovery_v2_tb/dut/smu(13) {-radix decimal} /timingrecovery_v2_tb/dut/smu(12) {-radix decimal} /timingrecovery_v2_tb/dut/smu(11) {-radix decimal} /timingrecovery_v2_tb/dut/smu(10) {-radix decimal} /timingrecovery_v2_tb/dut/smu(9) {-radix decimal} /timingrecovery_v2_tb/dut/smu(8) {-radix decimal} /timingrecovery_v2_tb/dut/smu(7) {-radix decimal} /timingrecovery_v2_tb/dut/smu(6) {-radix decimal} /timingrecovery_v2_tb/dut/smu(5) {-radix decimal} /timingrecovery_v2_tb/dut/smu(4) {-radix decimal} /timingrecovery_v2_tb/dut/smu(3) {-radix decimal} /timingrecovery_v2_tb/dut/smu(2) {-radix decimal} /timingrecovery_v2_tb/dut/smu(1) {-radix decimal} /timingrecovery_v2_tb/dut/smu(0) {-radix decimal}} /timingrecovery_v2_tb/dut/smu
add wave -noupdate /timingrecovery_v2_tb/dut/interptype
add wave -noupdate /timingrecovery_v2_tb/dut/stimingerror
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {258374591 ps} 0}
configure wave -namecolwidth 323
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {420 us}
