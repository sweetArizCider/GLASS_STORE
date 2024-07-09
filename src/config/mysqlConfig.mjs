import mysql from 'mysql2/promise';

export const pool = mysql.createPool({
    host: 'localhost',
    user: 'sofia',
    password: 'password', 
    database: 'glass_store_v1',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});




