<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login — SmartBalance</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="theme.css">
<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
  body { background: var(--bg); color: var(--text); font-family: 'DM Sans', sans-serif; min-height: 100vh; display: flex; align-items: center; justify-content: center; overflow: hidden; }
  body::before { content: ''; position: fixed; inset: 0; background-image: linear-gradient(var(--grid-line) 1px, transparent 1px), linear-gradient(90deg, var(--grid-line) 1px, transparent 1px); background-size: 60px 60px; }
  .orb { position: fixed; border-radius: 50%; filter: blur(120px); opacity: 0.12; pointer-events: none; }
  .orb-1 { width: 500px; height: 500px; background: var(--accent2); top: -150px; right: -100px; }
  .orb-2 { width: 400px; height: 400px; background: var(--accent); bottom: -100px; left: -80px; }
  [data-theme="light"] .orb { opacity: 0.05; }

  /* top-right theme button */
  .top-toggle { position: fixed; top: 1.2rem; right: 1.5rem; z-index: 200; }

  .panel { position: relative; z-index: 1; display: grid; grid-template-columns: 1fr 1fr; width: 900px; max-width: 96vw; min-height: 560px; border-radius: 2rem; overflow: hidden; border: 1px solid var(--border); box-shadow: var(--shadow); animation: slideUp 0.5s ease both; }
  @keyframes slideUp { from{opacity:0;transform:translateY(30px)} to{opacity:1;transform:translateY(0)} }

  .panel-left { background: var(--surface); padding: 3rem; display: flex; flex-direction: column; justify-content: center; border-right: 1px solid var(--border); position: relative; overflow: hidden; }
  .panel-left::after { content: ''; position: absolute; bottom: -80px; right: -80px; width: 280px; height: 280px; border-radius: 50%; background: radial-gradient(circle, rgba(0,229,255,0.08), transparent 70%); }

  .logo { font-family: 'Syne', sans-serif; font-weight: 800; font-size: 1.4rem; color: var(--text2); margin-bottom: 3rem; }
  .logo span { color: var(--accent); }
  .panel-left h2 { font-family: 'Syne', sans-serif; font-size: 2rem; font-weight: 800; line-height: 1.2; margin-bottom: 1rem; color: var(--text2); }
  .panel-left p { color: var(--muted); font-size: 0.9rem; line-height: 1.7; }
  .feature-list { margin-top: 2.5rem; display: flex; flex-direction: column; gap: 0.9rem; }
  .feature-item { display: flex; align-items: center; gap: 0.75rem; font-size: 0.875rem; color: var(--muted); }
  .feature-item::before { content: '✓'; background: rgba(0,229,255,0.12); color: var(--accent); width: 22px; height: 22px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.7rem; font-weight: 700; flex-shrink: 0; }

  .panel-right { background: var(--bg); padding: 3rem; display: flex; flex-direction: column; justify-content: center; }
  .panel-right h3 { font-family: 'Syne', sans-serif; font-size: 1.5rem; font-weight: 700; margin-bottom: 0.4rem; color: var(--text2); }
  .panel-right .sub { color: var(--muted); font-size: 0.875rem; margin-bottom: 2.5rem; }

  .form-group { margin-bottom: 1.2rem; }
  label { display: block; font-size: 0.8rem; font-weight: 500; color: var(--muted); margin-bottom: 0.5rem; letter-spacing: 0.04em; text-transform: uppercase; }
  input[type="text"], input[type="password"] { width: 100%; background: var(--input-bg); border: 1px solid var(--border); border-radius: 0.75rem; color: var(--text); font-family: 'DM Sans', sans-serif; font-size: 0.95rem; padding: 0.85rem 1.1rem; outline: none; transition: all 0.2s; }
  input:focus { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(0,229,255,0.1); }
  input::placeholder { color: var(--muted); }

  .btn-submit { width: 100%; background: var(--accent); color: #000; border: none; cursor: pointer; font-family: 'DM Sans', sans-serif; font-size: 0.95rem; font-weight: 600; padding: 0.9rem; border-radius: 0.75rem; margin-top: 0.5rem; transition: all 0.2s; box-shadow: 0 0 30px rgba(0,229,255,0.2); }
  .btn-submit:hover { transform: translateY(-1px); box-shadow: 0 0 50px rgba(0,229,255,0.4); }
  .footer-link { text-align: center; margin-top: 1.5rem; font-size: 0.875rem; color: var(--muted); }
  .footer-link a { color: var(--accent); text-decoration: none; font-weight: 500; }
  @media (max-width: 640px) { .panel { grid-template-columns: 1fr; } .panel-left { display: none; } }
</style>
</head>
<body>
<div class="orb orb-1"></div>
<div class="orb orb-2"></div>

<div class="top-toggle">
  <button class="theme-toggle-btn" onclick="toggleTheme()"><span class="theme-icon">☀️</span><span class="theme-label">Light Mode</span></button>
</div>

<div class="panel">
  <div class="panel-left">
    <div class="logo">Smart<span>Balance</span></div>
    <h2>Secure Access Portal</h2>
    <p>Sign in to manage your intelligent load balancing environment and monitor server health.</p>
    <div class="feature-list">
      <div class="feature-item">Real-time server monitoring</div>
      <div class="feature-item">Automated threat detection</div>
      <div class="feature-item">Smart task allocation</div>
      <div class="feature-item">Role-based access control</div>
    </div>
  </div>
  <div class="panel-right">
    <h3>Welcome back</h3>
    <p class="sub">Enter your credentials to continue</p>
    <form action="LoginServlet" method="post">
      <div class="form-group"><label>Username</label><input type="text" name="username" placeholder="Enter your username" required></div>
      <div class="form-group"><label>Password</label><input type="password" name="password" placeholder="••••••••" required></div>
      <button type="submit" class="btn-submit">Sign In →</button>
    </form>
    <div class="footer-link">Don't have an account? <a href="register.jsp">Register now</a></div>
  </div>
</div>
<script src="theme.js"></script>
</body>
</html>
