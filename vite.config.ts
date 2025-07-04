// vite.config.ts
import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    environment: "node", // Node.js環境でテストを実行
    globals: true, // JestのようなグローバルAPI (describe, test, expectなど) を有効にする
    globalSetup: "./vitest.globalSetup.ts", // オプション: 全テストファイルで共通の前処理を定義する場合
    // その他の設定...
  },
});
