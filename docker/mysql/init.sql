-- mysqlの認証方式を、8.0以前のものに変更
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'root';
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';

-- テーブル作成＆初期データ投入
-- usersテーブル
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,            -- 主キー、オートインクリメント
    username VARCHAR(20) NOT NULL,                 -- ユーザー名（20文字以内、NULL不可）
    email VARCHAR(255) NOT NULL UNIQUE,            -- メールアドレス（ユニーク、NULL不可）
    password VARCHAR(255) NOT NULL,                -- パスワード（NULL不可）
    age INT CHECK (age >= 18),                     -- 年齢（18歳以上、MySQL 8.0以降）
    delete_flag TINYINT(1) DEFAULT 0,              -- 削除フラグ（0:削除されていない、1:削除されている、デフォルトは0）
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 作成日時（デフォルトは現在のタイムスタンプ）
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 更新日時（更新時に自動的に更新）
    deleted_at TIMESTAMP NULL,                     -- 削除日時（NULLの場合は削除されていない）
    CONSTRAINT email_format CHECK (email LIKE '%@%.%') -- メールアドレスの形式チェック（簡易的なチェック）
);

INSERT INTO users (username, email, password, age)
VALUES
('kusogakiRoot', 'verykusogackie12345@gmail.com', 'shitchildren950950', 25),
('numasaka', 'numa4545@gmail.com', 'numany', 25),
('ezaki', 'princeZeacky@zeus.chu', '0725', 25);
