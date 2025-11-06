# 백업 정보 (Backup Information)

## 백업 일시
**2025-11-05 15:38**

## 백업 내용
이 폴더는 React + Clean Architecture 마이그레이션 전 **원본 Vanilla JavaScript 웹사이트**를 보관합니다.

## 백업된 파일
- **총 파일 수**: 84개
- **총 용량**: 3.4MB
- **기술 스택**: Vanilla JavaScript, HTML5, CSS3, Supabase

## 디렉토리 구조
```
backup/
├── assets/                  # 정적 파일 (이미지, CSS)
├── components/              # Vanilla JS 컴포넌트
│   ├── base/               # 기본 컴포넌트 (버튼, 입력 등)
│   ├── data/               # 데이터 컴포넌트
│   ├── feedback/           # 알림 컴포넌트
│   ├── form/               # 폼 컴포넌트
│   ├── layout/             # 레이아웃 컴포넌트
│   └── navigation/         # 내비게이션
├── core/                    # 인프라 & 유틸리티
│   ├── config/             # Supabase, 라우트 설정
│   ├── constants/          # 앱 상수
│   ├── templates/          # HTML 템플릿
│   ├── themes/             # Toss 디자인 시스템
│   └── utils/              # 유틸리티 함수
├── pages/                   # 페이지 (HTML)
│   ├── auth/               # 인증 페이지
│   ├── dashboard/          # 대시보드
│   ├── product/            # 상품 관리
│   │   ├── inventory/      # 재고 관리 (270KB)
│   │   ├── invoice/        # 송장 관리 (429KB)
│   │   └── ...
│   ├── finance/            # 재무 관리
│   ├── employee/           # 직원 관리
│   └── settings/           # 설정
├── index.html              # 메인 엔트리 포인트
├── package.json            # Node.js 의존성
├── server.js               # Express 개발 서버
└── update-pages.js         # 페이지 생성 스크립트
```

## 주요 특징
- **Supabase 연동**: 인증 및 데이터베이스
- **Toss 디자인 시스템**: UI/UX 컴포넌트
- **Apache (XAMPP) 환경**: 로컬 개발

## ⚠️ 알려진 문제점
1. **파일 크기 초과**: 일부 HTML 파일 270-429KB (권장: 50KB 이하)
2. **인라인 코드**: HTML 파일에 CSS/JS 인라인으로 포함
3. **Clean Architecture 미적용**: 도메인/데이터/프레젠테이션 레이어 분리 없음
4. **컴포넌트 재사용 어려움**: Vanilla JS 클래스 기반

## 복구 방법 (필요시)
```bash
# backup 폴더에서 website 루트로 복구
cd /Applications/XAMPP/xamppfiles/htdocs/mysite/mystorecluade/website
cp -r backup/* .
rm -rf backup/  # 선택사항
```

## 참고 문서
- [ARCHITECTURE.md](../docs/ARCHITECTURE.md) - 원래 아키텍처 가이드
- [마이그레이션 계획] - React + Clean Architecture 전환 계획

---

**⚠️ 중요**: 이 백업 폴더는 **절대 수정하지 마세요**. 마이그레이션 실패 시 복구용입니다.
