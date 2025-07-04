import { describe, beforeAll, afterAll, expect, test } from "vitest";
import request from "supertest";
import { app } from "../../app";
import { AppDataSource } from "../../src/AppDataSource";

describe("ユーザー情報取得(1件)API テスト", () => {
  beforeAll(async () => {
    // すべてのテストケースの前に実行される処理
    // DB接続
    if (!AppDataSource.isInitialized) {
      await AppDataSource.initialize().catch((err) => {
        console.error("DB接続失敗:", err);
      });
    }
  });

  afterAll(async () => {
    // すべてのテストケースの後に実行される処理
    // DB切断
    if (AppDataSource.isInitialized) {
      await AppDataSource.destroy().catch((err) => {
        console.error("DB切断失敗:", err);
      });
    }
  });

  // describe("バリデーションテスト", () => {});
  describe("レスポンステスト", () => {
    test("存在するユーザーidを指定し、200が返ってくることの確認", async () => {
      const response = await request(app).get("/user/1");

      expect(response.status).toStrictEqual(200);
      expect(response.body).toEqual({
        id: 1,
        name: "kusogakiRoot",
        email: "verykusogackie12345@gmail.com",
        age: 25,
        deletedFlag: false,
      });
    });
    test("存在しないユーザーidを指定し、404が返ってくることの確認", async () => {
      const response = await request(app).get("/user/1213");

      expect(response.status).toStrictEqual(404);
      expect(response.body).toEqual({
        message: "Not Found",
        detail: "指定したid(id : 1213)のユーザーが見つかりませんでした",
      });
    });
  });
});
