<?php
/**
 * POST /api/login.php
 * المدخلات: email, password
 * المخرجات: بيانات المستخدم + توكن جلسة
 */
require_once __DIR__ . '/../helpers.php';
send_headers();

if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') {
    fail('استخدم POST.', 405);
}

$in       = input();
$email    = trim(strtolower($in['email'] ?? ''));
$password = (string)($in['password'] ?? '');

if ($email === '' || $password === '') {
    fail('البريد وكلمة المرور مطلوبان.');
}

$pdo  = db();
$stmt = $pdo->prepare('SELECT * FROM users WHERE email = ?');
$stmt->execute([$email]);
$user = $stmt->fetch();

if (!$user || !password_verify($password, $user['password_hash'])) {
    fail('البريد أو كلمة المرور غير صحيحة.', 401);
}

// توكن جلسة جديد
$token = make_token();
$pdo->prepare('INSERT INTO api_tokens (user_id, token) VALUES (?, ?)')->execute([(int)$user['id'], $token]);

ok([
    'token' => $token,
    'user'  => [
        'id'        => (int)$user['id'],
        'full_name' => $user['full_name'],
        'email'     => $user['email'],
        'skin_type' => $user['skin_type'],
    ],
], 'تم تسجيل الدخول بنجاح.');
