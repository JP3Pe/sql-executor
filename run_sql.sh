#/bin/bash
# 스크립트의 목적: mysql 명령 실행 후 반환값에 따라 Slack messenger를 호출하는 API 실행
output_file_name="./output.txt"

mysql -u root -h host.docker.internal --port=3306 --password=example < ./init.sql 2> "$output_file_name"
output="$(cat "$output_file_name")"

output_first_line=$(echo "$output" | head -n 1)
db_error_message=$(echo "$output" | head -n 2 | tail -1)

echo "First line: $output_first_line"
echo "SQL output: $db_error_message"

rm -rf "$output_file_name"