-- SQL 안전 모드 비활성화 (DELETE 경고 방지)
SET SQL_SAFE_UPDATES = 0;
-- 기존 데이터 삭제 (외래키 제약조건 고려하여 역순으로 삭제)
DELETE FROM `recommended_code_snippets`;
DELETE FROM `chat_bot_messages`;
DELETE FROM `chat_bot_conversations`;
DELETE FROM `user_tracked_repositories`;
DELETE FROM `issues`;
DELETE FROM `repository_languages`;
DELETE FROM `repositories`;
DELETE FROM `licenses`;
DELETE FROM `users`;
-- AUTO_INCREMENT 값 초기화
ALTER TABLE `users` AUTO_INCREMENT = 1;
ALTER TABLE `repositories` AUTO_INCREMENT = 1;
ALTER TABLE `issues` AUTO_INCREMENT = 1;
ALTER TABLE `chat_bot_conversations` AUTO_INCREMENT = 1;
ALTER TABLE `chat_bot_messages` AUTO_INCREMENT = 1;
ALTER TABLE `recommended_code_snippets` AUTO_INCREMENT = 1;
-- 사용자 데이터 삽입
INSERT INTO users(
        github_user_id,
        username,
        avatar_url,
        email,
        refresh_token,
        refresh_token_expires_at,
        is_pro_plan,
        pro_plan_activated_at,
        pro_plan_expires_at,
        created_at,
        updated_at
    )
VALUES (
        9911991,
        '김앨리스',
        'https://avatars.githubusercontent.com/u/9911991?v=4',
        'alice.kim@example.com',
        'token_alice_123abc',
        '2025-06-29 10:00:00',
        TRUE,
        '2024-01-01 10:00:00',
        '2025-01-01 10:00:00',
        '2024-01-01 10:00:00',
        '2025-05-21 12:00:00'
    ),
    (
        8822882,
        '이밥',
        'https://avatars.githubusercontent.com/u/8822882?v=4',
        'bob.lee@example.com',
        NULL,
        NULL,
        FALSE,
        NULL,
        NULL,
        '2023-11-10 08:30:00',
        '2025-05-21 12:00:00'
    ),
    (
        7733773,
        '박찰리',
        'https://avatars.githubusercontent.com/u/7733773?v=4',
        'charlie.park@example.com',
        'token_charlie_xyz789',
        '2025-07-29 14:30:00',
        TRUE,
        '2024-06-01 14:30:00',
        '2025-06-01 14:30:00',
        '2024-06-01 14:30:00',
        '2025-05-21 12:00:00'
    );
-- 저장소 데이터 삽입 (언어 관련 컬럼 제거)
INSERT INTO repositories (
        github_repo_id,
        full_name,
        description,
        html_url,
        license_spdx_id,
        readme_summary_gpt,
        star,
        fork,
        pr_total_count,
        issue_total_count,
        last_analyzed_at,
        analysis_status,
        analysis_completed_at,
        created_at,
        updated_at
    )
VALUES (
        123456789,
        'octocat/Hello-World',
        '깃허브에서의 첫 번째 저장소입니다!',
        'https://github.com/octocat/Hello-World',
        'MIT',
        '자바스크립트로 작성된 간단한 Hello World 프로젝트입니다.',
        1500,
        300,
        45,
        12,
        '2024-12-01 10:30:00',
        'completed',
        '2024-12-01 10:30:00',
        '2011-01-26 19:01:12',
        '2025-05-01 09:00:00'
    ),
    (
        234567890,
        'torvalds/linux',
        '리눅스 커널 소스 트리',
        'https://github.com/torvalds/linux',
        'GPL-3.0-only',
        '리눅스 운영체제 커널의 소스 코드입니다.',
        150000,
        75000,
        1200,
        5000,
        '2025-05-20 14:00:00',
        'completed',
        '2025-05-20 14:00:00',
        '2011-09-04 22:48:00',
        '2025-05-21 12:00:00'
    ),
    (
        345678901,
        'facebook/react',
        '사용자 인터페이스 구축을 위한 선언적이고 효율적이며 유연한 자바스크립트 라이브러리',
        'https://github.com/facebook/react',
        'MIT',
        '리액트는 현대적인 UI 구축을 위한 자바스크립트 라이브러리입니다.',
        210000,
        44000,
        500,
        1300,
        '2025-05-21 18:30:00',
        'completed',
        '2025-05-21 18:30:00',
        '2013-05-24 16:15:10',
        '2025-05-22 08:30:00'
    ),
    (
        456789012,
        'tensorflow/tensorflow',
        '모든 사람을 위한 오픈소스 머신러닝 프레임워크',
        'https://github.com/tensorflow/tensorflow',
        'Apache-2.0',
        '텐서플로우는 종단간 오픈소스 머신러닝 플랫폼입니다.',
        180000,
        85000,
        300,
        2200,
        '2025-05-20 11:45:00',
        'completed',
        '2025-05-20 11:45:00',
        '2015-11-09 22:25:36',
        '2025-05-21 09:10:00'
    ),
    (
        567890123,
        'microsoft/vscode',
        'Visual Studio Code - 코드 편집의 재정의',
        'https://github.com/microsoft/vscode',
        'MIT',
        'VS Code는 가볍지만 강력한 소스 코드 에디터입니다.',
        160000,
        28000,
        600,
        1500,
        '2025-05-22 10:00:00',
        'completed',
        '2025-05-22 10:00:00',
        '2015-11-18 13:50:23',
        '2025-05-22 10:10:00'
    ),
    (
        5678901234,
        'vscode/Hello-World',
        'VS Code에서의 첫 번째 저장소입니다!',
        'https://github.com/vscode/Hello-World',
        'MIT',
        '자바로 작성된 간단한 Hello World 프로젝트입니다.',
        2500,
        300,
        45,
        12,
        '2024-12-01 10:30:00',
        'completed',
        '2024-12-01 10:30:00',
        '2012-01-26 19:01:12',
        '2025-05-11 09:00:00'
    ),
    (
        6789012345,
        'golang/go',
        'Go 프로그래밍 언어',
        'https://github.com/golang/go',
        'BSD-3-Clause',
        'Go는 구글에서 개발한 오픈소스 프로그래밍 언어입니다.',
        120000,
        17000,
        800,
        3500,
        '2025-05-21 16:00:00',
        'completed',
        '2025-05-21 16:00:00',
        '2014-08-19 04:33:40',
        '2025-05-22 11:00:00'
    ),
    (
        800000001,
        'tanstack/react-query',
        '🤖 강력한 비동기 상태 관리 및 서버 상태 유틸리티 라이브러리',
        'https://github.com/tanstack/react-query',
        'MIT',
        'React Query는 React 애플리케이션에서 서버 상태를 가져오고, 캐싱하고, 동기화하고, 업데이트하는 작업을 쉽게 만들어주는 라이브러리입니다. 복잡한 상태 관리 코드 없이도 비동기 데이터를 효율적으로 관리할 수 있습니다.',
        35200,
        2100,
        15,
        42,
        '2023-05-15 00:00:00',
        'completed',
        '2023-05-15 00:00:00',
        '2020-01-10 10:00:00',
        '2023-05-20 10:00:00'
    ),
    (
        800000002,
        'vercel/next.js',
        'React 프레임워크로 풀스택 웹 애플리케이션을 구축하세요',
        'https://github.com/vercel/next.js',
        'MIT',
        'Next.js는 풀스택 웹 애플리케이션 구축을 위한 React 프레임워크입니다. 서버 사이드 렌더링, 정적 사이트 생성 등 다양한 기능을 제공합니다.',
        98700,
        24300,
        200,
        156,
        '2023-05-18 00:00:00',
        'completed',
        '2023-05-18 00:00:00',
        '2016-10-25 00:00:00',
        '2023-05-19 00:00:00'
    ),
    (
        800000003,
        'honggildong/my-project',
        '개인 프로젝트 저장소',
        'https://github.com/honggildong/my-project',
        'MIT',
        '홍길동의 개인 프로젝트입니다. 다양한 실험과 학습 내용을 포함하고 있습니다.',
        5,
        1,
        2,
        8,
        '2023-05-19 00:00:00',
        'completed',
        '2023-05-19 00:00:00',
        '2022-08-01 00:00:00',
        '2023-05-20 00:00:00'
    );
-- 사용자 추적 저장소 데이터 삽입
INSERT INTO user_tracked_repositories (
        user_id,
        repo_id,
        tracked_at,
        last_viewed_at
    )
VALUES (
        1,
        1,
        '2025-05-20 10:15:30',
        '2025-05-21 08:00:00'
    ),
    (
        1,
        6,
        '2025-05-19 09:00:00',
        '2025-05-21 15:30:00'
    ),
    (
        1,
        3,
        '2025-05-18 14:20:00',
        '2025-05-22 09:45:00'
    ),
    (
        2,
        2,
        '2025-05-17 11:30:00',
        '2025-05-20 16:20:00'
    ),
    (2, 4, '2025-05-16 13:15:00', NULL),
    (
        3,
        5,
        '2025-05-15 10:00:00',
        '2025-05-21 12:30:00'
    ),
    (
        3,
        7,
        '2025-05-14 16:45:00',
        '2025-05-22 08:15:00'
    );
-- 이슈 데이터 샘플 삽입
INSERT INTO issues (
        repo_id,
        github_issue_id,
        github_issue_number,
        title,
        body,
        author,
        state,
        score,
        html_url,
        summary_gpt,
        tags_gpt_json,
        created_at_github,
        updated_at_github
    )
VALUES (
        1,
        101,
        1,
        'README 파일 개선 요청',
        'README 파일에 설치 방법과 사용 예제를 추가해주세요.',
        'user123',
        'open',
        85,
        'https://github.com/octocat/Hello-World/issues/1',
        '문서화 개선을 위한 README 파일 업데이트 요청입니다.',
        '["documentation", "enhancement", "good-first-issue"]',
        '2025-05-20 09:30:00',
        '2025-05-21 10:15:00'
    ),
    (
        3,
        201,
        2,
        '성능 최적화: useState 훅 개선',
        'useState 훅에서 불필요한 리렌더링이 발생하는 문제를 해결해야 합니다.',
        'reactdev',
        'open',
        95,
        'https://github.com/facebook/react/issues/2',
        '리액트 훅의 성능 최적화와 관련된 중요한 이슈입니다.',
        '["performance", "hooks", "bug", "high-priority"]',
        '2025-05-19 14:20:00',
        '2025-05-21 16:45:00'
    ),
    (
        4,
        301,
        3,
        '텐서플로우 2.x 호환성 문제',
        'TensorFlow 2.x에서 레거시 코드 호환성 문제가 발생합니다.',
        'mldev',
        'closed',
        78,
        'https://github.com/tensorflow/tensorflow/issues/3',
        '버전 호환성 관련 이슈로 해결되었습니다.',
        '["compatibility", "tensorflow2", "resolved"]',
        '2025-05-18 11:00:00',
        '2025-05-20 13:30:00'
    ),
    (
        1,
        102,
        4,
        '설치 스크립트 오류',
        'npm install 실행 시 오류가 발생합니다. 해결 방법을 알려주세요.',
        'user456',
        'open',
        80,
        'https://github.com/octocat/Hello-World/issues/2',
        '설치 스크립트와 관련된 오류 수정 이슈입니다.',
        '["installation", "bug", "high-priority"]',
        '2025-05-21 10:00:00',
        '2025-05-21 10:15:00'
    ),
    (
        5,
        90001,
        1234,
        'useQuery가 SSR에서 제대로 작동하지 않는 문제',
        'Next.js 앱에서 useQuery를 사용할 때 SSR 중에 데이터를 가져오지 못하는 문제가 있습니다. 서버 컴포넌트에서 사용할 때 특히 문제가 됩니다.\n\n재현 단계:\n1. Next.js 13 앱 라우터 프로젝트 생성\n2. 서버 컴포넌트에서 useQuery 사용 시도\n3. \'useQuery는 클라이언트 컴포넌트에서만 사용할 수 있습니다\' 오류 발생\n\n예상 동작: SSR 중에도 데이터를 가져올 수 있어야 합니다.',
        'user123',
        'open',
        88,
        'https://github.com/tanstack/react-query/issues/1234',
        '이 이슈는 React Query의 useQuery 훅이 Next.js 13의 서버 컴포넌트에서 작동하지 않는 문제에 관한 것입니다. 이는 React 훅이 서버 컴포넌트에서 지원되지 않기 때문에 발생하는 제한사항입니다.',
        JSON_ARRAY('bug', 'help wanted'),
        '2023-05-10 00:00:00',
        '2023-05-11 00:00:00'
    ),
    (
        6,
        90002,
        1235,
        'useMutation 타입 추론 개선 제안',
        'useMutation 훅의 타입 추론을 개선하여 더 나은 개발자 경험을 제공하면 좋겠습니다. 현재는 복잡한 제네릭 타입을 직접 지정해야 하는 경우가 많습니다.',
        'devUser456',
        'open',
        75,
        'https://github.com/tanstack/react-query/issues/1235',
        'useMutation 훅의 TypeScript 타입 추론을 개선하여 개발자 경험을 향상시키자는 제안입니다.',
        JSON_ARRAY('enhancement', 'typescript'),
        '2023-05-12 00:00:00',
        '2023-05-13 00:00:00'
    ),
    (
        7,
        90003,
        1236,
        '문서에 React 18 관련 내용 추가 필요',
        'React 18의 새로운 기능과 함께 React Query를 사용하는 방법에 대한 문서가 필요합니다. 특히 Suspense와의 통합에 대한 가이드가 있으면 좋겠습니다.',
        'docWriter789',
        'open',
        70,
        'https://github.com/tanstack/react-query/issues/1236',
        'React 18의 새로운 기능(특히 Suspense)과 React Query 통합 사용법에 대한 문서 추가 요청입니다.',
        JSON_ARRAY('documentation', 'good first issue'),
        '2023-05-14 00:00:00',
        '2023-05-15 00:00:00'
    ),
    (
        8,
        90004,
        1237,
        '캐시 무효화 API 개선',
        '특정 조건에서 캐시를 무효화하는 더 유연한 API가 필요합니다. 현재는 queryKey 기반으로만 무효화할 수 있어 제한적입니다.',
        'cacheExpert',
        'closed',
        80,
        'https://github.com/tanstack/react-query/issues/1237',
        '더 유연한 조건으로 캐시를 무효화할 수 있는 API 개선에 대한 이슈였으며, 해결되었습니다.',
        JSON_ARRAY('enhancement', 'fixed'),
        '2023-05-05 00:00:00',
        '2023-05-08 00:00:00'
    ),
    (
        9,
        90005,
        45678,
        'App Router에서 getStaticProps 대체 방법 문서화 필요',
        'Next.js 13 App Router에서 기존 Pages Router의 getStaticProps를 대체하는 방법에 대한 명확한 문서가 필요합니다. 데이터 페칭 전략에 대한 상세 가이드가 포함되면 좋겠습니다.',
        'nextUser123',
        'open',
        90,
        'https://github.com/vercel/next.js/issues/45678',
        'Next.js 13의 App Router 환경에서 Pages Router의 getStaticProps와 유사한 기능을 구현하는 방법에 대한 문서화 요청입니다.',
        JSON_ARRAY('documentation', 'app-router'),
        '2023-05-16 00:00:00',
        '2023-05-17 00:00:00'
    );
-- 챗봇 대화 데이터 삽입
INSERT INTO chat_bot_conversations (
        user_id,
        repo_id,
        created_at,
        updated_at
    )
VALUES (
        1,
        1,
        '2025-05-20 10:30:00',
        '2025-05-21 14:20:00'
    ),
    (
        1,
        3,
        '2025-05-21 09:15:00',
        '2025-05-21 16:45:00'
    ),
    (
        2,
        2,
        '2025-05-19 14:00:00',
        '2025-05-20 11:30:00'
    ),
    (
        3,
        5,
        '2025-05-18 16:20:00',
        '2025-05-19 10:15:00'
    ),
    (
        1,
        8,
        '2024-05-23 10:00:00',
        '2024-05-23 10:05:00'
    );
-- 챗봇 메시지 데이터 삽입
INSERT INTO chat_bot_messages (
        conversation_id,
        sender_type,
        content,
        timestamp
    )
VALUES (
        1,
        'User',
        'Hello World 프로젝트를 시작하는 방법을 알려주세요.',
        '2025-05-20 10:30:00'
    ),
    (
        1,
        'Agent',
        '안녕하세요! Hello World 프로젝트를 시작하려면 먼저 저장소를 클론하고 npm install을 실행해주세요.',
        '2025-05-20 10:31:00'
    ),
    (
        1,
        'User',
        '의존성 설치 후 어떤 스크립트를 실행해야 하나요?',
        '2025-05-20 10:32:00'
    ),
    (
        1,
        'Agent',
        'npm start 명령어로 개발 서버를 시작할 수 있습니다. 포트 3000에서 실행됩니다.',
        '2025-05-20 10:33:00'
    ),
    (
        2,
        'User',
        'React 훅 성능 최적화에 대해 질문이 있습니다.',
        '2025-05-21 09:15:00'
    ),
    (
        2,
        'Agent',
        'React 훅 성능 최적화는 useMemo, useCallback, React.memo를 적절히 활용하는 것이 중요합니다. 어떤 부분에 대해 궁금하신가요?',
        '2025-05-21 09:16:00'
    ),
    (
        3,
        'User',
        '리눅스 커널 빌드 방법을 알려주세요.',
        '2025-05-19 14:00:00'
    ),
    (
        3,
        'Agent',
        '리눅스 커널 빌드는 make menuconfig로 설정 후 make -j$(nproc) 명령어로 수행할 수 있습니다.',
        '2025-05-19 14:01:00'
    ),
    (
        4,
        'User',
        'VS Code 확장 개발을 시작하고 싶습니다.',
        '2025-05-18 16:20:00'
    ),
    (
        4,
        'Agent',
        'VS Code 확장 개발은 yo code 제너레이터로 시작할 수 있습니다. TypeScript 템플릿을 추천드립니다.',
        '2025-05-18 16:21:00'
    ),
    (
        5,
        'User',
        '이 프로젝트에 기여하려면 어떻게 해야 하나요?',
        '2024-05-23 10:00:00'
    ),
    (
        5,
        'Agent',
        'tanstack/react-query 프로젝트에 기여하는 방법은 다음과 같습니다:\n1. 저장소를 포크(Fork)하세요.\n2. 새 브랜치를 생성하세요 (예: feature/your-feature-name).\n3. 변경사항을 커밋하세요.\n4. 브랜치를 푸시하세요.\n5. Pull Request를 생성하세요.\n자세한 내용은 CONTRIBUTING.md 파일을 참고하세요.',
        '2024-05-23 10:01:00'
    );
-- 추천 코드 스니펫 데이터 삽입
INSERT INTO recommended_code_snippets (
        issue_id,
        file_path,
        function_name,
        class_name,
        code_snippet,
        relevance_score,
        explanation_gpt,
        created_at
    )
VALUES (
        1,
        'src/README.md',
        NULL,
        NULL,
        '## 설치 방법\n\n```bash\nnpm install\nnpm start\n```\n\n## 사용 예제\n\n```javascript\nconsole.log("Hello, World!");\n```',
        92.50,
        'README 파일 개선을 위한 설치 방법과 사용 예제 섹션입니다.',
        '2025-05-20 10:00:00'
    ),
    (
        1,
        'docs/getting-started.md',
        NULL,
        NULL,
        '# 시작하기\n\n이 프로젝트는 JavaScript 기반의 Hello World 예제입니다.\n\n### 빠른 시작\n1. 저장소 클론\n2. 의존성 설치\n3. 개발 서버 실행',
        87.25,
        '시작하기 가이드 문서의 기본 구조를 제안합니다.',
        '2025-05-20 10:05:00'
    ),
    (
        2,
        'src/hooks/useState.js',
        'optimizedUseState',
        NULL,
        'import { useState, useCallback, useMemo } from "react";\n\nexport const optimizedUseState = (initialValue) => {\n  const [value, setValue] = useState(initialValue);\n  \n  const memoizedValue = useMemo(() => value, [value]);\n  const memoizedSetter = useCallback((newValue) => {\n    setValue(newValue);\n  }, []);\n  \n  return [memoizedValue, memoizedSetter];\n};',
        95.80,
        'useState 훅의 성능을 최적화한 커스텀 훅 예제입니다. useMemo와 useCallback을 활용하여 불필요한 리렌더링을 방지합니다.',
        '2025-05-19 15:30:00'
    ),
    (
        2,
        'src/components/OptimizedComponent.jsx',
        NULL,
        'OptimizedComponent',
        'import React, { memo, useCallback } from "react";\n\nconst OptimizedComponent = memo(({ data, onUpdate }) => {\n  const handleClick = useCallback(() => {\n    onUpdate(data.id);\n  }, [data.id, onUpdate]);\n  \n  return (\n    <div onClick={handleClick}>\n      {data.name}\n    </div>\n  );\n});\n\nexport default OptimizedComponent;',
        91.35,
        'React.memo와 useCallback을 활용한 컴포넌트 최적화 예제입니다.',
        '2025-05-19 15:35:00'
    ),
    (
        3,
        'src/tensorflow/compatibility.py',
        'convert_to_tf2',
        'TensorFlowConverter',
        'import tensorflow.compat.v1 as tf1\nimport tensorflow as tf2\n\nclass TensorFlowConverter:\n    def convert_to_tf2(self, legacy_model):\n        """TensorFlow 1.x 모델을 2.x로 변환"""\n        tf1.disable_v2_behavior()\n        \n        # 레거시 세션 코드를 eager execution으로 변환\n        @tf2.function\n        def converted_function(inputs):\n            return legacy_model(inputs)\n        \n        return converted_function',
        89.60,
        'TensorFlow 1.x에서 2.x로 마이그레이션을 위한 호환성 레이어 코드입니다.',
        '2025-05-18 12:15:00'
    ),
    (
        3,
        'tests/compatibility_test.py',
        'test_tf2_compatibility',
        'CompatibilityTest',
        'import unittest\nimport tensorflow as tf\n\nclass CompatibilityTest(unittest.TestCase):\n    def test_tf2_compatibility(self):\n        """TF 2.x 호환성 테스트"""\n        # 테스트 데이터 준비\n        test_input = tf.constant([[1.0, 2.0], [3.0, 4.0]])\n        \n        # 모델 실행 및 검증\n        result = self.model(test_input)\n        self.assertIsNotNone(result)\n        \n    def setUp(self):\n        self.model = tf.keras.Sequential([\n            tf.keras.layers.Dense(10, activation="relu"),\n            tf.keras.layers.Dense(1)\n        ])',
        85.40,
        'TensorFlow 2.x 호환성을 검증하는 테스트 코드 예제입니다.',
        '2025-05-18 12:20:00'
    ),
    (
        5,
        'src/useQuery.ts',
        NULL,
        NULL,
        'export function useQuery(options) {\n  const queryClient = useQueryClient()\n  // React 훅 사용\n  const [state, setState] = React.useState()\n  \n  // 이 부분이 서버 컴포넌트에서 문제가 됨\n  React.useEffect(() => {\n    // 데이터 페칭 로직\n  }, [])\n  \n  return state\n}',
        95.00,
        'useQuery 훅의 핵심 로직으로, React.useEffect 사용 부분이 서버 컴포넌트에서 문제를 야기합니다. 이 문제를 해결하기 위해서는 Next.js 13 앱 라우터에서 "use client" 지시문을 사용하여 클라이언트 컴포넌트를 명시적으로 선언하고, 그 안에서 useQuery를 사용해야 합니다.',
        '2023-05-21 10:00:00'
    ),
    (
        6,
        'examples/nextjs/pages/index.tsx',
        NULL,
        NULL,
        '// Next.js 페이지 컴포넌트\nexport default function Home() {\n  // 클라이언트 사이드에서만 작동\n  const { data, isLoading } = useQuery({\n    queryKey: [\'todos\'],\n    queryFn: fetchTodos,\n  })\n  \n  if (isLoading) return <div>로딩 중...</div>\n  \n  return (\n    <div>\n      {data.map(todo => (\n        <div key={todo.id}>{todo.title}</div>\n      ))}\n    </div>\n  )\n}',
        85.00,
        'Next.js 페이지 컴포넌트에서 useQuery를 사용하는 예시입니다. 클라이언트 사이드에서 정상 작동하며, 서버 컴포넌트에서는 직접 fetch를 사용하거나 클라이언트 컴포넌트로 분리해야 합니다.',
        '2023-05-21 10:05:00'
    ),
    (
        7,
        'src/core/queryClient.ts',
        NULL,
        NULL,
        '// class QueryClient { ... } \n // 이 파일은 QueryClient의 핵심 로직을 담고 있으며, \n // useQuery가 내부적으로 이 클라이언트를 사용하여 상태를 관리합니다. \n // 서버 컴포넌트 호환성을 위해서는 클라이언트 인스턴스 생성 및 주입 방식을 고려해야 할 수 있습니다.',
        80.00,
        'QueryClient 핵심 로직 파일입니다. 서버 컴포넌트와의 호환성을 위해서는 QueryClient 인스턴스가 클라이언트 측에서 관리되도록 해야 합니다.',
        '2023-05-21 10:10:00'
    );
-- 저장소 언어 데이터 삽입
INSERT INTO repository_languages (
        repo_id,
        language_name,
        percentage,
        bytes_count
    )
VALUES -- octocat/Hello-World (repo_id: 1)
    (1, 'JavaScript', 85.50, 125000),
    (1, 'HTML', 10.20, 15000),
    (1, 'CSS', 4.30, 6300),
    -- torvalds/linux (repo_id: 2)
    (2, 'C', 97.80, 45000000),
    (2, 'Assembly', 1.50, 690000),
    (2, 'Shell', 0.70, 322000),
    -- facebook/react (repo_id: 3)
    (3, 'JavaScript', 88.40, 2200000),
    (3, 'TypeScript', 8.90, 221000),
    (3, 'HTML', 2.70, 67000),
    -- tensorflow/tensorflow (repo_id: 4)
    (4, 'Python', 70.30, 8500000),
    (4, 'C++', 25.60, 3100000),
    (4, 'Jupyter Notebook', 3.20, 387000),
    (4, 'Shell', 0.90, 109000),
    -- microsoft/vscode (repo_id: 5)
    (5, 'TypeScript', 80.10, 12000000),
    (5, 'JavaScript', 15.20, 2280000),
    (5, 'CSS', 3.40, 510000),
    (5, 'HTML', 1.30, 195000),
    -- vscode/Hello-World (repo_id: 6)
    (6, 'Java', 90.00, 180000),
    (6, 'XML', 8.50, 17000),
    (6, 'Gradle', 1.50, 3000),
    -- golang/go (repo_id: 7)
    (7, 'Go', 95.20, 28000000),
    (7, 'Assembly', 3.10, 912000),
    (7, 'Shell', 1.40, 412000),
    (7, 'Perl', 0.30, 88000),
    -- tanstack/react-query (repo_id: 8)
    (8, 'TypeScript', 87.30, 1750000),
    (8, 'JavaScript', 10.20, 204000),
    (8, 'CSS', 2.50, 50000),
    -- vercel/next.js (repo_id: 9)
    (9, 'JavaScript', 70.80, 8500000),
    (9, 'TypeScript', 25.40, 3050000),
    (9, 'CSS', 2.90, 348000),
    (9, 'HTML', 0.90, 108000),
    -- honggildong/my-project (repo_id: 10)
    (10, 'Python', 100.00, 25000);
-- SQL 안전 모드 재활성화
SET SQL_SAFE_UPDATES = 1;