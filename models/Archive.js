const { DataTypes } = require('sequelize');

const Archive = (sequelize) =>
  sequelize.define(
    'Archive',
    {
      id: {
        type: DataTypes.UUID,
        primaryKey: true,
        defaultValue: DataTypes.UUIDV4,
      },
      title: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      publishedAt: {
        type: DataTypes.DATE,
      },
      retentionCategory: {
        type: DataTypes.ENUM('vital', 'important', 'useful', 'temporary'),
        allowNull: false,
      },
      removedAt: {
        type: DataTypes.DATE,
      },
      description: {
        type: DataTypes.STRING(512),
        defaultValue: '',
      },
    },
    { underscored: true }
  );

module.exports = Archive;
