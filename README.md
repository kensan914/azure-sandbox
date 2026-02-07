# azure-sandbox

## 概要 (Overview)
`azure-sandbox` は、Azureのクラウドインフラ—特にネットワーク設計と Azure App Service —を実践的に学ぶための個人学習・検証プロジェクトである。
本プロジェクトでは、単なるチュートリアルではなく「実務に近い構成」を小さく再現し、設計・構築・運用・IaC化まで一貫して経験することを目的とする。

---
## 目的 (Purpose)
本プロジェクトの主な目的は以下のとおり。
- Azureの主要サービス（特にネットワークと App Service）の実践的理解を深めること
- Hub/Spoke を中心とした標準的なクラウドアーキテクチャを手で構築できるようになること
- 「動くサンプル」ではなく「設計できる力」を身につけること
- 最終的に Terraform（IaC）でインフラを再現可能にすること
---
## 学習要件
- **Azure App Service を利用すること**
  - Python（FastAPI）によるシンプルな Web API をホストする。
- **データベースは使用しないこと**
  - 学習の焦点をインフラとネットワークに絞る。
- **Hub/Spoke 型のネットワーク構成を採用すること**
  - よくあるエンタープライズ構成を理解し、実装できるようにする。
- **基本的にプライベートネットワークで閉じること**
  - App Service は原則として Private Endpoint 経由で接続する。
- **Webエンドポイントのみを安全に公開すること**
  - Azure Front Door または Application Gateway を入口にする。
- **踏み台（Jump Server）を用意すること**
  - Azure Bastion 経由で踏み台VMに接続し、そこから App Service の保守作業ができる環境を整える。
## 学習スコープ（本プロジェクトで扱うこと）
- VNet設計（CIDR、サブネット設計）
- Hub/Spoke アーキテクチャ
- Private Endpoint の仕組みと実装
- Azure App Service のネットワーク設定
- Azure Bastion と踏み台運用
- Azure Firewall の基本概念
- 最終的な Terraform 化（IaC）
## 学習しないこと（Non-Goals）
本プロジェクトでは以下は主目的としない。
- 複雑なアプリケーション開発
- データベース設計・運用
- 大規模トラフィック設計
- マルチリージョン構成
（必要に応じて将来拡張は可）
---
## アプリケーション（仮）
- **技術スタック**：Python 3.14 + FastAPI + uv
- **API仕様（想定）**：
```
GET /
→ { "message": "Hello Azure Sandbox" }

GET /health
→ { "status": "healthy" }
```

### ローカル開発
```bash
# Docker Composeで起動
docker-compose up -d

# APIの動作確認
curl http://localhost:8000/
curl http://localhost:8000/health

# ログ確認
docker-compose logs -f

# 停止
docker-compose down
```

### App Service 方針
- **コンテナ化は現時点では行わない**（PaaSとしての App Service を学ぶ）
    - ただし**将来的にコンテナ化へ移行する可能性がある**
- **デプロイは GitHub から行う**（App Service の GitHub 連携を利用）
- **将来的に GitHub Actions による CI/CD を構築する**
- **カスタムドメイン設定を実施する**
- **SSL証明書を設定し HTTPS で提供する**
- **スケール設定は優先度が低い**（当面は既定値）
