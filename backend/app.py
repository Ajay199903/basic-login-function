import os
from flask import Flask, request, jsonify
from flask_cors import CORS
from flask_jwt_extended import (
    JWTManager, create_access_token, jwt_required, get_jwt_identity
)

import sqlite3
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)
CORS(app)

app.config['JWT_SECRET_KEY'] = 'my-special-secret'
jwt = JWTManager(app)

DB = 'users.db'

def init_db():
    if not os.path.exists(DB):
        conn = get_db()
        cur = conn.cursor()
        cur.execute('''
        CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL
        )
        ''')
        conn.commit()
        conn.close()
        print('データベースが初期化されました!')

def get_db():
    return sqlite3.connect(DB)

@app.route('/register', methods=['POST'])
def register():
    data = request.json
    userName = data.get('userName')
    userPassword = data.get('userPassword')

    if not userName or not userPassword:
        return jsonify({'error': '入力が不足しています!'}), 400

    hashedPassword = generate_password_hash(userPassword)

    try:
        conn = get_db()
        cur = conn.cursor()
        cur.execute('INSERT INTO users (name, password) VALUES (?, ?)', (userName, hashedPassword))
        conn.commit()
        return jsonify({'message': '登録完了!'}), 201
    except sqlite3.IntegrityError:
        return jsonify({'error': '既に登録されています!'}), 409


@app.route('/login', methods=['POST'])
def login():
    data = request.json
    userName = data.get('userName')
    userPassword = data.get('userPassword')

    conn = get_db()
    cur = conn.cursor()
    cur.execute('SELECT password FROM users WHERE name=?', (userName))
    row = cur.fetchone()

    if row and check_password_hash(row[0], userPassword):
        token = create_access_token(identity=userName)
        return jsonify({'access_token': token}), 200

    return jsonify({'error': '名前またはパスワードが違います!'}), 401


@app.route('/profile', methods=['GET'])
@jwt_required()
def profile():
    user = get_jwt_identity()
    return jsonify({'message': f'こんにちは {user}'}), 200


if __name__ == '__main__':
    init_db()
    app.run(debug=True)