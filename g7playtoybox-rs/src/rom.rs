use serde::Deserialize;
use std::fs;
use crate::utils::download_file;
use crate::adb;

#[derive(Deserialize, Clone)]
pub struct Rom {
    pub name: String,
    pub method: String, // "fastboot" ou "adb_sideload"
    pub link: String,
}

pub fn load_roms(path: &str) -> Vec<Rom> {
    let data = fs::read_to_string(path).expect("Cannot read roms.json");
    serde_json::from_str(&data).expect("Invalid JSON format")
}

pub fn install_rom(rom: &Rom) {
    let filename = format!("{}.zip", rom.name.replace(" ", "_"));
    download_file(&rom.link, &filename).unwrap();

    if rom.method == "fastboot" {
        println!("Flashing ROM via fastboot: {}", rom.name);
        // Exemplo de flash, você pode expandir para múltiplas imagens
        adb::run_fastboot(&["flash", "system", &filename]);
    } else {
        println!("Installing ROM via adb sideload: {}", rom.name);
        adb::run_adb(&["sideload", &filename]);
    }

    println!("Rebooting device...");
    adb::run_fastboot(&["reboot"]);
}
