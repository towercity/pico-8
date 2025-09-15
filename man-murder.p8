pico-8 cartridge // http://www.pico-8.com
version 43
__lua__


function _init() 
   options={
      'atk1',
      'atk2',
      'dodge'
   }
   
   debug=''

   player_right, player_left = make_player(), make_player();
   single_player=false
   
   frame=0
   sec=0
   turn=1
   speed=60
   
   mode='start'
   sf_idx=0
end

function _update60()
   if(mode!='win_player_right' and mode!='win_player_left') then
      update_time()
   end
   
   if(mode=='start') then
      turn_sec=4
      sf_idx=0
      mode='move'
   end

   local active_players={player_right,player_left}
   if(single_player)then
      active_players={player_right}
   end

   if (mode=='move') then
      if (not player_right.moved) then
         player_right.moved=true
         player_right.turn_order=frame
         if (btn(⬇️) )then
            player_right.move='atk1'
         elseif (btn(⬅️)) then
            player_right.move='atk2'
         elseif (btn(⬆️) or btn(➡️)) then
            player_right.move='dodge'
         else
            player_right.move=''
            player_right.moved=false
            player_right.turn_order=0
         end
      end
      
      if (not player_left.moved) then
         player_left.moved=true
         player_left.turn_order=frame
         if (btn(⬇️, 1) )then
            player_left.move='atk1'
         elseif (btn(➡️, 1)) then
            player_left.move='atk2'
         elseif (btn(⬆️, 1) 
         or btn(⬅️, 1)) then
            player_left.move='dodge'
         else
            player_left.move=''
            player_left.moved=false
            player_left.turn_order=0
         end
      end

   end
end

function _draw()
   cls()

   if(mode!='win_player_right' and mode!='win_player_left') then
      print(debug..'\n')
   else
      if(mode=='win_player_right')then
         print('wow, good job\nplayer on right won with '..player_right.health..' health.',0,0,7)
      elseif(mode=='win_player_left')then
         print('player left wom with '..player_left.health..'.\n',0,0,7)
      end
   end
   draw_lights()
   draw_guys()
   
end
-->8
function update_time()
   frame+=1
   if(0 == frame%speed) then
      sec+=1
      update_seconds();
   end
end

function update_seconds()
   if(turn_sec==1) then 
      sf_idx=1
      mode='attack'
   end
   
   if(mode=='attack') then
      turn+=1
      if(single_player)then
         player_left.move=get_opp_move()
      end 
      do_attacks()

      if(player_right.health<1)then
         mode='win_player_left'
      elseif(player_left.health<1)then
         mode='win_player_right'
      else
         mode='start'
      end
   end
   
   sfx(sf_idx)
   
   turn_sec-=1
end
-->8
function get_opp_move()
   return rnd(options)
end


function do_attacks()
   for p in all({player_right, player_left}) do
      p.last_move=p.move
      local move=p.move
      p.atk,p.def=0,0
      if(move==options[1])then
         p.atk=1
      elseif(move==options[2])then
         p.atk=2
      elseif(move==options[3])then
         p.def=1
      end
      p.moved=false
   end

   player_right_goes_first = get_player_order()
   if(player_right_goes_first)then
      do_attack(player_right,player_left)
      do_attack(player_left,player_right)
   else
      do_attack(player_left,player_right)
      do_attack(player_right,player_left)
   end
end
-->8
function make_player()
   return {
      move="",
      health=10,
      atk=0,
      def=0,
      turn_order=0,
      damage=0,
      moved=false,
      -- for ui
      last_move=''
   }
end

function do_attack(killer,victim)
   local damage=killer.atk-victim.def

   if(damage<0) damage=0

   killer.damage=damage
   victim.health-=damage
   end

function get_player_order()
   if(single_player) then
      return rnd({true,false})
   end

   return player_right.turn_order < player_left.turn_order
end

function draw_lights()
   if (turn_sec==4) do
      spr(17)
      return
   end
   for i=0,turn_sec-1 do
      spr(16,i*8)
   end
   end

function draw_guys()
   local bottom=96
   local left_x, right_x=4*8,12*8
   
   --guy 1
   spr(1,left_x, bottom)
   if(player_left.damage!=0) then
      print('-'..player_left.damage, left_x+8, bottom-10,8)
   end
   if(player_left.moved) then
      spr(17,left_x, bottom+8)
   end
   print(player_left.health, left_x, bottom+16,7)
   
   --guy 2
   spr(2, right_x, bottom)
   if(player_right.damage!=0) then
      print('-'..player_right.damage, right_x-8, bottom-10,8)
   end
   if(player_right.moved) then
      spr(17,right_x, bottom+8)
   end
   print(player_right.health, right_x, bottom+16,7)

   if(turn_sec == 4) then
      print(player_left.last_move,left_x+8,bottom)
      print(player_right.last_move,right_x-16,bottom)
   end
end



__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000cc0000009900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000ccccc000999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000c7c7c000979790000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000ccccc000999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000ccc0000099900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000ccc0000099900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00088000000bb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0088880000bbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0088880000bbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00088000000bb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010100000000000000000002b0502c0502c0502c050000000000000000000000000000000000000000000000000000000000000000000000005000000000000000000000000e0000000000000000000000000000
010100000000000000000000000000000380503805038050380500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
