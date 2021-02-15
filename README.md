# Terraform Sample

## 使用方法

個別リソースで操作していく。

```bash
# 個別のリソースのterraform 初期化
$ cd [対象リソース]/[環境]
$ terraform init -backend-config=backend.tf ..

# 個別のリソースの設定確認
$ cd [対象リソース]/[環境]
$ terraform validate ..

# 個別のリソースの差分確認
$ cd [対象リソース]/[環境]
$ terraform plan ..

# 個別のリソースの適用
$ cd [対象リソース]/[環境]
$ terraform apply ..

# 個別のリソースの削除
$ cd [対象リソース]/[環境]
$ terraform destroy ..
```

## 構成

```bash
$ tree -L 3
.
└── [AWSサービス単位] # 作成する AWS サービス名（ex. xxx-vpc, xxx-lb, xxx-dynamodb,,,)
    ├── dev    # 環境差分用ディレクトリ（必要分だけ作成）
    │   ├── backend.tf       # tfstate ファイルを保存する S3 bucket/key/region 情報を代入
    │   └── terraform.tfvars # variables.tf で定義した変数へ値を代入
    ├── tst
    │   ├── backend.tf
    │   └── terraform.tfvars
    ├── prd
    │   ├── backend.tf
    │   └── terraform.tfvars
    ├── backend.tf   # tfstate ファイルを保存する情報、date terraform_remote_state の必要情報を定義
    ├── main.tf      # resource の設定を記載
    ├── outputs.tf   # outputし、他のリソースから tfstate ファイル経由で参照されるデータを記載
    ├── provider.tf  # aws などの provider 情報を記載
    ├── variables.tf # local、variables などの変数を記載
    └── versions.tf  # terraform のバージョンを記載
```

## 設計

### 共通

- AWSサービス単位(Elasticache、DynamoDB等)でディレクトリを切り、dev/tst/prd環境で命名以外の環境差分が出ないようにする
- 環境(dev/tst/prdなど)毎にディレクトリを切り、 `backend.tf` と `terraform.tfvars` を作成する
- 意図しない構成差分を発生させない為に各リソース内の `variables.tf` 内の変数の値は原則空白とし、環境毎に作成したディレクトリ内の `terraform.tfvars` にて、変数の値を代入する
- `resource` の `name` 属性は記載せず、 `Name` tag で名称を付与する

### sample-vpc

- VPCに割り当てるセグメントは `10.0.0.0/16`
  - 以下のIPはカッコの用途のため利用できない（前4つと最後1つ）
    - `10.0.0.0`（ネットワークアドレス）
    - `10.0.0.1`（VPC ルーター）
    - `10.0.0.2`（DNS へのマッピング用）
    - `10.0.0.3`（将来の利用のためにAWSで予約）
    - `10.0.255.255` （ネットワークブロードキャストアドレス）
- サブネットは冗長化のため2つ利用し、セグメントはそれぞれ以下
  - Public サブネット AZ-A: `10.0.0.0/24`
  - Public サブネット AZ-A: `10.0.1.0/24`
  - Public サブネット AZ-A: `10.0.2.0/24`
  - Protected サブネット AZ-A: `10.0.64.0/24`
  - Protected サブネット AZ-A: `10.0.65.0/24`
  - Protected サブネット AZ-A: `10.0.66.0/24`
  - Private サブネット AZ-A: `10.0.128.0/24`
  - Private サブネット AZ-A: `10.0.129.0/24`
  - Private サブネット AZ-A: `10.0.130.0/24`
- なお、Public/Protected/Privateの意味は以下の通り
  - Public：インターネットゲートウェイ指定のあるサブネット。LB置き場。
  - Protected：NAT経由でインターネット接続できるサブネット。AP置き場。Public サブネットからのみアクセスを許可。
  - Private：インターネットゲートウェイもNAT経由の指定のないサブネット。DB置き場。Protected サブネットからのみ接続を許可。

## 接続

EC2 へのアクセスは SSM Login を行うため、 Session Manager Plugin の導入が必要。

```bash
$ brew install --cask session-manager-plugin
```

以下でアクセス。

```bash
$ aws ssm start-session --target "i-xxxxxxxxxxxxxxxxx"
```