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

## アーキテクチャ

```
Internet
  │
  ▼
┌──────────────────────────┐
│  Azure Front Door /      │
│  Application Gateway     │
└────────┬─────────────────┘
         │ (HTTPS)
         ▼
┌──────────────────────────┐    Private Endpoint     ┌──────────────────────────┐
│  App Service (Web)       │ ──────────────────────► │  App Service (API)       │
│  Next.js フロントエンド   │                          │  FastAPI バックエンド      │
│  ※ 外部公開              │                          │  ※ プライベートネットワーク │
└──────────────────────────┘                          └──────────────────────────┘
                                                               ▲
┌──────────────────────────┐                                   │
│  Azure Bastion           │                                   │
│  → 踏み台VM              │ ── SSH ──────────────────────────┘
│                          │ ── SSH ──► App Service (Web) にも接続可
└──────────────────────────┘
```

### 構成要素
| コンポーネント | 技術スタック | ネットワーク | 役割 |
|---|---|---|---|
| **フロントエンド** | Next.js (App Router) + TypeScript | App Service（外部公開） | API の結果を表示する Web UI |
| **バックエンド API** | Python 3.14 + FastAPI + uv | App Service（Private Endpoint、非公開） | REST API を提供 |
| **踏み台サーバー** | Azure Bastion + VM | Hub VNet | SSH で各 App Service の保守・デバッグ |
| **エントリポイント** | Azure Front Door / Application Gateway | - | HTTPS の入口、WAF |

### ネットワーク設計方針
- **Hub/Spoke 型ネットワーク構成**を採用
- **API（FastAPI）は外部公開しない** — Private Endpoint 経由でのみアクセス可能
- **フロントエンド（Next.js）は外部公開** — Front Door / Application Gateway 経由でユーザーにサービス提供
- **踏み台サーバー（Azure Bastion + VM）** を経由して、フロントエンド・API 両方の App Service に SSH 接続可能

---
## 学習要件
- **Azure App Service を2つ利用すること**
  - フロントエンド：Next.js による Web UI をホスト
  - バックエンド：Python（FastAPI）による Web API をホスト
- **データベースは使用しないこと**
  - 学習の焦点をインフラとネットワークに絞る。
- **Hub/Spoke 型のネットワーク構成を採用すること**
  - よくあるエンタープライズ構成を理解し、実装できるようにする。
- **API はプライベートネットワークで閉じること**
  - API の App Service は Private Endpoint 経由でのみ接続する。
- **Web エンドポイントのみを安全に公開すること**
  - Azure Front Door または Application Gateway を入口にする。
- **踏み台（Jump Server）を用意すること**
  - Azure Bastion 経由で踏み台VMに接続し、そこからフロントエンド・API 両方の App Service に SSH で保守作業ができる環境を整える。

## 学習スコープ（本プロジェクトで扱うこと）
- VNet設計（CIDR、サブネット設計）
- Hub/Spoke アーキテクチャ
- Private Endpoint の仕組みと実装
- Azure App Service のネットワーク設定（VNet統合、Private Endpoint）
- Azure Bastion と踏み台運用
- Azure Firewall の基本概念
- App Service への SSH 接続（踏み台経由）
- 最終的な Terraform 化（IaC）

## 学習しないこと（Non-Goals）
本プロジェクトでは以下は主目的としない。
- 複雑なアプリケーション開発
- データベース設計・運用
- 大規模トラフィック設計
- マルチリージョン構成

（必要に応じて将来拡張は可）

---
## プロジェクト構成

```
azure-sandbox/
├── api/                  # FastAPI バックエンド
│   ├── main.py
│   ├── pyproject.toml
│   └── Dockerfile
├── web/                  # Next.js フロントエンド
│   ├── src/
│   │   └── app/
│   │       ├── layout.tsx
│   │       └── page.tsx
│   ├── package.json
│   ├── next.config.ts
│   └── Dockerfile
├── terraform/            # IaC（Terraform）
├── docker-compose.yml
└── README.md
```

---
## アプリケーション

### バックエンド API（FastAPI）
- **技術スタック**：Python 3.14 + FastAPI + uv
- **API仕様**：
```
GET /
→ { "message": "Hello Azure Sandbox!!!" }

GET /health
→ { "status": "healthy" }
```

### フロントエンド（Next.js）
- **技術スタック**：Next.js (App Router) + TypeScript
- **機能**：バックエンド API の GET エンドポイントを呼び出し、結果を画面に表示する
- **環境変数**：
  - `API_BASE_URL` — バックエンド API のベース URL（デフォルト: `http://localhost:8000`）

### ローカル開発
```bash
# Docker Composeで全サービス起動
docker-compose up -d

# フロントエンドの動作確認
# http://localhost:3000

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
- **カスタムドメイン設定を実施する**
- **SSL証明書を設定し HTTPS で提供する**
- **スケール設定は優先度が低い**（当面は既定値）
