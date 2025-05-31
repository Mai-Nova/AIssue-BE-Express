import express from 'express';
import {
  addRepositoryWithGitHub,
  searchRepository,
  getRepositoryList,
  addRepositoryInTracker,
  deleteRepositoryInTracker,
} from '../controllers/repositoryController.js';
import { authenticate } from '../middlewares/authMiddleware.js';

const router = express.Router();
router.post('/', authenticate, addRepositoryWithGitHub);

// 내 저장소의 저장소중 검색
router.get('/search', authenticate, searchRepository);

// 내 저장소 목록 조회
router.get('/tracked', authenticate, getRepositoryList);

// 저장소 트래킹 추가
router.post('/tracked', authenticate, addRepositoryInTracker);

// 저장소 트래킹 삭제
router.delete('/tracked', authenticate, deleteRepositoryInTracker);

export default router;
