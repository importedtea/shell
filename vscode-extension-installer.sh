#!/bin/bash

# Add the dependencies you want to install
EXTENSIONS=(aeschli.vscode-css-formatter
alefragnani.numbered-bookmarks
AndrsDC.base16-themes
bajdzis.vscode-database
batisteo.vscode-django
bibhasdn.django-html
bibhasdn.django-snippets
bmewburn.vscode-intelephense-client
chenxsan.vscode-standardjs
christian-kohler.path-intellisense
CoenraadS.bracket-pair-colorizer
dbaeumer.vscode-eslint
donjayamanne.githistory
donjayamanne.jupyter
donjayamanne.python-extension-pack
eg2.tslint
emallin.phpunit
felixfbecker.php-debug
felixfbecker.php-pack
formulahendry.auto-close-tag
formulahendry.auto-rename-tag
formulahendry.code-runner
humao.rest-client
jrebocho.vscode-random
junstyle.php-cs-fixer
magicstack.MagicPython
mechatroner.rainbow-csv
ms-python.python
ms-vscode.cpptools
ms-vscode.csharp
ms-vscode.Theme-MaterialKit
msjsdiag.debugger-for-chrome
neilbrayfield.php-docblocker
patbenatar.advanced-new-file
PeterJausovec.vscode-docker
PKief.material-icon-theme
redhat.java
robertohuertasm.vscode-icons
Shan.code-settings-sync
sleistner.vscode-fileutils
VisualStudioExptTeam.vscodeintellicode
vscjava.vscode-java-debug
vscjava.vscode-java-pack
vscjava.vscode-java-test
vscjava.vscode-maven
whatwedo.twig
wholroyd.jinja
Zignd.html-css-class-completion)

# Loop through all extensions and install
for extension in "${EXTENSIONS[@]}"; do
    code --install-extension $extension
    echo "Successfully installed $extension"
done