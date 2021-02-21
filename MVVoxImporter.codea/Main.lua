-- MagicalVoxelVoxImporter

-- Use this function to perform your initial setup
function setup() 
    local path = os.getenv("HOME").."/Documents/MVVoxImporter.codea/"
    path = os.getenv("HOME").."/Documents/"
    scene = craft.scene()
    scene.sky.active = true
    scene.sky.material.sky = color(80, 198, 233)
    scene.sky.material.horizon = color(164, 223, 223)
    scene.sky.material.ground = color(163, 97, 44)
   -- local asst = path .. './snd.vox'
 --   local asst = path .. './sndScene.vox'
-- local asst = path .. './MagicSword.vox'
  --  local asst = path .. './Blocks.vox.vox'
    --local asst = path .. './rot.vox'
  --  local asst = path .. './chr_fox.vox'
    local asst = path .. './monu6-without-water.vox'
    local e = scene:entity()
  --  local v = e:add(craft.volume, 10, 10, 10)
    viewer = scene.camera:add(OrbitViewer, e.position, 10, 19, 1120)
    camera = scene.camera:get(craft.camera)
    
 --   v:set(1,1,1, 'name', 'solid', 'color', color(233, 80, 212))
    voxUtil.loadVox(e, asst)
end

-- This function gets called once every frame
function draw()
    scene:update(DeltaTime)
    
    scene:draw()
end

