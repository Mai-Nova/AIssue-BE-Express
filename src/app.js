import dotenv from 'dotenv';
dotenv.config();

import express from 'express';
import authRoutes from './routes/auth.js';
import cors from 'cors';
import { connectDB } from './db.js';
import { sequelize } from './db.js';

const app = express();

app.use(cors({
  origin: process.env.FRONTEND_URL || 'http://localhost:3000',
  credentials: true
}));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use('/auth', authRoutes);

app.get('/', (req, res) => {
  res.send('Welcome to the GitHub OAuth Authentication App');
});

const PORT = process.env.PORT || 3001;

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});

await connectDB();
await sequelize.sync(); // 테이블 자동 생성(최초 1회)