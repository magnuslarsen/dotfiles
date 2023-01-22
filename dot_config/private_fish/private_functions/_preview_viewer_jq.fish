command --query jq || exit

set --local cmd (status basename | path change-extension "")

function $cmd
    jq -Cnf $argv
end
