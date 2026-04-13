function textUI(action, text)
    if action == 'show' then
        if IsResourceRunning('ox_lib') then
            exports.ox_lib:showTextUI(text)
        elseif IsResourceRunning('qb-core') then
            exports['qb-core']:DrawText(text, 'left')
        elseif IsResourceRunning('esx_textui') then
            exports['esx_textui']:TextUI(text)
        end
    elseif action == 'hide' then
        if IsResourceRunning('ox_lib') then
            exports.ox_lib:hideTextUI()
        elseif IsResourceRunning('qb-core') then
            exports['qb-core']:HideText()
        elseif IsResourceRunning('esx_textui') then
            exports['esx_textui']:HideUI()
        end
    end
end
