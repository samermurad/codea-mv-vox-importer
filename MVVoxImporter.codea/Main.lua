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
--  local asst = path .. './sndScene.vox'
 -- local asst = path .. './MagicSword.vox'
  -- local asst = path .. './Houses.vox'
-- local asst = path .. './BrawlStars.vox'
 local asst = path .. './Blocks.vox.vox'
  --  local asst = path .. './rot3.vox'
 -- local asst = path .. './chr_fox.vox'
-- local asst = path .. './Pack.vox'
 --local asst = path .. './TRex.vox'
  --  local asst = path .. './maze.vox'
--local asst = path .. './monu6-without-water.vox'
    e = scene:entity()
    viewer = scene.camera:add(OrbitViewer, e.position, 10, 19, 1120)
    camera = scene.camera:get(craft.camera)
    local floor = scene:entity()
   local v =  floor:add(craft.renderer, craft.model.cube(vec3(1, 10, 1)))
    v.material = craft.material(asset.builtin.Materials.Specular)
    v.material.diffuse = color(66, 47, 30, 255)
    floor.position = vec3(0, 0, 0)
  --  v:set('color', color(255, 14, 0))
  --  voxUtil.loadVox(e, asst)
    loader = VoxLoader()
    loader:load({
        filePath = asst,
       -- entity = e,
        debug = true
    }, function(status, data)
        for i, v in ipairs(data.models) do
            local ie = scene:entity()
            ie.parent = e
            if v.transform then
                ie.position = v.transform.position
            end
            local obj = ie:add(craft.volume, v.size.x, v.size.y, v.size.z)
            for j, vox in ipairs(v.voxels) do
                local x, y, z, colIdx = vox:unpack()
                local col = data.palette[colIdx]
                obj:set(x, y, z, 'name', 'solid', 'color', col)
            end
        end
        end
    )
end

-- This function gets called once every frame
function draw()
    loader:tick()
    scene:update(DeltaTime)
    scene:draw()
end

