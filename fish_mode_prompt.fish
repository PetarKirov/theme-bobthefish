# Display the user-defined prompt prefix and current binding mode... if it's vi
# or vi-like.
#
# To configure the prompt prefix (in combination with the newline prompt):
#     set -g theme_prompt_prefix   '╭─'
#     set -g theme_newline_prompt ' ╰─➤ '
#
# To always show the binding mode (regardless of current bindings):
#     set -g theme_display_vi yes
#
# To never show:
#     set -g theme_display_vi no

function __bobthefish_prompt_user_prefix -S -d 'Display user-defined prefix'
    [ -z "$theme_prompt_prefix" ]
    and return

    __bobthefish_colors $theme_color_scheme
    __bobthefish_start_segment $color_hostname
    echo -ns $theme_prompt_prefix ' '
end

function fish_mode_prompt -d 'bobthefish-optimized fish mode indicator'
    # Note: When Fish builds the prompt it first calls `fish_mode_prompt`, so
    # this is the only place where we can prepend the user prefix.
    __bobthefish_prompt_user_prefix

    [ "$theme_display_vi" != 'no' ]
    or return

    [ "$fish_key_bindings" = 'fish_vi_key_bindings' \
        -o "$fish_key_bindings" = 'hybrid_bindings' \
        -o "$fish_key_bindings" = 'fish_hybrid_key_bindings' \
        -o "$theme_display_vi" = 'yes' ]
    or return

    __bobthefish_colors $theme_color_scheme

    type -q bobthefish_colors
    and bobthefish_colors

    set_color normal # clear out anything bold or underline...

    switch $fish_bind_mode
        case default
            set_color -b $color_vi_mode_default
            echo -n ' N '
        case insert
            set_color -b $color_vi_mode_insert
            echo -n ' I '
        case replace_one replace-one
            set_color -b $color_vi_mode_insert
            echo -n ' R '
        case visual
            set_color -b $color_vi_mode_visual
            echo -n ' V '
    end

    set_color normal
end
