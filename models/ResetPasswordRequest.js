const { DataTypes } = require('sequelize');

const ResetPasswordRequest = (sequelize) =>
  sequelize.define(
    'ResetPasswordRequest',
    {
      id: {
        type: DataTypes.UUID,
        primaryKey: true,
        defaultValue: DataTypes.UUIDV4,
      },
      expiredAt: {
        type: DataTypes.DATE,
        allowNull: false,
      },
    },
    { underscored: true }
  );

module.exports = ResetPasswordRequest;
