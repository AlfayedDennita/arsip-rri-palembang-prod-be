const { DataTypes } = require('sequelize');

const ArchiveCode = (sequelize) =>
  sequelize.define(
    'ArchiveCode',
    {
      id: {
        type: DataTypes.UUID,
        primaryKey: true,
        defaultValue: DataTypes.UUIDV4,
      },
      code: {
        type: DataTypes.STRING(50),
        allowNull: false,
        unique: true,
      },
      description: {
        type: DataTypes.STRING(512),
        defaultValue: '',
      },
    },
    { underscored: true }
  );

module.exports = ArchiveCode;
