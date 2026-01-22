use uuid::Uuid;

pub fn new_uuid_v7() -> Uuid {
    Uuid::now_v7()
}
