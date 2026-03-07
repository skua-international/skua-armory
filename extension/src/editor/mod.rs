use std::path::Path;

const DESCRIPTION_EXT: &str = include_str!("description.ext");

pub fn description_ext(mut mission_path: String) -> bool {
    if mission_path.ends_with('\\') {
        mission_path.pop();
    };
    if mission_path.is_empty() {
        return false;
    }
    let path = Path::new(&mission_path);
    if !path.exists() {
        return false;
    }
    if !path.is_dir() {
        return false;
    }

    let description_ext_path = path.join("description.ext");
    if description_ext_path.exists() {
        return false;
    }

    std::fs::write(description_ext_path, DESCRIPTION_EXT).is_ok()
}
