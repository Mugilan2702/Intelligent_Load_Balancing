<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Register — SmartBalance</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="theme.css">
<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
  body { background: var(--bg); color: var(--text); font-family: 'DM Sans', sans-serif; min-height: 100vh; display: flex; align-items: center; justify-content: center; overflow: hidden; }
  body::before { content: ''; position: fixed; inset: 0; background-image: linear-gradient(var(--grid-line) 1px, transparent 1px), linear-gradient(90deg, var(--grid-line) 1px, transparent 1px); background-size: 60px 60px; }
  .orb { position: fixed; border-radius: 50%; filter: blur(120px); opacity: 0.12; pointer-events: none; }
  .orb-1 { width: 500px; height: 500px; background: var(--accent2); top: -150px; left: -100px; }
  .orb-2 { width: 400px; height: 400px; background: var(--accent); bottom: -100px; right: -80px; }
  [data-theme="light"] .orb { opacity: 0.05; }
  .top-toggle { position: fixed; top: 1.2rem; right: 1.5rem; z-index: 200; }

  .panel { position: relative; z-index: 1; display: grid; grid-template-columns: 1fr 1fr; width: 900px; max-width: 96vw; min-height: 580px; border-radius: 2rem; overflow: hidden; border: 1px solid var(--border); box-shadow: var(--shadow); animation: slideUp 0.5s ease both; }
  @keyframes slideUp { from{opacity:0;transform:translateY(30px)} to{opacity:1;transform:translateY(0)} }

  .panel-left { background: var(--bg); padding: 3rem; display: flex; flex-direction: column; justify-content: center; order: 1; }
  .panel-left h3 { font-family: 'Syne', sans-serif; font-size: 1.5rem; font-weight: 700; margin-bottom: 0.4rem; color: var(--text2); }
  .panel-left .sub { color: var(--muted); font-size: 0.875rem; margin-bottom: 2.5rem; }

  .panel-right { background: var(--surface); padding: 3rem; display: flex; flex-direction: column; justify-content: center; border-left: 1px solid var(--border); order: 2; }
  .logo { font-family: 'Syne', sans-serif; font-weight: 800; font-size: 1.4rem; color: var(--text2); margin-bottom: 3rem; }
  .logo span { color: var(--accent); }
  .panel-right h2 { font-family: 'Syne', sans-serif; font-size: 2rem; font-weight: 800; line-height: 1.2; margin-bottom: 1rem; color: var(--text2); }
  .panel-right p { color: var(--muted); font-size: 0.9rem; line-height: 1.7; }
  .security-badge { display: inline-flex; align-items: center; gap: 0.5rem; margin-top: 2.5rem; background: rgba(124,58,237,0.1); border: 1px solid rgba(124,58,237,0.2); border-radius: 100px; padding: 0.5rem 1rem; font-size: 0.8rem; color: #a78bfa; }

  .form-group { margin-bottom: 1.2rem; }
  label { display: block; font-size: 0.8rem; font-weight: 500; color: var(--muted); margin-bottom: 0.5rem; letter-spacing: 0.04em; text-transform: uppercase; }
  input[type="text"], input[type="password"] { width: 100%; background: var(--input-bg); border: 1px solid var(--border); border-radius: 0.75rem; color: var(--text); font-family: 'DM Sans', sans-serif; font-size: 0.95rem; padding: 0.85rem 1.1rem; outline: none; transition: all 0.2s; }
  input:focus { border-color: var(--accent2); box-shadow: 0 0 0 3px rgba(124,58,237,0.1); }
  input::placeholder { color: var(--muted); }
  .strength-bar { height: 3px; background: var(--border); border-radius: 100px; margin-top: 0.5rem; overflow: hidden; }
  .strength-fill { height: 100%; border-radius: 100px; transition: all 0.3s; width: 0; }

  .btn-submit { width: 100%; background: linear-gradient(135deg, #7c3aed, #4f46e5); color: #fff; border: none; cursor: pointer; font-family: 'DM Sans', sans-serif; font-size: 0.95rem; font-weight: 600; padding: 0.9rem; border-radius: 0.75rem; margin-top: 0.5rem; transition: all 0.2s; box-shadow: 0 0 30px rgba(124,58,237,0.3); }
  .btn-submit:hover { transform: translateY(-1px); box-shadow: 0 0 50px rgba(124,58,237,0.5); }
  .footer-link { text-align: center; margin-top: 1.5rem; font-size: 0.875rem; color: var(--muted); }
  .footer-link a { color: var(--accent); text-decoration: none; font-weight: 500; }
  @media (max-width: 640px) { .panel { grid-template-columns: 1fr; } .panel-right { display: none; } }
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
    <h3>Create account</h3>
    <p class="sub">Join the SmartBalance network</p>
    <form action="RegisterServlet" method="post">
      <div class="form-group"><label>Username</label><input type="text" name="username" placeholder="Choose a username" required></div>
      <div class="form-group">
        <label>Password</label>
        <input type="password" name="password" id="pwdInput" placeholder="Create a strong password" required oninput="checkStrength(this.value)">
        <div class="strength-bar"><div class="strength-fill" id="strengthFill"></div></div>
      </div>
      <button type="submit" class="btn-submit">Create Account →</button>
    </form>
    <div class="footer-link">Already have an account? <a href="login.jsp">Sign in</a></div>
  </div>
  <div class="panel-right">
    <div class="logo">Smart<span>Balance</span></div>
    <h2>Join the Network</h2>
    <p>Register to get access to the intelligent load balancing system. Your tasks will be automatically routed, classified, and protected in real-time.</p>
    <div class="security-badge">🔒 End-to-end encrypted</div>
  </div>
</div>
<script src="theme.js"></script>
<script>
function checkStrength(val) {
  const fill = document.getElementById('strengthFill');
  let score = 0;
  if (val.length > 6) score++;
  if (val.length > 10) score++;
  if (/[A-Z]/.test(val)) score++;
  if (/[0-9]/.test(val)) score++;
  if (/[^a-zA-Z0-9]/.test(val)) score++;
  fill.style.width = (score/5*100) + '%';
  fill.style.background = ['#ff4d6d','#ff9a3c','#ffd93d','#6bcb77','#00e5ff'][score-1] || '#ff4d6d';
}
</script>
</body>
</html>
