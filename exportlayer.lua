local spr = app.activeSprite

if not spr then
  return app.alert("No active sprite open.")
end

-- Create export folder path
local exportPath = app.fs.filePath(spr.filename) .. "/export/"
app.fs.makeDirectory(exportPath)


local originalVisibility = {}
for _, layer in ipairs(spr.layers) do
  originalVisibility[layer] = layer.isVisible
end

-- Export only originally visible image layers
for _, layer in ipairs(spr.layers) do
  if layer.isImage and originalVisibility[layer] then
    -- Set only this layer visible
    for _, l in ipairs(spr.layers) do
      l.isVisible = false
    end
    layer.isVisible = true

    local filename = exportPath .. layer.name
    app.alert("Exporting: " .. filename)

    app.command.ExportSpriteSheet{
      ui = false,
      type = SpriteSheetType.HORIZONTAL,
      textureFilename = filename .. ".png",
      dataFilename = filename .. ".json",
      dataFormat = SpriteSheetDataFormat.JSON_ARRAY,
      filenameFormat = "{tag}_{frame}.{extension}",
      listLayers = false,
      listTags = false,
      listSlices = false
    }
  end
end
-- -- Loop through layers
-- for _, layer in ipairs(spr.layers) do
--   if layer.isImage and layer.isVisible then
--     -- Set only this layer visible (optional)
--     for _, l in ipairs(spr.layers) do
--       l.isVisible = (l == layer)
--     end

--     -- Build filename
--     local filename = exportPath .. layer.name
--     app.alert(filename)
--     -- Export current sprite with only this layer visible
--     app.command.ExportSpriteSheet{
--       ui = false,
--       type = SpriteSheetType.HORIZONTAL,
--       textureFilename = filename .. '.png',
--       dataFilename = filename .. '.json',
--       dataFormat = SpriteSheetDataFormat.JSON_ARRAY,
--       filenameFormat = "{tag}_{frame}.{extension}",
--       listLayers = false,
--       listTags = false,
--       listSlices = false
--     }
--   end
-- end

-- Restore original visibility
for layer, visibility in pairs(originalVisibility) do
  layer.isVisible = visibility
end

app.alert("Export complete!")