CREATE DATABASE sismobilidade;
GO

USE sismobilidade;
GO

CREATE LOGIN laravel WITH PASSWORD = 'secret';
CREATE USER laravel FOR LOGIN laravel;
ALTER ROLE db_owner ADD MEMBER laravel;
GO