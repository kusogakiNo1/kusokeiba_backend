import { IsDefined, IsNotEmpty, IsNumber } from "class-validator";
import { Transform } from "class-transformer";

// ユーザー情報取得（1件）APIのバリデーションを定義

export class GetOneUserValidation {
  // idはパスパラメータなので、nullやundefinedの状態でバリデーション処理まで来ることはないかも。。。。
  // とはいえ一応、nullやundefinedの時のバリデーションもチェックしておく
  @Transform(({ value }) =>
    value !== undefined && value !== null && value !== ""
      ? Number(value)
      : value
  )
  @IsDefined({ message: "idがundefinedです。idを指定してください。" })
  @IsNotEmpty({ message: "idがnullもしくは空白です。idを指定してください。" })
  @IsNumber({}, { message: "idは数字で指定してください" })
  id!: number;
}
