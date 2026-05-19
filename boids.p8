pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
	bs={} --boids
	grid={} --fake 2d grid for easy calc
	make_boids(1100)
	f=0
end

function _update60()
	f=f+1
	move_boids()
end

function _draw()
	cls(7)
	draw_boids()
	-- cpu
	print(stat(1),4,4,11)
	print(f)
end


-->8
function make_boids(bc)
	for i=1,bc do
		add(bs,make_boid())
	end
end

function make_boid()
		local lb={
			x=flr(rnd(128)),
			y=flr(rnd(128)),
			z=rnd({1,2,14})
		}
	
		if boid_at(lb) then
		 return make_boid()
		end
	
		grid[grid_key(lb)]=lb
		
		return lb
end

function draw_boids()
	for _,b in ipairs(bs) do
		pset(b.x,b.y,b.z)
	end
end

function move_boids()
	for _,b in ipairs(bs) do
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
