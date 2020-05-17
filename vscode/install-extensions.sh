#!/bin/bash

declare -a extensions=(
    "bierner.markdown-preview-github-styles"
    "cduruk.thrift"
    "JakeBecker.elixir-ls"
    "kleber-swf.ocean-dark-extended"
    "ms-python.python"
    "pgourlain.erlang"
    "eamodio.gitlens"
)

if [ -z "$(command -v code)" ]; then
    echo "'code' is not installed"
    exit 1
fi

for extension in "${extensions[@]}"; do
    code --install-extension "$extension"
done
