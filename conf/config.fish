# Aliases
alias vim="nvim"

# Path
fish_add_path $HOME/.scripts-bin
fish_add_path /opt/homebrew/bin
fish_add_path $HOME/.cargo/bin

# Fish git prompt
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate ''
set __fish_git_prompt_showupstream 'none'
set -g fish_prompt_pwd_dir_length 3

function fish_prompt
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.

    set_color brblack
    echo -n "["(date "+%H:%M")"] "

    if [ $PWD != $HOME ]
        set_color yellow
        echo -n (prompt_pwd)
    end

    set_color green
    printf '%s ' (__fish_git_prompt)

    # Pipestatus (from default prompt: share/functions/fish_prompt.fish)
    set -l fish_color_status red
    set -l bold_flag --bold
    set -q __fish_prompt_status_generation; or set -g __fish_prompt_status_generation $status_generation
    if test $__fish_prompt_status_generation = $status_generation
        set bold_flag
    end
    set __fish_prompt_status_generation $status_generation
    set -l status_color (set_color $fish_color_status)
    set -l statusb_color (set_color $bold_flag $fish_color_status)
    set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)
    echo -n $prompt_status

    # Suffix
    set_color red
    echo -n '> '
    set_color normal
end
