import mysql from 'mysql2/promise';

export const pool = mysql.createPool({
    host: 'localhost',
    user: 'applecider',
    password: 'start', 
    database: 'GLASS_STORE_v1',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});




