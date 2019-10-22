--liquibase formatted sql

--changeset simanov-an:create-db-changelog-1
--comment Create database
CREATE TABLE DEVICES_INFO
(
    ID VARCHAR (36) PRIMARY KEY,
    NAME VARCHAR (512) NOT NULL
);

CREATE TABLE LOCATIONS
(
    ID VARCHAR (36) PRIMARY KEY,
    NAME VARCHAR (256) NOT NULL
);
CREATE UNIQUE INDEX I_LOCATIONS_NAME ON LOCATIONS(NAME);

CREATE TABLE WIFI_ANALYZE_REPORTS
(
    ID VARCHAR (36) PRIMARY KEY,
    CREATION_DATE TIMESTAMP NOT NULL,
    COMMENT VARCHAR (1024),
    DEVICE_ID VARCHAR (36) NOT NULL,
    LOCATION_ID VARCHAR (36) NOT NULL,
    OWNER_USER_ID VARCHAR (36) NOT NULL,
    FOREIGN KEY (DEVICE_ID) REFERENCES DEVICES_INFO(ID) ON DELETE CASCADE,
    FOREIGN KEY (LOCATION_ID) REFERENCES LOCATIONS(ID) ON DELETE CASCADE,
    FOREIGN KEY (OWNER_USER_ID) REFERENCES USERS(ID)
);
CREATE INDEX I_WARS_CD ON WIFI_ANALYZE_REPORTS(CREATION_DATE);
CREATE INDEX I_WARS_LID ON WIFI_ANALYZE_REPORTS(LOCATION_ID, CREATION_DATE);
CREATE INDEX I_WARS_OUID ON WIFI_ANALYZE_REPORTS(OWNER_USER_ID, CREATION_DATE);

CREATE TABLE WIFI_ANALYZES_INFO
(
    ID VARCHAR (36) PRIMARY KEY,
    CREATION_DATE TIMESTAMP NOT NULL,
    SSID VARCHAR (512) NOT NULL,
    WIFI_REPORT_ID VARCHAR (36) NOT NULL,
    FOREIGN KEY (WIFI_REPORT_ID) REFERENCES WIFI_ANALYZE_REPORTS(ID)
);
CREATE INDEX I_WAI_CD_SSID ON WIFI_ANALYZES_INFO(SSID, CREATION_DATE);

--rollback;