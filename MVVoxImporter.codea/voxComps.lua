MVTransform = class()

function MVTransform:init(opt)
    self.nodeId = opt.nodeId
    self.nodeAttr = opt.nodeAttr
    self.childNodeId = opt.childNodeId
    self.reversedId = opt.reversedId
    self.layerId = opt.layerId
    self.numFrames = opt.numFrames
    self.frames = opt.frames
end


function MVTransform:__tostring()
    local mt = self
    local attr = #mt.nodeAttr
    return string.format(
[[
nTRN
-----
Node Id: %d
Child Id: %d
Attr Size: %d
Reversed Id: %d
Layer Id: %d
Frames: %d
]], mt.nodeId, mt.childNodeId, attr, mt.reversedId, mt.layerId, mt.numFrames)
end
