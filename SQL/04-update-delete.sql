-- 04-update-delete.sql

SELECT * FROM members;

-- Update (데이터 수정)
UPDATE members SET name='체밍석', email='seok@a.com' WHERE id=2;
-- 원치 않는 케이스 (name이 같으면 동시 수정)
UPDATE members SET name='No name' WHERE name='홍길동';

-- Delete (데이터 삭제)
DELETE FROM members WHERE id=7;
-- 테이블 모든 데이터 삭제 (위험)
DELETE FROM members;
