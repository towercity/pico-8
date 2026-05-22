pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
   _init_boids(150)
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
      -- find neighbors
      --get_closest(b)
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
-- point comps

-- use pivot sort to get closest 5 (i dont understand the algo yet, read online)
function get_closest(b)
   local k=5 --how many closest to find
   local l,r=1,#boids_pos --left and right, for use below

   local function compare(p1,p2) --compare two points
      local d1=(p1.x-b.x)^2+(p1.y-b.y)^2
      local d2=(p2.x-b.x)^2+(p2.y-b.y)^2
      return d1-d2
   end  

   -- the magic algo: partition for pivot sort (i have an arts degree)
   local function partition(bs,l,r)
      local pivot=bs[l]

      while l<r do
         while l<r and compare(bs[r],pivot) >= 0 do
            r=r-1
         end
         bs[l] = bs[r]
         while l<r and compare(bs[l],pivot) <= 0 do
            l=l+1
         end
         bs[r]=bs[l]
      end
      bs[l]=pivot
      return l
   end

   while l<=r do
      local pivotIndex = partition(boids_pos,l,r)
      if pivotIndex == k then break end
      if pivotIndex < k then
         l = pivotIndex + 1
      else
         r = pivotIndex - 1
      end
   end

   local closest = {}
   for i = 1, k do
      closest[i] = boids_pos[i]
   end
   return closest
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
