import mysql from 'mysql2/promise';

export async function connect() {
    try {
        const connection = await mysql.createConnection({
            host: 'localhost',
            user: 'root',
            password: 'inicio',
            database: 'glass_store_v1',
        });
        console.log("MySQL Connected...");
    } catch (err) {
        console.error("MySQL error:", err);
    }
}


