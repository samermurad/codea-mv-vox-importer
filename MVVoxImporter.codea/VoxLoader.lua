VoxLoader = class()

VL_IDLE = 'VL_IDLE'
VL_READING_BUFFER = 'VL_READING_BUFFER'
VL_STARTING_CHUNK = 'VL_STARTING_CHUNK'
VL_BUILDING_CHUNK = 'VL_BUILDING_CHUNK'
VL_PROCESSING = 'VL_PROCESSING'
VL_INFLATING = 'VL_INFLATING'
VL_ERROR ='VL_ERROR'
VL_DONE = 'VL_DONE'
function VoxLoader:init(opt)
  --  self.thread =
    self.status = VL_IDLE
end

function VoxLoader:process(opt)
    -- setup process options
    opt = opt or {}
    if not opt.filePath then
        self.error = 'Missing .vox file, must provide opt.filePath'
        -- Mark error and finish coroutine
        coroutine.yield(VL_ERROR, 'Missing .vox file, must provide opt.filePath')
        return
    end
    
    local filePath = opt.filePath
    local spacing = opt.spacing or 1
    local size = opt.size or 1
    local loadFrame = opt.loadFrame or 0
    local useDefaultPalette = opt.useDefaultPalette or false
    -- debug
    local verbose = opt.debug or false
    local function dLog(...)
        if verbose then
            print(...)
        end
    end

    coroutine.yield(VL_READING_BUFFER)
    
    -- load buffer
    local buffer = voxUtil.openFile(filePath)
    if buffer == nil then
        coroutine.yield(VL_ERROR, 'File does not exit for path ' .. opt.filePath)
        return
    end

    -- setup variables
    local store = {
        models = {},
        palette = nil
    }

    if not voxUtil.validateVersion(buffer) then
        coroutine.yield(VL_ERROR, 'Invalid file version: Must be "VOX 150"')
        return
    end
    
    local mainChunkSize, mainChunkError = voxUtil.validateMainChunk(buffer)
    if not mainChunkSize then
        -- failed to get main chunk, mark error, finish coroutine
        coroutine.yield(VL_ERROR, mainChunkError)
        return
    end
    dLog('Main Chunk Size:', mainChunkSize)
    
    while true do
        -- read header
        local chunkName, chunkSize, childSize = voxUtil.readHeaderData(buffer)
        -- mark READING_BUFFER, await next execution
        coroutine.yield(VL_STARTING_CHUNK, {
            chunkName = chunkName,
            chunkSize = chunkSize
        })

        if chunkName == EOF then
            -- END OF FILE
            break
        end
        dLog(
            string.format(
                [[ ChunkName: %s,  Size: %d, ChildSize: %d ]],
                chunkName, chunkSize, childSize
            )
        )

        if childSize ~= 0 then
            coroutine.yield(VL_ERROR, 'broken pipeline, file might be corrupted')
            return 
        end
        -- get routine for chunk
        local routine = voxUtil.getRoutineForChunk(chunkName)
        if routine then
            local isDone,data
            local routineId = coroutine.create(routine)
            while coroutine.status(routineId) == 'suspended' do
                isDone, data = coroutine.resume(routineId, buffer, chunkName, chunkSize)
                coroutine.yield(VL_PROCESSING, chunkName)
            end
            -- storing results
            if chunkName == 'RGBA' then
                store.palette = data
            end

            if chunkName == 'SIZE' then
                -- add model to models array
                table.insert(store.models, { size = data })
            end
            if chunkName == 'XYZI' then
                -- update coordinates on last added model
                local ln = #store.models
                store.models[ln].voxels = data
                print('XYZI', #store.models)
            end
            if chunkName == 'nTRN' then
                local ln = #store.models
                store.models[ln].transform = data
            end
        else
            chunk = buffer:read(chunkSize)
            print('"' ..chunkName .. '" chunk is not implemented, skipping')
        end
        
    end
    
    -- close buffer
    buffer:close()

    return VL_DONE, store
end

function VoxLoader:runThread(data)
    if self.thread then
        local co, vl_status, res = coroutine.resume(self.thread, self, data)
        local status = coroutine.status(self.thread)
        if status == 'suspended' then
         --   print('loop', co, vl_status, data)
        end
        if status == 'dead' then
            print('VoxLoader done, data: ', vl_status, res)
            self.status = vl_status
            if vl_status == VL_ERROR then
                self.error = res
            end
            self.thread = nil
            if self.onDone then
                self.onDone(vl_status, res)
            end
        end
        return vl_status, data
    end
    return VL_IDLE
end
function VoxLoader:tick()
    return self:runThread()
end

function VoxLoader:load(opt, onDone)
    assert(self.thread == nil, 'Trying to queue load before previous is done')
    self.onDone = onDone
    self.thread = coroutine.create(self.process, opt)
    return self:runThread(opt)
end

