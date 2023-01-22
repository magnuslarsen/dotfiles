if ! functions --query _preview_viewer_jq && ! functions --query _preview_viewer_bat
    exit
end

function _preview_ext_json
    if functions --query _preview_viewer_jq
        _preview_viewer_jq $argv
    else
        _preview_viewer_bat $argv
    end
end
