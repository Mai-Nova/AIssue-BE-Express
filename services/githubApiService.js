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


export const repositoryApi = {
  async function getGitHubRepository(userToken, githubFullName) {
    const instance = axios.create({
      baseURL: 'https://api.github.com',
      headers: {
        Authorization: userToken
      }
    });
    // DB랑 비교해서 가져올 정보만 셋팅
    const data = await instance.get(`/repos${githubFullName}`);
    const githubRepoUd = data.id;
    const fullName = data.full_name;
    const description = data.description;
    const htmlUrl = data.html_url;
    const license = data.license;
    const start = data.stargazers_count;
    const createdAt = data.created_at;
    const updatedAt = data.updated_at;
    const fork = data.forks_count;
    const issueTotalCount = data.open_issues_count;
    
  },
  async function getGitHubContentReadme(userToken, githubFullName) {
    try {
      const instance = axios.create({
        baseURL: 'https://api.github.com',
        headers: {
          Authorization: userToken
        }
      });
      const response = await instance.get(`/repos${githubFullName}/contents/README.md`);
      const { encoding, content } = response.data;
      const decodedContent = await encodeBaseContent(content, encoding);
      // 여기서 content 파일 가져다가 gpt 로 보내면 됩니다. (DB :readme_summary_gpt)
      
      if (!decodedContent) {
        throw new Error('README 파일이 없습니다.');
      }
    } catch (error) {
      throw new Error(`GitHub README 파일 조회 실패: ${error.response?.status === 404 ? '파일이 존재하지 않습니다.' : error.message}`);
    }
  },

  async function encodeBaseContent(content, encoding) {
    try{
      // readme 파일을 utf-8로 인코딩
      if (encoding === 'base64') {
        return Buffer.from(content, 'base64').toString('utf8');
      }
      throw new Error('지원되지 않는 인코딩 형식입니다.')
    }catch (error) {
      throw new Error(`README 파일 인코딩 실패: ${error.message}`);
    }
  },
  async function getGitHubLicenseFile(userToken, githubFullName) {
    try {
      const instance = axios.create({
        baseURL: 'https://api.github.com',
        headers: {
          Authorization: userToken
        }
      });
      const response = await instance.get(`/repos${githubFullName}/contents/LICENSE`);
      const { encoding, content } = response.data;
      const decodedContent = await encodeBaseContent(content, encoding);
      
      if (!decodedContent) {
        throw new Error('LICENSE 파일이 없습니다.');
      }
    } catch (error) {
      throw new Error(`GitHub LICENSE 파일 조회 실패: ${error.response?.status === 404 ? '파일이 존재하지 않습니다.' : error.message}`);
    }
  },


  async function getRepoLanguages(userToken, githubFullName) {
    const instance = axios.create({
      baseURL : `${GITHUB_API_URL}/repos${githubFulName}/languages`
    });
    instance.defaults.headers.common['Authorization']=userToken;
    const data = await instance.get();
    
    const languages = Object.keys(data);
    const langTotal =  Object.values(data).reduce((acc, cur) => acc + cur, 0);
    const percentage = {};
    for (const [lang, value] of Object.entries(data)) {
      percentage[lang] = +(value / langTotal * 100).toFixed(2);  // 소수점 둘째자리까지
    }
    const result = languages.map(lang => ({
      languageName: lang,
      languagePercentage: percentage[lang]
    }))
    return { success : true, data: result };
  },
};

