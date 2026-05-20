pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
   _init_boids(900)
   f=0
end

function _update60()
   f=f+1
   _update_boids()
end

function _draw()
   cls(7)
   _draw_boids()
   -- cpu
   print(stat(1),4,4,11)
   print(f)
end


-->8
function _init_boids(boids_count)
   -- multiple tables for data, so we don't need expensive lookups
   boids_pos,boids_speed,boids_angle={},{},{}

   for i=1,boids_count do
      make_boid()
   end
end

-- note: we allow boids in same spot on the presumtion they may correct
function make_boid()
   -- make a pos
   local lb={
      x=flr(rnd(128)),
      y=flr(rnd(128)),
      z=rnd({1,2,14})
   }
   local speed,angle=rnd()+.25,rnd()
   
   add(boids_pos,lb)
   add(boids_speed,speed)
   add(boids_angle,angle)
end

function _draw_boids()
   for _,b in ipairs(boids_pos) do
      pset(b.x,b.y,b.z)
   end
end

function _update_boids()
   for idx,b in ipairs(boids_pos) do
      move_boid(b,boids_speed[idx],boids_angle[idx])
   end
end

function move_boid(b,speed,angle)
   local dx=speed*cos(angle)
   local dy=speed*sin(angle)
   local x,y=b.x+dx,b.y+dy

   if
      y<128 and x<128 and
      y>0 and x>0 
   then
      b.x=x
      b.y=y
   end
end
-->8

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
