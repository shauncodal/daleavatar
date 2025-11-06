import mysql from 'mysql2/promise';

let pool;
export function getPool() {
  if (!pool) {
    if (!process.env.MYSQL_DSN || process.env.MYSQL_DSN === '') {
      throw new Error('MYSQL_DSN environment variable is not set');
    }
    const url = new URL(process.env.MYSQL_DSN);
    pool = mysql.createPool({
      host: url.hostname,
      port: Number(url.port || 3306),
      user: url.username,
      password: url.password,
      database: url.pathname.replace(/^\//, ''),
      waitForConnections: true,
      connectionLimit: 10
    });
  }
  return pool;
}

