const { DataTypes } = require('sequelize');

const ArchiveFile = (sequelize) =>
  sequelize.define(
    'ArchiveFile',
    {
      id: {
        type: DataTypes.UUID,
        primaryKey: true,
        defaultValue: DataTypes.UUIDV4,
      },
      page: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      extension: {
        type: DataTypes.ENUM('pdf', 'jpg', 'jpeg', 'png'),
        allowNull: false,
      },
      url: {
        type: DataTypes.VIRTUAL,
        get() {
          return `${process.env.BACK_END_BASE_URL}/static/archives/${this.id}.${this.extension}`;
        },
      },
    },
    { underscored: true }
  );

module.exports = ArchiveFile;
