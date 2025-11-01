#!/bin/bash

# SE! G7PlayToybox
# github.com/

playwav() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        return 1  # arquivo não existe
    fi

    if command -v aplay >/dev/null 2>&1; then
        nohup aplay "$file" >/dev/null 2>&1 &
    elif command -v paplay >/dev/null 2>&1; then
        nohup paplay "$file" >/dev/null 2>&1 &
    elif command -v play >/dev/null 2>&1; then
        nohup play "$file" >/dev/null 2>&1 &
    else
        return 2  # nenhum player disponível
    fi
}


GREEN="\033[38;2;34;139;34m" # this is dark
DARK_GREEN="\033[38;2;152;251;152m" # and this is light
# XD

PHRASE='“Proprietary software is an injustice. It’s a way of taking away your freedom.”'
RESET="\033[0m"

clear
function phrase() {
    playwav $HOME/.config/g7ptoybox/buddy.wav
    echo -e "\n${GREEN} ${PHRASE}"
    sleep 5
    printf "${GREEN} \n ~ Richard Stallman"
    sleep 1.5
    printf ", creator of GNU Project.\n"
    sleep 2
}

function logo() {
    playwav $HOME/.config/g7ptoybox/beeps.wav
    echo -e "${DARK_GREEN}"
    sleep 0.1
    echo -e "     ${DARK_GREEN}--------  --  ------ "
    sleep 0.05
    echo -e "   ${DARK_GREEN}---       ----     --  "
    sleep 0.05
    echo -e "  ${DARK_GREEN}---         ---    --   "
    sleep 0.05
    echo -e "  ${DARK_GREEN}--           --   --    "
    sleep 0.05
    echo -e "  ${DARK_GREEN}--           --         "
    sleep 0.05
    echo -e "  ${DARK_GREEN}---         ---   -----  -        --   --  --"
    sleep 0.05
    echo -e "   ${DARK_GREEN}---       ----   -   -  -       -  -   ---- "
    sleep 0.05
    echo -e "     ${DARK_GREEN}--------  --   ----   -      ------   --  "
    sleep 0.05
    echo -e "               ${DARK_GREEN}--   -      ----- --    --  --  "
    sleep 0.1
    echo -e "              ${DARK_GREEN}--      ${GREEN}__                ___.                 "
    sleep 0.05
    echo -e "${DARK_GREEN}   ---       ---    ${GREEN}_/  |_  ____ ___.__.\\_ |__   _______  ___"             
    sleep 0.05
    echo -e "${DARK_GREEN}     -------${GREEN}        \\   __\\/  _ <   |  | | __ \\ /  _ \\  \\/  /"           
    sleep 0.05
    echo -e "${GREEN}                     |  | (  <_> )___  | | \\_\\ ( <_>  >    < "
    sleep 0.05
    echo -e "${GREEN}                     |__|  \\____// ____| |___  /\\____/__/\\_ \\"
    sleep 0.05
    echo -e "${GREEN}                                 \\/          \\/            \\/${RESET}"
    sleep 0.2

    # efeito "terminal" piscando
    printf "${GREEN}\n ▄ "
    sleep 0.6
    printf "${GREEN} ▄ "
    sleep 0.9
    echo -e "\033[1A\033[2K"

    echo -e "${DARK_GREEN} By:     SyntaxError!"
    echo -e "${DARK_GREEN} GitHub: synt-xerror"
    sleep 0.1
    playwav $HOME/.config/g7ptoybox/syntax.wav

    echo -e "${GREEN}"
    echo -e "\n Welcome to G7PlayToybox, $USER!\n"
    echo -e "${DARK_GREEN}"
    read -p " Press [ENTER] to continue: "
}


# Função para checar se um comando existe
command_exists() {
    if  command -v "$1" >/dev/null 2>&1; then
        echo "$1 já está instalado"
    else
        echo "$1 não encontrado. Instalando..."
        sudo pacman -S $1
    fi
}

detect_rom() {
    if [[ $(adb shell getprop ro.build.display.id) == "QPYS30.52-22-14" ]]; then
        echo "Stock ROM detected"
        ROM="stock"
    elif adb shell getprop ro.lineage.version; then
        echo "LineageOS ROM detected"
        ROM="lineageos"
    else
        echo "Couldn't detect your ROM, exiting..."
        sleep 2
        main_menu
    fi
}

detect_debug() {
    devices=($(adb devices | tail -n +2 | awk '{print $1}'))

    # Retorna 0 se houver exatamente um dispositivo conectado
    [ ${#devices[@]} -eq 1 ]
}

install_stock () {
    folder="$HOME/.config/g7ptoybox/roms/moto"

    fastboot flash partition $folder/gpt.bin
    fastboot flash bootloader $folder/bootloader.img
    fastboot flash modem $folder/NON-HLOS.bin
    fastboot flash fsg $folder/fsg.mbn
    fastboot erase modemst1
    fastboot erase modemst2
    fastboot flash dsp $folder/adspso.bin
    fastboot flash logo $folder/logo.bin
    fastboot flash boot $folder/boot.img
    fastboot flash dtbo $folder/dtbo.img
    fastboot flash oem $folder/oem.img
    fastboot flash system $folder/system.img_sparsechunk.0
    fastboot flash system $folder/system.img_sparsechunk.1
    fastboot flash system $folder/system.img_sparsechunk.2
    fastboot flash system $folder/system.img_sparsechunk.3
    fastboot flash system $folder/system.img_sparsechunk.4
    fastboot flash system $folder/system.img_sparsechunk.5
    fastboot flash system $folder/system.img_sparsechunk.6
    fastboot flash system $folder/system.img_sparsechunk.7
    fastboot flash system $folder/system.img_sparsechunk.8
    fastboot flash vendor $folder/vendor.img_sparsechunk.0
    fastboot flash vendor $folder/vendor.img_sparsechunk.1
    fastboot erase userdata
    fastboot erase cache
}


function handle_menu() {
    case $1 in
        1)  command_exists adb
            command_exists fastboot
            
            detect_rom

            echo "Waiting for USB debugging activation..."
            until detect_debug; do
                sleep 1
            done

            # instala APK Magisk
            MAGISK_APK="apks/Magisk-v29.0.apk"
            echo -e "${GREEN}Instalando APK Magisk...${RESET}"
            adb install -r -g "$MAGISK_APK"

            echo "Entre no app do Magisk e faça o patch do boot.img"
            echo "⏳ Aguardando o Magisk gerar o boot patchado..."

            until adb shell ls /storage/emulated/0/Download/magisk_patched*.img >/dev/null 2>&1; do
                sleep 2
            done

            echo "✅ Arquivo encontrado!"
            PATCHED_FILE=$(adb shell ls /storage/emulated/0/Download/magisk_patched*.img | tr -d '\r')

            # baixa o arquivo pro computador
            adb pull "$PATCHED_FILE" ./magisk_patched.img

            echo "📦 Boot patchado salvo como magisk_patched.img"

            # Reboot para bootloader
            echo "Reiniciando em bootloader..."
            adb reboot bootloader

            # Espera fastboot conectar com timeout de 30s
            echo "Aguardando conexão com fastboot..."
            SECONDS=0
            until fastboot devices; do
                sleep 1
                if [ $SECONDS -ge 30 ]; then
                    echo "[ERRO] Timeout: dispositivo não detectado em fastboot."
                    exit 1
                fi
            done

            # Flash do boot.img patchado no slot ativo
            fastboot flash boot_a $BOOT_IMG
            fastboot flash boot_b $BOOT_IMG

            # Reinicia o sistema
            echo "Reiniciando o dispositivo..."
            fastboot reboot
            sleep 1

            echo -e "${GREEN}Processo concluído!${RESET}"

            ;;
        2)
            
            echo -e "${GREEN}\n Removing Magisk..."
            sleep 2
            echo " (Pretend removal here)"
            sleep 1.5
            ;;
        3)
            echo "ATENÇÃO, ISSO VAI APAGAR TODOS OS DADOS DO SEU DISPOSITIVO. CONTINUAR? [Y/n]"
            read confirm

            # Normaliza a resposta para maiúscula
            confirm=$(echo "$confirm" | tr '[:lower:]' '[:upper:]')

            if [[ "$confirm" == "Y" || "$confirm" == "" ]]; then
                 echo -e "${GREEN}\n Installing Stock ROM..."
                sleep 2
                echo "Reiniciando no bootloader..."
                adb reboot bootloader
                echo "Aguardando conexão com fastboot..."
                SECONDS=0

                until fastboot devices; do
                    sleep 1
                    if [ $SECONDS -ge 30 ]; then
                        echo "[ERRO] Timeout: dispositivo não detectado em fastboot."
                        exit 1
                    fi
                done

                fastboot erase system
                fastboot erase userdata
                fastboot erase cache
                fastboot erase vendor
                install_stock

                echo "Operação concluída, reiniciando..."
                fastboot reboot
            else
                echo "Operação cancelada."
                exit 0
            fi
            sleep 1.5
            ;;
        4)
            
            echo -e "${GREEN}\n Installing LineageOS..."
            sleep 2
            echo " (Pretend ROM flash)"
            sleep 1.5
            ;;
        5)
            
            echo -e "${GREEN}\n Creating system backup..."
            sleep 2
            echo " (Pretend backup)"
            sleep 1.5
            ;;
        6)
            
            echo -e "${GREEN}\n Restoring system backup..."
            sleep 2
            echo " (Pretend restore)"
            sleep 1.5
            ;;
        7)
            playwav $HOME/.config/g7ptoybox/syntax.wav
            echo -e "${GREEN}\n G7PlayToybox v1.0"
            echo -e " By SyntaxError! - github.com/synt-xerror"
            sleep 3
            ;;
        8)
            echo -e "${GREEN}\n Preparing to fix Play Integrity..."
            sleep 2
            ;;
        9)
            echo -e "${DARK_GREEN}\n Exiting...${RESET}"
            exit 0
            ;;
        *)
            echo -e "${GREEN}\n Invalid option! Try again."
            sleep 1
            ;;
    esac

    read -p " Press [ENTER] to return to menu..." dummy
    main_menu
}

# --- MENU PRINCIPAL ---
function main_menu() {
    clear

    echo -e "${GREEN}\n Main Menu - G7PlayToybox\n${RESET}"
    echo -e "${DARK_GREEN} 1) Install Magisk"
    echo -e " 2) Remove Magisk"
    echo -e " 3) Install Stock ROM"
    echo -e " 4) Install LineageOS"
    echo -e " 5) Backup current system"
    echo -e " 6) Restore backup"
    echo -e " 7) About G7PlayToybox"
    echo -e " 8) Fix Play Integrity (BETA)"
    echo -e " 9) Exit\n${RESET}"

    read -p " Select an option [1-8]: " choice
    handle_menu "$choice"
}

# --- INÍCIO ---
if [[ ! "$1" == "--easteregg" ]]; then
    logo
    main_menu
else
    phrase
    logo
    main_menu
fi