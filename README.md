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
│   ├── create_db.py      # Database creation script
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

- User registration (サインアップ)
- User login (サインイン)
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

#### Step 3: Create the database

```bash
python create_db.py
```

This will create a local SQLite database file.

---

#### Step 4: Run the backend server

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

#### ステップ3：データベース作成

```bash
python create_db.py
```

SQLiteデータベースが作成されます。

---

#### ステップ4：バックエンド起動

```bash
python app.py
```

---