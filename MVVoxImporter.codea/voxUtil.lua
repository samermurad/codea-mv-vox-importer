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



function voxUtil.importSync(opt)
    opt = opt or {}
    local filePath = assert(opt.filePath, 'must provide filePath')
    local spacing = opt.spacing or 1
    local size = opt.size or 1
    local loadFrame = opt.loadFrame or 0
    
    local buffer = voxUtil.openFile(filePath)
    
    
    local voxels = {}
    local palette = {}
    local currentFrame = 0
    -- assert is VOX 150 file
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
    print('M ', M)
    assert (N == 0, 'MAIN chunk should have no content')
    local num_models = 0
    local x, y, z = 0,0,0
    while true do
        chunk = buffer:read(12)
        --print('next chunk ', chunk)
        if chunk == nil then break end -- end of file
        local name, s_self, s_child = struct.unpack('<c4ii', chunk)
        print(name, s_self, s_child)
        assert(s_child == 0, 's_child == 0')
        
        if name == 'PACK' then
            -- number of models
            chunk = buffer:read(4)
            num_models,wot = struct.unpack('<i', chunk)
            print(num_models, wot)
            -- clamp load_frame to total number of frames
            loadFrame = math.min(loadFrame, num_models)
        elseif name == 'SIZE' then
            -- model size
            chunk = buffer:read(12)
            x, y, z = struct.unpack('<iii', chunk)
            print('xyz', x, y, z)
        elseif name == 'XYZI' then
            if currentFrame == loadFrame then
                chunk = buffer:read(4)
                local nVox = struct.unpack('<i', chunk)
                print('voxels count', nVox)
                for voxel = 1, nVox, 1 do
                    chunk = buffer:read(4)
                    print('voxel', vec4(struct.unpack('<BBBB', chunk)))
                    table.insert(
                        voxels, 
                        vec4(struct.unpack('<BBBB', chunk))
                    )
                end
            else
                print('Skipping voxels in frame', currentFrame)
                chunk = buffer:read(s_self)
            end
        elseif name == 'RGBA' then
            -- palette
            for col = 0, 255 do
                chunk = buffer:read(4)
                local r, g, b, a = struct.unpack('<BBBB', chunk)
                print('rgba', r, g, b, a)
                palette[col + 1] = vec4(r,g,b,a)
            end
        elseif name == 'MATT' then
            -- material
            chunk = buffer:read(12)
            local matt_id, mat_type, weight = struct.unpack('<Bif', chunk)
            print( 'MATT', matt_id, mat_type, weight)
            chunk = buffer:read(4)
            local propBits = struct.unpack('<i', chunk)
            --[[
            Need to read property values, but this gets fiddly
            # TODO: finish implementation
            # We have read 16 bytes of this chunk so far, ignoring remainder
            --]]
            buffer.read(s_self - 16)
        else
            chunk = buffer:read(s_self)
            print(name .. ' not implemented, skipping')
        end
        
    end
    
end

function voxUtil.openFile(filePath)
    return assert(io.open(filePath, 'rb'))
end

