// vitestのテスト（全体）実行前後に実施したいことを記載するファイル
import { AppDataSource } from "./src/AppDataSource";

// setup関数: 全てのテストが実行される前に一度だけ実行
export async function setup() {
  // DB接続
  if (!AppDataSource.isInitialized) {
    await AppDataSource.initialize()
      .then(() => {
        console.error("DB接続成功:");
      })
      .catch((err) => {
        console.error("DB接続失敗:", err);
      });
  }
}

// teardown関数: 全てのテストが終了された後に一度だけ実行
export async function teardown(global: any) {
  // DB切断
  if (AppDataSource.isInitialized) {
    await AppDataSource.destroy()
      .then(() => {
        console.error("DB切断成功:");
      })
      .catch((err) => {
        console.error("DB切断失敗:", err);
      });
  }
}
