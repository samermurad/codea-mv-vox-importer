voxUtil = {}

-- End of file signal
EOF = 'EOF'
-- Default palette, given in .vox 150 specification format
DEFAULT_PALETTE = {
0x00000000, 0xffffffff, 0xffccffff, 0xff99ffff, 0xff66ffff, 0xff33ffff, 0xff00ffff, 0xffffccff,
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
    return io.open(filePath, 'rb')
end

function voxUtil.readInt32(buffer)
    local chunk = buffer:read(4)
    local num = struct.unpack('<i', chunk)
    return num, 4
end

function voxUtil.readString(buffer, chunkSize)
    local strLn, readB = voxUtil.readInt32(buffer)
    local str = ''
    local chunk = buffer:read(strLn)
    readB = readB + strLn
    str = struct.unpack('<c' .. strLn, chunk)
    print('string: ', str, ', read: ', strLn, 'length:', string.len(str))
    return str, readB
end

local function split(s, delimiter)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end
--[[
=================================
(c) ROTATION type

store a row-major rotation in the bits of a byte

for example :
R =
0  1  0
0  0 -1
-1  0  0
==>
unsigned char _r = (1 << 0) | (2 << 2) | (0 << 4) | (1 << 5) | (1 << 6)

bit | value
0-1 : 1 : index of the non-zero entry in the first row
2-3 : 2 : index of the non-zero entry in the second row
4   : 0 : the sign in the first row (0 : positive; 1 : negative)
5   : 1 : the sign in the second row (0 : positive; 1 : negative)
6   : 1 : the sign in the third row (0 : positive; 1 : negative)
]]
-- return x & 1 << n != 0
function voxUtil.readRot(buffer, chunkSize)
    local str, readB = voxUtil.readString(buffer, chunkSize)
    local rot = tonumber(str)
    print('rot bits: ', rot)
    
    local b01 = (rot & 1 << 0) | (rot & 1 << 1)
    local b23 = (rot & 1 << 2) | (rot & 1 << 3) >> 3
    local b4 = (rot & 1 << 4) >> 4
    local b5 = (rot & 1 << 5) >> 5
    local b6 = (rot & 1 << 6) >> 6
    
    local a11, a12, a13
    local a21, a22, a23
    local a31, a32, a33
    
    a11 = (b01 == 0 and 1 or 0) * (b01 == 0 and b4 == 1 and -1 or 1)
    a12 = (b01 == 1 and 1 or 0) * (b01 == 1 and b4 == 1 and -1 or 1)
    a13 = (b01 == 2 and 1 or 0) * (b01 == 2 and b4 == 1 and -1 or 1)
    
    a21 = (b23 == 0 and 1 or 0) * (b23 == 0 and b5 == 1 and -1 or 1)
    a22 = (b23 == 1 and 1 or 0) * (b23 == 1 and b5 == 1 and -1 or 1)
    a23 = (b23 == 2 and 1 or 0) * (b23 == 2 and b5 == 1 and -1 or 1)
    
    a31 = (a11 == 0 and a21 == 0 and 1 or 0) * (a11 == 0 and a21 == 0 and b6 == 1 and -1 or 1)
    a32 = (a12 == 0 and a22 == 0 and 1 or 0) * (a12 == 0 and a22 == 0 and b6 == 1 and -1 or 1)
    a33 = (a13 == 0 and a23 == 0 and 1 or 0) * (a13 == 0 and a23 == 0 and b6 == 1 and -1 or 1)
    
    local R = matrix(
        a11, a12, a13, 0,
        a21, a22, a23, 0,
        a31, a32, a33, 0,
        0,   0,   0,   1
    )
    local x, y, z
    
    if a13 < 1 then
        if a13 > -1 then
            x = math.atan2(-a23, a33)
            y = math.asin(a13)
            z = math.atan2(-a12, a11)
        else
            x = -math.atan2(a21, a22)
            y = -math.pi/2
            z = 0
        end
    else
        x = math.atan2(a21, a22)
        y = math.pi / 2
        z = 0
    end

    x = x * mathX.rad2deg
    y = y * mathX.rad2deg
    z = z * mathX.rad2deg
    print(R)
    print('euler: ', x, y, z)
    return vec3(x, y, z), readB
end
function voxUtil.readVec3(buffer, chunkSize)
    local str, readB = voxUtil.readString(buffer, chunkSize)
    local x, y, z
    str:gsub('-?%d+',
    function(num)
        if x == nil then
            x = tonumber(num)
        elseif z == nil then
            z = tonumber(num)
        elseif y == nil then
            y = tonumber(num)
        else
            assert(false, 'Fatal: voxUtil.readVec3 expects int3x3 separated by space')
        end
    end
    )
    local vector = vec3(x,y,z)
    print('vec3: ', vector)
    return vector, readB
end

-- read upcoming dict key count, consumes 4 bytes of buffer
function voxUtil.readDictKeyCount(buffer)
    local keyCount, readB = voxUtil.readInt32(buffer)
    print( 'DICT count: ', keyCount)
    return keyCount, readB
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
            local val, readV = nil, nil
            
            if key == '_t' then
                -- read value as vec3
                val, readV = voxUtil.readVec3(buffer, cSize)
            elseif key == '_r' then
                -- read value as row-major rotation bit
                val, readV = voxUtil.readRot(buffer, cSize)
            else
                -- default string read
                val, readV = voxUtil.readString(buffer, cSize)
            end
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

function voxUtil.createRGBAIteratorReader(buffer)
    local col = 0
    local num = 256
    return function()
        col = col + 1
        if col <= num then
            local chunk = buffer:read(4)
            local r, g, b, a = struct.unpack('<BBBB', chunk)
            return col, color(r,g,b,a)
        end
    end
end
function voxUtil.loadDefaultPalette()
    local palette = {}
    for col = 0, 255 do
        -- pack hexa as unsigned int
        local chunk = struct.pack('<I', DEFAULT_PALETTE[col + 1])
        -- read as 4 unsigned chars, converts hexa to rgba
        local r, g, b, a = struct.unpack('<BBBB', chunk)
        palette[col + 1] = color(r,g,b,a)
    end
    return palette
end

function voxUtil.readCoords(buffer)
    local nVox = voxUtil.readInt32(buffer)
    local voxels = {}
    local chunk
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

function voxUtil.createCoordsIteratorReader(buffer)
    local nVox = voxUtil.readInt32(buffer)
    local i = 0
    local chunk
    return function()
        i = i + 1
        if i <= nVox then
            chunk = buffer:read(4)
            local x, z, y, colIdx = struct.unpack('<BBBB', chunk)
            return i, vec4(x, y, z , colIdx)
        end
    end
end

function voxUtil.readTransform(buffer, chunkSize)
    local nodeId, readB = voxUtil.readInt32(buffer)
    local cSize = chunkSize - readB

    local attr, readAttr = voxUtil.readDict(buffer, cSize)
    cSize = cSize - readAttr
    -- read transform properties
    local childId = voxUtil.readInt32(buffer)
    local rId = voxUtil.readInt32(buffer)
    local layerId = voxUtil.readInt32(buffer)
    local nFrames = voxUtil.readInt32(buffer)

    cSize = cSize - 16
    local frames, readFrames = voxUtil.readDict(buffer, cSize)
    print('frames: ', nFrames, dump(frames))
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
    local groupId, readB = voxUtil.readInt32(buffer)
    print('groupId', groupId)
    local attr, readD = voxUtil.readDict(buffer, chunkSize - readB)
    local numOfChildren, readS = voxUtil.readInt32(buffer)
    print('attr', #attr)
    print('numOfChildren', numOfChildren)
    print('skipping ', chunkSize - readB - readD - readS, 'bytes')
    buffer:read(chunkSize - readB - readD - readS)
    return groupId, attr, numOfChildren
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
    buffer:read(chunkSize - 16)
    return matt_id, mat_type, weight, propBits
    
end

function voxUtil.validateVersion(buffer)
    local chunk = buffer:read(8)
    local VOX_,version = struct.unpack('<c4i', chunk)
    return VOX_ == 'VOX ' and version == 150
end

function voxUtil.assertMainChunk(buffer)
    -- MAIN chunk
    local chunk = buffer:read(4)
    assert(struct.unpack('<c4',chunk) == 'MAIN')
    chunk = buffer:read(8)
    local N, M = struct.unpack('<ii', chunk)
    assert (N == 0, 'MAIN chunk should have no content')
    return M
end

-- Validate .vox file MAIN Chunk.
-- attempts to return the content size of the main chuck
-- if succeeds, returns one M, of the content size
-- if failed, returns a false and an error message
function voxUtil.validateMainChunk(buffer)
    local chunk = buffer:read(4)
    if not (struct.unpack('<c4',chunk) == 'MAIN') then
        return false, 'Missing main chunk'
    end
    chunk = buffer:read(8)
    local N, M = struct.unpack('<ii', chunk)
    if N ~= 0 then
        return false, 'MAIN chunk should have no content'
    end
    return tonumber(M)
end


function voxUtil.readHeaderData(buffer)
    chunk = buffer:read(12)
    if chunk == nil then
        -- end of file
        return EOF
    end
    local chunkName, chunkSize, childSize = struct.unpack('<c4ii', chunk)
    return chunkName, chunkSize, childSize
end

function voxUtil.getRoutineForChunk(name)
    -- SIZE Chunk
    if name == 'SIZE' then
        return function(buffer, chunkName, chunkSize)
            local x, y, z = voxUtil.readSize(buffer)
            return vec3(x, y, z)
        end
    end
    -- Coords Chunk
    if name == 'XYZI' then
        return function(buffer, chunkName, chunkSize)
            --ocal iter = 
            local list = {}
            for k, v in voxUtil.createCoordsIteratorReader(buffer) do
                if k % 120 == 0 then
                    -- take a break
                    coroutine.yield()
                end
                list[k] = v
            end
            return list
        end
    end
    
    -- Color Palette Chunk
    if name == 'RGBA' then
        return function(buffer)
            local palette = {}
            for k, col in voxUtil.createRGBAIteratorReader(buffer) do
                if k % 120 == 0 then
                    -- take a break
                    coroutine.yield()
                end
                palette[k] = col
            end
            return palette
        end
    end
    -- group node
    if name == 'nGRP' then
        return function(buffer, chunkName, chunkSize)
            coroutine.yield()
            return voxUtil.readNodeGroup(buffer, chunkSize)
        end
    end
    -- Object Transform
    if name == 'nTRN' then
        return function(buffer, chunkName, chunkSize)
            coroutine.yield()
            return voxUtil.readTransform(buffer, chunkSize)
        end
    end
    return nil
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
    local chunk = nil
    -- assert is VOX 150 file
    assert(
    voxUtil.validateVersion(buffer),
    'Invalid Version'
    )
    local contentSize = voxUtil.assertMainChunk(buffer)
    dLog('Content Size ', contentSize )
    
    
    
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
    
    if palette == nil or useDefaultPalette then
        if palette == nil then
            print('~r~WARN: no palette provided with file, using default, set useDefaultPalette to dismiss')
        end
        palette = voxUtil.loadDefaultPalette()
    end
    
    assert(#volumes > 0, 'failed to load voxels')
    buffer:close()
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
