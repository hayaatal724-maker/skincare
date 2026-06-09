<?php
/**
 * صفحة معلومات الـ API (للتأكد أن السيرفر يعمل).
 * افتح: http://localhost/skincare/backend/
 */
require_once __DIR__ . '/helpers.php';
send_headers();

ok([
    'api'       => 'Dermalyze AI Backend',
    'version'   => '1.0.0',
    'model'     => GEMINI_MODEL,
    'endpoints' => [
        'POST /api/register.php'  => 'إنشاء حساب (full_name, email, password, skin_type?)',
        'POST /api/login.php'     => 'تسجيل الدخول (email, password)',
        'POST /api/logout.php'    => 'تسجيل الخروج — يتطلب توكن',
        'GET  /api/profile.php'   => 'بيانات المستخدم — يتطلب توكن',
        'POST /api/profile.php'   => 'تحديث الملف (full_name, skin_type) — يتطلب توكن',
        'POST /api/analyze.php'   => 'تحليل صورة بشرة (image, latitude?, longitude?) — يتطلب توكن',
        'GET  /api/scans.php'     => 'سجل الفحوصات — يتطلب توكن',
        'GET  /api/scans.php?id=' => 'تفاصيل فحص واحد — يتطلب توكن',
    ],
], 'الـ API يعمل ✅');
