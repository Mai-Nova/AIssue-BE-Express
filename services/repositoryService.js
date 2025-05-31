import repoModel from '../models/Repository.js';
import { repositoryApi } from './githubApiService.js';

async function addRepositoryInfoToDB() {
    const data = repositoryApi.getGitHubRepository();
    if(!data) {
      throw new Error('저장소 정보를 가져오는데 실패했습니다.');
    }
    const repository = {
      githubRepoId: data.id,
      fullName: data.full_name,
      description: data.description || '',
      htmlUrl: data.html_url,
      licenseSpdxId: data.license,
      star: data.stargazers_count,
      fork: data.forks_count,
      prTotalCount: data.open_issues_count, 
      issueTotalCount: data.open_issues_count,
      createAt: new Date(data.created_at),
      updateAt: new Date(data.updated_at),
    };
    const response = await repoModel.insertRepository(repository);
    if(!response.success) {
      throw new Error('저장소 저장이 실패했습니다.');
    }  
    return response;    
  }

async function searchRepositories(word) {
  const response = await repoModel.selectRepository(word);
  if(!response.success) {
    throw new Error('저장소 검색에 실패했습니다.');
  }
  return response;
};

async function getUserRepositories(userId) {
  const response = await repoModel.selectTrackRepositories(userId);
  if (!response.success) {
    throw new Error('유저별 저장소 찾기에 실패했습니다.');
  }
  return response;
};

async function checkUserTrackingStatus(userId, githubRepositoryId) {
  const response = await repoModel.selectTrack(userId, githubRepositoryId);
  if (!response.success) {
    throw new Error('트래킹 상태 확인에 실패했습니다.');
  }
  return response;
};

async function addRepositoryToTracking(userId, githubRepositoryId) {
  const response = await repoModel.insertTrack(userId, githubRepositoryId);
  if (!response.success) {
    throw new Error('저장소 추가에 실패했습니다.');
  }
  return await getUserRepositories(userId);
};

async function removeRepositoryFromTracking(userId, githubRepoId) {
  const response = await repoModel.deleteTrack(userId, githubRepoId);
  if (!response.success) {
    throw new Error('저장소 삭제에 실패했습니다.');
  }
  return response;
};

export{
  addRepositoryInfoToDB,
  searchRepositories,
  getUserRepositories,
  checkUserTrackingStatus,
  addRepositoryToTracking,
  removeRepositoryFromTracking,
};
