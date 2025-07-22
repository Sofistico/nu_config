def __change_dir_with_fzf [] {
    {
        name: change_dir_with_fzf
        modifier: CONTROL
        keycode: char_t
        mode: emacs
        event: {
            send: executehostcommand,
            cmd: "cd (fd --type directory --follow --hidden --exclude .git | fzf --preview-window=right,60%,border-left --bind ctrl-u:preview-half-page-up --bind ctrl-d:preview-half-page-down --bind ctrl-e:toggle-preview --layout=reverse --cycle --scroll-off=5 | decode utf-8 | str trim)"
        }
    }
}

def __open_file_in_vim_with_fzf [] {
    {
        name: open_file_in_vim_with_fzf
        modifier: CONTROL
        keycode: char_x
        mode: emacs
        event: {
            send: executehostcommand,
            cmd: "nvim (fzf --preview-window=right,60%,border-left --bind ctrl-u:preview-half-page-up --bind ctrl-d:preview-half-page-down --bind ctrl-e:toggle-preview --layout=reverse --cycle --scroll-off=5)"
        }
    }
}

def __edit_keybinding [] {
    {
        name: edit
        modifier: CONTROL
        keycode: char_s
        mode: [emacs, vi_normal, vi_insert]
        event: [
            { 
                send: executehostcommand,
                cmd: "nvim"
            }
        ]
    }
}

export-env {
    $env.config  = ($env.config
        | upsert keybindings ($env.config.keybindings | append [(__change_dir_with_fzf) (__open_file_in_vim_with_fzf) (__edit_keybinding)])
    )
}
