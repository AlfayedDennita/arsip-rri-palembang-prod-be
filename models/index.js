const { Sequelize } = require('sequelize');

const db = {};

const dbDialect = process.env.DB_DIALECT;
const dbHost = process.env.DB_HOST;
const dbUsername = process.env.DB_USERNAME;
const dbPassword = process.env.DB_PASSWORD;
const dbName = process.env.DB_NAME;

const sequelize = new Sequelize(dbName, dbUsername, dbPassword, {
  host: dbHost,
  dialect: dbDialect,
  logging: process.argv.includes('--listen') ? console.log : false,
});

db.sequelize = sequelize;

db.scopes = require('./Scope')(sequelize);
db.users = require('./User')(sequelize);
db.archives = require('./Archive')(sequelize);
db.archiveCodes = require('./ArchiveCode')(sequelize);
db.archiveFiles = require('./ArchiveFile')(sequelize);
db.reports = require('./Report')(sequelize);
db.refreshTokens = require('./RefreshToken')(sequelize);
db.resetPasswordRequests = require('./ResetPasswordRequest')(sequelize);

// RELATIONSHIPS

// Scopes

db.scopes.belongsTo(db.scopes, {
  as: 'ancestor',
  foreignKey: { name: 'ancestorId', allowNull: true },
});
db.scopes.hasMany(db.scopes, {
  onDelete: 'CASCADE',
  hooks: true,
  as: 'descendants',
  foreignKey: { name: 'ancestorId', allowNull: true },
});

// Users

db.users.belongsTo(db.scopes, {
  foreignKey: { allowNull: false },
});
db.scopes.hasMany(db.users, {
  onDelete: 'RESTRICT',
});

// Archives

db.archives.belongsTo(db.users, {
  foreignKey: { name: 'createdBy', allowNull: true },
});
db.users.hasMany(db.archives, {
  onDelete: 'SET NULL',
  foreignKey: { name: 'createdBy', allowNull: true },
});

db.archives.belongsTo(db.archiveCodes, {
  foreignKey: { allowNull: false },
});
db.archiveCodes.hasMany(db.archives, {
  onDelete: 'RESTRICT',
});

// Archive Codes

db.archiveCodes.belongsTo(db.scopes, {
  foreignKey: { allowNull: false },
});
db.scopes.hasMany(db.archiveCodes, {
  onDelete: 'RESTRICT',
});

// Archive Files

db.archiveFiles.belongsTo(db.archives, {
  foreignKey: { allowNull: false },
});
db.archives.hasMany(db.archiveFiles, {
  onDelete: 'CASCADE',
  hooks: true,
});

// Reports

db.reports.belongsTo(db.users, {
  foreignKey: { name: 'createdBy', allowNull: true },
});
db.users.hasMany(db.reports, {
  onDelete: 'SET NULL',
  foreignKey: { name: 'createdBy', allowNull: true },
});

db.reports.belongsTo(db.scopes, {
  foreignKey: { allowNull: false },
});
db.scopes.hasMany(db.reports, {
  onDelete: 'RESTRICT',
});

// Refresh Tokens

db.refreshTokens.belongsTo(db.users, {
  foreignKey: { allowNull: false },
});
db.users.hasOne(db.refreshTokens, {
  onDelete: 'CASCADE',
  hooks: true,
});

// Reset Password Requests

db.resetPasswordRequests.belongsTo(db.users, {
  foreignKey: { allowNull: false },
});
db.users.hasOne(db.resetPasswordRequests, {
  onDelete: 'CASCADE',
  hooks: true,
});

module.exports = db;
