voxUtil = {}

-- Default palette, given in .vox 150 specification format
DEFAULT_PALETTE = {0x00000000, 0xffffffff, 0xffccffff, 0xff99ffff, 0xff66ffff, 0xff33ffff, 0xff00ffff, 0xffffccff,
0xffccccff, 0xff99ccff, 0xff66ccff, 0xff33ccff, 0xff00ccff, 0xffff99ff, 0xffcc99ff, 0xff9999ff,
0xff6699ff, 0xff3399ff, 0xff0099ff, 0xffff66ff, 0xffcc66ff, 0xff9966ff, 0xff6666ff, 0xff3366ff,
0xff0066ff, 0xffff33ff, 0xffcc33ff, 0xff9933ff, 0xff6633ff, 0xff3333ff, 0xff0033ff, 0xffff00ff,
0xffcc00ff, 0xff9900ff, 0xff6600ff, 0xff3300ff, 0xff0000ff, 0xffffffcc, 0xffccffcc, 0xff99ffcc,
0xff66ffcc, 0xff33ffcc, 0xff00ffcc, 0xffffcccc, 0xffcccccc, 0xff99cccc, 0xff66cccc, 0xff33cccc,
0xff00cccc, 0xffff99cc, 0xffcc99cc, 0xff9999cc, 0xff6699cc, 0xff3399cc, 0xff0099cc, 0xffff66cc,
0xffcc66cc, 0xff9966cc, 0xff6666cc, 0xff3366cc, 0xff0066cc, 0xffff33cc, 0xffcc33cc, 0xff9933cc,
0xff6633cc, 0xff3333cc, 0xff0033cc, 0xffff00cc, 0xffcc00cc, 0xff9900cc, 0xff6600cc, 0xff3300cc,
0xff0000cc, 0xffffff99, 0xffccff99, 0xff99ff99, 0xff66ff99, 0xff33ff99, 0xff00ff99, 0xffffcc99,
0xffcccc99, 0xff99cc99, 0xff66cc99, 0xff33cc99, 0xff00cc99, 0xffff9999, 0xffcc9999, 0xff999999,
0xff669999, 0xff339999, 0xff009999, 0xffff6699, 0xffcc6699, 0xff996699, 0xff666699, 0xff336699,
0xff006699, 0xffff3399, 0xffcc3399, 0xff993399, 0xff663399, 0xff333399, 0xff003399, 0xffff0099,
0xffcc0099, 0xff990099, 0xff660099, 0xff330099, 0xff000099, 0xffffff66, 0xffccff66, 0xff99ff66,
0xff66ff66, 0xff33ff66, 0xff00ff66, 0xffffcc66, 0xffcccc66, 0xff99cc66, 0xff66cc66, 0xff33cc66,
0xff00cc66, 0xffff9966, 0xffcc9966, 0xff999966, 0xff669966, 0xff339966, 0xff009966, 0xffff6666,
0xffcc6666, 0xff996666, 0xff666666, 0xff336666, 0xff006666, 0xffff3366, 0xffcc3366, 0xff993366,
0xff663366, 0xff333366, 0xff003366, 0xffff0066, 0xffcc0066, 0xff990066, 0xff660066, 0xff330066,
0xff000066, 0xffffff33, 0xffccff33, 0xff99ff33, 0xff66ff33, 0xff33ff33, 0xff00ff33, 0xffffcc33,
0xffcccc33, 0xff99cc33, 0xff66cc33, 0xff33cc33, 0xff00cc33, 0xffff9933, 0xffcc9933, 0xff999933,
0xff669933, 0xff339933, 0xff009933, 0xffff6633, 0xffcc6633, 0xff996633, 0xff666633, 0xff336633,
0xff006633, 0xffff3333, 0xffcc3333, 0xff993333, 0xff663333, 0xff333333, 0xff003333, 0xffff0033,
0xffcc0033, 0xff990033, 0xff660033, 0xff330033, 0xff000033, 0xffffff00, 0xffccff00, 0xff99ff00,
0xff66ff00, 0xff33ff00, 0xff00ff00, 0xffffcc00, 0xffcccc00, 0xff99cc00, 0xff66cc00, 0xff33cc00,
0xff00cc00, 0xffff9900, 0xffcc9900, 0xff999900, 0xff669900, 0xff339900, 0xff009900, 0xffff6600,
0xffcc6600, 0xff996600, 0xff666600, 0xff336600, 0xff006600, 0xffff3300, 0xffcc3300, 0xff993300,
0xff663300, 0xff333300, 0xff003300, 0xffff0000, 0xffcc0000, 0xff990000, 0xff660000, 0xff330000,
0xff0000ee, 0xff0000dd, 0xff0000bb, 0xff0000aa, 0xff000088, 0xff000077, 0xff000055, 0xff000044,
0xff000022, 0xff000011, 0xff00ee00, 0xff00dd00, 0xff00bb00, 0xff00aa00, 0xff008800, 0xff007700,
0xff005500, 0xff004400, 0xff002200, 0xff001100, 0xffee0000, 0xffdd0000, 0xffbb0000, 0xffaa0000,
0xff880000, 0xff770000, 0xff550000, 0xff440000, 0xff220000, 0xff110000, 0xffeeeeee, 0xffdddddd,
0xffbbbbbb, 0xffaaaaaa, 0xff888888, 0xff777777, 0xff555555, 0xff444444, 0xff222222, 0xff111111}

function voxUtil.openFile(filePath)
    return assert(io.open(filePath, 'rb'))
end

function voxUtil.readString(buffer, chunkSize)
    local chunk = buffer:read(4)
    local strLn = struct.unpack('<i', chunk)
    local readB = 4
    local str = ''
    chunk = buffer:read(strLn)
    readB = readB + strLn
    str = struct.unpack('<c' .. strLn, chunk)
    print('string: ', str, ', read: ', readB)
    return str, readB
end

function voxUtil.readDictKeyCount(buffer)
    local chunk = buffer:read(4)
    local keyCount = struct.unpack('<i', chunk)
    print( 'DICT count: ', keyCount)
    return keyCount, 4
end
function voxUtil.readDict(buffer, chunkSize)
    local cSize = chunkSize
    local dictKeyCount, readBytes = voxUtil.readDictKeyCount(buffer)
    cSize = cSize - readBytes
    local dict = {}
    if dictKeyCount == 0 then
        print('empty dict')
        return dict, readBytes
    else
        for i = 1, dictKeyCount, 1 do
            local key, readK = voxUtil.readString(buffer, cSize)
            cSize = cSize - readK
            local val, readV = voxUtil.readString(buffer, cSize)
            cSize = cSize - readV
            dict[key] = val
            print('DICT - key: ', key, ' value: ', val)
        end
    end
    print(' DICT: read ', chunkSize - cSize, 'bytes')
    return dict, chunkSize - cSize
end

function voxUtil.readSize(buffer)
    local chunk = buffer:read(12)
    x, z, y = struct.unpack('<iii', chunk)
    return x, y, z
end
function voxUtil.readRGBA(buffer)
    local palette = {}
    for col = 0, 255 do
        local chunk = buffer:read(4)
        local r, g, b, a = struct.unpack('<BBBB', chunk)
        palette[col + 1] = color(r,g,b,a)
    end
    return palette
end
function voxUtil.loadDefaultPalette()
    local palette = {}
    for col = 0, 255 do
        local chunk = struct.pack('<I', DEFAULT_PALETTE[col + 1])
        local r, g, b, a = struct.unpack('<BBBB', chunk)
        palette[col + 1] = color(r,g,b,a)
    end
    return palette
    --  struct.unpack('<4B', struct.pack('<I', DEFAULT_PALETTE[col]
end

function voxUtil.readCoords(buffer)
    local chunk = buffer:read(4)
    local nVox = struct.unpack('<i', chunk)
    local voxels = {}
    for voxel = 1, nVox, 1 do
        chunk = buffer:read(4)
        local x, z, y, colIdx = struct.unpack('<BBBB', chunk)
        local voxel = {
        coords = vec3(x,y,z),
        colIdx = colIdx
        }
        table.insert(
        voxels,
        voxel
        )
    end
    return voxels
end

function voxUtil.readTransform(buffer, chunkSize)
    local chunk = buffer:read(4)
    local cSize = chunkSize - 4
    assert(type(cSize) == 'number')
    local nodeId = struct.unpack('<i', chunk)
    local attr, readAttr = voxUtil.readDict(buffer, cSize)
    cSize = cSize - readAttr
    chunk = buffer:read(16)
    cSize = cSize - 16
    
    local childId, rId, layerId, nFrames = struct.unpack('<iiii', chunk)
    
    -- discard frames dict
    local frames, readFrames = voxUtil.readDict(buffer, cSize)
    cSize = cSize - readFrames
    print('discard frames dict ', cSize)
    buffer:read(cSize)
 --   id, nodeId, rId, layerId, nFrames
    return MVTransform{
        nodeId = nodeId,
        nodeAttr = attr,
        childNodeId = childId,
        reversedId = rId,
        layerId = layerId,
        numFrames = nFrames,
        frames = frames
    }

end

function voxUtil.readNodeGroup(buffer, chunkSize)
    print('skipping group', chunkSize)
    return buffer:read(chunkSize)
    --[[
    local chunk = buffer:read(4)
    local cSize = chunkSize - 4
    local nodeId = struct.unpack('<i', chunk)
    local dictKeyCount = voxUtil.readDictKeyCount(buffer)
    cSize = cSize - 4 
    if dictKeyCount == 0 then
        buffer:read(4)
    else
        for i = 1, dictKeyCount, 1 do
            local key, readK = voxUtil.readString(buffer, chunkSize)
            local val, readV = voxUtil.readString(buffer, chunkSize)
            print('GRP: key ', key, 'value', value)
        end
    end
    local nChild = struct.unpack('<i',buffer:read(4))
    cSize = cSize - 4 
    -- discard children nodes
    buffer:read(cSize)
    return nodeId, dict , nChild
    ]]--
end
function voxUtil.readMaterial(buffer, chunkSize)
    -- Method not fully implemented
    -- doesnt produce anything useful yet
    local chunk = buffer:read(12)
    local matt_id, mat_type, weight = struct.unpack('<Bif', chunk)
    chunk = buffer:read(4)
    local propBits = struct.unpack('<i', chunk)
    --[[
    Need to read property values, but this gets fiddly
    # TODO: finish implementation
    # We have read 16 bytes of this chunk so far, ignoring remainder
    --]]
    buffer.read(chunkSize - 16)
    return matt_id, mat_type, weight, propBits
    
end

function voxUtil.processVoxFile(opt)
    -- props
    opt = opt or {}
    local filePath = assert(opt.filePath, 'must provide filePath')
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
    ---
    local buffer = voxUtil.openFile(filePath)
    
    local volumes = {}
    local voxels = nil
    local palette = nil
    local transforms = {}
    local currentFrame = 0
    local x, y, z = 0,0,0
    local nModels = 0
    -- assert is VOX 150 fil()e
    local chunk = buffer:read(8)
    local VOX_,version = struct.unpack('<c4i', chunk)
    assert(
    VOX_ == 'VOX ' and version == 150,
    'Invalid Version'
    )
    
    -- MAIN chunk
    chunk = buffer:read(4)
    assert(struct.unpack('<c4',chunk) == 'MAIN')
    chunk = buffer:read(8)
    local N, M = struct.unpack('<ii', chunk)
    dLog('Content Size ', M)
    assert (N == 0, 'MAIN chunk should have no content')
    
    
    while true do
        -- read header
        chunk = buffer:read(12)
        if chunk == nil then break end -- end of file
        
        local chunkName, chunkSize, childSize = struct.unpack('<c4ii', chunk)
        dLog(
        string.format(
        [[ chunkName: %s,  size: %d, childSize: %d]],
        chunkName, chunkSize, childSize
        )
        )
        assert(childSize == 0, 'broken pipe') -- sanity check
        
        if chunkName == 'PACK' then
            -- number of models
            chunk = buffer:read(4)
            nModels = struct.unpack('<i', chunk)
            print('nModels',nModels, wot)
            -- clamp load_frame to total number of frames
            loadFrame = math.min(loadFrame, nModels)
            
        elseif chunkName == 'SIZE' then
            -- model size
            -- add new volume 
            
            x, y, z = voxUtil.readSize(buffer)
            local vol = {
                size = {
                    x = x,
                    y = y,
                    z = z
                }
            }
            table.insert(volumes, vol)
            dLog('x: ', x, 'y: ', y, 'z: ', z)
            
        elseif chunkName == 'XYZI' then
            -- coords
            if currentFrame == loadFrame then
                voxels = voxUtil.readCoords(buffer)
                dLog('found and loaded ', #voxels, ' Voxels')
                volumes[#volumes].voxels = voxels
            else
                print('Skipping voxels in frame', currentFrame)
                chunk = buffer:read(chunkSize)
            end
            
        elseif chunkName == 'RGBA' then
            -- palette
            dLog('found custom palette, loading it')
            palette = voxUtil.readRGBA(buffer)
        elseif chunkName == 'MATT' then
            -- material
            local matId, mType, mWeight, propBits = voxUtil.readMaterial(buffer, chunkSize)
            dLog(
            string.format(
            [[
            Material, Id: %d, type: %d, weight: %d, prop: %d
            ]],
            matId, mType,mWeight,propBits
            )
            )
     elseif chunkName == 'nTRN' then
         dLog(voxUtil.readTransform(buffer, chunkSize))
        elseif chunkName == 'nGRP' then
        dLog('Group: ', voxUtil.readNodeGroup(buffer, chunkSize))
        else
            chunk = buffer:read(chunkSize)
            print(chunkName .. ' not implemented, skipping')
        end
        dLog('======')
    end
    
    if not useDefaultPalette then
        assert(palette ~= nil, 'no palette provided with file, set useDefaultPalette to true to use defalut palette')
    else
        palette = voxUtil.loadDefaultPalette()
    end
    
    assert(#volumes > 0, 'failed to load voxels')
    return {
    size = vec3(x, y, z),
    volumes = volumes,
    palette = palette,
    nModels = nModels
    }
end


function voxUtil.loadVox(entity, filePath)
    local res = voxUtil.processVoxFile{
        filePath = filePath,
        debug = true
    }
    
   -- volume:resize(res.size.x, res.size.y, res.size.z)
    local e = scene:entity()
    e.parent = entity
    for i, vol in ipairs(res.volumes) do
        local vSize = vol.size
        print(vSize.x, vSize.y, vSize.z)
        local ie = scene:entity()
        ie.parent = e
        local obj = ie:add(craft.volume, vSize.x, vSize.y, vSize.z)
        for j, v in ipairs(vol.voxels) do
            local x, y, z = v.coords:unpack()
            local col = res.palette[v.colIdx]
            obj:set(x, y, z, 'name', 'solid', 'color', col)
        end
    end
end
