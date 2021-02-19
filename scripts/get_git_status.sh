#!/usr/bin/env bash

PANE_PATH=$(tmux display-message -p -F "#{pane_current_path}")
cd $PANE_PATH

get_git_status() {
  local branch="$(git rev-parse --abbrev-ref HEAD)"
  local change_st="$(git status --short | perl -nlE 'if(/^ M/){$n+=1}; END{if($n==0){$n=0} say "M:$n"}')"
  local add_file_st="$(git status --short | perl -nlE 'if(/\?\?/){$n+=1} END{if($n==0){$n=0} say "??:$n"}')"
  local stage_st="$(git diff --staged --name-only | perl -nlE 'END{say "S:$."}')"
  local remote_st="$(git rev-list --count --left-right HEAD...@{upstream} 2>&1 | perl -anlE 'if(@F[0]=~/^[0-9]+$/ && @F[1]=~/^[0-9]+$/){say "+@F[0]-@F[1]"}else{say "+0 -0"}')"

  printf "[$branch] [$change_st | $add_file_st | $stage_st] [$remote_st]"
}

main() {
  get_git_status
}

main

