import { githubService } from '../services/githubService.js';
import jwt from 'jsonwebtoken';
import { User } from '../models/User.js';

export const login = (req, res) => {
  const clientId = process.env.GITHUB_CLIENT_ID;
  const redirectUri = process.env.GITHUB_REDIRECT_URI;
  const githubAuthUrl = `https://github.com/login/oauth/authorize?client_id=${clientId}&redirect_uri=${redirectUri}&scope=user:email&allow_signup=true&prompt=login`;
  res.redirect(githubAuthUrl);
};

export const callback = async (req, res) => {
  const { code } = req.query;
  try {
    const accessToken = await githubService.getAccessToken(code);
    const userInfo = await githubService.getUserInfo(accessToken);

    // 이메일 처리
    let email = userInfo.email;
    if (!email) {
      const emails = await githubService.getUserEmails(accessToken);
      const primaryEmail = emails.find(e => e.primary && e.verified);
      email = primaryEmail ? primaryEmail.email : (emails[0]?.email || '');
    }

    // DB에서 사용자 조회
    let user = await User.findOne({ githubId: userInfo.id });
    if (!user) {
      user = await User.create({
        githubId: userInfo.id,
        username: userInfo.login,
        avatar_url: userInfo.avatar_url,
        email,
        accessToken,
      });
    } else {
      user.email = email;
      user.avatar_url = userInfo.avatar_url;
      user.accessToken = accessToken;
      await user.save();
    }

    // JWT 발급
    const token = jwt.sign(
      {
        id: user._id,
        githubId: user.githubId,
        username: user.username,
        email: user.email,
        avatar_url: user.avatar_url,
      },
      process.env.JWT_SECRET,
      { expiresIn: '1h' }
    );

    const frontendUrl = process.env.FRONTEND_URL || 'http://localhost:3000';
    res.redirect(
      `${frontendUrl}/oauth/callback?token=${token}&username=${encodeURIComponent(user.username)}&email=${encodeURIComponent(user.email)}&avatar_url=${encodeURIComponent(user.avatar_url)}`
    );
  } catch (err) {
    console.error('OAuth Callback Error:', err?.response?.data || err.message || err);
    res.status(500).json({ message: 'Internal server error', error: err?.response?.data || err.message || err });
  }
};

export const logout = async (req, res) => {
  try {
    const token = req.headers['authorization']?.split(' ')[1];
    if (!token) {
      return res.status(403).json({ message: 'A token is required for logout' });
    }
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const user = await User.findByPk(decoded.id);

    if (user && user.accessToken) {
      await githubService.revokeAccessToken(user.accessToken);
      user.accessToken = null;
      await user.save();
    }

    res.json({ message: 'Logged out and GitHub app authorization revoked' });
  } catch (err) {
    console.error('Logout Error:', err?.response?.data || err.message || err);
    res.status(500).json({ message: 'Internal server error', error: err?.response?.data || err.message || err });
  }
};