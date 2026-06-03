<%@ page import="java.sql.*" %>
<%@ page import="com.db.DBConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Attack Monitor — SmartBalance</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="theme.css">
<link rel="stylesheet" href="dashboard.css">
<style>
  .alert-banner { display: flex; align-items: center; gap: 1rem; background: rgba(255,77,109,0.07); border: 1px solid rgba(255,77,109,0.2); border-radius: 1rem; padding: 1.25rem 1.75rem; margin-bottom: 2rem; }
  .alert-icon { font-size: 1.5rem; animation: shake 1.5s ease-in-out infinite; }

  @keyframes shake {
    0%, 100% { transform: rotate(0); }
    20%       { transform: rotate(-5deg); }
    40%       { transform: rotate(5deg); }
    60%       { transform: rotate(-3deg); }
    80%       { transform: rotate(3deg); }
  }

  .alert-text h3 { font-family: 'Syne', sans-serif; font-size: 1rem; font-weight: 700; color: var(--red); }
  .alert-text p  { font-size: 0.82rem; color: var(--muted); margin-top: 0.2rem; }
  .alert-count   { margin-left: auto; font-family: 'Syne', sans-serif; font-size: 2rem; font-weight: 800; color: var(--red); }
  .live-badge { display: flex; align-items: center; gap: 0.4rem; background: rgba(255,77,109,0.1); border: 1px solid rgba(255,77,109,0.2); border-radius: 100px; padding: 0.3rem 0.75rem; font-size: 0.75rem; color: var(--red); font-weight: 600; }
  .live-dot { width: 6px; height: 6px; border-radius: 50%; background: var(--red); animation: blink 1s infinite; }

  @keyframes blink { 0%,100%{opacity:1} 50%{opacity:0} }
</style>
</head>
<body>
<aside class="sidebar">
  <div class="logo">Smart<span>Balance</span></div>
  <a href="commondashboard.jsp" class="nav-item"><span>🏠</span> Dashboard</a>
  <a href="index.jsp"           class="nav-item"><span>📤</span> Upload Task</a>
  <a href="dashboard.jsp"       class="nav-item"><span>📋</span> View Tasks</a>
  <a href="attack_monitor.jsp"  class="nav-item active"><span>🛡️</span> Attack Monitor</a>
  <a href="server_status.jsp"   class="nav-item"><span>📊</span> Server Status</a>
  <a href="admin_login.jsp"     class="nav-item"><span>🔑</span> Admin Panel</a>
  <div class="spacer"></div>
  <button class="theme-toggle-btn" onclick="toggleTheme()"><span class="theme-icon">☀️</span><span class="theme-label">Light Mode</span></button>
  <a href="logout.jsp" class="nav-item logout"><span>🚪</span> Sign Out</a>
</aside>
<main class="main">
  <%
  int attackCount = 0;
  try {
    ResultSet rc = DBConnection.getConnection().createStatement().executeQuery("SELECT COUNT(*) FROM tasks WHERE data_type='ATTACK'");
    if(rc.next()) attackCount = rc.getInt(1);
  } catch(Exception e){ e.printStackTrace(); }
  %>
  <div class="alert-banner">
    <div class="alert-icon">⚠️</div>
    <div class="alert-text"><h3>Threat Monitor Active</h3><p>Showing all tasks classified as attack traffic — routed to high-security servers</p></div>
    <div class="alert-count"><%=attackCount%></div>
  </div>
  <div class="page-header"><h1>Attack Monitor</h1><p>Detected malicious or suspicious task traffic</p></div>
  <div class="table-wrap">
    <div class="table-header"><strong>🔴 Attack Traffic Log</strong><div class="live-badge"><div class="live-dot"></div> LIVE</div></div>
    <table>
      <thead><tr><th>#</th><th>Task Name</th><th>Type</th><th>Priority</th><th>Assigned Server</th></tr></thead>
      <tbody>
<%
int cnt = 0;
try {
  ResultSet rs = DBConnection.getConnection().createStatement().executeQuery("SELECT * FROM tasks WHERE data_type='ATTACK' ORDER BY id DESC");
  while(rs.next()){ cnt++;
%>
        <tr>
          <td style="color:var(--muted);font-size:0.82rem"><%=rs.getInt("id")%></td>
          <td style="font-weight:500;color:var(--text2)"><%=rs.getString("task_name")%></td>
          <td><span class="badge badge-attack">⚡ ATTACK</span></td>
          <td style="color:var(--red);font-weight:700;font-size:0.82rem">HIGH</td>
          <td><span class="server-tag"><%=rs.getString("assigned_server")%></span></td>
        </tr>
<% } } catch(Exception e){ e.printStackTrace(); } %>
<% if(cnt==0){ %><tr><td colspan="5" style="text-align:center;padding:4rem;color:var(--muted)"><div style="font-size:2.5rem;margin-bottom:1rem">✅</div>No attack traffic detected</td></tr><% } %>
      </tbody>
    </table>
  </div>
</main>
<script src="theme.js"></script>
</body>
</html>
