const { DataTypes } = require('sequelize');

const RefreshToken = (sequelize) =>
  sequelize.define(
    'RefreshToken',
    {
      id: {
        type: DataTypes.UUID,
        primaryKey: true,
        defaultValue: DataTypes.UUIDV4,
      },
      token: {
        type: DataTypes.STRING(512),
        allowNull: false,
        unique: true,
      },
      lastAccessedAt: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW,
      },
    },
    { underscored: true }
  );

module.exports = RefreshToken;
