const { DataTypes } = require('sequelize');

const Scope = (sequelize) =>
  sequelize.define(
    'Scope',
    {
      id: {
        type: DataTypes.UUID,
        primaryKey: true,
        defaultValue: DataTypes.UUIDV4,
      },
      name: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      level: {
        type: DataTypes.SMALLINT,
        allowNull: false,
      },
    },
    { underscored: true }
  );

module.exports = Scope;
