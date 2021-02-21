-- MagicalVoxelVoxImporter

-- Use this function to perform your initial setup
function setup() 
    --dir = os.getenv("PWD") or os.execute("pwd"):read()
    local path = os.getenv("HOME").."/Documents/MagicalVoxelVoxImporter.codea/"
    print(path)
    scene = craft.scene()
    scene.sky.active = true
    scene.sky.material.sky = color(80, 198, 233)
    scene.sky.material.horizon = color(164, 223, 223)
    scene.sky.material.ground = color(163, 97, 44)
    local asst = path .. './snd.vox'
    voxUtil.importSync{
        filePath = asst
    }
    
    local e = scene:entity()
    local v = e:add(craft.volume, 10, 10, 10)
    viewer = scene.camera:add(OrbitViewer, e.position, 10, 19, 1120)
    camera = scene.camera:get(craft.camera)
    v:set(1,1,1, 'name', 'solid', 'color', color(233, 80, 212))
    
   -- file = assert(io.open(path .. './snd.vox', 'rb'))
--    local str = file:read(8)
 --   print(string.char(str:byte(1)))
end

-- This function gets called once every frame
function draw()
    scene:update(DeltaTime)
    
    scene:draw()
end

