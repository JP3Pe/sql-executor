# SQL Executor
## 프로그램의 목적
쿠버네티스에서 동작하는 DB 환경은 외부에서 접속이 불가능해 내부망 IP 주소를 사용해 원하는 MySQL 쿼리를 실행할 수 있는 MySQL 컨테이너 생성

## 프로그램 동작 방식
1. DB에서 실행을 원하는 SQL 쿼리를 작성한다.
2. 1번에서 작성한 sql 파일을 Dockerfile 파일을 사용해 Docker image 내부의 특정 위치로 이동한다.
3. Dockerfile 내 SQL을 실행할 웹 서버의 IP, Port, DB 등의 정보를 하드코딩한다.
4. Docker image 사용해 컨테이너 실행 시 설정한 DB에 설정한 SQL 실행 후 컨테이너 삭제

## 명령어 예시
### 이미지 빌드
```
docker build -t rlaworhkd430/sql-executor .
```

### 컨테이너 실행(SQL 실행)
```
docker run --rm -it -e MYSQL_ROOT_PASSWORD=example rlaworhkd430/sql-executor
```

## 관련 사이트 링크
[Docker hub](https://hub.docker.com/repository/docker/rlaworhkd430/sql-executor)

## TODO(택1 혹은 기타)
* 하드코딩된 DB 정보 shell script 실행 시 파라미터 형식으로 입력
* 특정 API Body 내 파리미터로 호출 해 줄 경우 해당 값 사용