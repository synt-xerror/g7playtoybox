#!/bin/bash

echo "Iniciando instalação do SE-G7PlayToyBox..."
sleep 2
git clone https://github.com/synt-xerror/g7playtoybox
sudo rm -f /bin/g7ptoybox
sudo mv g7playtoybox/src/g7ptoybox.sh /bin/g7ptoybox
mkdir -p $HOME/.config/g7ptoybox/
mv g7playtoybox/src/* $HOME/.config/g7ptoybox/
rm -rf g7playtoybox

echo "Instalação concluída. Execute no terminal: 'g7ptoybox'"