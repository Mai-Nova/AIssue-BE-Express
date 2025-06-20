import UserModel from '../models/User.js';
import emailService from '../services/emailService.js';

const clientData = new Map();

function initializeSseConnection(req, res) {
  res.status(200);
  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');
  res.flushHeaders();

  const clientName = req.query.clientName;
  if (!clientName) {
    res.status(400).end();
    return;
  }

  console.log(`등록된 clientName: ${clientName}`);

  // 연결 확인 메시지
  res.write(
    `data: ${JSON.stringify({
      clientName,
      type: 'connected',
      message: '알림 서비스에 연결되었습니다.',
      timestamp: Date.now(),
    })}\n\n`
  );

  // ping 전송
  const intervalId = setInterval(() => {
    try {
      res.write(`: keep-alive\n\n`);
    } catch (e) {
      console.log(`${clientName} 연결 실패, 정리 중`);
      clearInterval(intervalId);
      clientData.delete(clientName);
      res.end();
    }
  }, 15000);

  // 일관된 구조로 저장
  clientData.set(clientName, { res, intervalId });

  // 연결 해제 처리
  req.on('close', () => {
    console.log(`클라이언트 연결 해제됨: ${clientName}`);
    clearInterval(intervalId);
    clientData.delete(clientName);
  });
}

// 클라이언트에게 알림 전송
async function pushBrowserNotification(userId, data) {
  try {
    const clientName = await UserModel.findUsernameByUserId(userId);
    if (!clientName) {
      console.error(
        `사용자 ID ${userId}에 해당하는 사용자 정보를 찾을 수 없거나 username이 없습니다.`
      );
      return;
    }
    const client = clientData.get(clientName);

    if (!client?.res) {
      console.error(`클라이언트 ${clientName}에 해당하는 연결이 없습니다.`);
      return;
    }
    const message = `data: ${JSON.stringify(data)}\n\n`;
    client.res.write(message);
  } catch (error) {
    console.error(`서버: 사용자 ID ${userId}에게 메시지 전송 실패:`, error);
  }
}

async function sendEmailNotificationStatus(req, res) {
  const { isEnable, userId } = req.body;

  if (typeof isEnable !== 'boolean' || !userId) {
    res.status(400).json({ message: '유효하지 않은 요청 파라미터.' });
    return;
  }
  try {
    const saveDB = await emailService.saveEmailStatus(isEnable, userId);
    if (!saveDB) {
      res.status(500).json({ success: false, message: 'DB 저장 에러' });
      return;
    }
    if (saveDB.success) {
      res.status(200).json({ success: true, message: 'DB 저장 완료' });
    } else {
      res.status(500).json({ success: false, message: 'DB 저장 에러' });
    }
  } catch (error) {
    res.status(500).json({ success: false, message: '서버 오류' });
  }
}

async function sendEmail(data) {
  const { userId, repoName, result } = data;
  console.log(userId, result, repoName);
  if (!userId || typeof result !== 'boolean' || !repoName) {
    console.error('handleAnalysisCompletion: 필수 분석 데이터 누락.');
    return { success: false, message: '필수 데이터 누락' };
  }
  try {
    const repoInfo = { repoName, result };
    const response = await emailService.selectEmailStatus(userId);
    if (!response.success) {
      console.error('에러 발생', response.error);
      return { success: false, message: '메일 전송 실패' };
    }
    if (!response.isEnable) {
      return { success: true, message: '메일 전송하기를 껐습니다.' };
    }
    const transporter = await emailService.transporterService();
    const sendMailResult = await emailService.sendMail(
      response.userEmail,
      repoInfo,
      transporter
    );
    if (sendMailResult) {
      return { success: true, message: '메일 전송 성공' };
    } else {
      console.error(`사용자 이메일 ${response.userEmail}에 발송 실패`);
      return { success: false, message: '메일 전송 실패' };
    }
  } catch (error) {
    console.error(`이메일 서비스 실패:`, error);
    return { success: false, message: '서버 오류로 메일 전송 실패' };
  }
}

async function getEmailStatus(req, res) {
  const userId = req.query.userId;
  if (!userId) {
    console.error('잘못된 요청입니다.');
    res.status(400).json({ success: false, message: '잘못된 요청입니다.' });
    return;
  }
  try {
    const response = await emailService.selectEmailStatus(userId);
    if (response.success) {
      res.status(200).json({ success: true, message: response.isEnable });
    } else {
      console.error('서버 오류: 이메일 상태를 가져오지 못했습니다.');
      res
        .status(500)
        .json({
          success: false,
          message: '이메일 상태를 가져오지 못했습니다.',
        });
    }
  } catch (error) {
    console.error('서버 오류:', error);
    res.status(500).json({ success: false, message: '서버 오류' });
  }
}

export default {
  initializeSseConnection,
  pushBrowserNotification,
  sendEmailNotificationStatus,
  sendEmail,
  getEmailStatus,
};
