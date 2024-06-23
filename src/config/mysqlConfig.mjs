import mysql from 'mysql2/promise';

export const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: 'inicio', 
    database: 'GLASS_STORE_V1',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});




