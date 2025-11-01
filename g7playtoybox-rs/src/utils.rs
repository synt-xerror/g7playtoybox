use std::{thread, time::Duration, fs::File, io::copy};
use reqwest::blocking::Client;

pub fn sleep_ms(ms: u64) {
    thread::sleep(Duration::from_millis(ms));
}

pub fn download_file(url: &str, path: &str) -> Result<(), Box<dyn std::error::Error>> {
    println!("Downloading: {}", url);
    let client = Client::new();
    let mut resp = client.get(url).send()?;
    let mut out = File::create(path)?;
    copy(&mut resp, &mut out)?;
    println!("Saved to {}", path);
    Ok(())
}

// cores básicas para terminal
pub mod color {
    pub const GREEN: &str = "\x1b[38;2;34;139;34m";
    pub const DARK_GREEN: &str = "\x1b[38;2;152;251;152m";
    pub const RESET: &str = "\x1b[0m";
}
