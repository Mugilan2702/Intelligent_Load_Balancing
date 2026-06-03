<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Smart Balance — Intelligent Load Balancing</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="theme.css">
<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
  body { background: var(--bg); color: var(--text); font-family: 'DM Sans', sans-serif; overflow-x: hidden; }
  body::before {
    content: ''; position: fixed; inset: 0;
    background-image: linear-gradient(var(--grid-line) 1px, transparent 1px), linear-gradient(90deg, var(--grid-line) 1px, transparent 1px);
    background-size: 60px 60px; pointer-events: none; z-index: 0;
  }
  .orb { position: fixed; border-radius: 50%; filter: blur(120px); opacity: 0.15; pointer-events: none; }
  .orb-1 { width: 600px; height: 600px; background: var(--accent2); top: -200px; right: -100px; animation: drift 12s ease-in-out infinite alternate; }
  .orb-2 { width: 500px; height: 500px; background: var(--accent); bottom: -150px; left: -100px; animation: drift 15s ease-in-out infinite alternate-reverse; }
  [data-theme="light"] .orb { opacity: 0.06; }
  @keyframes drift { from{transform:translate(0,0)} to{transform:translate(40px,30px)} }

  nav {
    position: fixed; top: 0; left: 0; right: 0; z-index: 100;
    display: flex; align-items: center; justify-content: space-between;
    padding: 1.2rem 3rem; backdrop-filter: blur(20px);
    border-bottom: 1px solid var(--border); background: var(--nav-bg);
  }
  .logo { font-family: 'Syne', sans-serif; font-weight: 800; font-size: 1.4rem; letter-spacing: -0.02em; color: var(--text2); }
  .logo span { color: var(--accent); }
  .nav-right { display: flex; align-items: center; gap: 0.75rem; }
  .nav-pill { display: flex; align-items: center; background: var(--surface2); border: 1px solid var(--border); border-radius: 100px; padding: 0.3rem; gap: 0.25rem; }
  .nav-pill a { text-decoration: none; color: var(--muted); font-size: 0.875rem; font-weight: 500; padding: 0.45rem 1.1rem; border-radius: 100px; transition: all 0.2s; }
  .nav-pill a:hover, .nav-pill a.active { background: var(--accent); color: #000; }

  .hero { position: relative; z-index: 1; min-height: 100vh; display: flex; align-items: center; justify-content: center; flex-direction: column; text-align: center; padding: 8rem 2rem 4rem; }

  .badge {
    display: inline-flex; align-items: center; gap: 0.5rem;
    background: rgba(0,229,255,0.08); border: 1px solid rgba(0,229,255,0.2);
    border-radius: 100px; padding: 0.4rem 1rem; font-size: 0.8rem;
    color: var(--accent); letter-spacing: 0.05em; text-transform: uppercase;
    margin-bottom: 2rem; animation: fadeUp 0.6s ease forwards;
  }
  .badge::before { content: '●'; font-size: 0.5rem; animation: blink 1.5s infinite; }

  @keyframes blink { 0%,100%{opacity:1} 50%{opacity:0.3} }

  h1 { font-family: 'Syne', sans-serif; font-size: clamp(2.8rem,7vw,6rem); font-weight: 800; line-height: 1.05; letter-spacing: -0.03em; margin-bottom: 1.5rem; color: var(--text2); animation: fadeUp 0.6s 0.1s ease both; }
  h1 .line2 { display: block; background: linear-gradient(135deg, var(--accent), var(--accent2)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
  .hero-sub { font-size: 1.15rem; color: var(--muted); max-width: 540px; line-height: 1.7; margin-bottom: 3rem; animation: fadeUp 0.6s 0.2s ease both; }
  .hero-cta { display: flex; gap: 1rem; flex-wrap: wrap; justify-content: center; animation: fadeUp 0.6s 0.3s ease both; }

  .btn-primary { display: inline-flex; align-items: center; gap: 0.5rem; background: var(--accent); color: #000; font-weight: 600; font-size: 0.95rem; padding: 0.85rem 2rem; border-radius: 100px; text-decoration: none; transition: all 0.2s; box-shadow: 0 0 30px rgba(0,229,255,0.3); }
  .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 0 50px rgba(0,229,255,0.5); }
  .btn-ghost { display: inline-flex; align-items: center; gap: 0.5rem; background: transparent; color: var(--text); font-weight: 500; font-size: 0.95rem; padding: 0.85rem 2rem; border-radius: 100px; text-decoration: none; border: 1px solid var(--border); transition: all 0.2s; }
  .btn-ghost:hover { border-color: var(--card-hover); background: var(--surface2); }

  .stats { position: relative; z-index: 1; display: flex; justify-content: center; margin: 0 auto 6rem; max-width: 700px; border: 1px solid var(--border); border-radius: 1.5rem; overflow: hidden; background: var(--surface2); backdrop-filter: blur(10px); }
  .stat { flex: 1; padding: 2rem; text-align: center; border-right: 1px solid var(--border); }
  .stat:last-child { border-right: none; }
  .stat-num { font-family: 'Syne', sans-serif; font-size: 2rem; font-weight: 800; color: var(--text2); display: block; }
  .stat-label { font-size: 0.8rem; color: var(--muted); margin-top: 0.3rem; text-transform: uppercase; letter-spacing: 0.05em; }

  .features { position: relative; z-index: 1; max-width: 1100px; margin: 0 auto 6rem; padding: 0 2rem; display: grid; grid-template-columns: repeat(auto-fit, minmax(280px,1fr)); gap: 1.5rem; }
  .card { background: var(--surface2); border: 1px solid var(--border); border-radius: 1.5rem; padding: 2rem; transition: all 0.3s; position: relative; overflow: hidden; }
  .card::before { content: ''; position: absolute; inset: 0; background: radial-gradient(circle at 50% 0%, rgba(0,229,255,0.05), transparent 70%); opacity: 0; transition: opacity 0.3s; }
  .card:hover::before { opacity: 1; }
  .card:hover { border-color: rgba(0,229,255,0.2); transform: translateY(-4px); }
  .card-icon { font-size: 2rem; margin-bottom: 1rem; display: block; }
  .card h3 { font-family: 'Syne', sans-serif; font-size: 1.1rem; font-weight: 700; margin-bottom: 0.6rem; color: var(--text2); }
  .card p { font-size: 0.9rem; color: var(--muted); line-height: 1.65; }

  @keyframes fadeUp { from{opacity:0;transform:translateY(24px)} to{opacity:1;transform:translateY(0)} }
  footer { position: relative; z-index: 1; text-align: center; padding: 2rem; color: var(--muted); font-size: 0.82rem; border-top: 1px solid var(--border); }
</style>
</head>
<body>
<div class="orb orb-1"></div>
<div class="orb orb-2"></div>
<nav>
  <div class="logo">Smart<span>Balance</span></div>
  <div class="nav-right">
    <button class="theme-toggle-btn" onclick="toggleTheme()"><span class="theme-icon">☀️</span><span class="theme-label">Light Mode</span></button>
    <div class="nav-pill">
      <a href="login.jsp">Login</a>
      <a href="register.jsp" class="active">Register</a>
    </div>
  </div>
</nav>
<section class="hero">
  <h1>Intelligent Load<br><span class="line2">Balancing System</span></h1>
  <p class="hero-sub">Secure file upload with real-time threat detection, smart server allocation, and automated traffic management — powered by intelligent algorithms.</p>
  <div class="hero-cta">
    <a href="register.jsp" class="btn-primary">⚡ Get Started</a>
    <a href="login.jsp" class="btn-ghost">Sign In →</a>
  </div>
</section>
<div class="features">
  <div class="card"><span class="card-icon">🛡️</span><h3>Attack Detection</h3><p>Real-time anomaly detection classifies and isolates attack traffic before it reaches your servers.</p></div>
  <div class="card"><span class="card-icon">⚖️</span><h3>Smart Balancing</h3><p>Intelligent routing assigns tasks based on data type, priority, and current server load — automatically.</p></div>
  <div class="card"><span class="card-icon">📊</span><h3>Live Monitoring</h3><p>Track server capacity, load metrics, and task status in real-time from a unified dashboard.</p></div>
  <div class="card"><span class="card-icon">🔐</span><h3>Tiered Security</h3><p>High-security servers handle sensitive data separately, ensuring compliance and data integrity.</p></div>
</div>
<footer>© 2026 SmartBalance System — Intelligent Load Balancing</footer>
<script src="theme.js"></script>
</body>
</html>
