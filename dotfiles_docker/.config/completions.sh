#!/bin/bash

# Orchestration
eval "$(docker completion bash)"
eval "$(grype completion bash)"
eval "$(trivy completion bash)"

# Tools
eval "$(fzf --bash)"
eval "$(gonzo completion bash)"
eval "$(procs --gen-completion-out bash)"
# eval "$(rg --generate complete-bash)" # TODO: not working
eval "$(yq shell-completion bash)"

# Version Control System (VCS)
source /usr/share/bash-completion/completions/git
