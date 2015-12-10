library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity	v_message_shift_pre	 is         
port(
   clk     : in  std_logic;
   reset   : in  std_logic;
   
   data_in : in  std_logic_vector(2047 downto 0);
   data_out: out  std_logic_vector(2047 downto 0)
   );	 
end	v_message_shift_pre;

architecture rtl of v_message_shift_pre is
 signal data_dly :std_logic_vector(2047 downto 0);
 signal data_reg :std_logic_vector(2047 downto 0);
 
 signal counter  :std_logic_vector(6 downto 0);
 signal counter_dly  :std_logic_vector(6 downto 0);
 
 begin
   
 process(clk,reset)
  begin
     if (reset='1') then
         data_dly <=(others=>'0');
		   data_reg <=(others=>'0');
		   counter  <=(others=>'0');
		   counter_dly  <=(others=>'0');
		   
	  elsif (clk'event and clk='1') then
		    data_dly <= data_in;
		    counter <= counter + 1;
		    counter_dly <= counter;
		  if(counter = "0000000") then
			   data_reg <= data_in;
		    end if;
		end if;
 end process;
 
 process(clk,reset)
  begin
     if (reset='1') then
         data_out <=(others=>'0');
		elsif (clk'event and clk='1') then
		   if (counter_dly<24) then
				data_out(31 downto 0) <= data_in(27 downto 0) & data_dly(31 downto 28);
			elsif (counter_dly =24) then
				data_out(31 downto 0) <= data_in(31 downto 0);
			elsif (counter_dly =63) then
				data_out(31 downto 0) <= data_reg(31 downto 0);
			else
				data_out(31 downto 0) <= data_in(31 downto 0);
			end if;
			
			if (counter_dly<6) then
				data_out(63 downto 32) <= data_in(47 downto 32) & data_dly(63 downto 48);
			elsif (counter_dly =6) then
				data_out(63 downto 32) <= data_in(51 downto 32) & data_dly(59 downto 48);
			elsif (counter_dly =63) then
				data_out(63 downto 32) <= data_reg(51 downto 32) & data_dly(63 downto 52);
			else
				data_out(63 downto 32) <= data_in(51 downto 32) & data_dly(63 downto 52);
			end if;
			
			if (counter_dly<45) then
				data_out(95 downto 64) <= data_in(75 downto 64) & data_dly(95 downto 76);
			elsif (counter_dly =45) then
				data_out(95 downto 64) <= data_in(79 downto 64) & data_dly(91 downto 76);
			elsif (counter_dly =63) then
				data_out(95 downto 64) <= data_reg(79 downto 64) & data_dly(95 downto 80);
			else
				data_out(95 downto 64) <= data_in(79 downto 64) & data_dly(95 downto 80);
			end if;
			
			if (counter_dly<30) then
				data_out(127 downto 96) <= data_in(107 downto 96) & data_dly(127 downto 108);
			elsif (counter_dly =30) then
				data_out(127 downto 96) <= data_in(111 downto 96) & data_dly(123 downto 108);
			elsif (counter_dly =63) then
				data_out(127 downto 96) <= data_reg(111 downto 96) & data_dly(127 downto 112);
			else
				data_out(127 downto 96) <= data_in(111 downto 96) & data_dly(127 downto 112);
			end if;
			
			if (counter_dly<23) then
				data_out(159 downto 128) <= data_dly(159 downto 128);
			elsif (counter_dly =23) then
				data_out(159 downto 128) <= data_in(131 downto 128) & data_dly(155 downto 128);
			elsif (counter_dly =63) then
				data_out(159 downto 128) <= data_reg(131 downto 128) & data_dly(159 downto 132);
			else
				data_out(159 downto 128) <= data_in(131 downto 128) & data_dly(159 downto 132);
			end if;
			
			if (counter_dly<12) then
				data_out(191 downto 160) <= data_in(187 downto 160) & data_dly(191 downto 188);
			elsif (counter_dly =12) then
				data_out(191 downto 160) <= data_in(191 downto 160);
			elsif (counter_dly =63) then
				data_out(191 downto 160) <= data_reg(191 downto 160);
			else
				data_out(191 downto 160) <= data_in(191 downto 160);
			end if;
			
			if (counter_dly<37) then
				data_out(223 downto 192) <= data_in(195 downto 192) & data_dly(223 downto 196);
			elsif (counter_dly =37) then
				data_out(223 downto 192) <= data_in(199 downto 192) & data_dly(219 downto 196);
			elsif (counter_dly =63) then
				data_out(223 downto 192) <= data_reg(199 downto 192) & data_dly(223 downto 200);
			else
				data_out(223 downto 192) <= data_in(199 downto 192) & data_dly(223 downto 200);
			end if;
			
			if (counter_dly<34) then
				data_out(255 downto 224) <= data_in(247 downto 224) & data_dly(255 downto 248);
			elsif (counter_dly =34) then
				data_out(255 downto 224) <= data_in(251 downto 224) & data_dly(251 downto 248);
			elsif (counter_dly =63) then
				data_out(255 downto 224) <= data_reg(251 downto 224) & data_dly(255 downto 252);
			else
				data_out(255 downto 224) <= data_in(251 downto 224) & data_dly(255 downto 252);
			end if;
			
			if (counter_dly<24) then
				data_out(287 downto 256) <= data_in(279 downto 256) & data_dly(287 downto 280);
			elsif (counter_dly =24) then
				data_out(287 downto 256) <= data_in(283 downto 256) & data_dly(283 downto 280);
			elsif (counter_dly =63) then
				data_out(287 downto 256) <= data_reg(283 downto 256) & data_dly(287 downto 284);
			else
				data_out(287 downto 256) <= data_in(283 downto 256) & data_dly(287 downto 284);
			end if;
			
			if (counter_dly<6) then
				data_out(319 downto 288) <= data_in(315 downto 288) & data_dly(319 downto 316);
			elsif (counter_dly =6) then
				data_out(319 downto 288) <= data_in(319 downto 288);
			elsif (counter_dly =63) then
				data_out(319 downto 288) <= data_reg(319 downto 288);
			else
				data_out(319 downto 288) <= data_in(319 downto 288);
			end if;
			
			if (counter_dly<35) then
				data_out(351 downto 320) <= data_in(339 downto 320) & data_dly(351 downto 340);
			elsif (counter_dly =35) then
				data_out(351 downto 320) <= data_in(343 downto 320) & data_dly(347 downto 340);
			elsif (counter_dly =63) then
				data_out(351 downto 320) <= data_reg(343 downto 320) & data_dly(351 downto 344);
			else
				data_out(351 downto 320) <= data_in(343 downto 320) & data_dly(351 downto 344);
			end if;
			
			if (counter_dly<26) then
				data_out(383 downto 352) <= data_dly(383 downto 352);
			elsif (counter_dly =26) then
				data_out(383 downto 352) <= data_in(355 downto 352) & data_dly(379 downto 352);
			elsif (counter_dly =63) then
				data_out(383 downto 352) <= data_reg(355 downto 352) & data_dly(383 downto 356);
			else
				data_out(383 downto 352) <= data_in(355 downto 352) & data_dly(383 downto 356);
			end if;
			
			if (counter_dly<32) then
				data_out(415 downto 384) <= data_in(395 downto 384) & data_dly(415 downto 396);
			elsif (counter_dly =32) then
				data_out(415 downto 384) <= data_in(399 downto 384) & data_dly(411 downto 396);
			elsif (counter_dly =63) then
				data_out(415 downto 384) <= data_reg(399 downto 384) & data_dly(415 downto 400);
			else
				data_out(415 downto 384) <= data_in(399 downto 384) & data_dly(415 downto 400);
			end if;
			
			if (counter_dly<24) then
				data_out(447 downto 416) <= data_in(419 downto 416) & data_dly(447 downto 420);
			elsif (counter_dly =24) then
				data_out(447 downto 416) <= data_in(423 downto 416) & data_dly(443 downto 420);
			elsif (counter_dly =63) then
				data_out(447 downto 416) <= data_reg(423 downto 416) & data_dly(447 downto 424);
			else
				data_out(447 downto 416) <= data_in(423 downto 416) & data_dly(447 downto 424);
			end if;
			
			if (counter_dly<16) then
				data_out(479 downto 448) <= data_in(467 downto 448) & data_dly(479 downto 468);
			elsif (counter_dly =16) then
				data_out(479 downto 448) <= data_in(471 downto 448) & data_dly(475 downto 468);
			elsif (counter_dly =63) then
				data_out(479 downto 448) <= data_reg(471 downto 448) & data_dly(479 downto 472);
			else
				data_out(479 downto 448) <= data_in(471 downto 448) & data_dly(479 downto 472);
			end if;
			
			if (counter_dly<12) then
				data_out(511 downto 480) <= data_in(495 downto 480) & data_dly(511 downto 496);
			elsif (counter_dly =12) then
				data_out(511 downto 480) <= data_in(499 downto 480) & data_dly(507 downto 496);
			elsif (counter_dly =63) then
				data_out(511 downto 480) <= data_reg(499 downto 480) & data_dly(511 downto 500);
			else
				data_out(511 downto 480) <= data_in(499 downto 480) & data_dly(511 downto 500);
			end if;
			
			if (counter_dly<4) then
				data_out(543 downto 512) <= data_in(523 downto 512) & data_dly(543 downto 524);
			elsif (counter_dly =4) then
				data_out(543 downto 512) <= data_in(527 downto 512) & data_dly(539 downto 524);
			elsif (counter_dly =63) then
				data_out(543 downto 512) <= data_reg(527 downto 512) & data_dly(543 downto 528);
			else
				data_out(543 downto 512) <= data_in(527 downto 512) & data_dly(543 downto 528);
			end if;
			
			if (counter_dly =63) then
			data_out(575 downto 544) <= data_dly(575 downto 544);
			else
			data_out(575 downto 544) <= data_dly(575 downto 544);
			end if;
			
			if (counter_dly<25) then
				data_out(607 downto 576) <= data_in(595 downto 576) & data_dly(607 downto 596);
			elsif (counter_dly =25) then
				data_out(607 downto 576) <= data_in(599 downto 576) & data_dly(603 downto 596);
			elsif (counter_dly =63) then
				data_out(607 downto 576) <= data_reg(599 downto 576) & data_dly(607 downto 600);
			else
				data_out(607 downto 576) <= data_in(599 downto 576) & data_dly(607 downto 600);
			end if;
			
			if (counter_dly =63) then
			data_out(639 downto 608) <= data_dly(639 downto 608);
			
			else
			data_out(639 downto 608) <= data_dly(639 downto 608);
			end if;
			
			if (counter_dly<2) then
				data_out(671 downto 640) <= data_in(659 downto 640) & data_dly(671 downto 660);
			elsif (counter_dly =2) then
				data_out(671 downto 640) <= data_in(663 downto 640) & data_dly(667 downto 660);
			elsif (counter_dly =63) then
				data_out(671 downto 640) <= data_reg(663 downto 640) & data_dly(671 downto 664);
			else
				data_out(671 downto 640) <= data_in(663 downto 640) & data_dly(671 downto 664);
			end if;
			
			if (counter_dly =63) then
			data_out(703 downto 672) <= data_dly(703 downto 672);
			
			else
			data_out(703 downto 672) <= data_dly(703 downto 672);
			end if;
			
			if (counter_dly<6) then
				data_out(735 downto 704) <= data_in(711 downto 704) & data_dly(735 downto 712);
			elsif (counter_dly =6) then
				data_out(735 downto 704) <= data_in(715 downto 704) & data_dly(731 downto 712);
			elsif (counter_dly =63) then
				data_out(735 downto 704) <= data_reg(715 downto 704) & data_dly(735 downto 716);
			else
				data_out(735 downto 704) <= data_in(715 downto 704) & data_dly(735 downto 716);
			end if;
			
			if (counter_dly =63) then
			data_out(767 downto 736) <= data_dly(767 downto 736);
			
			else
			data_out(767 downto 736) <= data_dly(767 downto 736);
			end if;
			
			if (counter_dly<1) then
				data_out(799 downto 768) <= data_in(791 downto 768) & data_dly(799 downto 792);
			elsif (counter_dly =1) then
				data_out(799 downto 768) <= data_in(795 downto 768) & data_dly(795 downto 792);
			elsif (counter_dly =63) then
				data_out(799 downto 768) <= data_reg(795 downto 768) & data_dly(799 downto 796);
			else
				data_out(799 downto 768) <= data_in(795 downto 768) & data_dly(799 downto 796);
			end if;
			
			if (counter_dly =63) then
			data_out(831 downto 800) <= data_dly(831 downto 800);
			else
			data_out(831 downto 800) <= data_dly(831 downto 800);
			end if;
			
			if (counter_dly<18) then
				data_out(863 downto 832) <= data_dly(863 downto 832);
			elsif (counter_dly =18) then
				data_out(863 downto 832) <= data_in(835 downto 832) & data_dly(859 downto 832);
			elsif (counter_dly =63) then
				data_out(863 downto 832) <= data_reg(835 downto 832) & data_dly(863 downto 836);
			else
				data_out(863 downto 832) <= data_in(835 downto 832) & data_dly(863 downto 836);
			end if;
			
			if (counter_dly =63) then
			data_out(895 downto 864) <= data_dly(895 downto 864);
			
			else
			data_out(895 downto 864) <= data_dly(895 downto 864);
			end if;
			
			if (counter_dly<3) then
				data_out(927 downto 896) <= data_in(923 downto 896) & data_dly(927 downto 924);
			elsif (counter_dly =3) then
				data_out(927 downto 896) <= data_in(927 downto 896);
			elsif (counter_dly =63) then
				data_out(927 downto 896) <= data_reg(927 downto 896);
			else
				data_out(927 downto 896) <= data_in(927 downto 896);
			end if;
			
			if (counter_dly =63) then
			data_out(959 downto 928) <= data_dly(959 downto 928);
			
			else
			data_out(959 downto 928) <= data_dly(959 downto 928);
			end if;
			
			if (counter_dly<1) then
				data_out(991 downto 960) <= data_in(971 downto 960) & data_dly(991 downto 972);
			elsif (counter_dly =1) then
				data_out(991 downto 960) <= data_in(975 downto 960) & data_dly(987 downto 972);
			elsif (counter_dly =63) then
				data_out(991 downto 960) <= data_reg(975 downto 960) & data_dly(991 downto 976);
			else
				data_out(991 downto 960) <= data_in(975 downto 960) & data_dly(991 downto 976);
			end if;
			
			if (counter_dly =63) then
			data_out(1023 downto 992) <= data_dly(1023 downto 992);
			else
			data_out(1023 downto 992) <= data_dly(1023 downto 992);
			end if;
			
			if (counter_dly<51) then
				data_out(1055 downto 1024) <= data_in(1027 downto 1024) & data_dly(1055 downto 1028);
			elsif (counter_dly =51) then
				data_out(1055 downto 1024) <= data_in(1031 downto 1024) & data_dly(1051 downto 1028);
			elsif (counter_dly =63) then
				data_out(1055 downto 1024) <= data_reg(1031 downto 1024) & data_dly(1055 downto 1032);
			else
				data_out(1055 downto 1024) <= data_in(1031 downto 1024) & data_dly(1055 downto 1032);
			end if;
			
			if (counter_dly<47) then
				data_out(1087 downto 1056) <= data_in(1059 downto 1056) & data_dly(1087 downto 1060);
			elsif (counter_dly =47) then
				data_out(1087 downto 1056) <= data_in(1063 downto 1056) & data_dly(1083 downto 1060);
			elsif (counter_dly =63) then
				data_out(1087 downto 1056) <= data_reg(1063 downto 1056) & data_dly(1087 downto 1064);
			else
				data_out(1087 downto 1056) <= data_in(1063 downto 1056) & data_dly(1087 downto 1064);
			end if;
			
			if (counter_dly<58) then
				data_out(1119 downto 1088) <= data_in(1091 downto 1088) & data_dly(1119 downto 1092);
			elsif (counter_dly =58) then
				data_out(1119 downto 1088) <= data_in(1095 downto 1088) & data_dly(1115 downto 1092);
			elsif (counter_dly =63) then
				data_out(1119 downto 1088) <= data_reg(1095 downto 1088) & data_dly(1119 downto 1096);
			else
				data_out(1119 downto 1088) <= data_in(1095 downto 1088) & data_dly(1119 downto 1096);
			end if;
			
			if (counter_dly<58) then
				data_out(1151 downto 1120) <= data_in(1135 downto 1120) & data_dly(1151 downto 1136);
			elsif (counter_dly =58) then
				data_out(1151 downto 1120) <= data_in(1139 downto 1120) & data_dly(1147 downto 1136);
			elsif (counter_dly =63) then
				data_out(1151 downto 1120) <= data_reg(1139 downto 1120) & data_dly(1151 downto 1140);
			else
				data_out(1151 downto 1120) <= data_in(1139 downto 1120) & data_dly(1151 downto 1140);
			end if;
			
			if (counter_dly<48) then
				data_out(1183 downto 1152) <= data_in(1171 downto 1152) & data_dly(1183 downto 1172);
			elsif (counter_dly =48) then
				data_out(1183 downto 1152) <= data_in(1175 downto 1152) & data_dly(1179 downto 1172);
			elsif (counter_dly =63) then
				data_out(1183 downto 1152) <= data_reg(1175 downto 1152) & data_dly(1183 downto 1176);
			else
				data_out(1183 downto 1152) <= data_in(1175 downto 1152) & data_dly(1183 downto 1176);
			end if;
			
			if (counter_dly<47) then
				data_out(1215 downto 1184) <= data_in(1199 downto 1184) & data_dly(1215 downto 1200);
			elsif (counter_dly =47) then
				data_out(1215 downto 1184) <= data_in(1203 downto 1184) & data_dly(1211 downto 1200);
			elsif (counter_dly =63) then
				data_out(1215 downto 1184) <= data_reg(1203 downto 1184) & data_dly(1215 downto 1204);
			else
				data_out(1215 downto 1184) <= data_in(1203 downto 1184) & data_dly(1215 downto 1204);
			end if;
			
			if (counter_dly<56) then
				data_out(1247 downto 1216) <= data_in(1231 downto 1216) & data_dly(1247 downto 1232);
			elsif (counter_dly =56) then
				data_out(1247 downto 1216) <= data_in(1235 downto 1216) & data_dly(1243 downto 1232);
			elsif (counter_dly =63) then
				data_out(1247 downto 1216) <= data_reg(1235 downto 1216) & data_dly(1247 downto 1236);
			else
				data_out(1247 downto 1216) <= data_in(1235 downto 1216) & data_dly(1247 downto 1236);
			end if;
			
			if (counter_dly<53) then
				data_out(1279 downto 1248) <= data_in(1251 downto 1248) & data_dly(1279 downto 1252);
			elsif (counter_dly =53) then
				data_out(1279 downto 1248) <= data_in(1255 downto 1248) & data_dly(1275 downto 1252);
			elsif (counter_dly =63) then
				data_out(1279 downto 1248) <= data_reg(1255 downto 1248) & data_dly(1279 downto 1256);
			else
				data_out(1279 downto 1248) <= data_in(1255 downto 1248) & data_dly(1279 downto 1256);
			end if;
			
			if (counter_dly<55) then
				data_out(1311 downto 1280) <= data_in(1287 downto 1280) & data_dly(1311 downto 1288);
			elsif (counter_dly =55) then
				data_out(1311 downto 1280) <= data_in(1291 downto 1280) & data_dly(1307 downto 1288);
			elsif (counter_dly =63) then
				data_out(1311 downto 1280) <= data_reg(1291 downto 1280) & data_dly(1311 downto 1292);
			else
				data_out(1311 downto 1280) <= data_in(1291 downto 1280) & data_dly(1311 downto 1292);
			end if;
			
			if (counter_dly<49) then
				data_out(1343 downto 1312) <= data_in(1323 downto 1312) & data_dly(1343 downto 1324);
			elsif (counter_dly =49) then
				data_out(1343 downto 1312) <= data_in(1327 downto 1312) & data_dly(1339 downto 1324);
			elsif (counter_dly =63) then
				data_out(1343 downto 1312) <= data_reg(1327 downto 1312) & data_dly(1343 downto 1328);
			else
				data_out(1343 downto 1312) <= data_in(1327 downto 1312) & data_dly(1343 downto 1328);
			end if;
			
			if (counter_dly<60) then
				data_out(1375 downto 1344) <= data_in(1367 downto 1344) & data_dly(1375 downto 1368);
			elsif (counter_dly =60) then
				data_out(1375 downto 1344) <= data_in(1371 downto 1344) & data_dly(1371 downto 1368);
			elsif (counter_dly =63) then
				data_out(1375 downto 1344) <= data_reg(1371 downto 1344) & data_dly(1375 downto 1372);
			else
				data_out(1375 downto 1344) <= data_in(1371 downto 1344) & data_dly(1375 downto 1372);
			end if;
			
			if (counter_dly<52) then
				data_out(1407 downto 1376) <= data_in(1387 downto 1376) & data_dly(1407 downto 1388);
			elsif (counter_dly =52) then
				data_out(1407 downto 1376) <= data_in(1391 downto 1376) & data_dly(1403 downto 1388);
			elsif (counter_dly =63) then
				data_out(1407 downto 1376) <= data_reg(1391 downto 1376) & data_dly(1407 downto 1392);
			else
				data_out(1407 downto 1376) <= data_in(1391 downto 1376) & data_dly(1407 downto 1392);
			end if;
			
			if (counter_dly<59) then
				data_out(1439 downto 1408) <= data_in(1411 downto 1408) & data_dly(1439 downto 1412);
			elsif (counter_dly =59) then
				data_out(1439 downto 1408) <= data_in(1415 downto 1408) & data_dly(1435 downto 1412);
			elsif (counter_dly =63) then
				data_out(1439 downto 1408) <= data_reg(1415 downto 1408) & data_dly(1439 downto 1416);
			else
				data_out(1439 downto 1408) <= data_in(1415 downto 1408) & data_dly(1439 downto 1416);
			end if;
			
			if (counter_dly<54) then
				data_out(1471 downto 1440) <= data_in(1455 downto 1440) & data_dly(1471 downto 1456);
			elsif (counter_dly =54) then
				data_out(1471 downto 1440) <= data_in(1459 downto 1440) & data_dly(1467 downto 1456);
			elsif (counter_dly =63) then
				data_out(1471 downto 1440) <= data_reg(1459 downto 1440) & data_dly(1471 downto 1460);
			else
				data_out(1471 downto 1440) <= data_in(1459 downto 1440) & data_dly(1471 downto 1460);
			end if;
			
			if (counter_dly<59) then
				data_out(1503 downto 1472) <= data_in(1495 downto 1472) & data_dly(1503 downto 1496);
			elsif (counter_dly =59) then
				data_out(1503 downto 1472) <= data_in(1499 downto 1472) & data_dly(1499 downto 1496);
			elsif (counter_dly =63) then
				data_out(1503 downto 1472) <= data_reg(1499 downto 1472) & data_dly(1503 downto 1500);
			else
				data_out(1503 downto 1472) <= data_in(1499 downto 1472) & data_dly(1503 downto 1500);
			end if;
			
			if (counter_dly<58) then
				data_out(1535 downto 1504) <= data_dly(1535 downto 1504);
			elsif (counter_dly =58) then
				data_out(1535 downto 1504) <= data_in(1507 downto 1504) & data_dly(1531 downto 1504);
			elsif (counter_dly =63) then
				data_out(1535 downto 1504) <= data_reg(1507 downto 1504) & data_dly(1535 downto 1508);
			else
				data_out(1535 downto 1504) <= data_in(1507 downto 1504) & data_dly(1535 downto 1508);
			end if;
			
			if (counter_dly<32) then
				data_out(1567 downto 1536) <= data_in(1543 downto 1536) & data_dly(1567 downto 1544);
			elsif (counter_dly =32) then
				data_out(1567 downto 1536) <= data_in(1547 downto 1536) & data_dly(1563 downto 1544);
			elsif (counter_dly =63) then
				data_out(1567 downto 1536) <= data_reg(1547 downto 1536) & data_dly(1567 downto 1548);
			else
				data_out(1567 downto 1536) <= data_in(1547 downto 1536) & data_dly(1567 downto 1548);
			end if;
			
			if (counter_dly<30) then
				data_out(1599 downto 1568) <= data_dly(1599 downto 1568);
			elsif (counter_dly =30) then
				data_out(1599 downto 1568) <= data_in(1571 downto 1568) & data_dly(1595 downto 1568);
			elsif (counter_dly =63) then
				data_out(1599 downto 1568) <= data_reg(1571 downto 1568) & data_dly(1599 downto 1572);
			else
				data_out(1599 downto 1568) <= data_in(1571 downto 1568) & data_dly(1599 downto 1572);
			end if;
			
			if (counter_dly<57) then
				data_out(1631 downto 1600) <= data_in(1623 downto 1600) & data_dly(1631 downto 1624);
			elsif (counter_dly =57) then
				data_out(1631 downto 1600) <= data_in(1627 downto 1600) & data_dly(1627 downto 1624);
			elsif (counter_dly =63) then
				data_out(1631 downto 1600) <= data_reg(1627 downto 1600) & data_dly(1631 downto 1628);
			else
				data_out(1631 downto 1600) <= data_in(1627 downto 1600) & data_dly(1631 downto 1628);
			end if;
			
			if (counter_dly<49) then
				data_out(1663 downto 1632) <= data_dly(1663 downto 1632);
			elsif (counter_dly =49) then
				data_out(1663 downto 1632) <= data_in(1635 downto 1632) & data_dly(1659 downto 1632);
			elsif (counter_dly =63) then
				data_out(1663 downto 1632) <= data_reg(1635 downto 1632) & data_dly(1663 downto 1636);
			else
				data_out(1663 downto 1632) <= data_in(1635 downto 1632) & data_dly(1663 downto 1636);
			end if;
			
			if (counter_dly<35) then
				data_out(1695 downto 1664) <= data_in(1687 downto 1664) & data_dly(1695 downto 1688);
			elsif (counter_dly =35) then
				data_out(1695 downto 1664) <= data_in(1691 downto 1664) & data_dly(1691 downto 1688);
			elsif (counter_dly =63) then
				data_out(1695 downto 1664) <= data_reg(1691 downto 1664) & data_dly(1695 downto 1692);
			else
				data_out(1695 downto 1664) <= data_in(1691 downto 1664) & data_dly(1695 downto 1692);
			end if;
			
			if (counter_dly<25) then
				data_out(1727 downto 1696) <= data_dly(1727 downto 1696);
			elsif (counter_dly =25) then
				data_out(1727 downto 1696) <= data_in(1699 downto 1696) & data_dly(1723 downto 1696);
			elsif (counter_dly =63) then
				data_out(1727 downto 1696) <= data_reg(1699 downto 1696) & data_dly(1727 downto 1700);
			else
				data_out(1727 downto 1696) <= data_in(1699 downto 1696) & data_dly(1727 downto 1700);
			end if;
			
			if (counter_dly<41) then
				data_out(1759 downto 1728) <= data_in(1751 downto 1728) & data_dly(1759 downto 1752);
			elsif (counter_dly =41) then
				data_out(1759 downto 1728) <= data_in(1755 downto 1728) & data_dly(1755 downto 1752);
			elsif (counter_dly =63) then
				data_out(1759 downto 1728) <= data_reg(1755 downto 1728) & data_dly(1759 downto 1756);
			else
				data_out(1759 downto 1728) <= data_in(1755 downto 1728) & data_dly(1759 downto 1756);
			end if;
			
			if (counter_dly<38) then
				data_out(1791 downto 1760) <= data_in(1775 downto 1760) & data_dly(1791 downto 1776);
			elsif (counter_dly =38) then
				data_out(1791 downto 1760) <= data_in(1779 downto 1760) & data_dly(1787 downto 1776);
			elsif (counter_dly =63) then
				data_out(1791 downto 1760) <= data_reg(1779 downto 1760) & data_dly(1791 downto 1780);
			else
				data_out(1791 downto 1760) <= data_in(1779 downto 1760) & data_dly(1791 downto 1780);
			end if;
			
			if (counter_dly<44) then
				data_out(1823 downto 1792) <= data_dly(1823 downto 1792);
			elsif (counter_dly =44) then
				data_out(1823 downto 1792) <= data_in(1795 downto 1792) & data_dly(1819 downto 1792);
			elsif (counter_dly =63) then
				data_out(1823 downto 1792) <= data_reg(1795 downto 1792) & data_dly(1823 downto 1796);
			else
				data_out(1823 downto 1792) <= data_in(1795 downto 1792) & data_dly(1823 downto 1796);
			end if;
			
			if (counter_dly<43) then
				data_out(1855 downto 1824) <= data_dly(1855 downto 1824);
			elsif (counter_dly =43) then
				data_out(1855 downto 1824) <= data_in(1827 downto 1824) & data_dly(1851 downto 1824);
			elsif (counter_dly =63) then
				data_out(1855 downto 1824) <= data_reg(1827 downto 1824) & data_dly(1855 downto 1828);
			else
				data_out(1855 downto 1824) <= data_in(1827 downto 1824) & data_dly(1855 downto 1828);
			end if;
			
			if (counter_dly<51) then
				data_out(1887 downto 1856) <= data_in(1879 downto 1856) & data_dly(1887 downto 1880);
			elsif (counter_dly =51) then
				data_out(1887 downto 1856) <= data_in(1883 downto 1856) & data_dly(1883 downto 1880);
			elsif (counter_dly =63) then
				data_out(1887 downto 1856) <= data_reg(1883 downto 1856) & data_dly(1887 downto 1884);
			else
				data_out(1887 downto 1856) <= data_in(1883 downto 1856) & data_dly(1887 downto 1884);
			end if;
			
			if (counter_dly<49) then
				data_out(1919 downto 1888) <= data_in(1915 downto 1888) & data_dly(1919 downto 1916);
			elsif (counter_dly =49) then
				data_out(1919 downto 1888) <= data_in(1919 downto 1888);
			elsif (counter_dly =63) then
				data_out(1919 downto 1888) <= data_reg(1919 downto 1888);
			else
				data_out(1919 downto 1888) <= data_in(1919 downto 1888);
			end if;
			
			if (counter_dly<53) then
				data_out(1951 downto 1920) <= data_dly(1951 downto 1920);
			elsif (counter_dly =53) then
				data_out(1951 downto 1920) <= data_in(1923 downto 1920) & data_dly(1947 downto 1920);
			elsif (counter_dly =63) then
				data_out(1951 downto 1920) <= data_reg(1923 downto 1920) & data_dly(1951 downto 1924);
			else
				data_out(1951 downto 1920) <= data_in(1923 downto 1920) & data_dly(1951 downto 1924);
			end if;
			
			if (counter_dly<44) then
				data_out(1983 downto 1952) <= data_in(1979 downto 1952) & data_dly(1983 downto 1980);
			elsif (counter_dly =44) then
				data_out(1983 downto 1952) <= data_in(1983 downto 1952);
			elsif (counter_dly =63) then
				data_out(1983 downto 1952) <= data_reg(1983 downto 1952);
			else
				data_out(1983 downto 1952) <= data_in(1983 downto 1952);
			end if;
			
			if (counter_dly<29) then
				data_out(2015 downto 1984) <= data_dly(2015 downto 1984);
			elsif (counter_dly =29) then
				data_out(2015 downto 1984) <= data_in(1987 downto 1984) & data_dly(2011 downto 1984);
			elsif (counter_dly =63) then
				data_out(2015 downto 1984) <= data_reg(1987 downto 1984) & data_dly(2015 downto 1988);
			else
				data_out(2015 downto 1984) <= data_in(1987 downto 1984) & data_dly(2015 downto 1988);
			end if;
			
			if (counter_dly < 22) then
				data_out(2047 downto 2016) <= data_in(2043 downto 2016) & data_dly(2047 downto 2044);
			elsif (counter_dly =22) then
				data_out(2047 downto 2016) <= data_in(2047 downto 2016);
			elsif (counter_dly=63) then
				data_out(2047 downto 2016) <= data_reg(2047 downto 2016);
			else
				data_out(2047 downto 2016) <= data_in(2047 downto 2016);
			end if;
      end if;
   end process;
end rtl;