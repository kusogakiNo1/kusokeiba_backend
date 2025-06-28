-- mysqlの認証方式を、8.0以前のものに変更
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'root';
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';

-- テーブル作成＆初期データ投入
-- usersテーブル
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,            -- 主キー、オートインクリメント
    name VARCHAR(20) NOT NULL,                 -- ユーザー名（20文字以内、NULL不可）
    email VARCHAR(255) NOT NULL UNIQUE,            -- メールアドレス（ユニーク、NULL不可）
    password VARCHAR(255) NOT NULL,                -- パスワード（NULL不可）
    age INT CHECK (age >= 0),                     -- 年齢（18歳以上、MySQL 8.0以降）
    deleted_flag TINYINT(1) DEFAULT 0,              -- 削除フラグ（0:削除されていない、1:削除されている、デフォルトは0）
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 作成日時（デフォルトは現在のタイムスタンプ）
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 更新日時（更新時に自動的に更新）
    deleted_at TIMESTAMP NULL,                     -- 削除日時（NULLの場合は削除されていない）
    CONSTRAINT email_format CHECK (email LIKE '%@%.%') -- メールアドレスの形式チェック（簡易的なチェック）
);

INSERT INTO users (name, email, password, age)
VALUES
('kusogakiRoot', 'verykusogackie12345@gmail.com', 'shitchildren950950', 25),
('numasaka', 'numa4545@gmail.com', 'numany', 25),
('ezaki', 'princeZeacky@zeus.chu', '0725', 25);

-- placesテーブル
CREATE TABLE places (
  id INT AUTO_INCREMENT PRIMARY KEY,
  place_type TINYINT(2) NOT NULL COMMENT '場所のジャンル（0:レース開催地, 1:トレーニングセンター, 2:その他）',
  name VARCHAR(15) NOT NULL COMMENT '場所の名前',
  address VARCHAR(255) NOT NULL COMMENT '場所の住所',
  deleted_flag TINYINT(1) DEFAULT 0 COMMENT '削除フラグ',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
  deleted_at TIMESTAMP NULL DEFAULT NULL COMMENT '削除日時'
);

INSERT INTO places (place_type, name, address)
VALUES
(0, '二子玉川河川敷', ''),
(0, '金沢城公園', ''),
(0, '早明浦ダム', ''),
(1, '用賀トレーニングセンター', ''),
(1, '一之江トレーニングセンター', ''),
(1, '西宮北口トレーニングセンター', ''),
(1, '天竺トレーニングセンター', ''),
(1, '明石トレーニングセンター', ''),
(2, '安路都', ''),
(2, '天竺', '');

-- race_basic_informationsテーブル
CREATE TABLE race_basic_informations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  grade TINYINT(1) NOT NULL COMMENT 'レースのグレード（0:G1, 1:G2, 2:G3, 3:L, 4:O, 5:3勝, 6:2勝, 7:1勝, 8:未勝利, 9:新馬）',
  name VARCHAR(30) NOT NULL COMMENT 'レース名',
  place_id INT NOT NULL COMMENT '開催場所ID（placesテーブルの外部キー）',
  race_number INT NOT NULL COMMENT '第何レースか',
  track_type INT NOT NULL COMMENT 'トラックの種類（0:芝, 1:ダート, 2:障害, 3:アスファルト）',
  distance INT NOT NULL COMMENT '距離（メートル）',
  start_time VARCHAR(10) NOT NULL COMMENT '発走時刻（例: 15:40）',
  deleted_flag TINYINT(1) DEFAULT 0 COMMENT '削除フラグ',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
  deleted_at TIMESTAMP NULL DEFAULT NULL COMMENT '削除日時',
  CONSTRAINT fk_place FOREIGN KEY (place_id) REFERENCES places(id)
);

INSERT INTO race_basic_informations (grade, name, place_id, race_number, track_type, distance, start_time)
VALUES
(2, 'クソガキサマーダッシュ', 1, 12, 0, 50,'16:00'),
(0, '野々市優駿', 2, 11, 0, 200,'15:30'),
(2, '早明浦記念', 3, 1, 3, 150,'16:30'),
(0, 'よしかずの宮杯', 1, 1, 0, 400,'16:00');

-- race_detailsテーブル
CREATE TABLE race_details (
  id INT AUTO_INCREMENT PRIMARY KEY,
  race_basic_info_id INT NOT NULL COMMENT 'race_basic_informationsテーブルの外部キー',
  date DATE NOT NULL COMMENT 'レース開催日',
  climate TINYINT(1) NOT NULL COMMENT '天気（0:晴, 1:曇, 2:小雨, 3:雨, 4:小雪, 5:雪, 6:虹）',
  track_condition TINYINT(1) NOT NULL COMMENT '馬場状態（0:良, 1:稍重, 2:重, 3:不良）',
  winning_time FLOAT DEFAULT NULL COMMENT '1着馬のタイム（秒単位）',
  deleted_flag TINYINT(1) DEFAULT 0 COMMENT '削除フラグ',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
  deleted_at TIMESTAMP NULL DEFAULT NULL COMMENT '削除日時',
  CONSTRAINT fk_race_basic_info FOREIGN KEY (race_basic_info_id) REFERENCES race_basic_informations(id)
);

INSERT INTO race_details (race_basic_info_id, date, climate, track_condition, winning_time)
VALUES
(1, '2021-07-25', 0, 0, 10.0),
(2, '2021-09-20', 0, 0, 13.0),
(3, '2021-10-10', 1, 0, 30.0),
(4, '2025-05-25', 0, 0, null);

-- horsesテーブル
CREATE TABLE horses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(20) NOT NULL COMMENT '馬の名前',
  birthday DATE COMMENT '馬の誕生日',
  sex TINYINT(1) COMMENT '性別（0:牡, 1:牝, 2:セン馬）',
  running_style TINYINT(1) COMMENT '脚質（0:逃げ, 1:先行, 2:差し, 3:追い込み, 4:自由自在）',
  training_center_id INT COMMENT '所属トレセンID（training_centersテーブルの外部キー）',
  retired_flag TINYINT(1) DEFAULT 0 COMMENT '引退フラグ（0:現役, 1:引退）',
  deleted_flag TINYINT(1) DEFAULT 0 COMMENT '削除フラグ',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
  deleted_at TIMESTAMP NULL DEFAULT NULL COMMENT '削除日時',
  CONSTRAINT fk_training_center_id FOREIGN KEY (training_center_id) REFERENCES places(id)
);

INSERT INTO horses (name, birthday, sex, running_style, training_center_id)
VALUES
('Agostino Steffani', '1999/12/27', 0, 2, 4),
('チンチンカイカイ', '1999/08/17', 0, 2, 5),
('カルテスピリッツ', '1999/07/25', 0, 1, 7),
('デスヴォイス', '1999/08/29', 0, 3, 6),
('メッチャゴーラ', '1999/05/03', 0, 1, 8);

-- race_tesultsテーブル
CREATE TABLE race_results (
  id INT AUTO_INCREMENT PRIMARY KEY,
  horse_id INT NOT NULL COMMENT 'horsesテーブルの外部キー（馬の情報）',
  race_id INT NOT NULL COMMENT 'racesテーブルの外部キー（レースの情報）',
  horse_number INT NOT NULL COMMENT '馬の、レースにおける馬番',
  weight FLOAT NOT NULL COMMENT '馬の、そのレース時の体重',
  popularity INT NOT NULL COMMENT '馬の、レースにおける人気順',
  odds FLOAT NOT NULL COMMENT '馬の、レースにおける単勝オッズ',
  finish_position INT DEFAULT NULL COMMENT '馬の、レースにおける着順',
  finish_time FLOAT DEFAULT NULL COMMENT '馬が、そのレースでゴールするまでにかかった秒数',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',
  CONSTRAINT fk_horse FOREIGN KEY (horse_id) REFERENCES horses(id),
  CONSTRAINT fk_race FOREIGN KEY (race_id) REFERENCES race_details(id)
);

-- commentsテーブル
CREATE TABLE comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    horse_id INT,
    race_id INT,
    comment TEXT NOT NULL,
    deleted_flag TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (horse_id) REFERENCES horses(id),
    FOREIGN KEY (race_id) REFERENCES race_details(id),
    CHECK (
        (horse_id IS NOT NULL AND race_id IS NULL) OR 
        (horse_id IS NULL AND race_id IS NOT NULL)
    )
);