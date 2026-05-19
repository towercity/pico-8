pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
   _init_boids(1100)
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
   boids_pos,grid,boids_vel,boids_angle={},{},{},{}   

   for i=1,boids_count do
      make_boid()
   end
end

function make_boid()
   -- make a pos
   local lb={
      x=flr(rnd(128)),
      y=flr(rnd(128)),
      z=rnd({1,2,14})
   }

   -- if we have a boid at this pos, rerun the func from start: this'n cant be
   if boid_at(lb) then return make_boid() end

   -- once we're here, do some more calcs for angle and speed
   local vel,angel=rnd(),rnd()
   
   add(boids_pos,lb)
   add(boids_vel,vel)
   add(boid_angle,angle)
   grid[grid_key(lb)]=lb
end

function _draw_boids()
   for _,b in ipairs(boids_pos) do
      pset(b.x,b.y,b.z)
   end
end

function _update_boids()
   for _,b in ipairs(boids_pos) do
      move_boid(b)
   end
end

function move_boid(b)
   local nb={
      x=b.x,
      y=b.y+1,
      z=b.z
   }

   if nb.y<128 and	not boid_at(nb)
   then
      remove_boid(b)
      b.y=nb.y
      add_boid(nb)
   end
end
-->8
function grid_key(b)
   return b.x..","..b.y..","..b.z
end

function boid_at(b)
   return grid[grid_key(b)]
end

function remove_boid(b)
   grid[grid_key(b)]=nil
end

function add_boid(b)
   grid[grid_key(b)]=b
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
