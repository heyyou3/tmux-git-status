#!/usr/bin/env bash

PANE_PATH=$(tmux display-message -p -F "#{pane_current_path}")
cd $PANE_PATH

get_git_status() {
  local branch="$(git rev-parse --abbrev-ref HEAD)"
  local change_st="$(git status --short | perl -nlE 'if(/^ M/){$n+=1}; END{if($n==0){$n=0} say "M:$n"}')"
  local add_st="$(git status --short | perl -nlE 'if(/\?\?/){$n+=1} END{if($n==0){$n=0} say "??:$n"}')"
  local remote_st="$(git rev-list --count --left-right HEAD...@{upstream} 2>/dev/null | perl -anlE 'say "+@F[0]-@F[1]"')"

  printf "[$branch] [$change_st $add_st] [$remote_st]"
}

main() {
  get_git_status
}

main

