# Elidek-Database
Semester-Database Project

## Dependencies

 - [MySQL](https://www.mysql.com/) for Windows
 - [Python](https://www.python.org/downloads/), with the additional libraries:
    - [Flask](https://flask.palletsprojects.com/en/2.0.x/)
    - [Flask-MySQLdb](https://flask-mysqldb.readthedocs.io/en/latest/)
    - [Flask-WTForms](https://flask-wtf.readthedocs.io/en/1.0.x/) 

We use pip, python's package manager, to install each individual Python package (library) directly for the entire system, or create a virtual environment with the [`venv`](https://docs.python.org/3/library/venv.html) module.
The necessary packages for this app are listed in `requirements.txt` and can be installed all together via `pip install -r requirements.txt`.

In order to send queries to a database from a Python program, a connection between it and the databases' server must be established first. That is accomplished by a cursor object from the `Flask-MySQLdb` library, and using the appropriate methods (`execute`, `commit`).

## Credentials

 1. Never upload passwords or API keys to github. One simple way to secure your passwords is to store them in a separate file, that will be included in `.gitignore`:
 We import the credentials in `__init__.py` by replacing the `app.config` commands with:
    _dbdemo/config.json_
    ```json
    {
        "MYSQL_USER": "root",
        "MYSQL_PASSWORD": "",
        "MYSQL_DB": "elidek",
        "MYSQL_HOST": "localhost",
        "SECRET_KEY": "key",
        "WTF_CSRF_SECRET_KEY": "key"
    }
    ```
   
    ```python
    import json
    ## ...
    app.config.from_file("config.json", load = json.load)
    ```

## Structure

  `__init__.py` configures the application, including the necessary information and credentials for the database
  
  `routes.py` currently contains all the endpoints and corresponding controllers
  
  `run.py` launches the simple, built-in server and runs the app on it

In order to run we can use the  `flask run` command (if we set the environment variable `FLASK_APP` to `run.py`) or directly with `run.py`.

We also include the DDL and DML scripts that are used to generate the MySQL database and its data. We also include a queries.sql file including most of the queries used.

