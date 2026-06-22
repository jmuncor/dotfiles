# ~/.bash_profile is sourced for login shells (e.g. SSH logins).
# Just source ~/.bashrc so login and non-login shells behave the same.
[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
