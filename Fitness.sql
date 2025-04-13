CREATE TABLE Clients (
    client_id INT PRIMARY KEY,
    full_name VARCHAR(200) NOT NULL,
    gender VARCHAR(10),
    birthdate DATE,
    phone VARCHAR(20),
    email VARCHAR(100)
);

CREATE TABLE Trainers (
    trainer_id INT PRIMARY KEY,
    full_name VARCHAR(200) NOT NULL,
    specialization VARCHAR(100),
    experience_years INT
);

CREATE TABLE Memberships (
    subscription_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    duration_days INT NOT NULL,
    max_visits INT
);

CREATE TABLE ClientMemberships (
    active_sub_id INT PRIMARY KEY,
    client_id INT NOT NULL,
    subscription_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    status VARCHAR(50),
    FOREIGN KEY (client_id) REFERENCES Clients(client_id),
    FOREIGN KEY (subscription_id) REFERENCES Memberships(subscription_id)
);

CREATE TABLE TrainingSessions (
    session_id INT PRIMARY KEY,
    client_id INT NOT NULL,
    trainer_id INT NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    type VARCHAR(100),
    FOREIGN KEY (client_id) REFERENCES Clients(client_id),
    FOREIGN KEY (trainer_id) REFERENCES Trainers(trainer_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    client_id INT NOT NULL,
    subscription_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_method VARCHAR(50),
    FOREIGN KEY (client_id) REFERENCES Clients(client_id),
    FOREIGN KEY (subscription_id) REFERENCES Memberships(subscription_id)
);