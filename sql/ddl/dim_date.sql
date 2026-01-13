CREATE TABLE IF NOT EXISTS mart.dim_date (
    date_key        INT PRIMARY KEY,
    full_date       DATE NOT NULL,
    day             SMALLINT NOT NULL,
    month           SMALLINT NOT NULL,
    month_name      TEXT NOT NULL,
    quarter         SMALLINT NOT NULL,
    year            INT NOT NULL,
    day_of_week     SMALLINT NOT NULL,
    day_name        TEXT NOT NULL,
    is_weekend      BOOLEAN NOT NULL
);
