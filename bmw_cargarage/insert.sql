CREATE TABLE owned_vehicles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner VARCHAR(255) NOT NULL,
    plate VARCHAR(20) NOT NULL UNIQUE,
    vehicle TEXT NOT NULL,
    state TINYINT NOT NULL DEFAULT 1,
    UNIQUE(plate, owner)
);
