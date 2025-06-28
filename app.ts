import * as dotenv from "dotenv";
dotenv.config();
console.log("▶ app.ts started");

import express from "express";
import cors from "cors";
import { AppDataSource } from "./src/AppDataSource";
import {
  throwValidationError,
  createNotFoundMessage,
} from "./src/util/ErrorUtils";
import { HttpError } from "./src/error/HttpError";
import { HttpStatus } from "./src/constants/HttpStatus";
import { GetOneUserService } from "./src/service/user/GetOneUserService";
import { CreateUserService } from "./src/service/user/CreateUserService";

const app = express();

// CORS周りの設定
const corsOptions = {
  origin: "http://localhost:3000", // 許可するオリジン
  methods: "GET,HEAD,PUT,PATCH,POST,DELETE", // 許可するHTTPメソッド
  credentials: true, // Cookieなどの認証情報を許可するか
  allowedHeaders: "Content-Type,Authorization", // 許可するリクエストヘッダー
};
app.use(cors(corsOptions));

const getOneUserService = new GetOneUserService();
const createUserService = new CreateUserService();

app.listen(Number(process.env.PORT), () => {
  console.log(`Server listening on port ${process.env.PORT}`);
});

// このミドルウェアを使わないとボディがパースされない
app.use(express.json());

// ヘルスチェック
app.get("/health", (req, res) => {
  res.send("Hello Kusogaki!");
});

// DB接続
AppDataSource.initialize()
  .then(() => {
    // DB接続チェック
    app.get("/health/db", (req, res) => {
      res.send("DB is Healthy!");
    });
    // 以下、APIエンドポイントたち

    // ユーザー情報取得（1件）API
    app.get("/user/:id", async (req, res, next) => {
      try {
        // バリデーション確認
        const validationErrors = await getOneUserService.validate(req.params);
        if (validationErrors.length > 0) throwValidationError(validationErrors); // バリデーションエラーをthrow！

        // 本処理
        const userId = parseInt(req.params.id);
        const result = await getOneUserService.getOneUserById(userId);

        // レスポンスを返す（ユーザーが見つからなかった場合は、404を返す）
        Object.keys(result).length > 0
          ? res.status(HttpStatus.OK.code).json(result)
          : res
              .status(HttpStatus.NOT_FOUND.code)
              .json(
                createNotFoundMessage(
                  `指定したid(id : ${userId})のユーザーが見つかりませんでした`
                )
              );
      } catch (err) {
        next(err);
      }
    });

    // ユーザー登録API
    app.post("/user", async (req, res, next) => {
      try {
        // バリデーション確認
        const validationErrors = await createUserService.validate(req.body);
        if (validationErrors.length > 0) throwValidationError(validationErrors); // バリデーションエラーをthrow！

        // 本処理
        const result = await createUserService.createUser(req.body);

        // レスポンスを返す
        res.status(HttpStatus.OK.code).json(result);
      } catch (err) {
        next(err);
      }
    });

    // エラー処理用ミドルウェア
    app.use((err: HttpError, req, res, next) => {
      console.error(err);
      return res
        .status(err.statusCode)
        .json({ message: err.message, detail: err.detail });
    });
  })
  .catch((err) => {
    console.error("DB接続失敗:", err);
  });
