local socket = require("socket")
client = socket.connect("pixelflut.uwu.industries", 1234)

function pxf_canv_size()
    client:send("SIZE\n")
    local size = client:receive()
    return size:match("(%d+) (%d+)")
end

function pxf_write_pixel(pixel)
    local function unpack_to_str(color)
        return color.r .. "" .. color.g .. "" .. color.b .. "" .. color.a
    end
    client:send("PX " .. pixel.x .. " " .. pixel.y .. " " .. unpack_to_str(pixel.color) .. "\n")
end

function pxf_write_image(pixels)
    local pretty_pixelcount = tostring(#pixels)
                                :reverse()
                                :gsub("%d%d%d", "%1 ")
                                :reverse()
                                :gsub("^%s+", "")
    print("Drawing " .. pretty_pixelcount .. " pixels")
    for i, pixel in ipairs(pixels) do
        pxf_write_pixel(pixel)
    end
end

local RED    = {r="FF", g="00", b="00", a="FF"}
local GREEN  = {r="00", g="FF", b="00", a="FF"}
local BLUE   = {r="00", g="00", b="FF", a="FF"}
local WHITE  = {r="FF", g="FF", b="FF", a="FF"}
local BLACK  = {r="00", g="00", b="00", a="FF"}
local CLEAR  = {r="00", g="00", b="00", a="00"}

local function main()
    print("Pixelflua -- " .. arg[0])
    local w, h = pxf_canv_size()
    local start = os.clock()
    local pixels = {}
    local function randcolor()
        local colors = {RED, GREEN, BLUE, WHITE, BLACK, CLEAR}
        return colors[math.random(#colors)]
    end
    for x = 1, w do
        for y = 1, h do
            table.insert(pixels, {x = x, y = y, color = randcolor()})
            table.insert(
                pixels, {x = x, y = y, color = 
                            {
                                r = string.format("%02X", (x * y) % 255),
                                g = string.format("%02X", (x * y) % 255),
                                b = string.format("%02X", (x * y) % 255),
                                a = string.format("%02X", (x * y) % 255) 
                            }
                        }
            )
            table.insert(
                pixels, {x = x, y = y, color = 
                            {
                                r = string.format("%02X", (x + y) % 255),
                                g = string.format("%02X", (x + y) % 255),
                                b = string.format("%02X", (x + y) % 255),
                                a = string.format("%02X", (x + y) % 255) 
                            }
                        }
            )
        end
    end
    pxf_write_image(pixels)
    local finish = os.clock()
    print("Finished in " .. finish - start .. " seconds")
end
-- Entry point
main()
