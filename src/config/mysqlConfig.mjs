import mysql from 'mysql2/promise';

export const pool = mysql.createPool({
    host: '34.220.188.2',
    user: 'arizpe',
    password: 'arizpe123', 
    database: 'GLASS_STORE_v1',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});




