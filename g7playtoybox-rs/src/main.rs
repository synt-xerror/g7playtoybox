// Módulos, importamos todos os outros arquivos rust, como se fosse um import do python
mod utils;
mod adb;
mod menu;
mod rom;
mod magisk;

// função principal
fn main() {

    // pega a função detect_device do módulo adb, se retornar erro (! - sinal not) ele executa a condição
    // se for retornar sucesso, ele não executa a condição e continua
    if !adb::detect_device() {
        println!("No device detected via ADB. Please connect your device.");
        return;
    }

    menu::main_menu(); // se chegou até aqui, executa a função main_menu do módulo menu
}
