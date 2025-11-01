use std::process::Command;

pub fn run_adb(args: &[&str]) -> bool {
    let status = Command::new("adb").args(args).status();
    status.map(|s| s.success()).unwrap_or(false)
}

pub fn run_fastboot(args: &[&str]) -> bool {
    let status = Command::new("fastboot").args(args).status();
    status.map(|s| s.success()).unwrap_or(false)
}

pub fn detect_device() -> bool {
    let output = Command::new("adb").arg("devices").output();
    if let Ok(o) = output {
        let stdout = String::from_utf8_lossy(&o.stdout);
        let lines: Vec<&str> = stdout.lines().skip(1).collect();
        !lines.is_empty()
    } else { false }
}
