const { Sequelize } = require('sequelize');
const { database } = require('./config.json');

const sequelize = new Sequelize(database.name, database.user, database.password, {
    host: database.host,
    dialect: database.dialect
});

class Database {
    constructor(){
        this.sequelize = sequelize;
    }

    async connect(){
        try {
            await this.sequelize.authenticate();
            console.log('Connection has been established successfully.');
        }catch(err){
            console.error('Unable to connect to the database:', err);
        }
    }

    get getSequelize(){
        return this.sequelize;
    }
}

if(!global.database_singleton){
    global.database_singleton = new Database();
    global.database_singleton.connect();
}

module.exports = global.database_singleton;