function _draw_segment \
    --argument-names bg fg text prev_bg split_before

    # Optional split from previous segment
    if test "$split_before" = "true"
        if test -n "$prev_bg"
            echo -n (set_color --background normal)
            echo -n (set_color $prev_bg)
            echo -n (set_color $bg)
        end
    end

    # Regular color transition
    if test "$split_before" = "false"
        if test -n "$prev_bg"
            echo -n (set_color --background $prev_bg)(set_color $bg)
        end
    end
    echo -n (set_color normal)


    # Segment body
    echo -n (set_color --background $bg)
    if test "$fg" != normal
        echo -n (set_color $fg)
    end
    echo -n " $text "
    echo -n (set_color normal)
end


function fish_prompt
    set BANNER_LEFT_COLOR C0C0D0
    set BANNER_MIDDLE_COLOR 3e937a
    set BANNER_RIGHT_COLOR 40405B
    # set BANNER_LEADING_BLOCK " "
    set BANNER_LAST_CHARACTER "\$"
    set SPLIT_1 false
    set SPLIT_2 true

    echo

    # Leading rounded block
    echo -n (set_color --background normal)(set_color $BANNER_LEFT_COLOR)$BANNER_LEADING_BLOCK
    echo -n (set_color normal)

    # Left segment (user)
    _draw_segment \
        $BANNER_LEFT_COLOR \
        101020 \
        $USER \
        "" \
        false

    set last_color $BANNER_LEFT_COLOR

    # Virtualenv segment (optional)
    if set -q VIRTUAL_ENV
        _draw_segment \
            $BANNER_MIDDLE_COLOR \
            normal \
            (basename $VIRTUAL_ENV) \
            $last_color \
            $SPLIT_1

        set last_color $BANNER_MIDDLE_COLOR
    end

    # Right segment (cwd)
    _draw_segment \
        $BANNER_RIGHT_COLOR \
        normal \
        "󰉋 "(prompt_pwd)" $BANNER_LAST_CHARACTER" \
        $last_color \
        $SPLIT_2

    # Closing transition
    echo -n (set_color --background normal)
    echo -n (set_color $BANNER_RIGHT_COLOR)" "
    echo -n (set_color normal)
end
