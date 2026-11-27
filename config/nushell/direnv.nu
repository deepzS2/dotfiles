$env.config.hooks.env_change.PWD = (
    $env.config.hooks.env_change.PWD? | default []
)

$env.config.hooks.env_change.PWD ++= [{||
    if (which direnv | is-not-empty) {
        direnv export json
        | from json
        | default {}
        | load-env
    }
}]
