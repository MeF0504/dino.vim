" Name:         dino.vim
" Description:  vim plugin like chrome://dino
" Author:       MeF
" GitHub:       https://github.com/MeF0504/dino.vim
" Version:      0.1.0

let s:jump_index_max = 18
let s:jump_index = 0
let s:cacti_space_max = 50
let s:cacti_space = s:cacti_space_max
let s:left_bias  = 10
let s:right_bias = 3

let s:space_keycode = get(g:, 'dino_space_keycode', 32)
let s:q_keycode = get(g:, 'dino_q_keycode', 113)

let s:dino = [0,0,0,0]
let s:dino[0] =<< EOL
       |o||||\
\\    |||||__
 |||||||||
  ||||||||^
   |||||||
    '' ||
EOL

let s:dino[1] =<< EOL
       |o||||\
\\    |||||__
 |||||||||
  ||||||||^
   |||||||
    || ''
EOL

let s:dino[2] =<< EOL
       |o||||\
\\    |||||__
 |||||||||
  ||||||||^
   |||||||
    || ||
EOL

let s:dino[3] =<< EOL
       |*||||\
\\    ||||||/
 |||||||||
  ||||||||^
   |||||||
    || ||
EOL

let s:dino_height = len(s:dino[0])
let s:dino_width  = len(s:dino[0][0])

let s:cactus1 =<< EOL
  |||  
| ||| |
|||||||
  |||  
EOL

let s:cactus2 =<< EOL
  ||  ||  
|_||||||_|
  ||  ||  
EOL

let s:cactus3 =<< EOL
  || ||  ||  
|_|||||||||_|
  || ||  ||  
EOL

function! dino#run_dino()
    let jump_bias = s:jump_index_max/2
    let stage_height = jump_bias+s:dino_height+2

    if &lines <= stage_height+2
        echoerr 'this plugin requires &lines > '.(stage_height+2)
        return
    endif

    let index = 0
    let old_cmdheight = &cmdheight
    let &cmdheight = stage_height
    let is_jumping = 0
    let is_hit = 0

    let sub_score = 0
    let score = 0

    while 1
        let help_str = "q: quit, <space>: jump   score:".score
        let c = getchar(0)

        if c == s:space_keycode
            let is_jumping = 1
            let show_dino = s:dino[2]
        elseif c == s:q_keycode
            let s:jump_index = 0
            let s:cacti_space = s:cacti_space_max
            break
        elseif !is_jumping
            let index = index==1 ? 0 : 1
            let show_dino = s:dino[index]
        endif

        " display image initialization
        let show_field = []
        let lspace = ''
        for i in range(s:left_bias)
            let lspace .= ' '
        endfor
        for i in range(stage_height)
            call add(show_field, lspace)
        endfor

        " calculate jumping height
        let jump_height = 0
        if is_jumping
            let jump_height = jump_bias-abs(s:jump_index-jump_bias)
            if s:jump_index == s:jump_index_max-1
                " jump finish
                let s:jump_index = 0
                let is_jumping = 0
            else
                let s:jump_index += 1
            endif
        endif

        " show dino
        for i in range(stage_height-1)
            let space = ''
            if (stage_height-jump_height-s:dino_height-1<=i) && (i<stage_height-jump_height-1)
                let dindex = i-stage_height+jump_height+s:dino_height+1
                for j in range(s:dino_width-len(show_dino[dindex]))
                    let space .= ' '
                endfor
                let show_field[i] .= show_dino[dindex].space
            else
                for j in range(s:dino_width)
                    let space .= ' '
                endfor
                let show_field[i] .= space
            endif
        endfor

        " show cacti
        let cactus = s:cactus1
        if s:cacti_space >= s:dino_width+s:left_bias
            let space = ''
            for i in range(s:cacti_space-s:dino_width-s:left_bias)
                let space .= ' '
            endfor
            for i in range(len(cactus))
                let findex = stage_height-len(cactus)-1+i
                let show_field[findex] .= space . cactus[i]
            endfor
        else
            for i in range(len(cactus))
                let findex = stage_height-len(cactus)-1+i
                for j in range(len(cactus[i]))
                    let cindex = s:cacti_space+j+1
                    if cindex >= s:dino_width+s:left_bias
                        let show_field[findex] .= cactus[i][j]
                    else
                        if (cactus[i][j]!=' ') && (show_field[findex][cindex]!=' ')
                            let is_hit = 1
                        elseif show_field[findex][cindex] == ' '
                            let new_line = show_field[findex][:cindex-1].cactus[i][j].show_field[findex][cindex+1:]
                            let show_field[findex] = new_line
                        else
                        endif
                    endif
                endfor
            endfor
        endif

        if is_hit == 1
            for i in range(len(show_field))
                if (stage_height-jump_height-s:dino_height-1<=i) && (i<stage_height-jump_height-1)
                    let dindex = i-stage_height+jump_height+s:dino_height+1
                    let show_field[i] = substitute(show_field[i], show_dino[dindex], s:dino[3][dindex], '')
                endif
            endfor
        endif

        let s:cacti_space -= 2
        if s:cacti_space < 0
            let s:cacti_space = s:cacti_space_max
        endif

        if is_hit == 1
            let help_str .= '     press Enter'
        endif
        let show_field[stage_height-1] .= help_str
        for i in range(len(show_field))
            echo show_field[i][:&columns-s:right_bias]
        endfor

        sleep 100ms

        if is_hit == 1
            let s:jump_index = 0
            let s:cacti_space = s:cacti_space_max
            sleep 1
            call getchar()
            break
        endif

        normal! :
        redraw

        let sub_score += 1
        if sub_score >= 10
            let score += 1
            let sub_score = 0
        endif
    endwhile

    normal! :
    let &cmdheight = old_cmdheight
endfunction

