#!/bin/bash

# 색깔 변수 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Sonic 데일리 퀘스트 스크립트를 시작합니다...${NC}"

# 작업 디렉토리 설정
work="/root/sonic-all"

# 작업 디렉토리 삭제 (존재할 경우)
if [ -d "$work" ]; then
    echo -e "${YELLOW}기존 작업 디렉토리를 삭제합니다...${NC}"
    rm -rf "$work"
fi

# 파일 다운로드 및 덮어쓰기
echo -e "${YELLOW}필요한 파일들을 다운로드합니다...${NC}"

# Git 설치
echo -e "${YELLOW}Git을 설치합니다...${NC}"
sudo apt install -y git

# Git 클론
echo -e "${YELLOW}Git 저장소 클론 중...${NC}"
git clone https://github.com/KangJKJK/sonic-all

# 작업 디렉토리 이동
echo -e "${YELLOW}작업디렉토리를 이동합니다...${NC}"
cd "$work"

# nvm 설치
echo -e "${YELLOW}nvm을 설치합니다...${NC}"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# nvm 환경 설정
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # nvm script 로드
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # nvm bash_completion 로드

# Node.js LTS 버전 설치
echo -e "${YELLOW}Node.js LTS 버전을 설치합니다...${NC}"
cd "$work"
nvm install --lts
nvm use --lts
npm install -g npm@latest

# Node.js 모듈 설치
echo -e "${YELLOW}필요한 Node.js 모듈을 설치합니다...${NC}"
sudo apt-get install -y npm
sudo npm install -g npm@latest

# 빌드 도구 설치
echo -e "${YELLOW}필요한 빌드 도구를 설치합니다...${NC}"
sudo apt-get install -y build-essential
sudo npm install -g node-gyp

# Node.js 모듈 설치 및 네이티브 모듈 빌드
echo -e "${YELLOW}필요한 Node.js 모듈을 설치하고 네이티브 모듈을 빌드합니다...${NC}"
npm install
npm rebuild

# 개인키 입력받기
read -p "Solana의 개인키를 쉼표로 구분하여 입력하세요: " privkeys

# 개인키를 파일에 저장
echo "$privkeys" > "$work/private.txt"

# 파일 생성 확인
if [ -f "$work/private.txt" ]; then
    echo -e "${GREEN}개인키 파일이 성공적으로 생성되었습니다.${NC}"
else
    echo -e "${RED}개인키 파일 생성에 실패했습니다.${NC}"
fi

# sonic.js 스크립트 실행
echo -e "${GREEN}sonic.js 스크립트를 실행합니다...${NC}"
node --no-deprecation sonic.js

echo -e "${GREEN}모든 작업이 완료되었습니다. 컨트롤+A+D로 스크린을 종료해주세요.${NC}"
echo -e "${GREEN}스크립트 작성자: https://t.me/kjkresearch${NC}"
