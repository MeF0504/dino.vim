# Dino.vim

vim plugin like chrome://dino

<img src=images/dino.gif width="70%">

## Requirements

- Nothing (Maybe).

## Installation

If you use dein,
```vim
call dein#add('MeF0504/dino.vim')
```
or do something like this.

## Usage

The following command will start dino game.
```vim
Dino
```
In the game,

- \<space>: jump
- q: quit

## Variables

- g:dino_space_keycode
    - key code of space key. You can check it by
    ```vim
    echo getchar()
    ```
    and enter space key.
    - default value: 32
- g:dino_q_keycode
    - key code of "q" key. You can check it by
    ```vim
    echo getchar()
    ```
    and enter q.
    - default value: 113


