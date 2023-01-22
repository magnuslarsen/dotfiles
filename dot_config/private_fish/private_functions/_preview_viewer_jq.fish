command --query jq || exit

set --local cmd (status basename | path change-extension "")

function $cmd
    jq -C '.' $argv
end
