# Belf SQL Executor
## 프로그램의 목적
Belf의 service DB는 외부에서 접속이 불가능하다.
Dev DB 에서 스키마의 변경이 일어날 경우 관련 SQL 내부망에서 실행할 수 있는 수단이 필요하다.
**스키마를 변경하는 SQL을 실행**하는 Docker container를 생성해 해당 작업을 수행한 다음 결과를 Slack 메신저로 전달받는다.
## 프로그램 동작 방식
1. 개발자가 실행을 원하는 쿼리를 작성한다. 작성되는 쿼리는 **실행 가능한 경우**와 **가능하지 않은 경우**에 대한 코드를 *if*, *else* 구문 등으로 포함해야한다.
예: DB Table 생성 시 기존 테이블이 존재하는 경우와 존재하지 않는 경우, Table 컬럼 명을 변경하는데 변경할 컬럼이 존재하는 경우와 존재하지 않는 경우
2. 스키마 변경에 관한 SQL 코드를 feature 브랜치에 커밋 후 해당 브랜치를 master 브랜치에 **pull request** 한다.
3. 팀원들이 커밋된 SQL 코드에 이상이 없는 경우 pull request를 승낙해 master 브랜치에 **merge** 한다.
4. CI 서버가 master 브랜치에 새로은 커밋이 push 된 것을 **확인**한다.
5. CI 서버가 CD 서버에게 새로운 커밋을 기준으로 Docker image를 **생성하라는 명령**을 내린다.[Docke image 생성방식](#Docker-image-생성-방식) 참고
6. CI 서버가 CD 서버에게 새로운 Docker image를 기반으로 컨테이너를 **실행하라는 명령**을 내린다.[Docker container 작동 방식](#Docker-container-작동-방식) 참고
7. Slack 메신저를 통해서 SQL 실행 결과를 확인한다.

### Docker image 생성 방식
1. SQL 파일을 MySQL Docker image 내부에 복사한다.
2. Service DB 서버의 IP, Port 정보를 CD 서버(K8S)의 환경변수를 사용해 입력한다.
3. Docker image를 빌드한다.

### Docker container 작동 방식
1. mysql 명령어를 제어하는 [shell script](#mysql-명령어-핸들링-shell-script)를 사용해 sql 구문을 실행한다.
2. sql 수행 결과를 Slack message를 통해 전달받는다.

#### mysql 명령어 핸들링 shell script
빌드된 Docker image 내부에는 mysql 명령 실행 후 반환값을 핸들링하는 shell script가 존재한다.
shell script는 명령 실행 후 반환 결과를 저장한다.

- 반환 결과가 True(1) 인 경우 SQL 코드가 문제없이 실행 되었다는 Slack message 관련 API HTTP 요청을 수행한다.
- 반환 결과가 False(0) 인 경우 SQL 코드 실행에 문제가 생겼다는 메세지를 SQL 실행 후 SQL 실행 후 출력값과 함께 Slack message 관련 API HTTP 요청을 수행한다.

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