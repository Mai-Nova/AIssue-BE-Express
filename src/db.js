import { Sequelize } from 'sequelize';

export const sequelize = new Sequelize(
  process.env.MYSQL_DATABASE,    // DB 이름
  process.env.MYSQL_USER,        // DB 사용자
  process.env.MYSQL_PASSWORD,    // DB 비밀번호
  {
    host: process.env.MYSQL_HOST, // EC2 인스턴스의 내부/공인 IP 또는 도메인
    dialect: 'mysql',
    logging: false,
  }
);

export const connectDB = async () => {
  try {
    await sequelize.authenticate();
    console.log('MySQL 연결 성공');
  } catch (err) {
    console.error('MySQL 연결 실패:', err);
    process.exit(1);
  }
};