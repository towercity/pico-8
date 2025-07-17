-- how many ticks to switch sprite on, assumes
-- the tick is held in the parent file in 't',
-- which the parent file also tracks
dance_offset=10

function dance_sprite(sprites, x, y, w, h)
   local w, h, sprite = w or 1, h or 1, sprites[
      (t \ dance_offset)
      % #sprites
      + 1
   ]

   spr(sprite, x, y, w, h)
end
