use serde::Deserialize;
use std::fs;
use crate::utils::download_file;
use crate::adb;

#[derive(Deserialize, Clone)]
pub struct Module {
    pub name: String,
    pub link: String,
}

pub fn load_modules(path: &str) -> Vec<Module> {
    let data = fs::read_to_string(path).expect("Cannot read modules.json");
    serde_json::from_str(&data).expect("Invalid JSON format")
}

pub fn install_module(module: &Module) {
    let filename = format!("{}.zip", module.name.replace(" ", "_"));
    download_file(&module.link, &filename).unwrap();

    println!("Installing Magisk module: {}", module.name);
    adb::run_adb(&["push", &filename, "/sdcard/Download/"]);
    println!("Use Magisk app to install module from /sdcard/Download/{}", filename);
}

pub fn remove_magisk() {
    println!("Removing Magisk (pretend)...");
    // Aqui você pode implementar remoção real se quiser
}
