<%@ page session="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String user = (String) session.getAttribute("user");
if(user == null){ response.sendRedirect("login.jsp"); }
String activePage = "dashboard";
%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Dashboard — SmartBalance</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="theme.css">
<link rel="stylesheet" href="dashboard.css">
<style>
  .grid-4 { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1.25rem; margin-bottom: 2.5rem; }
  .quick-card { background: var(--surface2); border: 1px solid var(--border); border-radius: 1.25rem; padding: 1.5rem; text-decoration: none; color: inherit; transition: all 0.25s; position: relative; overflow: hidden; display: flex; flex-direction: column; }
  .quick-card:hover { transform: translateY(-4px); border-color: var(--card-hover); }
  .card-icon-wrap { width: 44px; height: 44px; border-radius: 0.75rem; display: flex; align-items: center; justify-content: center; font-size: 1.3rem; margin-bottom: 1.2rem; }
  .quick-card h3 { font-family: 'Syne', sans-serif; font-size: 1rem; font-weight: 700; color: var(--text2); margin-bottom: 0.4rem; }
  .quick-card p { font-size: 0.82rem; color: var(--muted); line-height: 1.5; }
  .arrow { margin-top: auto; padding-top: 1rem; font-size: 0.8rem; opacity: 0.5; transition: opacity 0.2s; }
  .quick-card:hover .arrow { opacity: 1; }

  .user-card { background: var(--surface2); border: 1px solid var(--border); border-radius: 1rem; padding: 1rem; margin-bottom: 2rem; display: flex; align-items: center; gap: 0.75rem; }
  .avatar { width: 38px; height: 38px; border-radius: 50%; background: linear-gradient(135deg, var(--accent), var(--accent2)); display: flex; align-items: center; justify-content: center; font-weight: 700; color: #000; font-size: 0.9rem; flex-shrink: 0; text-transform: uppercase; }
  .user-info .name { font-weight: 600; font-size: 0.9rem; color: var(--text2); }
  .user-info .role { font-size: 0.75rem; color: var(--muted); }
  .nav-section { font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.08em; color: var(--muted); margin-bottom: 0.75rem; padding: 0 0.5rem; margin-top: 1rem; }

  .status-row { background: var(--surface2); border: 1px solid var(--border); border-radius: 1.25rem; padding: 1.5rem 2rem; display: flex; align-items: center; gap: 2rem; flex-wrap: wrap; }
  .status-item { display: flex; align-items: center; gap: 0.6rem; font-size: 0.875rem; }
  .dot { width: 8px; height: 8px; border-radius: 50%; }
  .dot-green  { background: var(--green);  box-shadow: 0 0 8px var(--green);  animation: pulse 2s infinite; }
  .dot-yellow { background: var(--yellow); box-shadow: 0 0 8px var(--yellow); }
  .dot-red    { background: var(--red);    box-shadow: 0 0 8px var(--red); }
  .status-label { color: var(--muted); }
  .status-val   { color: var(--text2); font-weight: 500; }
</style>
</head>
<body>

<aside class="sidebar">
  <div class="logo">Smart<span>Balance</span></div>
  <div class="user-card">
    <div class="avatar"><%=user != null ? user.substring(0,1) : "U"%></div>
    <div class="user-info">
      <div class="name"><%=user%></div>
      <div class="role">Standard User</div>
    </div>
  </div>
  <div class="nav-section">Navigation</div>
  <a href="commondashboard.jsp" class="nav-item active"><span>🏠</span> Dashboard</a>
  <a href="index.jsp"           class="nav-item"><span>📤</span> Upload Task</a>
  <a href="dashboard.jsp"       class="nav-item"><span>📋</span> View Tasks</a>
  <div class="nav-section">Monitoring</div>
  <a href="attack_monitor.jsp"  class="nav-item"><span>🛡️</span> Attack Monitor</a>
  <a href="server_status.jsp"   class="nav-item"><span>📊</span> Server Status</a>
  <div class="nav-section">Admin</div>
  <a href="admin_login.jsp"     class="nav-item"><span>🔑</span> Admin Panel</a>
  <div class="spacer"></div>
  <button class="theme-toggle-btn" onclick="toggleTheme()"><span class="theme-icon">☀️</span><span class="theme-label">Light Mode</span></button>
  <a href="logout.jsp" class="nav-item logout"><span>🚪</span> Sign Out</a>
</aside>

<main class="main">
  <div class="page-header">
    <h1>Good day, <%=user%> 👋</h1>
    <p>Here's a quick overview of your load balancing environment.</p>
  </div>
  <div class="grid-4">
    <a href="index.jsp" class="quick-card">
      <div class="card-icon-wrap" style="background:rgba(0,229,255,0.1)">📤</div>
      <h3>Upload Task</h3><p>Submit files for intelligent classification and server routing.</p>
      <div class="arrow">→ Upload now</div>
    </a>
    <a href="dashboard.jsp" class="quick-card">
      <div class="card-icon-wrap" style="background:rgba(124,58,237,0.1)">📋</div>
      <h3>Task Queue</h3><p>View all submitted tasks, their types, priorities, and server assignments.</p>
      <div class="arrow">→ View tasks</div>
    </a>
    <a href="attack_monitor.jsp" class="quick-card">
      <div class="card-icon-wrap" style="background:rgba(255,77,109,0.1)">🛡️</div>
      <h3>Attack Monitor</h3><p>Real-time view of detected attack traffic and threat classification.</p>
      <div class="arrow">→ Monitor threats</div>
    </a>
    <a href="server_status.jsp" class="quick-card">
      <div class="card-icon-wrap" style="background:rgba(34,197,94,0.1)">📊</div>
      <h3>Server Load</h3><p>Check live server capacity, current load, and operational status.</p>
      <div class="arrow">→ Check status</div>
    </a>
  </div>
  <div class="status-row">
    <div class="status-item"><div class="dot dot-green"></div><span class="status-label">System:</span><span class="status-val">Operational</span></div>
    <div class="status-item"><div class="dot dot-green"></div><span class="status-label">Load Balancer:</span><span class="status-val">Active</span></div>
    <div class="status-item"><div class="dot dot-yellow"></div><span class="status-label">Threat Level:</span><span class="status-val">Moderate</span></div>
    <div class="status-item"><div class="dot dot-green"></div><span class="status-label">DB Connection:</span><span class="status-val">Connected</span></div>
  </div>
</main>
<script src="theme.js"></script>
</body>
</html>
