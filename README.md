# MVVoxImporter

Tool for conerting Megical Voxel `.vox` files to codea volume models.
works well with the [Voxel Max App](https://voxelmax.com/) for iOS/iPadOS.

Implementation of buffer reading is based on the `.vox` File format definition, more info can be found in the [voxel-model](https://github.com/ephtracy/voxel-model) repo

> NOTE: Work in progress, initial logic is working



## Basic Usage

```lua

-- Main

function setup()
    scene = craft.scene()
    myEntity = scene:entity()
    
    -- base path to Codea folder
    local basePath = os.getenv("HOME") .. "/Documents/"
    local myVoxFile = path .. './MyVoxel.vox'
    
    -- init loader
    loader = VoxLoader()
    -- define onDone method
    local function onDone(status, result)
        if status == VL_ERROR then 
            print('Error', result)
            return
        end
        
        for i, v in ipairs(data.models) do
            local ie = scene:entity()
            ie.parent = e
            if v.transform then
                ie.position = v.transform.position
            end
            local obj = ie:add(craft.volume, v.size.x, v.size.y,v.size.z)
            for j, vox in ipairs(v.voxels) do
                local x, y, z, colIdx = vox:unpack()
                local col = data.palette[colIdx]
                obj:set(x, y, z, 'name', 'solid', 'color', col)
            end
        end
        
    end
    
    -- kickstart loading
    loader:load({ filePath = myVoxFile }, onDone) 

end


function draw()
    scene:update(DeltaTime)
    scene:draw()
    -- loader.tick must be called on update
    -- to continue the coroutine
    -- probably better to put at the end
    -- to prioritize your logic
    loader:tick()
end

```
