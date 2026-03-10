use arma_rs::IntoArma;

/// Match database schema for certifications.
/// This is used to serialize and deserialize certifications from the database.
#[derive(IntoArma)]
pub struct Certification {
    pub id: CertificationId,
    pub display_name: String,
    pub document: String,
}

pub type CertificationId = String;
