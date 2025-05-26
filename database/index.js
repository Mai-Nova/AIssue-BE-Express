import mysql from "mysql2/promise";
import config from "./config.js";

const connection_pool = mysql.createPool({
  host: config.MYSQL_HOST,
  port: config.MYSQL_PORT,
  user: config.MYSQL_USER,
  password: config.MYSQL_PASSWORD,
  database: config.MYSQL_DB
});

export default connection_pool;
