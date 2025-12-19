# Flutter + Python (Flask) Authentication Demo (Local Setup)

This project is a **simple Sign In / Sign Up authentication demo** using:

- **Backend**: Python (Flask) + SQLite + JWT authentication
- **Frontend**: Flutter Web
- **Language**: UI text in Japanese

This README explains **how to run everything locally** for demo or learning purposes.

---

## 📂 Project Structure

```text
project-root/
│
├── backend/
│   ├── app.py            # Flask API (login/signup)
│   ├── requirements.txt # Python dependencies
│   └── venv/             # Python virtual environment (not committed)
│
├── frontend/
│   ├── lib/              # Flutter source code
│   ├── web/              # Web entry point
│   └── pubspec.yaml      # Flutter dependencies
│
└── README.md
```

---

## 🧩 Features

- User registration (登録)
- User login (ログイン)
- Password hashing
- JWT-based authentication
- Flutter Web UI (Japanese text)
- SQLite database (local)

---

## 🛠 Prerequisites

### Backend (Python)
- Python 3.9+

### Frontend (Flutter Web)
- Flutter SDK
- Google Chrome (or Edge)

---

## 1️⃣ Backend Setup (Flask API)

### 🇬🇧 English

#### Step 1: Create virtual environment (recommended)

```bash
cd backend
python -m venv venv
```

Activate it:

**Windows**
```bash
venv\Scripts\activate
```

**macOS / Linux**
```bash
source venv/bin/activate
```

---

#### Step 2: Install dependencies

```bash
pip install -r requirements.txt
```

---

#### Step 3: Run the backend server

```bash
python app.py
```

Backend will start at:

```text
http://localhost:5000
```

---

### 🇯🇵 日本語

#### ステップ1：仮想環境の作成（推奨）

```bash
cd backend
python -m venv venv
```

有効化：

**Windows**
```bash
venv\Scripts\activate
```

**macOS / Linux**
```bash
source venv/bin/activate
```

---

#### ステップ2：依存関係のインストール

```bash
pip install -r requirements.txt
```

---

#### ステップ3：バックエンド起動

```bash
python app.py
```

---

## 2️⃣ Frontend Setup (Flutter Web)

### 🇬🇧 English

#### Step 1: Enable Flutter Web (once)

```bash
flutter config --enable-web
flutter doctor
```

---

#### Step 2: Install dependencies

```bash
cd frontend
flutter pub get
```

---

#### Step 3: Run Flutter Web app

```bash
flutter run -d chrome
```

The app will open in your browser.

---

### 🇯🇵 日本語

#### ステップ1：Flutter Webを有効化（一度だけ）

```bash
flutter config --enable-web
flutter doctor
```

---

#### ステップ2：依存関係の取得

```bash
cd frontend
flutter pub get
```

---

#### ステップ3：Webアプリ起動

```bash
flutter run -d chrome
```

ブラウザでアプリが起動します。

---

## 🌐 API Endpoint Configuration

Flutter Web uses:

```dart
http://localhost:5000
```

⚠ Do NOT use `10.0.2.2` (that is only for Android emulators).

---

## 🗣 UI Text (Japanese)

- ログイン
- 登録
- 名前
- パスワード

---

## 🧪 Demo Flow

1. Start backend server
2. Start Flutter Web frontend
3. Register a new user (登録)
4. Login with the same account (ログイン)
5. JWT is returned from backend

---

## 🎯 Purpose

This project is intended for:

- Learning Flutter + Flask integration
- Authentication demo
- Interview or portfolio demo

---

## 📌 Notes

- SQLite is used for simplicity
- Not intended for production
- Authentication logic can be extended easily

---

## 🖼 Screenshots

以下は本アプリの画面イメージ例です（※実装後にスクリーンショットを差し替えてください）。

- ログイン画面（再生可能エネルギーをテーマにしたデザイン）
- 新規登録画面（ログイン画面と切り替え）
- ホーム / ダッシュボード画面
  - Solar（太陽光）カード
  - Wind（風力）カード
  - Battery（蓄電池）カード

---

## 🤖 Prompts used to generate Frontend & README

このプロジェクトでは、以下のようなプロンプトを使用して ChatGPT に支援してもらいました。

### Prompt 1: Frontend Generation

**English**

> "Create a beautiful Flutter Web login and register page with Japanese UI text. The theme should be related to renewable energy. Include authentication, auto-login on refresh, dashboard cards (Solar / Wind / Battery), form validation, and logout functionality."

**日本語**

> 「日本語UIテキストを使用した、美しいFlutter Webのログイン・新規登録画面を作成してください。再生可能エネルギーをテーマにし、認証機能、リロード時の自動ログイン、Solar / Wind / Battery のダッシュボードカード、フォームバリデーション、ログアウト機能を含めてください。」

---

### Prompt 2: README Generation

**English**

> "Create a clear and beginner-friendly README.md explaining how to run a Flutter Web frontend and Flask backend locally, including virtual environment setup, database creation, and demo instructions."

**日本語**

> 「Flutter WebのフロントエンドとFlaskバックエンドをローカル環境で実行する方法について、仮想環境のセットアップ、データベース作成、デモ手順を含めた、初心者にも分かりやすいREADME.mdを作成してください。」

---

## 📄 License

Free to use for learning and demo purposes.