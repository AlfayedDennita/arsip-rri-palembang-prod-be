const { DataTypes } = require('sequelize');

const Report = (sequelize) =>
  sequelize.define(
    'Report',
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
      description: {
        type: DataTypes.STRING(512),
        defaultValue: '',
      },
      url: {
        type: DataTypes.VIRTUAL,
        get() {
          return `${process.env.BACK_END_BASE_URL}/static/reports/${this.id}.pdf`;
        },
      },
    },
    { underscored: true }
  );

module.exports = Report;
