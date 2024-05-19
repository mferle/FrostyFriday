--!jinja2

--Deployment Differentiation: Dynamically adapts to different deployment types (prod and non-prod).
--Uses distinct environment names (prod1, prod2 for production and dev, qa, staging for non-production).

--Schema Creation: Creates specific schemas (finance, sales, hr for production and development, testing, support for non-production).

{% if DEPLOYMENT_TYPE == 'prod' %}
  {% set environments = ['prod1', 'prod2'] %}
  {% set schemas_list = ['finance', 'sales', 'hr'] %}
{% else %}
  {% set environments = ['dev', 'qa', 'staging'] %}
  {% set schemas_list = ['development', 'testing', 'support'] %}
{% endif %}

{% for environment in environments %}
--Database Setup: Creates databases named according to the environment ({{ environment }}_db).
  CREATE DATABASE {{ environment }}_db;
  USE DATABASE {{ environment }}_db;
  
  {% for sch in schemas_list %}
    CREATE SCHEMA {{ sch }};
    USE SCHEMA {{ sch }};
--Schema-Specific Table Creation: Creates multiple tables within each schema according to the environment ({{ environment }}_{{sch}}_employees for example):
--orders table with columns id, item, quantity, and order_date.
    CREATE TABLE {{ environment }}_{{sch}}_orders (
      id NUMBER,
      item VARCHAR,
      quantity NUMBER,
      order_date DATE);
--customers table with columns id, name, and email.
    CREATE TABLE {{ environment }}_{{sch}}_customers (
      id NUMBER,
      name VARCHAR,
      email VARCHAR);
--products table with columns product_id, product_name, and price.
    CREATE TABLE {{ environment }}_{{sch}}_products (
      product_id NUMBER,
      product_name VARCHAR,
      price DECIMAL);
--employees table with columns employee_id, employee_name, and position
    CREATE TABLE {{ environment }}_{{sch}}_employees (
      employee_id NUMBER,
      employee_name VARCHAR,
      position VARCHAR);
  {% endfor %}

--Production-Specific Setup: Creates a separate prod_analytics_db database.
  {% if DEPLOYMENT_TYPE == 'prod' %}
    CREATE DATABASE {{ environment }}_analytics_db;
    USE DATABASE {{ environment }}_analytics_db;
--Within this database, creates an analytics_reports table with columns report_id, report_name, and created_date.
-- ? no schema specified ? assuming PUBLIC 
    CREATE TABLE analytics_reports (
      report_id NUMBER,
      report_name VARCHAR,
      created_date DATE);
  {% endif %}

{% endfor %}

