use crate::utils::color::*;
use crate::rom;
use crate::magisk;
use crate::adb;
use std::io::{self, Write};

pub fn main_menu() {
    loop {
        println!("{}--- G7PlayToybox ---{}", GREEN, RESET);
        println!("{}1) Install Magisk{}", DARK_GREEN, RESET);
        println!("{}2) Remove Magisk{}", DARK_GREEN, RESET);
        println!("{}3) Install ROM{}", DARK_GREEN, RESET);
        println!("{}4) Install Magisk Module{}", DARK_GREEN, RESET);
        println!("{}5) Hard Reset{}", DARK_GREEN, RESET);
        println!("{}6) Exit{}", DARK_GREEN, RESET);

        print!("Select an option [1-6]: ");
        io::stdout().flush().unwrap();

        let mut choice = String::new();
        io::stdin().read_line(&mut choice).unwrap();
        let choice = choice.trim();

        match choice {
            "1" => println!("Install Magisk (placeholder)"),
            "2" => magisk::remove_magisk(),
            "3" => {
                let roms = rom::load_roms("data/roms.json");
                for (i, r) in roms.iter().enumerate() {
                    println!("{}: {}", i+1, r.name);
                }
                print!("Select ROM: ");
                io::stdout().flush().unwrap();
                let mut sel = String::new();
                io::stdin().read_line(&mut sel).unwrap();
                if let Ok(idx) = sel.trim().parse::<usize>() {
                    if idx > 0 && idx <= roms.len() {
                        rom::install_rom(&roms[idx-1]);
                    }
                }
            }
            "4" => {
                let modules = magisk::load_modules("data/modules.json");
                for (i, m) in modules.iter().enumerate() {
                    println!("{}: {}", i+1, m.name);
                }
                print!("Select module: ");
                io::stdout().flush().unwrap();
                let mut sel = String::new();
                io::stdin().read_line(&mut sel).unwrap();
                if let Ok(idx) = sel.trim().parse::<usize>() {
                    if idx > 0 && idx <= modules.len() {
                        magisk::install_module(&modules[idx-1]);
                    }
                }
            }
            "5" => println!("Hard Reset placeholder (combine erase + ROM install)"),
            "6" => {
                println!("Exiting...");
                break;
            }
            _ => println!("Invalid option!"),
        }
    }
}
