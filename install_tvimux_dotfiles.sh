#!/bin/sh

F="$HOME/dotfiles-tvimux"
echo "installing vim dotfiles from $F"
rm -rf $HOME/.config/nvim
rm -rf $HOME/.config/alacritty
rm  $HOME/.vimrc
rm  $HOME/.vimrc.plug
rm  $HOME/.tmux.conf
rm  $HOME/.tmux.conf.remote

ln -s $F/.config/nvim $HOME/.config/nvim
ln -s $F/.config/alacritty $HOME/.config/alacritty
ln -s $F/.vimrc $HOME/.vimrc
ln -s $F/.vimrc.plug $HOME/.vimrc.plug
ln -s $F/.tmux.conf $HOME/.tmux.conf
ln -s $F/.tmux.conf.remote $HOME/.tmux.conf.remote
