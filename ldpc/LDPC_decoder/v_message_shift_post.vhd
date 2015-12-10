library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity	v_message_shift_post	 is         
port(
   clk     : in  std_logic;
   reset   : in  std_logic;
   data_in : in  std_logic_vector(2047 downto 0);
   data_out: out  std_logic_vector(2047 downto 0)
   );	 
end	v_message_shift_post;

architecture rtl of v_message_shift_post is
 signal data_dly :std_logic_vector(2047 downto 0);
 signal data_reg :std_logic_vector(2047 downto 0);
 signal counter  :std_logic_vector(6 downto 0);

begin  
 process(clk,reset)
  begin
     if (reset='1') then
         data_dly <=(others=>'0');
		   data_reg <=(others=>'0');
		   counter  <=(others=>'0');
	  elsif (clk'event and clk='1') then
		    data_dly <= data_in;
		    counter <= counter + 1;
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
		   if (counter<24) then
				data_out(31 downto 0)<= data_in(3 downto 0) & data_dly(31 downto 4);
			elsif (counter=24) then
				data_out(31 downto 0)<= "0000" & data_dly(31 downto 4);
			elsif (counter=64) then
				data_out(31 downto 0)<= data_reg(3 downto 0) & data_dly(27 downto 0);
			else
				data_out(31 downto 0)<= data_dly(31 downto 0);
			end if;
			
			if (counter<6) then
				data_out(63 downto 32)<= data_in(47 downto 32) & data_dly(63 downto 48);
			elsif (counter=6) then
				data_out(63 downto 32)<= "0000" & data_in(43 downto 32) & data_dly(63 downto 48);
			elsif (counter=64) then
				data_out(63 downto 32)<= data_reg(47 downto 32) & data_dly(59 downto 44);
			else
				data_out(63 downto 32)<= data_in(43 downto 32) & data_dly(63 downto 44);
			end if;
			
			if (counter<45) then
				data_out(95 downto 64)<= data_in(83 downto 64) & data_dly(95 downto 84);
			elsif (counter=45) then
				data_out(95 downto 64)<= "0000" & data_in(79 downto 64) & data_dly(95 downto 84);
			elsif (counter=64) then
				data_out(95 downto 64)<= data_reg(83 downto 64) & data_dly(91 downto 80);
			else
				data_out(95 downto 64)<= data_in(79 downto 64) & data_dly(95 downto 80);
			end if;
			
			if (counter<30) then
				data_out(127 downto 96)<= data_in(115 downto 96) & data_dly(127 downto 116);
			elsif (counter=30) then
				data_out(127 downto 96)<= "0000" & data_in(111 downto 96) & data_dly(127 downto 116);
			elsif (counter=64) then
				data_out(127 downto 96)<= data_reg(115 downto 96) & data_dly(123 downto 112);
			else
				data_out(127 downto 96)<= data_in(111 downto 96) & data_dly(127 downto 112);
			end if;
			
			if (counter<23) then
				data_out(159 downto 128)<= data_in(159 downto 128);
			elsif (counter=23) then
				data_out(159 downto 128)<= "0000" & data_in(155 downto 128);
			elsif (counter=64) then
				data_out(159 downto 128)<= data_reg(159 downto 128);
			else
				data_out(159 downto 128)<= data_in(155 downto 128) & data_dly(159 downto 156);
			end if;
			
			if (counter<12) then
				data_out(191 downto 160)<= data_in(163 downto 160) & data_dly(191 downto 164);
			elsif (counter=12) then
				data_out(191 downto 160)<= "0000" & data_dly(191 downto 164);
			elsif (counter=64) then
				data_out(191 downto 160)<= data_reg(163 downto 160) & data_dly(187 downto 160);
			else
				data_out(191 downto 160)<= data_dly(191 downto 160);
			end if;
			
			if (counter<37) then
				data_out(223 downto 192)<= data_in(219 downto 192) & data_dly(223 downto 220);
			elsif (counter=37) then
				data_out(223 downto 192)<= "0000" & data_in(215 downto 192) & data_dly(223 downto 220);
			elsif (counter=64) then
				data_out(223 downto 192)<= data_reg(219 downto 192) & data_dly(219 downto 216);
			else
				data_out(223 downto 192)<= data_in(215 downto 192) & data_dly(223 downto 216);
			end if;
			
			if (counter<34) then
				data_out(255 downto 224)<= data_in(231 downto 224) & data_dly(255 downto 232);
			elsif (counter=34) then
				data_out(255 downto 224)<= "0000" & data_in(227 downto 224) & data_dly(255 downto 232);
			elsif (counter=64) then
				data_out(255 downto 224)<= data_reg(231 downto 224) & data_dly(251 downto 228);
			else
				data_out(255 downto 224)<= data_in(227 downto 224) & data_dly(255 downto 228);
			end if;
			
			if (counter<24) then
				data_out(287 downto 256)<= data_in(263 downto 256) & data_dly(287 downto 264);
			elsif (counter=24) then
				data_out(287 downto 256)<= "0000" & data_in(259 downto 256) & data_dly(287 downto 264);
			elsif (counter=64) then
				data_out(287 downto 256)<= data_reg(263 downto 256) & data_dly(283 downto 260);
			else
				data_out(287 downto 256)<= data_in(259 downto 256) & data_dly(287 downto 260);
			end if;
			
			if (counter<6) then
				data_out(319 downto 288)<= data_in(291 downto 288) & data_dly(319 downto 292);
			elsif (counter=6) then
				data_out(319 downto 288)<= "0000" & data_dly(319 downto 292);
			elsif (counter=64) then
				data_out(319 downto 288)<= data_reg(291 downto 288) & data_dly(315 downto 288);
			else
				data_out(319 downto 288)<= data_dly(319 downto 288);
			end if;
			
			if (counter<35) then
				data_out(351 downto 320)<= data_in(331 downto 320) & data_dly(351 downto 332);
			elsif (counter=35) then
				data_out(351 downto 320)<= "0000" & data_in(327 downto 320) & data_dly(351 downto 332);
			elsif (counter=64) then
				data_out(351 downto 320)<= data_reg(331 downto 320) & data_dly(347 downto 328);
			else
				data_out(351 downto 320)<= data_in(327 downto 320) & data_dly(351 downto 328);
			end if;
			
			if (counter<26) then
				data_out(383 downto 352)<= data_in(383 downto 352);
			elsif (counter=26) then
				data_out(383 downto 352)<= "0000" & data_in(379 downto 352);
			elsif (counter=64) then
				data_out(383 downto 352)<= data_reg(383 downto 352);
			else
				data_out(383 downto 352)<= data_in(379 downto 352) & data_dly(383 downto 380);
			end if;
			
			if (counter<32) then
				data_out(415 downto 384)<= data_in(403 downto 384) & data_dly(415 downto 404);
			elsif (counter=32) then
				data_out(415 downto 384)<= "0000" & data_in(399 downto 384) & data_dly(415 downto 404);
			elsif (counter=64) then
				data_out(415 downto 384)<= data_reg(403 downto 384) & data_dly(411 downto 400);
			else
				data_out(415 downto 384)<= data_in(399 downto 384) & data_dly(415 downto 400);
			end if;
			
			if (counter<24) then
				data_out(447 downto 416)<= data_in(443 downto 416) & data_dly(447 downto 444);
			elsif (counter=24) then
				data_out(447 downto 416)<= "0000" & data_in(439 downto 416) & data_dly(447 downto 444);
			elsif (counter=64) then
				data_out(447 downto 416)<= data_reg(443 downto 416) & data_dly(443 downto 440);
			else
				data_out(447 downto 416)<= data_in(439 downto 416) & data_dly(447 downto 440);
			end if;
			
			if (counter<16) then
				data_out(479 downto 448)<= data_in(459 downto 448) & data_dly(479 downto 460);
			elsif (counter=16) then
				data_out(479 downto 448)<= "0000" & data_in(455 downto 448) & data_dly(479 downto 460);
			elsif (counter=64) then
				data_out(479 downto 448)<= data_reg(459 downto 448) & data_dly(475 downto 456);
			else
				data_out(479 downto 448)<= data_in(455 downto 448) & data_dly(479 downto 456);
			end if;
			
			if (counter<12) then
				data_out(511 downto 480)<= data_in(495 downto 480) & data_dly(511 downto 496);
			elsif (counter=12) then
				data_out(511 downto 480)<= "0000" & data_in(491 downto 480) & data_dly(511 downto 496);
			elsif (counter=64) then
				data_out(511 downto 480)<= data_reg(495 downto 480) & data_dly(507 downto 492);
			else
				data_out(511 downto 480)<= data_in(491 downto 480) & data_dly(511 downto 492);
			end if;
			
			if (counter<4) then
				data_out(543 downto 512)<= data_in(531 downto 512) & data_dly(543 downto 532);
			elsif (counter=4) then
				data_out(543 downto 512)<= "0000" & data_in(527 downto 512) & data_dly(543 downto 532);
			elsif (counter=64) then
				data_out(543 downto 512)<= data_reg(531 downto 512) & data_dly(539 downto 528);
			else
				data_out(543 downto 512)<= data_in(527 downto 512) & data_dly(543 downto 528);
			end if;
			
			if (counter=64) then
			data_out(575 downto 544)<= data_reg(575 downto 544);
			else
			data_out(575 downto 544)<= data_in(575 downto 544);
			end if;
			
			if (counter<25) then
				data_out(607 downto 576)<= data_in(587 downto 576) & data_dly(607 downto 588);
			elsif (counter=25) then
				data_out(607 downto 576)<= "0000" & data_in(583 downto 576) & data_dly(607 downto 588);
			elsif (counter=64) then
				data_out(607 downto 576)<= data_reg(587 downto 576) & data_dly(603 downto 584);
			else
				data_out(607 downto 576)<= data_in(583 downto 576) & data_dly(607 downto 584);
			end if;
			
			if (counter=64) then
			data_out(639 downto 608)<= data_reg(639 downto 608);
			else
			data_out(639 downto 608)<= data_in(639 downto 608);
			end if;
			
			if (counter<2) then
				data_out(671 downto 640)<= data_in(651 downto 640) & data_dly(671 downto 652);
			elsif (counter=2) then
				data_out(671 downto 640)<= "0000" & data_in(647 downto 640) & data_dly(671 downto 652);
			elsif (counter=64) then
				data_out(671 downto 640)<= data_reg(651 downto 640) & data_dly(667 downto 648);
			else
				data_out(671 downto 640)<= data_in(647 downto 640) & data_dly(671 downto 648);
			end if;
			
			if (counter=64) then
			data_out(703 downto 672)<= data_reg(703 downto 672);
			else
			data_out(703 downto 672)<= data_in(703 downto 672);
			end if;
			
			if (counter<6) then
				data_out(735 downto 704)<= data_in(727 downto 704) & data_dly(735 downto 728);
			elsif (counter=6) then
				data_out(735 downto 704)<= "0000" & data_in(723 downto 704) & data_dly(735 downto 728);
			elsif (counter=64) then
				data_out(735 downto 704)<= data_reg(727 downto 704) & data_dly(731 downto 724);
			else
				data_out(735 downto 704)<= data_in(723 downto 704) & data_dly(735 downto 724);
			end if;
			
			if (counter=64) then
			data_out(767 downto 736)<= data_reg(767 downto 736);
			else
			data_out(767 downto 736)<= data_in(767 downto 736);
			end if;
			
			if (counter<1) then
				data_out(799 downto 768)<= data_in(775 downto 768) & data_dly(799 downto 776);
			elsif (counter=1) then
				data_out(799 downto 768)<= "0000" & data_in(771 downto 768) & data_dly(799 downto 776);
			elsif (counter=64) then
				data_out(799 downto 768)<= data_reg(775 downto 768) & data_dly(795 downto 772);
			else
				data_out(799 downto 768)<= data_in(771 downto 768) & data_dly(799 downto 772);
			end if;
			
			if (counter=64) then
			data_out(831 downto 800)<= data_reg(831 downto 800);
			else
			data_out(831 downto 800)<= data_in(831 downto 800);
			end if;
			
			if (counter<18) then
				data_out(863 downto 832)<= data_in(863 downto 832);
			elsif (counter=18) then
				data_out(863 downto 832)<= "0000" & data_in(859 downto 832);
			elsif (counter=64) then
				data_out(863 downto 832)<= data_reg(863 downto 832);
			else
				data_out(863 downto 832)<= data_in(859 downto 832) & data_dly(863 downto 860);
			end if;
			
			if (counter=64) then
			data_out(895 downto 864)<= data_reg(895 downto 864);
			else
			data_out(895 downto 864)<= data_in(895 downto 864);
			end if;
			
			if (counter<3) then
				data_out(927 downto 896)<= data_in(899 downto 896) & data_dly(927 downto 900);
			elsif (counter=3) then
				data_out(927 downto 896)<= "0000" & data_dly(927 downto 900);
			elsif (counter=64) then
				data_out(927 downto 896)<= data_reg(899 downto 896) & data_dly(923 downto 896);
			else
				data_out(927 downto 896)<= data_dly(927 downto 896);
			end if;
			
			if (counter=64) then
			data_out(959 downto 928)<= data_reg(959 downto 928);
			else
			data_out(959 downto 928)<= data_in(959 downto 928);
			end if;
			
			if (counter<1) then
				data_out(991 downto 960)<= data_in(979 downto 960) & data_dly(991 downto 980);
			elsif (counter=1) then
				data_out(991 downto 960)<= "0000" & data_in(975 downto 960) & data_dly(991 downto 980);
			elsif (counter=64) then
				data_out(991 downto 960)<= data_reg(979 downto 960) & data_dly(987 downto 976);
			else
				data_out(991 downto 960)<= data_in(975 downto 960) & data_dly(991 downto 976);
			end if;
			
			if (counter=64) then
			data_out(1023 downto 992)<= data_reg(1023 downto 992);
			else
			data_out(1023 downto 992)<= data_in(1023 downto 992);
			end if;
			
			if (counter<51) then
				data_out(1055 downto 1024)<= data_in(1051 downto 1024) & data_dly(1055 downto 1052);
			elsif (counter=51) then
				data_out(1055 downto 1024)<= "0000" & data_in(1047 downto 1024) & data_dly(1055 downto 1052);
			elsif (counter=64) then
				data_out(1055 downto 1024)<= data_reg(1051 downto 1024) & data_dly(1051 downto 1048);
			else
				data_out(1055 downto 1024)<= data_in(1047 downto 1024) & data_dly(1055 downto 1048);
			end if;
			
			if (counter<47) then
				data_out(1087 downto 1056)<= data_in(1083 downto 1056) & data_dly(1087 downto 1084);
			elsif (counter=47) then
				data_out(1087 downto 1056)<= "0000" & data_in(1079 downto 1056) & data_dly(1087 downto 1084);
			elsif (counter=64) then
				data_out(1087 downto 1056)<= data_reg(1083 downto 1056) & data_dly(1083 downto 1080);
			else
				data_out(1087 downto 1056)<= data_in(1079 downto 1056) & data_dly(1087 downto 1080);
			end if;
			
			if (counter<58) then
				data_out(1119 downto 1088)<= data_in(1115 downto 1088) & data_dly(1119 downto 1116);
			elsif (counter=58) then
				data_out(1119 downto 1088)<= "0000" & data_in(1111 downto 1088) & data_dly(1119 downto 1116);
			elsif (counter=64) then
				data_out(1119 downto 1088)<= data_reg(1115 downto 1088) & data_dly(1115 downto 1112);
			else
				data_out(1119 downto 1088)<= data_in(1111 downto 1088) & data_dly(1119 downto 1112);
			end if;
			
			if (counter<58) then
				data_out(1151 downto 1120)<= data_in(1135 downto 1120) & data_dly(1151 downto 1136);
			elsif (counter=58) then
				data_out(1151 downto 1120)<= "0000" & data_in(1131 downto 1120) & data_dly(1151 downto 1136);
			elsif (counter=64) then
				data_out(1151 downto 1120)<= data_reg(1135 downto 1120) & data_dly(1147 downto 1132);
			else
				data_out(1151 downto 1120)<= data_in(1131 downto 1120) & data_dly(1151 downto 1132);
			end if;
			
			if (counter<48) then
				data_out(1183 downto 1152)<= data_in(1163 downto 1152) & data_dly(1183 downto 1164);
			elsif (counter=48) then
				data_out(1183 downto 1152)<= "0000" & data_in(1159 downto 1152) & data_dly(1183 downto 1164);
			elsif (counter=64) then
				data_out(1183 downto 1152)<= data_reg(1163 downto 1152) & data_dly(1179 downto 1160);
			else
				data_out(1183 downto 1152)<= data_in(1159 downto 1152) & data_dly(1183 downto 1160);
			end if;
			
			if (counter<47) then
				data_out(1215 downto 1184)<= data_in(1199 downto 1184) & data_dly(1215 downto 1200);
			elsif (counter=47) then
				data_out(1215 downto 1184)<= "0000" & data_in(1195 downto 1184) & data_dly(1215 downto 1200);
			elsif (counter=64) then
				data_out(1215 downto 1184)<= data_reg(1199 downto 1184) & data_dly(1211 downto 1196);
			else
				data_out(1215 downto 1184)<= data_in(1195 downto 1184) & data_dly(1215 downto 1196);
			end if;
			
			if (counter<56) then
				data_out(1247 downto 1216)<= data_in(1231 downto 1216) & data_dly(1247 downto 1232);
			elsif (counter=56) then
				data_out(1247 downto 1216)<= "0000" & data_in(1227 downto 1216) & data_dly(1247 downto 1232);
			elsif (counter=64) then
				data_out(1247 downto 1216)<= data_reg(1231 downto 1216) & data_dly(1243 downto 1228);
			else
				data_out(1247 downto 1216)<= data_in(1227 downto 1216) & data_dly(1247 downto 1228);
			end if;
			
			if (counter<53) then
				data_out(1279 downto 1248)<= data_in(1275 downto 1248) & data_dly(1279 downto 1276);
			elsif (counter=53) then
				data_out(1279 downto 1248)<= "0000" & data_in(1271 downto 1248) & data_dly(1279 downto 1276);
			elsif (counter=64) then
				data_out(1279 downto 1248)<= data_reg(1275 downto 1248) & data_dly(1275 downto 1272);
			else
				data_out(1279 downto 1248)<= data_in(1271 downto 1248) & data_dly(1279 downto 1272);
			end if;
			
			if (counter<55) then
				data_out(1311 downto 1280)<= data_in(1303 downto 1280) & data_dly(1311 downto 1304);
			elsif (counter=55) then
				data_out(1311 downto 1280)<= "0000" & data_in(1299 downto 1280) & data_dly(1311 downto 1304);
			elsif (counter=64) then
				data_out(1311 downto 1280)<= data_reg(1303 downto 1280) & data_dly(1307 downto 1300);
			else
				data_out(1311 downto 1280)<= data_in(1299 downto 1280) & data_dly(1311 downto 1300);
			end if;
			
			if (counter<49) then
				data_out(1343 downto 1312)<= data_in(1331 downto 1312) & data_dly(1343 downto 1332);
			elsif (counter=49) then
				data_out(1343 downto 1312)<= "0000" & data_in(1327 downto 1312) & data_dly(1343 downto 1332);
			elsif (counter=64) then
				data_out(1343 downto 1312)<= data_reg(1331 downto 1312) & data_dly(1339 downto 1328);
			else
				data_out(1343 downto 1312)<= data_in(1327 downto 1312) & data_dly(1343 downto 1328);
			end if;
			
			if (counter<60) then
				data_out(1375 downto 1344)<= data_in(1351 downto 1344) & data_dly(1375 downto 1352);
			elsif (counter=60) then
				data_out(1375 downto 1344)<= "0000" & data_in(1347 downto 1344) & data_dly(1375 downto 1352);
			elsif (counter=64) then
				data_out(1375 downto 1344)<= data_reg(1351 downto 1344) & data_dly(1371 downto 1348);
			else
				data_out(1375 downto 1344)<= data_in(1347 downto 1344) & data_dly(1375 downto 1348);
			end if;
			
			if (counter<52) then
				data_out(1407 downto 1376)<= data_in(1395 downto 1376) & data_dly(1407 downto 1396);
			elsif (counter=52) then
				data_out(1407 downto 1376)<= "0000" & data_in(1391 downto 1376) & data_dly(1407 downto 1396);
			elsif (counter=64) then
				data_out(1407 downto 1376)<= data_reg(1395 downto 1376) & data_dly(1403 downto 1392);
			else
				data_out(1407 downto 1376)<= data_in(1391 downto 1376) & data_dly(1407 downto 1392);
			end if;
			
			if (counter<59) then
				data_out(1439 downto 1408)<= data_in(1435 downto 1408) & data_dly(1439 downto 1436);
			elsif (counter=59) then
				data_out(1439 downto 1408)<= "0000" & data_in(1431 downto 1408) & data_dly(1439 downto 1436);
			elsif (counter=64) then
				data_out(1439 downto 1408)<= data_reg(1435 downto 1408) & data_dly(1435 downto 1432);
			else
				data_out(1439 downto 1408)<= data_in(1431 downto 1408) & data_dly(1439 downto 1432);
			end if;
			
			if (counter<54) then
				data_out(1471 downto 1440)<= data_in(1455 downto 1440) & data_dly(1471 downto 1456);
			elsif (counter=54) then
				data_out(1471 downto 1440)<= "0000" & data_in(1451 downto 1440) & data_dly(1471 downto 1456);
			elsif (counter=64) then
				data_out(1471 downto 1440)<= data_reg(1455 downto 1440) & data_dly(1467 downto 1452);
			else
				data_out(1471 downto 1440)<= data_in(1451 downto 1440) & data_dly(1471 downto 1452);
			end if;
			
			if (counter<59) then
				data_out(1503 downto 1472)<= data_in(1479 downto 1472) & data_dly(1503 downto 1480);
			elsif (counter=59) then
				data_out(1503 downto 1472)<= "0000" & data_in(1475 downto 1472) & data_dly(1503 downto 1480);
			elsif (counter=64) then
				data_out(1503 downto 1472)<= data_reg(1479 downto 1472) & data_dly(1499 downto 1476);
			else
				data_out(1503 downto 1472)<= data_in(1475 downto 1472) & data_dly(1503 downto 1476);
			end if;
			
			if (counter<58) then
				data_out(1535 downto 1504)<= data_in(1535 downto 1504);
			elsif (counter=58) then
				data_out(1535 downto 1504)<= "0000" & data_in(1531 downto 1504);
			elsif (counter=64) then
				data_out(1535 downto 1504)<= data_reg(1535 downto 1504);
			else
				data_out(1535 downto 1504)<= data_in(1531 downto 1504) & data_dly(1535 downto 1532);
			end if;
			
			if (counter<32) then
				data_out(1567 downto 1536)<= data_in(1559 downto 1536) & data_dly(1567 downto 1560);
			elsif (counter=32) then
				data_out(1567 downto 1536)<= "0000" & data_in(1555 downto 1536) & data_dly(1567 downto 1560);
			elsif (counter=64) then
				data_out(1567 downto 1536)<= data_reg(1559 downto 1536) & data_dly(1563 downto 1556);
			else
				data_out(1567 downto 1536)<= data_in(1555 downto 1536) & data_dly(1567 downto 1556);
			end if;
			
			if (counter<30) then
				data_out(1599 downto 1568)<= data_in(1599 downto 1568);
			elsif (counter=30) then
				data_out(1599 downto 1568)<= "0000" & data_in(1595 downto 1568);
			elsif (counter=64) then
				data_out(1599 downto 1568)<= data_reg(1599 downto 1568);
			else
				data_out(1599 downto 1568)<= data_in(1595 downto 1568) & data_dly(1599 downto 1596);
			end if;
			
			if (counter<57) then
				data_out(1631 downto 1600)<= data_in(1607 downto 1600) & data_dly(1631 downto 1608);
			elsif (counter=57) then
				data_out(1631 downto 1600)<= "0000" & data_in(1603 downto 1600) & data_dly(1631 downto 1608);
			elsif (counter=64) then
				data_out(1631 downto 1600)<= data_reg(1607 downto 1600) & data_dly(1627 downto 1604);
			else
				data_out(1631 downto 1600)<= data_in(1603 downto 1600) & data_dly(1631 downto 1604);
			end if;
			
			if (counter<49) then
				data_out(1663 downto 1632)<= data_in(1663 downto 1632);
			elsif (counter=49) then
				data_out(1663 downto 1632)<= "0000" & data_in(1659 downto 1632);
			elsif (counter=64) then
				data_out(1663 downto 1632)<= data_reg(1663 downto 1632);
			else
				data_out(1663 downto 1632)<= data_in(1659 downto 1632) & data_dly(1663 downto 1660);
			end if;
			
			if (counter<35) then
				data_out(1695 downto 1664)<= data_in(1671 downto 1664) & data_dly(1695 downto 1672);
			elsif (counter=35) then
				data_out(1695 downto 1664)<= "0000" & data_in(1667 downto 1664) & data_dly(1695 downto 1672);
			elsif (counter=64) then
				data_out(1695 downto 1664)<= data_reg(1671 downto 1664) & data_dly(1691 downto 1668);
			else
				data_out(1695 downto 1664)<= data_in(1667 downto 1664) & data_dly(1695 downto 1668);
			end if;
			
			if (counter<25) then
				data_out(1727 downto 1696)<= data_in(1727 downto 1696);
			elsif (counter=25) then
				data_out(1727 downto 1696)<= "0000" & data_in(1723 downto 1696);
			elsif (counter=64) then
				data_out(1727 downto 1696)<= data_reg(1727 downto 1696);
			else
				data_out(1727 downto 1696)<= data_in(1723 downto 1696) & data_dly(1727 downto 1724);
			end if;
			
			if (counter<41) then
				data_out(1759 downto 1728)<= data_in(1735 downto 1728) & data_dly(1759 downto 1736);
			elsif (counter=41) then
				data_out(1759 downto 1728)<= "0000" & data_in(1731 downto 1728) & data_dly(1759 downto 1736);
			elsif (counter=64) then
				data_out(1759 downto 1728)<= data_reg(1735 downto 1728) & data_dly(1755 downto 1732);
			else
				data_out(1759 downto 1728)<= data_in(1731 downto 1728) & data_dly(1759 downto 1732);
			end if;
			
			if (counter<38) then
				data_out(1791 downto 1760)<= data_in(1775 downto 1760) & data_dly(1791 downto 1776);
			elsif (counter=38) then
				data_out(1791 downto 1760)<= "0000" & data_in(1771 downto 1760) & data_dly(1791 downto 1776);
			elsif (counter=64) then
				data_out(1791 downto 1760)<= data_reg(1775 downto 1760) & data_dly(1787 downto 1772);
			else
				data_out(1791 downto 1760)<= data_in(1771 downto 1760) & data_dly(1791 downto 1772);
			end if;
			
			if (counter<44) then
				data_out(1823 downto 1792)<= data_in(1823 downto 1792);
			elsif (counter=44) then
				data_out(1823 downto 1792)<= "0000" & data_in(1819 downto 1792);
			elsif (counter=64) then
				data_out(1823 downto 1792)<= data_reg(1823 downto 1792);
			else
				data_out(1823 downto 1792)<= data_in(1819 downto 1792) & data_dly(1823 downto 1820);
			end if;
			
			if (counter<43) then
				data_out(1855 downto 1824)<= data_in(1855 downto 1824);
			elsif (counter=43) then
				data_out(1855 downto 1824)<= "0000" & data_in(1851 downto 1824);
			elsif (counter=64) then
				data_out(1855 downto 1824)<= data_reg(1855 downto 1824);
			else
				data_out(1855 downto 1824)<= data_in(1851 downto 1824) & data_dly(1855 downto 1852);
			end if;
			
			if (counter<51) then
				data_out(1887 downto 1856)<= data_in(1863 downto 1856) & data_dly(1887 downto 1864);
			elsif (counter=51) then
				data_out(1887 downto 1856)<= "0000" & data_in(1859 downto 1856) & data_dly(1887 downto 1864);
			elsif (counter=64) then
				data_out(1887 downto 1856)<= data_reg(1863 downto 1856) & data_dly(1883 downto 1860);
			else
				data_out(1887 downto 1856)<= data_in(1859 downto 1856) & data_dly(1887 downto 1860);
			end if;
			
			if (counter<49) then
				data_out(1919 downto 1888)<= data_in(1891 downto 1888) & data_dly(1919 downto 1892);
			elsif (counter=49) then
				data_out(1919 downto 1888)<= "0000" & data_dly(1919 downto 1892);
			elsif (counter=64) then
				data_out(1919 downto 1888)<= data_reg(1891 downto 1888) & data_dly(1915 downto 1888);
			else
				data_out(1919 downto 1888)<= data_dly(1919 downto 1888);
			end if;
			
			if (counter<53) then
				data_out(1951 downto 1920)<= data_in(1951 downto 1920);
			elsif (counter=53) then
				data_out(1951 downto 1920)<= "0000" & data_in(1947 downto 1920);
			elsif (counter=64) then
				data_out(1951 downto 1920)<= data_reg(1951 downto 1920);
			else
				data_out(1951 downto 1920)<= data_in(1947 downto 1920) & data_dly(1951 downto 1948);
			end if;
			
			if (counter<44) then
				data_out(1983 downto 1952)<= data_in(1955 downto 1952) & data_dly(1983 downto 1956);
			elsif (counter=44) then
				data_out(1983 downto 1952)<= "0000" & data_dly(1983 downto 1956);
			elsif (counter=64) then
				data_out(1983 downto 1952)<= data_reg(1955 downto 1952) & data_dly(1979 downto 1952);
			else
				data_out(1983 downto 1952)<= data_dly(1983 downto 1952);
			end if;
			
			if (counter<29) then
				data_out(2015 downto 1984)<= data_in(2015 downto 1984);
			elsif (counter=29) then
				data_out(2015 downto 1984)<= "0000" & data_in(2011 downto 1984);
			elsif (counter=64) then
				data_out(2015 downto 1984)<= data_reg(2015 downto 1984);
			else
				data_out(2015 downto 1984)<= data_in(2011 downto 1984) & data_dly(2015 downto 2012);
			end if;
			
			if (counter<22) then
				data_out(2047 downto 2016)<= data_in(2019 downto 2016) & data_dly(2047 downto 2020);
			elsif (counter=22) then
				data_out(2047 downto 2016)<= "0000" & data_dly(2047 downto 2020);
			elsif (counter=64) then
				data_out(2047 downto 2016)<= data_reg(2019 downto 2016) & data_dly(2043 downto 2016);
			else
				data_out(2047 downto 2016)<= data_dly(2047 downto 2016);
			end if;
			
       end if;
     end process;
   end rtl;
 