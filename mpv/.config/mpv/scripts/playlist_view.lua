mp.add_key_binding("F8", "show-playlist", function()
    local playlist = mp.get_property_native("playlist")
    local count = #playlist
    local current = 0
    
    -- Find current song index
    for i, item in ipairs(playlist) do
        if item.current then
            current = i - 1 -- 0-based index
            break
        end
    end

    -- Define the "Window" (What allows it to fit on screen)
    local context_before = 5
    local context_after = 15
    
    local start_idx = math.max(0, current - context_before)
    local end_idx = math.min(count - 1, current + context_after)

    local text = "Playlist (" .. (current + 1) .. "/" .. count .. "):\n"
    
    -- Add "..." if we are hiding start of list
    if start_idx > 0 then
        text = text .. "...\n"
    end

    -- Loop only through the "Window"
    for i = start_idx, end_idx do
        local item = playlist[i + 1] -- Lua is 1-based
        local prefix = (i == current) and "-> " or "   "
        
        -- Use Title if available, otherwise filename
        local title = item.title or item.filename
        
        -- Truncate super long titles so they don't wrap
        if string.len(title) > 60 then
            title = string.sub(title, 1, 57) .. "..."
        end
        
        text = text .. prefix .. "[" .. i .. "] " .. title .. "\n"
    end

    -- Add "..." if we are hiding end of list
    if end_idx < count - 1 then
        text = text .. "...\n"
    end
    
    -- Display for 5 seconds
    mp.osd_message(text, 5)
end)
