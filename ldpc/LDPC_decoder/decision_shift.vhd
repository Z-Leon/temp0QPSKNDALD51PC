library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity	decision_shift	 is         
port(
   clk       : in  std_logic;
   reset     : in  std_logic;
   data_in   : in  std_logic_vector(511 downto 0);
   data_out  : out std_logic_vector(511 downto 0)
	);	 
end	decision_shift;

architecture rtl of decision_shift is
   signal data_dly :std_logic_vector(511 downto 0);
   signal data_reg :std_logic_vector(511 downto 0);
   signal counter  :std_logic_vector(6 downto 0);
 begin
     
   process(clk,reset)
    begin
       if (reset='1') then
          data_dly <=(others=>'0');
		    data_reg <=(others=>'0');
		    counter  <=(others=>'0'); 
		    elsif (clk'event and clk='1') then
		        data_dly <=data_in;
		        counter <=counter +1;
		        if(counter =0) then
			       data_reg<=data_in;
			     end if;
		  end if;
	end process;
	
	process(clk,reset)
	   begin
       if (reset='1') then
         data_out<=(others=>'0');
       elsif (clk'event and clk='1') then
         if (counter < 24) then
            data_out(7 downto 0) <=data_in(0)&data_dly(7 downto 1);
           elsif (counter=24) then
            data_out(7 downto 0) <='0'&data_dly(7 downto 1);
           elsif (counter=64) then
            data_out(7 downto 0) <=data_reg(0)&data_dly(6 downto 0);
           else
            data_out(7 downto 0) <=data_dly(7 downto 0);
        end if;
        
        if (counter < 6) then
            data_out(15 downto 8) <=data_in(11 downto 8)&data_dly(15 downto 12);
            elsif (counter=6) then
            data_out(15 downto 8) <='0'&data_in(10 downto 8)&data_dly(15 downto 12);
            elsif (counter=64) then
            data_out(15 downto 8) <=data_reg(11 downto 8)&data_dly(14 downto 11);
            else
            data_out(15 downto 8) <=data_in(10 downto 8)&data_dly(15 downto 11);
        end if;
        
        if (counter < 45) then
          data_out(23 downto 16) <= data_in(20 downto 16)&data_dly(23 downto 21);
          elsif (counter =45) then
          data_out(23 downto 16) <= '0'&data_in(19 downto 16)&data_dly(23 downto 21);
          elsif (counter =64) then
          data_out(23 downto 16) <= data_reg(20 downto 16)&data_dly(22 downto 20);
          else
          data_out(23 downto 16) <= data_in(19 downto 16)&data_dly(23 downto 20);
        end if;

        if (counter < 30) then
           data_out(31 downto 24) <= data_in(28 downto 24)&data_dly(31 downto 29);
          elsif (counter =30) then
           data_out(31 downto 24) <= '0'&data_in(27 downto 24)&data_dly(31 downto 29);
          elsif (counter =64) then
           data_out(31 downto 24) <= data_reg(28 downto 24)&data_dly(30 downto 28);
          else
           data_out(31 downto 24) <= data_in(27 downto 24)&data_dly(31 downto 28);
        end if;

        if (counter < 23) then
           data_out(39 downto 32) <=data_in(39 downto 32);
          elsif (counter =23) then
           data_out(39 downto 32) <='0'&data_in(38 downto 32);
          elsif (counter =64) then
           data_out(39 downto 32) <=data_reg(39 downto 32);
          else
           data_out(39 downto 32) <=data_in(38 downto 32)&data_dly(39);
        end if;
       
        if (counter < 12) then
          data_out(47 downto 40) <= data_in(40)&data_dly(47 downto 41);
          elsif (counter =12) then
          data_out(47 downto 40) <= '0'&data_dly(47 downto 41);
          elsif (counter =64) then
          data_out(47 downto 40) <= data_reg(40)&data_dly(46 downto 40);
          else
          data_out(47 downto 40) <=data_dly(47 downto 40);
        end if;
        
        if (counter < 37) then
          data_out(55 downto 48) <= data_in(54 downto 48)&data_dly(55);
         elsif (counter =37) then
          data_out(55 downto 48) <= '0'&data_in(53 downto 48)&data_dly(55);
         elsif (counter =64) then
          data_out(55 downto 48) <= data_reg(54 downto 48)&data_dly(54);
         else
          data_out(55 downto 48) <= data_in(53 downto 48)&data_dly(55 downto 54);
        end if;

        if (counter < 34) then
          data_out(63 downto 56) <= data_in(57 downto 56)&data_dly(63 downto 58);
         elsif (counter =34) then
          data_out(63 downto 56) <= '0'&data_in(56)&data_dly(63 downto 58);
         elsif (counter =64) then
          data_out(63 downto 56) <= data_reg(57 downto 56)&data_dly(62 downto 57);
         else
          data_out(63 downto 56) <= data_in(56)&data_dly(63 downto 57);
        end if;
       
        if (counter < 24) then
           data_out(71 downto 64) <= data_in(65 downto 64)&data_dly(71 downto 66);
         elsif (counter =24) then
           data_out(71 downto 64) <= '0'&data_in(64)&data_dly(71 downto 66);
         elsif (counter =64) then
           data_out(71 downto 64) <= data_reg(65 downto 64)&data_dly(70 downto 65);
         else
           data_out(71 downto 64) <= data_in(64)&data_dly(71 downto 65);
        end if;

        if (counter < 6) then
           data_out(79 downto 72) <= data_in(72)&data_dly(79 downto 73);
         elsif (counter =6) then
           data_out(79 downto 72) <= '0'&data_dly(79 downto 73);
         elsif (counter =64) then
           data_out(79 downto 72) <= data_reg(72)&data_dly(78 downto 72);
         else 
           data_out(79 downto 72) <=data_dly(79 downto 72);
        end if;

       if (counter < 35) then
          data_out(87 downto 80) <= data_in(82 downto 80)&data_dly(87 downto 83);
        elsif (counter =35) then
          data_out(87 downto 80) <= '0'&data_in(81 downto 80)&data_dly(87 downto 83);
        elsif (counter =64) then
          data_out(87 downto 80) <= data_reg(82 downto 80)&data_dly(86 downto 82);
        else
          data_out(87 downto 80) <= data_in(81 downto 80)&data_dly(87 downto 82);
       end if;

if (counter < 26) then
    data_out(95 downto 88) <=data_in(95 downto 88);
elsif (counter =26) then
    data_out(95 downto 88) <= '0'&data_in(94 downto 88);
elsif (counter =64) then
    data_out(95 downto 88) <=data_reg(95 downto 88);
else
    data_out(95 downto 88) <= data_in(94 downto 88)&data_dly(95);
end if;

if (counter < 32) then
    data_out(103 downto 96) <= data_in(100 downto 96)&data_dly(103 downto 101);
elsif (counter =32) then
    data_out(103 downto 96) <= '0'&data_in(99 downto 96)&data_dly(103 downto 101);
elsif (counter =64) then
    data_out(103 downto 96) <= data_reg(100 downto 96)&data_dly(102 downto 100);
else
    data_out(103 downto 96) <= data_in(99 downto 96)&data_dly(103 downto 100);
end if;

if (counter < 24) then
    data_out(111 downto 104) <= data_in(110 downto 104)&data_dly(111);
elsif (counter =24) then
    data_out(111 downto 104) <= '0'&data_in(109 downto 104)&data_dly(111);
elsif (counter =64) then
    data_out(111 downto 104) <= data_reg(110 downto 104)&data_dly(110);
else
    data_out(111 downto 104) <= data_in(109 downto 104)&data_dly(111 downto 110);
end if;

if (counter < 16) then
    data_out(119 downto 112) <= data_in(114 downto 112)&data_dly(119 downto 115);
elsif (counter =16) then
    data_out(119 downto 112) <= '0'&data_in(113 downto 112)&data_dly(119 downto 115);
elsif (counter =64) then
    data_out(119 downto 112) <= data_reg(114 downto 112)&data_dly(118 downto 114);
else
    data_out(119 downto 112) <= data_in(113 downto 112)&data_dly(119 downto 114);
end if;

if (counter < 12) then
    data_out(127 downto 120) <= data_in(123 downto 120)&data_dly(127 downto 124);
elsif (counter =12) then
    data_out(127 downto 120) <= '0'&data_in(122 downto 120)&data_dly(127 downto 124);
elsif (counter =64) then
    data_out(127 downto 120) <= data_reg(123 downto 120)&data_dly(126 downto 123);
else
    data_out(127 downto 120) <= data_in(122 downto 120)&data_dly(127 downto 123);
end if;

if (counter < 4) then
    data_out(135 downto 128) <= data_in(132 downto 128)&data_dly(135 downto 133);
elsif (counter =4) then
    data_out(135 downto 128) <= '0'&data_in(131 downto 128)&data_dly(135 downto 133);
elsif (counter =64) then
    data_out(135 downto 128) <= data_reg(132 downto 128)&data_dly(134 downto 132);
else
    data_out(135 downto 128) <= data_in(131 downto 128)&data_dly(135 downto 132);
end if;

if (counter=64) then
    data_out(143 downto 136) <=data_reg(143 downto 136);
else
    data_out(143 downto 136) <=data_in(143 downto 136);
end if;

if (counter < 25) then
    data_out(151 downto 144) <= data_in(146 downto 144)&data_dly(151 downto 147);
elsif (counter =25) then
    data_out(151 downto 144) <= '0'&data_in(145 downto 144)&data_dly(151 downto 147);
elsif (counter =64) then
    data_out(151 downto 144) <= data_reg(146 downto 144)&data_dly(150 downto 146);
else
    data_out(151 downto 144) <= data_in(145 downto 144)&data_dly(151 downto 146);
end if;

if (counter =64) then
    data_out(159 downto 152) <=data_reg(159 downto 152);
else
    data_out(159 downto 152) <=data_in(159 downto 152);
end if;

if (counter < 2) then
    data_out(167 downto 160) <= data_in(162 downto 160)&data_dly(167 downto 163);
elsif (counter =2) then
    data_out(167 downto 160) <= '0'&data_in(161 downto 160)&data_dly(167 downto 163);
elsif (counter =64) then
    data_out(167 downto 160) <= data_reg(162 downto 160)&data_dly(166 downto 162);
else
    data_out(167 downto 160) <= data_in(161 downto 160)&data_dly(167 downto 162);
end if;

if (counter =64) then
   data_out(175 downto 168) <=data_reg(175 downto 168);
else
   data_out(175 downto 168) <=data_in(175 downto 168);
end if;

if (counter < 6) then
    data_out(183 downto 176) <= data_in(181 downto 176)&data_dly(183 downto 182);
elsif (counter =6) then
    data_out(183 downto 176) <= '0'&data_in(180 downto 176)&data_dly(183 downto 182);
elsif (counter =64) then
    data_out(183 downto 176) <= data_reg(181 downto 176)&data_dly(182 downto 181);
else
    data_out(183 downto 176) <= data_in(180 downto 176)&data_dly(183 downto 181);
end if;

if (counter =64) then
   data_out(191 downto 184) <=data_reg(191 downto 184);
else
   data_out(191 downto 184) <=data_in(191 downto 184);
end if;

if (counter < 1) then
    data_out(199 downto 192) <= data_in(193 downto 192)&data_dly(199 downto 194);
elsif (counter =1) then
    data_out(199 downto 192) <= '0'&data_in(192)&data_dly(199 downto 194);
elsif (counter =64) then
    data_out(199 downto 192) <= data_reg(193 downto 192)&data_dly(198 downto 193);
else
    data_out(199 downto 192) <= data_in(192)&data_dly(199 downto 193);
end if;

if (counter =64) then
   data_out(207 downto 200) <=data_reg(207 downto 200);
else
   data_out(207 downto 200) <=data_in(207 downto 200);
end if;

if (counter < 18) then
   data_out(215 downto 208) <=data_in(215 downto 208);
elsif (counter =18) then
    data_out(215 downto 208) <= '0'&data_in(214 downto 208);
elsif (counter =64) then
    data_out(215 downto 208) <=data_reg(215 downto 208);
else
    data_out(215 downto 208) <= data_in(214 downto 208)&data_dly(215);
end if;

if (counter =64) then
   data_out(223 downto 216) <=data_reg(223 downto 216);
else
   data_out(223 downto 216) <=data_in(223 downto 216);
end if;

if (counter < 3) then
   data_out(231 downto 224) <= data_in(224)&data_dly(231 downto 225);
elsif (counter =3) then
    data_out(231 downto 224) <= '0'&data_dly(231 downto 225);
elsif (counter =64) then
    data_out(231 downto 224) <= data_reg(224)&data_dly(230 downto 224);
else
    data_out(231 downto 224) <=data_dly(231 downto 224);
end if;

if (counter =64) then
   data_out(239 downto 232) <=data_reg(239 downto 232);
else
   data_out(239 downto 232) <=data_in(239 downto 232);
end if;

if (counter < 1) then
   data_out(247 downto 240) <= data_in(244 downto 240)&data_dly(247 downto 245);
elsif (counter =1) then
    data_out(247 downto 240) <= '0'&data_in(243 downto 240)&data_dly(247 downto 245);
elsif (counter =64) then
    data_out(247 downto 240) <= data_reg(244 downto 240)&data_dly(246 downto 244);
else
    data_out(247 downto 240) <= data_in(243 downto 240)&data_dly(247 downto 244);
end if;

if (counter =64) then
    data_out(255 downto 248) <=data_reg(255 downto 248);
else
    data_out(255 downto 248) <=data_in(255 downto 248);
end if;

if (counter < 51) then
    data_out(263 downto 256) <= data_in(262 downto 256)&data_dly(263);
elsif (counter =51) then
    data_out(263 downto 256) <= '0'&data_in(261 downto 256)&data_dly(263);
elsif (counter =64) then
    data_out(263 downto 256) <= data_reg(262 downto 256)&data_dly(262);
else
    data_out(263 downto 256) <= data_in(261 downto 256)&data_dly(263 downto 262);
end if;

if (counter < 47) then
    data_out(271 downto 264) <= data_in(270 downto 264)&data_dly(271);
elsif (counter =47) then
    data_out(271 downto 264) <= '0'&data_in(269 downto 264)&data_dly(271);
elsif (counter =64) then
    data_out(271 downto 264) <= data_reg(270 downto 264)&data_dly(270);
else
    data_out(271 downto 264) <= data_in(269 downto 264)&data_dly(271 downto 270);
end if;

if (counter < 58) then
    data_out(279 downto 272) <= data_in(278 downto 272)&data_dly(279);
elsif (counter =58) then
    data_out(279 downto 272) <= '0'&data_in(277 downto 272)&data_dly(279);
elsif (counter =64) then
    data_out(279 downto 272) <= data_reg(278 downto 272)&data_dly(278);
else
    data_out(279 downto 272) <= data_in(277 downto 272)&data_dly(279 downto 278);
end if;

if (counter < 58) then
    data_out(287 downto 280) <= data_in(283 downto 280)&data_dly(287 downto 284);
elsif (counter =58) then
    data_out(287 downto 280) <= '0'&data_in(282 downto 280)&data_dly(287 downto 284);
elsif (counter =64) then
    data_out(287 downto 280) <= data_reg(283 downto 280)&data_dly(286 downto 283);
else
    data_out(287 downto 280) <= data_in(282 downto 280)&data_dly(287 downto 283);
end if;

if (counter < 48) then
    data_out(295 downto 288) <= data_in(290 downto 288)&data_dly(295 downto 291);
elsif (counter =48) then
    data_out(295 downto 288) <= '0'&data_in(289 downto 288)&data_dly(295 downto 291);
elsif (counter =64) then
    data_out(295 downto 288) <= data_reg(290 downto 288)&data_dly(294 downto 290);
else
    data_out(295 downto 288) <= data_in(289 downto 288)&data_dly(295 downto 290);
end if;

if (counter < 47) then
    data_out(303 downto 296) <= data_in(299 downto 296)&data_dly(303 downto 300);
elsif (counter =47) then
    data_out(303 downto 296) <= '0'&data_in(298 downto 296)&data_dly(303 downto 300);
elsif (counter =64) then
    data_out(303 downto 296) <= data_reg(299 downto 296)&data_dly(302 downto 299);
else
    data_out(303 downto 296) <= data_in(298 downto 296)&data_dly(303 downto 299);
end if;

if (counter < 56) then
    data_out(311 downto 304) <= data_in(307 downto 304)&data_dly(311 downto 308);
elsif (counter =56) then
    data_out(311 downto 304) <= '0'&data_in(306 downto 304)&data_dly(311 downto 308);
elsif (counter =64) then
    data_out(311 downto 304) <= data_reg(307 downto 304)&data_dly(310 downto 307);
else
    data_out(311 downto 304) <= data_in(306 downto 304)&data_dly(311 downto 307);
end if;

if (counter < 53) then
    data_out(319 downto 312) <= data_in(318 downto 312)&data_dly(319);
elsif (counter =53) then
    data_out(319 downto 312) <= '0'&data_in(317 downto 312)&data_dly(319);
elsif (counter =64) then
    data_out(319 downto 312) <= data_reg(318 downto 312)&data_dly(318);
else
    data_out(319 downto 312) <= data_in(317 downto 312)&data_dly(319 downto 318);
end if;

if (counter < 55) then
    data_out(327 downto 320) <= data_in(325 downto 320)&data_dly(327 downto 326);
elsif (counter =55) then
    data_out(327 downto 320) <= '0'&data_in(324 downto 320)&data_dly(327 downto 326);
elsif (counter =64) then
    data_out(327 downto 320) <= data_reg(325 downto 320)&data_dly(326 downto 325);
else
    data_out(327 downto 320) <= data_in(324 downto 320)&data_dly(327 downto 325);
end if;

if (counter < 49) then
    data_out(335 downto 328) <= data_in(332 downto 328)&data_dly(335 downto 333);
elsif (counter =49) then
    data_out(335 downto 328) <= '0'&data_in(331 downto 328)&data_dly(335 downto 333);
elsif (counter =64) then
    data_out(335 downto 328) <= data_reg(332 downto 328)&data_dly(334 downto 332);
else
    data_out(335 downto 328) <= data_in(331 downto 328)&data_dly(335 downto 332);
end if;

if (counter < 60) then
    data_out(343 downto 336) <= data_in(337 downto 336)&data_dly(343 downto 338);
elsif (counter =60) then
    data_out(343 downto 336) <= '0'&data_in(336)&data_dly(343 downto 338);
elsif (counter =64) then
    data_out(343 downto 336) <= data_reg(337 downto 336)&data_dly(342 downto 337);
else
    data_out(343 downto 336) <= data_in(336)&data_dly(343 downto 337);
end if;

if (counter < 52) then
    data_out(351 downto 344) <= data_in(348 downto 344)&data_dly(351 downto 349);
elsif (counter =52) then
    data_out(351 downto 344) <= '0'&data_in(347 downto 344)&data_dly(351 downto 349);
elsif (counter =64) then
    data_out(351 downto 344) <= data_reg(348 downto 344)&data_dly(350 downto 348);
else
    data_out(351 downto 344) <= data_in(347 downto 344)&data_dly(351 downto 348);
end if;

if (counter < 59) then
    data_out(359 downto 352) <= data_in(358 downto 352)&data_dly(359);
elsif (counter =59) then
    data_out(359 downto 352) <= '0'&data_in(357 downto 352)&data_dly(359);
elsif (counter =64) then
    data_out(359 downto 352) <= data_reg(358 downto 352)&data_dly(358);
else
    data_out(359 downto 352) <= data_in(357 downto 352)&data_dly(359 downto 358);
end if;

if (counter < 54) then
    data_out(367 downto 360) <= data_in(363 downto 360)&data_dly(367 downto 364);
elsif (counter =54) then
    data_out(367 downto 360) <= '0'&data_in(362 downto 360)&data_dly(367 downto 364);
elsif (counter =64) then
    data_out(367 downto 360) <= data_reg(363 downto 360)&data_dly(366 downto 363);
else
    data_out(367 downto 360) <= data_in(362 downto 360)&data_dly(367 downto 363);
end if;

if (counter < 59) then
    data_out(375 downto 368) <= data_in(369 downto 368)&data_dly(375 downto 370);
elsif (counter =59) then
    data_out(375 downto 368) <= '0'&data_in(368)&data_dly(375 downto 370);
elsif (counter =64) then
    data_out(375 downto 368) <= data_reg(369 downto 368)&data_dly(374 downto 369);
else
    data_out(375 downto 368) <= data_in(368)&data_dly(375 downto 369);
end if;

if (counter < 58) then
    data_out(383 downto 376) <=data_in(383 downto 376);
elsif (counter =58) then
    data_out(383 downto 376) <= '0'&data_in(382 downto 376);
elsif (counter =64) then
    data_out(383 downto 376) <=data_reg(383 downto 376);
else
    data_out(383 downto 376) <= data_in(382 downto 376)&data_dly(383);
end if;

if (counter < 32) then
    data_out(391 downto 384) <= data_in(389 downto 384)&data_dly(391 downto 390);
elsif (counter =32) then
    data_out(391 downto 384) <= '0'&data_in(388 downto 384)&data_dly(391 downto 390);
elsif (counter =64) then
    data_out(391 downto 384) <= data_reg(389 downto 384)&data_dly(390 downto 389);
else
    data_out(391 downto 384) <= data_in(388 downto 384)&data_dly(391 downto 389);
end if;

if (counter < 30) then
    data_out(399 downto 392) <=data_in(399 downto 392);
elsif (counter =30) then
    data_out(399 downto 392) <= '0'&data_in(398 downto 392);
elsif (counter =64) then
    data_out(399 downto 392) <=data_reg(399 downto 392);
else
    data_out(399 downto 392) <= data_in(398 downto 392)&data_dly(399);
end if;

if (counter < 57) then
    data_out(407 downto 400) <= data_in(401 downto 400)&data_dly(407 downto 402);
elsif (counter =57) then
    data_out(407 downto 400) <= '0'&data_in(400)&data_dly(407 downto 402);
elsif (counter =64) then
    data_out(407 downto 400) <= data_reg(401 downto 400)&data_dly(406 downto 401);
else
    data_out(407 downto 400) <= data_in(400)&data_dly(407 downto 401);
end if;

if (counter < 49) then
    data_out(415 downto 408) <=data_in(415 downto 408);
elsif (counter =49) then
    data_out(415 downto 408) <= '0'&data_in(414 downto 408);
elsif (counter =64) then
    data_out(415 downto 408) <=data_reg(415 downto 408);
else
    data_out(415 downto 408) <= data_in(414 downto 408)&data_dly(415);
end if;

if (counter < 35) then
    data_out(423 downto 416) <= data_in(417 downto 416)&data_dly(423 downto 418);
elsif (counter =35) then
    data_out(423 downto 416) <= '0'&data_in(416)&data_dly(423 downto 418);
elsif (counter =64) then
    data_out(423 downto 416) <= data_reg(417 downto 416)&data_dly(422 downto 417);
else
    data_out(423 downto 416) <= data_in(416)&data_dly(423 downto 417);
end if;

if (counter < 25) then
    data_out(431 downto 424) <=data_in(431 downto 424);
elsif (counter =25) then
    data_out(431 downto 424) <= '0'&data_in(430 downto 424);
elsif (counter =64) then
    data_out(431 downto 424) <=data_reg(431 downto 424);
else
    data_out(431 downto 424) <= data_in(430 downto 424)&data_dly(431);
end if;

if (counter < 41) then
    data_out(439 downto 432) <= data_in(433 downto 432)&data_dly(439 downto 434);
elsif (counter =41) then
    data_out(439 downto 432) <= '0'&data_in(432)&data_dly(439 downto 434);
elsif (counter =64) then
    data_out(439 downto 432) <= data_reg(433 downto 432)&data_dly(438 downto 433);
else
    data_out(439 downto 432) <= data_in(432)&data_dly(439 downto 433);
end if;

if (counter < 38) then
    data_out(447 downto 440) <= data_in(443 downto 440)&data_dly(447 downto 444);
elsif (counter =38) then
    data_out(447 downto 440) <= '0'&data_in(442 downto 440)&data_dly(447 downto 444);
elsif (counter =64) then
    data_out(447 downto 440) <= data_reg(443 downto 440)&data_dly(446 downto 443);
else
    data_out(447 downto 440) <= data_in(442 downto 440)&data_dly(447 downto 443);
end if;

if (counter < 44) then
    data_out(455 downto 448) <=data_in(455 downto 448);
elsif (counter =44) then
    data_out(455 downto 448) <= '0'&data_in(454 downto 448);
elsif (counter =64) then
    data_out(455 downto 448) <=data_reg(455 downto 448);
else
    data_out(455 downto 448) <= data_in(454 downto 448)&data_dly(455);
end if;

if (counter < 43) then
    data_out(463 downto 456) <=data_in(463 downto 456);
elsif (counter =43) then
    data_out(463 downto 456) <= '0'&data_in(462 downto 456);
elsif (counter =64) then
    data_out(463 downto 456) <=data_reg(463 downto 456);
else
    data_out(463 downto 456) <= data_in(462 downto 456)&data_dly(463);
end if;

if (counter < 51) then
    data_out(471 downto 464) <= data_in(465 downto 464)&data_dly(471 downto 466);
elsif (counter =51) then
    data_out(471 downto 464) <= '0'&data_in(464)&data_dly(471 downto 466);
elsif (counter =64) then
    data_out(471 downto 464) <= data_reg(465 downto 464)&data_dly(470 downto 465);
else
    data_out(471 downto 464) <= data_in(464)&data_dly(471 downto 465);
end if;

if (counter < 49) then
    data_out(479 downto 472) <= data_in(472)&data_dly(479 downto 473);
elsif (counter =49) then
    data_out(479 downto 472) <= '0'&data_dly(479 downto 473);
elsif (counter =64) then
    data_out(479 downto 472) <= data_reg(472)&data_dly(478 downto 472);
else
    data_out(479 downto 472) <=data_dly(479 downto 472);
end if;

if (counter < 53) then
    data_out(487 downto 480) <=data_in(487 downto 480);
elsif (counter =53) then
    data_out(487 downto 480) <= '0'&data_in(486 downto 480);
elsif (counter =64) then
    data_out(487 downto 480) <=data_reg(487 downto 480);
else
    data_out(487 downto 480) <= data_in(486 downto 480)&data_dly(487);
end if;

if (counter < 44) then
    data_out(495 downto 488) <= data_in(488)&data_dly(495 downto 489);
elsif (counter =44) then
    data_out(495 downto 488) <= '0'&data_dly(495 downto 489);
elsif (counter =64) then
    data_out(495 downto 488) <= data_reg(488)&data_dly(494 downto 488);
else
    data_out(495 downto 488) <=data_dly(495 downto 488);
end if;

if (counter < 29) then
    data_out(503 downto 496) <=data_in(503 downto 496);
elsif (counter =29) then
    data_out(503 downto 496) <= '0'&data_in(502 downto 496);
elsif (counter =64) then
    data_out(503 downto 496) <=data_reg(503 downto 496);
else
    data_out(503 downto 496) <= data_in(502 downto 496)&data_dly(503);
end if;

    if (counter < 22) then
     data_out(511 downto 504) <= data_in(504)&data_dly(511 downto 505);
    elsif (counter =22) then
     data_out(511 downto 504) <= '0'&data_dly(511 downto 505);
    elsif (counter =64) then
     data_out(511 downto 504) <= data_reg(504)&data_dly(510 downto 504);
    else
     data_out(511 downto 504) <=data_dly(511 downto 504);
    end if;

end if;
end process;  
end rtl;