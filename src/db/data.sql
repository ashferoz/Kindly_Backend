CREATE DATABASE kindly;

-- Languages
CREATE TABLE languages (
id 			SERIAL PRIMARY KEY,
location	VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO languages (name)
VALUES ('English'), ('Mandarin'), ('Malay'), ('Tamil'), ('Hokkien'), ('Cantonese');

SELECT * FROM languages;



-- Locations
CREATE TABLE locations (
id 			SERIAL PRIMARY KEY,
location	VARCHAR(255) NOT NULL UNIQUE
);

INSERT INTO locations (location)
VALUES ('Bedok');

SELECT * FROM locations;



-- Volunteers
CREATE TABLE volunteers (
uuid			UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
firstname		VARCHAR(50) NOT NULL,
lastname		VARCHAR(50) NOT NULL,
username		VARCHAR(20) NOT NULL UNIQUE,
email			VARCHAR(150) NOT NULL UNIQUE,
hashed_password	VARCHAR(255) NOT NULL,
bio				text	
);

INSERT INTO volunteers (firstname, lastname, username, email, hashed_password, bio)
VALUES ('Ash', 'Feroz', 'ashferoz', 'ash@mail.com', 'password', 'hello');

SELECT * FROM volunteers;



-- Beneficiaries
CREATE TABLE beneficiaries (
uuid 			UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
firstname 		VARCHAR(50) NOT NULL,
lastname 		VARCHAR(50) NOT NULL,
username 		VARCHAR(20) NOT NULL UNIQUE,
email 			VARCHAR(150) NOT NULL UNIQUE,
hashed_password VARCHAR(255) NOT NULL,
language_id 	INT NOT NULL,
location_id		INT NOT NULL,
FOREIGN KEY 	(language_id) REFERENCES languages(id),
FOREIGN KEY		(location_id) REFERENCES locations(id)
);

INSERT INTO beneficiaries (firstname, lastname, username, email, hashed_password, language_id, location_id)
VALUES ('Patrick', 'Star', 'patrickstar', 'patrick@mail.com', 'password', 1, 1);

SELECT * FROM beneficiaries;



-- Donation Type
CREATE TABLE donations_type (
id 			SERIAL PRIMARY KEY,
donation	VARCHAR(255) NOT NULL UNIQUE
);

INSERT INTO donations_type (donation)
VALUES ('food'), ('clothes'), ('electronics');

SELECT * FROM donations_type;



-- Request Urgencies
CREATE TABLE request_urgencies (
id		SERIAL PRIMARY KEY,
urgency	VARCHAR(255) NOT NULL UNIQUE
);

INSERT INTO request_urgencies (urgency)
VALUES	('urgent'), ('not urgent');



-- Request Status
CREATE TABLE request_statuses (
id		SERIAL PRIMARY KEY,
status	VARCHAR(255) NOT NULL UNIQUE
);

INSERT INTO request_statuses (status)
VALUES	('open'), ('on going'), ('complete');

SELECT * FROM request_statuses;



-- Request
CREATE TABLE requests (
request_id 			SERIAL PRIMARY KEY,
beneficiary_uuid 	UUID NOT NULL,
title 				VARCHAR(50) NOT NULL,
details 			TEXT,
request_type 		INT NOT NULL,
request_urgency 	INT NOT NULL,
request_location 	INT NOT NULL,
request_status 		INT NOT NULL DEFAULT 1,
date_created 		TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (beneficiary_uuid) 	REFERENCES beneficiaries(uuid),
FOREIGN KEY (request_type) 		REFERENCES donations_type(id),
FOREIGN KEY (request_urgency) 	REFERENCES request_urgencies(id),
FOREIGN KEY (request_location) 	REFERENCES locations(id),
FOREIGN KEY (request_status) 	REFERENCES request_statuses(id)
);

INSERT INTO requests (beneficiary_uuid, title, details, request_type, request_urgency, request_location)
VALUES ('a5d990ec-c298-49e1-8d0b-a51e1dfae61d', 'Need jellyfish net.', 'I cannot afford a new net', 3, 2, 1);



SELECT * FROM requests;



-- Connect Volunteer to Beneficiary request
CREATE TABLE connect_users (
connection_id      		SERIAL PRIMARY KEY,
request_status     		INT NOT NULL DEFAULT 1,
date_connected     		TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
volunteer_uuid     		UUID NOT NULL,
connect_request_id 		INT NOT NULL,
FOREIGN KEY (connect_request_id) 	REFERENCES requests(request_id),
FOREIGN KEY (volunteer_uuid) 		REFERENCES volunteers(uuid)
);




-- Messages
CREATE TABLE messages (
id                	SERIAL PRIMARY KEY,
content           	TEXT,
date_created      	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
volunteer_uuid    	UUID NOT NULL,
beneficiary_uuid  	UUID NOT NULL,
connection_id     	INT NOT NULL,
FOREIGN KEY (volunteer_uuid) 	REFERENCES volunteers(uuid),
FOREIGN KEY (beneficiary_uuid) 	REFERENCES beneficiaries(uuid),
FOREIGN KEY (connection_id) 	REFERENCES connect_users(connection_id)
);



-- Create First Message
DO $$
DECLARE
    new_connection_id INT;
BEGIN
    -- Create a new connection and capture the connection_id
    INSERT INTO connect_users (volunteer_uuid, connect_request_id)
    VALUES ('64142874-5e48-4c10-bd56-57d77dae8294', 1)
    RETURNING connection_id INTO new_connection_id;

    -- Insert a new message linked to the created connection
    INSERT INTO messages (content, volunteer_uuid, beneficiary_uuid, connection_id)
    VALUES ('Hello Patrick, I can help!', '64142874-5e48-4c10-bd56-57d77dae8294', 'a5d990ec-c298-49e1-8d0b-a51e1dfae61d', new_connection_id);
END $$;



-- Create another message
SELECT connection_id
FROM connect_users
WHERE volunteer_uuid = '64142874-5e48-4c10-bd56-57d77dae8294'
AND connect_request_id = 1;

INSERT INTO messages (content, volunteer_uuid, beneficiary_uuid, connection_id)
VALUES ('When are you available?', '64142874-5e48-4c10-bd56-57d77dae8294', 'a5d990ec-c298-49e1-8d0b-a51e1dfae61d', 1);