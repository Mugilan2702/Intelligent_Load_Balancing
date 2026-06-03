<%@ page import="java.sql.*" %>
<%@ page import="com.db.DBConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String user = (String) session.getAttribute("user");
if(user == null){ response.sendRedirect("login.jsp"); }
%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Task Dashboard — SmartBalance</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="theme.css">
<link rel="stylesheet" href="dashboard.css">
<style>
  .top-bar { display: flex; align-items: center; justify-content: space-between; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem; }
  .btn-upload { display: inline-flex; align-items: center; gap: 0.5rem; background: var(--accent); color: #000; font-weight: 600; font-size: 0.875rem; padding: 0.65rem 1.25rem; border-radius: 100px; text-decoration: none; transition: all 0.2s; }
  .btn-upload:hover { box-shadow: 0 0 30px rgba(0,229,255,0.4); transform: translateY(-1px); }
  .filter-bar { display: flex; gap: 0.5rem; margin-bottom: 1.5rem; flex-wrap: wrap; }
  .filter-btn { background: var(--surface2); border: 1px solid var(--border); border-radius: 100px; padding: 0.4rem 1rem; font-size: 0.82rem; color: var(--muted); cursor: pointer; transition: all 0.2s; font-family: 'DM Sans', sans-serif; }
  .filter-btn:hover, .filter-btn.active { background: rgba(0,229,255,0.1); border-color: rgba(0,229,255,0.3); color: var(--accent); }
  .task-name { font-weight: 500; color: var(--text2); }
  .priority-high { color: var(--red); font-weight: 600; font-size: 0.82rem; }
  .priority-low  { color: var(--muted); font-size: 0.82rem; }
</style>
</head>
<body>
<aside class="sidebar">
  <div class="logo">Smart<span>Balance</span></div>
  <a href="commondashboard.jsp" class="nav-item"><span>🏠</span> Dashboard</a>
  <a href="index.jsp"           class="nav-item"><span>📤</span> Upload Task</a>
  <a href="dashboard.jsp"       class="nav-item active"><span>📋</span> View Tasks</a>
  <a href="attack_monitor.jsp"  class="nav-item"><span>🛡️</span> Attack Monitor</a>
  <a href="server_status.jsp"   class="nav-item"><span>📊</span> Server Status</a>
  <a href="admin_login.jsp"     class="nav-item"><span>🔑</span> Admin Panel</a>
  <div class="spacer"></div>
  <button class="theme-toggle-btn" onclick="toggleTheme()"><span class="theme-icon">☀️</span><span class="theme-label">Light Mode</span></button>
  <a href="logout.jsp" class="nav-item logout"><span>🚪</span> Sign Out</a>
</aside>
<main class="main">
  <div class="top-bar">
    <div class="page-header" style="margin-bottom:0"><h1>Task Queue</h1><p>All submitted tasks and their allocation status</p></div>
    <a href="index.jsp" class="btn-upload">+ New Task</a>
  </div>
  <div class="filter-bar">
    <button class="filter-btn active" onclick="filterTable(this,'all')">All</button>
    <button class="filter-btn" onclick="filterTable(this,'ATTACK')">🔴 Attack</button>
    <button class="filter-btn" onclick="filterTable(this,'NORMAL')">🟢 Normal</button>
    <button class="filter-btn" onclick="filterTable(this,'HIGH')">⚡ High Priority</button>
  </div>
  <div class="table-wrap">
    <div class="table-header"><strong>All Tasks</strong><span>Auto-refreshes on page load</span></div>
    <table id="taskTable">
      <thead><tr><th>#</th><th>Task Name</th><th>Type</th><th>Priority</th><th>Server</th><th>Status</th></tr></thead>
      <tbody>
<%
int rowCount = 0;
try {
  Connection con = DBConnection.getConnection();
  ResultSet rs = con.createStatement().executeQuery("SELECT * FROM tasks ORDER BY id DESC");
  while(rs.next()) {
    rowCount++;
    String dtype = rs.getString("data_type");
    String pri   = rs.getString("priority");
    String bc    = "badge-normal";
    if("ATTACK".equals(dtype)) bc = "badge-attack";
    else if("SENSITIVE".equals(dtype)) bc = "badge-sensitive";
%>
        <tr data-type="<%=dtype%>" data-priority="<%=pri%>">
          <td style="color:var(--muted);font-size:0.82rem"><%=rs.getInt("id")%></td>
          <td class="task-name"><%=rs.getString("task_name")%></td>
          <td><span class="badge <%=bc%>"><%=dtype%></span></td>
          <td class="priority-<%=pri.toLowerCase()%>"><%=pri%></td>
          <td><span class="server-tag"><%=rs.getString("assigned_server")%></span></td>
          <td><span class="status-chip"><%=rs.getString("status")%></span></td>
        </tr>
<% } } catch(Exception e){ e.printStackTrace(); } %>
<% if(rowCount==0){ %><tr><td colspan="6" style="text-align:center;padding:3rem;color:var(--muted)">No tasks yet — <a href="index.jsp" style="color:var(--accent)">upload your first task</a></td></tr><% } %>
      </tbody>
    </table>
  </div>
</main>
<script src="theme.js"></script>
<script>
function filterTable(btn, type) {
  document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');
  document.querySelectorAll('#taskTable tbody tr[data-type]').forEach(row => {
    if (type === 'all') { row.style.display = ''; return; }
    if (type === 'HIGH') { row.style.display = row.dataset.priority === 'HIGH' ? '' : 'none'; return; }
    row.style.display = row.dataset.type === type ? '' : 'none';
  });
}
</script>
</body>
</html>
