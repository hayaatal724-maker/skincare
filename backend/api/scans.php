<?php
/**
 * GET /api/scans.php            -> قائمة فحوصات المستخدم (سجل التاريخ)
 * GET /api/scans.php?id=12      -> تفاصيل فحص واحد
 * (يتطلب توكن: Authorization: Bearer <token>)
 */
require_once __DIR__ . '/../helpers.php';
send_headers();

if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'GET') {
    fail('استخدم GET.', 405);
}

$user = current_user();
$pdo  = db();

// فحص واحد
if (isset($_GET['id'])) {
    $stmt = $pdo->prepare('SELECT * FROM scans WHERE id = ? AND user_id = ?');
    $stmt->execute([(int)$_GET['id'], $user['id']]);
    $scan = $stmt->fetch();
    if (!$scan) {
        fail('الفحص غير موجود.', 404);
    }
    ok(['scan' => $scan]);
}

// كل الفحوصات (الأحدث أولاً)
$stmt = $pdo->prepare('SELECT * FROM scans WHERE user_id = ? ORDER BY scan_date DESC');
$stmt->execute([$user['id']]);
ok(['scans' => $stmt->fetchAll()]);
