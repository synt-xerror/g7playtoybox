#!/bin/bash

echo "Iniciando instalação do SE-G7PlayToyBox..."
sleep 2
git clone https://github.com/synt-xerror/g7playtoybox.git
sudo mv g7playtoybox/src/g7ptoybox.sh /bin/g7ptoybox
mv g7playtoybox/src/* $HOME/.config/g7ptoybox/
rm -r g7playtoybox

echo "Instalação concluída. Execute no terminal: 'g7ptoybox'"