# Terraform Sample

## 使用方法

個別リソースで操作していく。

```bash
# 個別のリソースのterraform 初期化
$ cd [対象リソース]/[環境]
$ terraform init -backend-config=backend.tf ..

# 個別のリソースの差分確認
$ cd [対象リソース]/[環境]
$ terraform plan ..

# 個別のリソースの適用
$ cd [対象リソース]/[環境]
$ terraform apply ..
```