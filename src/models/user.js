import { DataTypes } from 'sequelize';
import { sequelize } from '../db.js';

export const User = sequelize.define('User', {
  githubId: { type: DataTypes.STRING, allowNull: false, unique: true },
  username: DataTypes.STRING,
  avatar_url: DataTypes.STRING,
  email: DataTypes.STRING,
  accessToken: DataTypes.STRING,
});