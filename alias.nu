# List the filenames, sizes, and modification times of items in a directory.
def lss [
    --all (-a),         # Show hidden files
    --long (-l),        # Get all available columns for each entry (slower; columns are platform-dependent)
    --short-names (-s), # Only print the file names, and not the path
    --full-paths (-f),  # display paths as absolute paths
    --du (-d),          # Display the apparent directory size ("disk usage") in place of the directory metadata size
    --directory (-D),   # List the specified directory itself instead of its contents
    --mime-type (-m),   # Show mime-type in type column instead of 'file' (based on filenames only; files' contents are not examined)
    --threads (-t),     # Use multiple threads to list contents. Output will be non-deterministic.
    ...pattern: glob,   # The glob pattern to use.
]: [ nothing -> table ] {
    let pattern = if ($pattern | is-empty) { [ '.' ] } else { $pattern }
    (ls
        --all=$all
        --long=$long
        --short-names=$short_names
        --full-paths=$full_paths
        --du=$du
        --directory=$directory
        --mime-type=$mime_type
        --threads=$threads
        ...$pattern
    ) | sort-by type name -i
}

alias ls-builtin = ls
alias ls = lss

alias la = ls -a
alias fzd = fzf --walker=dir,follow,hidden

alias v = nvim
alias lz = lazygit

def gitacp [message?: string] {
    print '> git add .'
    git add ./

    print $'> git commit -m ($message)'
    git commit -m $message

    print '> git push'
    git push
}

def pss [processName: string] {
    ps | where ($it.name | str downcase) =~ $processName
}

def killeach [processName: string] {
    # workaround for https://github.com/nushell/nushell/issues/13476
    chcp 65001
    pss $processName | select pid | each { |elt| kill -f $elt.pid }
    chcp 850
}

alias pq = pueue
alias pqd = pueued

# git aliases
alias g = git
alias gs = git status
alias gf = git fetch
alias gp = git pull --ff-only
alias gc = git checkout
alias gpu = git push

def vs [pipeName: string] {
  job spawn -t 'nvim-instance' { nvim --listen $'\\.\pipe\($pipeName)' --headless }
}

def vsd [pipeName: string] {
  pq add -i nvim --listen $'\\.\pipe\($pipeName)' --headless
}

def vl [pipeName: string] {
  nvim --server $'\\.\pipe\($pipeName)' --remote-ui
}

def findport [port?: string] {
  if ($port != null) {
    netstat -ano | findstr $':($port)'
  } else {
    netstat -ano
  }
}

def curlj [url: string, json: string, flags?: string] {
  curl $flags -H "Content-Type: application/json" -H "accept: */*" -d $json $url
}

def prunebranches [] {
  git fetch; git branch --merged | rg -v 'master|develop|main|release' | xargs git branch -d
}

def rmshada [] {
  rm -rf ~/AppData/Local/nvim-data/shada
}
