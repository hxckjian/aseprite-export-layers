local spr = app.activeSprite
if not spr then
  return app.alert("No active sprite.")
end

if spr.filename == "" then
  return app.alert("Please save your sprite before running the script.")
end

local exportPath = app.fs.filePath(spr.filename) .. "/export/"
app.fs.makeDirectory(exportPath)

-- Save original visibility of each layer
local originalVisibility = {}
for _, layer in ipairs(spr.layers) do
--   originalVisibility[layer] = layer.isVisible
    originalVisibility[layer.name] = layer.isVisible
end

for _, layer in ipairs(spr.layers) do
    if layer.isImage and originalVisibility[layer.name] then
        -- Set only this layer visible
        for _, l in ipairs(spr.layers) do
          l.isVisible = false
        end
        layer.isVisible = true
  
      -- Build filename
      local filename = exportPath .. layer.name
      -- Export current sprite with only this layer visible
      app.command.ExportSpriteSheet{
        ui = false,
        type = SpriteSheetType.HORIZONTAL,
        textureFilename = filename .. '.png',
        dataFilename = filename .. '.json',
        dataFormat = SpriteSheetDataFormat.JSON_ARRAY,
        filenameFormat = "{tag}_{frame}.{extension}",
        listLayers = false,
        listTags = false,
        listSlices = false
      }
    end
  end

-- Restore original visibility
for _, layer in ipairs(spr.layers) do
    layer.isVisible = originalVisibility[layer.name]
  end
app.alert("Export finished!")
