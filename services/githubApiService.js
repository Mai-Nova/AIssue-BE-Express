import axios from 'axios';
import querystring from 'querystring';

const GITHUB_API_URL = 'https://api.github.com';
const GITHUB_OAUTH_URL = 'https://github.com/login/oauth';

export const githubApiService = {
  // GitHub OAuth 코드로 액세스 토큰 요청
  async getAccessToken(code) {
    try {
      const response = await axios.post(
        `${GITHUB_OAUTH_URL}/access_token`,
        querystring.stringify({
          client_id: process.env.GITHUB_CLIENT_ID,
          client_secret: process.env.GITHUB_CLIENT_SECRET,
          code,
        }),
        {
          headers: { Accept: 'application/json' },
        }
      );

      if (!response.data.access_token) {
        throw new Error('GitHub에서 액세스 토큰을 받지 못했습니다.');
      }

      return response.data.access_token;
    } catch (error) {
      throw new Error(`GitHub 액세스 토큰 요청 실패: ${error.message}`);
    }
  },

  // 액세스 토큰으로 사용자 정보 조회
  async getUserInfo(accessToken) {
    try {
      const response = await axios.get(`${GITHUB_API_URL}/user`, {
        headers: { Authorization: `token ${accessToken}` },
      });
      return response.data;
    } catch (error) {
      throw new Error(`GitHub 사용자 정보 조회 실패: ${error.message}`);
    }
  },

  // 액세스 토큰으로 사용자 이메일 목록 조회
  async getUserEmails(accessToken) {
    try {
      const response = await axios.get(`${GITHUB_API_URL}/user/emails`, {
        headers: { Authorization: `Bearer ${accessToken}` },
      });
      return response.data;
    } catch (error) {
      throw new Error(`GitHub 이메일 정보 조회 실패: ${error.message}`);
    }
  },

  // GitHub 애플리케이션 액세스 토큰 철회
  async revokeAccessToken(accessToken) {
    try {
      const basicAuth = Buffer.from(
        `${process.env.GITHUB_CLIENT_ID}:${process.env.GITHUB_CLIENT_SECRET}`
      ).toString('base64');

      await axios.delete(
        `${GITHUB_API_URL}/applications/${process.env.GITHUB_CLIENT_ID}/grant`,
        {
          headers: {
            Authorization: `Basic ${basicAuth}`,
            Accept: 'application/vnd.github+json',
          },
          data: { access_token: accessToken },
        }
      );
    } catch (error) {
      throw new Error(`GitHub 토큰 철회 실패: ${error.message}`);
    }
  },
};
// 저장소 관련 API 호출
export const repositoryApi = {
  async getGitHubRepository(userToken, githubFullName) {
    const instance = axios.create({
      baseURL: GITHUB_API_URL,
      headers: { Authorization: userToken }
    });

    const { data } = await instance.get(`/repos/${githubFullName}`);

    return {
      githubRepoId: data.id,
      fullName: data.full_name,
      description: data.description,
      htmlUrl: data.html_url,
      licenseSpdxId: data.license?.spdx_id ?? null,
      star: data.stargazers_count,
      fork: data.forks_count,
      issueTotalCount: data.open_issues_count,
      createdAt: data.created_at,
      updatedAt: data.updated_at
    };
  },

  async getGitHubContentReadme(userToken, githubFullName) {
    try {
      const instance = axios.create({
        baseURL: GITHUB_API_URL,
        headers: { Authorization: userToken }
      });

      const response = await instance.get(`/repos/${githubFullName}/contents/README.md`);
      const { encoding, content } = response.data;

      const decodedContent = await repositoryApi.encodeBaseContent(content, encoding);
      if (!decodedContent) {
        throw new Error('README 파일이 없습니다.');
      }

      return decodedContent;
    } catch (error) {
      throw new Error(`GitHub README 파일 조회 실패: ${error.response?.status === 404 ? '파일이 존재하지 않습니다.' : error.message}`);
    }
  },

  async getGitHubLicenseFile(userToken, githubFullName) {
    try {
      const instance = axios.create({
        baseURL: GITHUB_API_URL,
        headers: { Authorization: userToken }
      });

      const response = await instance.get(`/repos/${githubFullName}/contents/LICENSE`);
      const { encoding, content } = response.data;

      const decodedContent = await repositoryApi.encodeBaseContent(content, encoding);
      if (!decodedContent) {
        throw new Error('LICENSE 파일이 없습니다.');
      }

      return decodedContent;
    } catch (error) {
      throw new Error(`GitHub LICENSE 파일 조회 실패: ${error.response?.status === 404 ? '파일이 존재하지 않습니다.' : error.message}`);
    }
  },

  async getRepoLanguages(userToken, githubFullName) {
    const instance = axios.create({
      baseURL: `${GITHUB_API_URL}/repos/${githubFullName}/languages`,
      headers: { Authorization: userToken }
    });

    const { data } = await instance.get();

    const total = Object.values(data).reduce((acc, val) => acc + val, 0);
    const result = Object.entries(data).map(([lang, val]) => ({
      languageName: lang,
      languagePercentage: +(val / total * 100).toFixed(2)
    }));

    return { success: true, data: result };
  },

  async encodeBaseContent(content, encoding) {
    try {
      if (encoding === 'base64') {
        return Buffer.from(content, 'base64').toString('utf8');
      }
      throw new Error('지원되지 않는 인코딩 형식입니다.');
    } catch (error) {
      throw new Error(`파일 인코딩 실패: ${error.message}`);
    }
  }
};
