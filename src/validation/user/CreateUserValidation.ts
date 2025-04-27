import {
  IsDefined,
  IsNotEmpty,
  Length,
  IsNumber,
  IsEmail,
  Min,
  Matches,
} from "class-validator";

// ユーザー作成APIのバリデーションを定義

export class CreateUserValidation {
  @IsDefined({ message: "ユーザー名が入力されていません" })
  @IsNotEmpty({ message: "ユーザー名が入力されていません" })
  @Length(1, 20, {
    message: "ユーザー名は1文字以上20文字以下で入力してください",
  })
  username!: string;

  @IsDefined({ message: "メールアドレスが入力されていません" })
  @IsNotEmpty({ message: "メールアドレスが入力されていません" })
  @Length(1, 255, {
    message: "メールアドレスは255文字以下のものにしてください",
  })
  @IsEmail({}, { message: "メールアドレスの形式が間違っています" })
  email!: string;

  @IsDefined({ message: "パスワードが入力されていません" })
  @IsNotEmpty({ message: "パスワードが入力されていません" })
  @Length(8, 255, {
    message: "パスワードは8文字以上255文字以下にしてください",
  })
  @Matches(/^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z0-9]{8,255}$/, {
    message:
      "パスワードは数字と半角英字の両方を用いるようにしてください。また、それ以外の記号は用いないでください",
  })
  password!: string;

  @IsDefined({ message: "年齢が入力されていません" })
  @IsNotEmpty({ message: "年齢が入力されていません" })
  @IsNumber({}, { message: "年齢が数字ではありません" })
  @Min(0, { message: "年齢が負の数になっています" })
  age!: number;
}
