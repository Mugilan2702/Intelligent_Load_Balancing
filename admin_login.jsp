<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Login — SmartBalance</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="theme.css">
<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
  body { background: var(--bg); color: var(--text); font-family: 'DM Sans', sans-serif; min-height: 100vh; display: flex; align-items: center; justify-content: center; overflow: hidden; }
  body::before { content: ''; position: fixed; inset: 0; background-image: linear-gradient(var(--grid-line) 1px, transparent 1px), linear-gradient(90deg, var(--grid-line) 1px, transparent 1px); background-size: 60px 60px; }
  .orb { position: fixed; border-radius: 50%; filter: blur(120px); opacity: 0.1; pointer-events: none; }
  .orb-1 { width: 500px; height: 500px; background: #d97706; top: -150px; right: -100px; }
  .orb-2 { width: 400px; height: 400px; background: #92400e; bottom: -100px; left: -80px; }
  [data-theme="light"] .orb { opacity: 0.05; }
  .top-toggle { position: fixed; top: 1.2rem; right: 1.5rem; z-index: 200; }

  .card { position: relative; z-index: 1; width: 420px; max-width: 95vw; background: var(--surface); border: 1px solid rgba(251,191,36,0.15); border-radius: 2rem; padding: 2.5rem; box-shadow: var(--shadow); animation: slideUp 0.5s ease both; }
  @keyframes slideUp { from{opacity:0;transform:translateY(30px)} to{opacity:1;transform:translateY(0)} }

  .admin-icon { width: 60px; height: 60px; border-radius: 1rem; background: rgba(251,191,36,0.1); border: 1px solid rgba(251,191,36,0.2); display: flex; align-items: center; justify-content: center; font-size: 1.6rem; margin-bottom: 1.5rem; }
  h2 { font-family: 'Syne', sans-serif; font-size: 1.6rem; font-weight: 800; color: var(--text2); margin-bottom: 0.3rem; }
  .sub { color: var(--muted); font-size: 0.875rem; margin-bottom: 2rem; }
  .restricted-banner { display: flex; align-items: center; gap: 0.6rem; background: rgba(251,191,36,0.07); border: 1px solid rgba(251,191,36,0.15); border-radius: 0.75rem; padding: 0.75rem 1rem; margin-bottom: 1.75rem; font-size: 0.82rem; color: #d97706; }

  .form-group { margin-bottom: 1.2rem; }
  label { display: block; font-size: 0.78rem; font-weight: 500; color: var(--muted); margin-bottom: 0.5rem; letter-spacing: 0.05em; text-transform: uppercase; }
  input[type="text"], input[type="password"] { width: 100%; background: var(--input-bg); border: 1px solid var(--border); border-radius: 0.75rem; color: var(--text); font-family: 'DM Sans', sans-serif; font-size: 0.95rem; padding: 0.85rem 1.1rem; outline: none; transition: all 0.2s; }
  input:focus { border-color: #fbbf24; box-shadow: 0 0 0 3px rgba(251,191,36,0.1); }
  input::placeholder { color: var(--muted); }

  .btn-submit { width: 100%; background: linear-gradient(135deg, #d97706, #b45309); color: #fff; border: none; cursor: pointer; font-family: 'DM Sans', sans-serif; font-size: 0.95rem; font-weight: 600; padding: 0.9rem; border-radius: 0.75rem; margin-top: 0.5rem; transition: all 0.2s; box-shadow: 0 0 30px rgba(217,119,6,0.3); }
  .btn-submit:hover { transform: translateY(-1px); box-shadow: 0 0 50px rgba(217,119,6,0.5); }
  .back-link { text-align: center; margin-top: 1.5rem; font-size: 0.875rem; color: var(--muted); }
  .back-link a { color: #fbbf24; text-decoration: none; font-weight: 500; }
</style>
</head>
<body>
<div class="orb orb-1"></div><div class="orb orb-2"></div>
<div class="top-toggle">
  <button class="theme-toggle-btn" onclick="toggleTheme()"><span class="theme-icon">☀️</span><span class="theme-label">Light Mode</span></button>
</div>
<div class="card">
  <div class="admin-icon">🔐</div>
  <h2>Admin Access</h2>
  <p class="sub">Restricted to system administrators only</p>
  <div class="restricted-banner">⚠️ Unauthorized access attempts are logged and monitored</div>
  <form action="AdminLoginServlet" method="post">
    <div class="form-group"><label>Admin Username</label><input type="text" name="username" placeholder="Enter admin username" required></div>
    <div class="form-group"><label>Password</label><input type="password" name="password" placeholder="••••••••" required></div>
    <button type="submit" class="btn-submit">🔓 Access Admin Panel</button>
  </form>
  <div class="back-link"><a href="commondashboard.jsp">← Back to Dashboard</a></div>
</div>
<script src="theme.js"></script>
</body>
</html>
