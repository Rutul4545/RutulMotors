# RutulMotors

## First admin account

Run the application through Tomcat with its MySQL database configured. Do not open
`login.html` directly as a local file: servlet login and account setup require the
application server.

On the login page, choose **Create the first admin account**. The setup link works
only from the same computer as the server, and setup closes automatically after
the first admin account is created. Choose a password with at least 12 characters.
Then sign in using the email address and password you entered.

If admin setup reports that it is closed, an admin account already exists. This
first-run setup does not reset existing accounts; use your database administrator
to recover an existing account.

## Local database configuration

Database connection settings can be provided as `RUTUL_DB_URL`, `RUTUL_DB_USER`,
and `RUTUL_DB_PASSWORD` environment variables. Alternatively, save `url`, `user`,
and `password` in the `.rutulmotors-db.properties` file in the account's home
directory. The checked-in schema is in [database/schema.sql](database/schema.sql).

For the local Windows setup, run this from the project folder:

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\start-local.ps1
```

This builds and deploys the app, starts the isolated app database on port 3307
if needed, and runs Tomcat. Open
`http://localhost:8080/RutulMotors/AdminSetupServlet` to create the first admin
account. Stop Tomcat with Ctrl+C; run
`powershell -ExecutionPolicy Bypass -File .\tools\stop-local.ps1` to stop the app
database as well. The original MySQL service on port 3306 is left unchanged.

The isolated database files are under
`%USERPROFILE%\Tools\RutulMotors\mysql-data`; app connection settings and local
database admin credentials are kept outside the project directory.