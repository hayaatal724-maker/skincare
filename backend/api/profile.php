<?php
/**
 * GET  /api/profile.php   -> بيانات المستخدم الحالي + عدد فحوصاته
 * POST /api/profile.php   -> تحديث الملف الشخصي (full_name, skin_type)
 * (يتطلب توكن: Authorization: Bearer <token>)
 */
require_once __DIR__ . '/../helpers.php';
send_headers();

$user   = current_user();
$pdo    = db();
$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

if ($method === 'GET') {
    $stmt = $pdo->prepare('SELECT COUNT(*) AS c FROM scans WHERE user_id = ?');
    $stmt->execute([$user['id']]);
    $scansCount = (int)($stmt->fetch()['c'] ?? 0);

    ok([
        'user' => [
            'id'          => (int)$user['id'],
            'full_name'   => $user['full_name'],
            'email'       => $user['email'],
            'skin_type'   => $user['skin_type'],
            'created_at'  => $user['created_at'],
            'scans_count' => $scansCount,
        ],
    ]);
}

if ($method === 'POST') {
    $in       = input();
    $fullName = trim($in['full_name'] ?? $user['full_name']);
    $skinType = array_key_exists('skin_type', $in) ? (trim($in['skin_type']) ?: null) : $user['skin_type'];

    if ($fullName === '') {
        fail('الاسم لا يمكن أن يكون فارغاً.');
    }

    $stmt = $pdo->prepare('UPDATE users SET full_name = ?, skin_type = ? WHERE id = ?');
    $stmt->execute([$fullName, $skinType, $user['id']]);

    ok([
        'user' => [
            'id'        => (int)$user['id'],
            'full_name' => $fullName,
            'email'     => $user['email'],
            'skin_type' => $skinType,
        ],
    ], 'تم تحديث الملف الشخصي.');
}

fail('طريقة غير مدعومة.', 405);
