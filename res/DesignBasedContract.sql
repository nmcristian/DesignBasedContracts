
CREATE TABLE IF NOT EXISTS AIRPLANES (
	id MEDIUMINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    type varchar(50) CHARACTER SET utf8 UNIQUE NOT NULL,
	total_seats int NOT NULL
);

CREATE TABLE IF NOT EXISTS AIRPORTS (
	id MEDIUMINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    code varchar(3) CHARACTER SET utf8 UNIQUE NOT NULL,
	timezone time NOT NULL
);

CREATE TABLE IF NOT EXISTS ROUTES (
	id MEDIUMINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    departure_id MEDIUMINT NOT NULL,
	arrival_id MEDIUMINT NOT NULL,
    FOREIGN KEY (departure_id) REFERENCES AIRPORTS(id) ON DELETE RESTRICT,
    FOREIGN KEY (arrival_id) REFERENCES AIRPORTS(id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS FLIGHTS (
	id varchar(5) CHARACTER SET utf8 PRIMARY KEY NOT NULL,
    ticket_price MEDIUMINT NOT NULL,
	carrier_code varchar(2) CHARACTER SET utf8 NOT NULL,
    date_from DATETIME NOT NULL,
    date_to DATETIME NOT NULL,
    route_id MEDIUMINT NOT NULL,
    plane_id MEDIUMINT NOT NULL,
    FOREIGN KEY (route_id) REFERENCES ROUTES(id) ON DELETE RESTRICT,
    FOREIGN KEY (plane_id) REFERENCES AIRPLANES(id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS PASSENGERS (
	pnr varchar(6) CHARACTER SET utf8 PRIMARY KEY NOT NULL,
    full_name varchar(50) CHARACTER SET utf8 NOT NULL
);

CREATE TABLE IF NOT EXISTS BOOKINGS (
	id MEDIUMINT AUTO_INCREMENT PRIMARY KEY NOT NULL
);

CREATE TABLE IF NOT EXISTS FLIGHT_BOOKINGS (
    flight_id varchar(5) CHARACTER SET utf8 NOT NULL,
	booking_id MEDIUMINT NOT NULL,
    FOREIGN KEY (flight_id) REFERENCES FLIGHTS(id) ON DELETE RESTRICT,
    FOREIGN KEY (booking_id) REFERENCES BOOKINGS(id) ON DELETE RESTRICT,
    PRIMARY KEY (flight_id, booking_id)
);

CREATE TABLE IF NOT EXISTS BOOKING_PASSENGERS (
	booking_id MEDIUMINT NOT NULL,
	passenger_id varchar(6) CHARACTER SET utf8 NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES BOOKINGS(id) ON DELETE RESTRICT,
    FOREIGN KEY (passenger_id) REFERENCES PASSENGERS(pnr) ON DELETE RESTRICT,
    PRIMARY KEY (booking_id, passenger_id)
);
