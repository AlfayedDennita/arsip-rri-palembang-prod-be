const { DataTypes } = require('sequelize');

const User = (sequelize) =>
  sequelize.define(
    'User',
    {
      id: {
        type: DataTypes.UUID,
        primaryKey: true,
        defaultValue: DataTypes.UUIDV4,
      },
      username: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
      },
      email: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
      },
      password: {
        type: DataTypes.STRING(72),
        allowNull: false,
      },
      role: {
        type: DataTypes.ENUM('root', 'admin', 'leader', 'staff'),
        allowNull: false,
      },
      name: {
        type: DataTypes.STRING,
        defaultValue: '',
      },
    },
    { underscored: true }
  );

module.exports = User;
