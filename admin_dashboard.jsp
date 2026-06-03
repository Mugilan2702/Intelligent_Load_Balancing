<%@ page import="java.sql.*" %>
<%@ page import="com.db.DBConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String admin = (String) session.getAttribute("admin");
if(admin == null){ response.sendRedirect("admin_login.jsp"); }
%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Dashboard — SmartBalance</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="theme.css">
<link rel="stylesheet" href="dashboard.css">
<style>
  .admin-badge { display: inline-block; background: rgba(251,191,36,0.1); border: 1px solid rgba(251,191,36,0.2); border-radius: 100px; font-size: 0.7rem; color: #fbbf24; padding: 0.15rem 0.6rem; font-weight: 600; letter-spacing: 0.05em; margin-bottom: 2rem; }
  .stats-row { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px,1fr)); gap: 1.25rem; margin-bottom: 2.5rem; }
  .stat-card { background: var(--surface2); border: 1px solid var(--border); border-radius: 1.25rem; padding: 1.5rem; }
  .stat-card .num { font-family: 'Syne', sans-serif; font-size: 2rem; font-weight: 800; color: var(--text2); display: block; }
  .stat-card .lbl { font-size: 0.78rem; color: var(--muted); text-transform: uppercase; letter-spacing: 0.05em; margin-top: 0.3rem; }
  .stat-card.yellow .num { color: #fbbf24; }
  .stat-card.blue   .num { color: var(--accent); }
  .stat-card.red    .num { color: var(--red); }
  .stat-card.green  .num { color: var(--green); }
  .grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-bottom: 2rem; }
  @media (max-width: 900px) { .grid-2 { grid-template-columns: 1fr; } }
</style>
</head>
<body>
<aside class="sidebar">
  <div class="logo">Smart<span>Balance</span></div>
  <div class="admin-badge">ADMIN MODE</div>
  <a href="admin_dashboard.jsp" class="nav-item active"><span>🔐</span> Admin Dashboard</a>
  <a href="commondashboard.jsp" class="nav-item"><span>🏠</span> User Dashboard</a>
  <a href="home.jsp"            class="nav-item"><span>🌐</span> Home</a>
  <div class="spacer"></div>
  <button class="theme-toggle-btn" onclick="toggleTheme()"><span class="theme-icon">☀️</span><span class="theme-label">Light Mode</span></button>
  <a href="logout.jsp" class="nav-item logout"><span>🚪</span> Sign Out</a>
</aside>
<main class="main">
  <%
  int userCount=0, taskCount=0, attackCount=0;
  try {
    Connection con = DBConnection.getConnection();
    ResultSet r1 = con.createStatement().executeQuery("SELECT COUNT(*) FROM users");  if(r1.next()) userCount=r1.getInt(1);
    ResultSet r2 = con.createStatement().executeQuery("SELECT COUNT(*) FROM tasks");  if(r2.next()) taskCount=r2.getInt(1);
    ResultSet r3 = con.createStatement().executeQuery("SELECT COUNT(*) FROM tasks WHERE data_type='ATTACK'"); if(r3.next()) attackCount=r3.getInt(1);
  } catch(Exception e){ e.printStackTrace(); }
  %>
  <div class="page-header"><h1>Admin Dashboard</h1><p>System overview and full data access</p></div>
  <div class="stats-row">
    <div class="stat-card blue"><span class="num"><%=userCount%></span><div class="lbl">Registered Users</div></div>
    <div class="stat-card yellow"><span class="num"><%=taskCount%></span><div class="lbl">Total Tasks</div></div>
    <div class="stat-card red"><span class="num"><%=attackCount%></span><div class="lbl">Attack Tasks</div></div>
    <div class="stat-card green"><span class="num"><%=taskCount-attackCount%></span><div class="lbl">Clean Tasks</div></div>
  </div>
  <div class="grid-2">
    <div class="table-wrap">
      <div class="table-header">👤 Registered Users <span>All accounts</span></div>
      <table><thead><tr><th>#</th><th>Username</th></tr></thead><tbody>
<%
try {
  ResultSet rs1 = DBConnection.getConnection().createStatement().executeQuery("SELECT * FROM users");
  while(rs1.next()){ %><tr><td style="color:var(--muted);font-size:0.8rem"><%=rs1.getInt("id")%></td><td style="font-weight:500"><%=rs1.getString("username")%></td></tr><% }
} catch(Exception e){ e.printStackTrace(); }
%>
      </tbody></table>
    </div>
    <div class="table-wrap">
      <div class="table-header">📋 Task Overview <span>All submissions</span></div>
      <table><thead><tr><th>#</th><th>Task</th><th>Type</th><th>Priority</th><th>Server</th><th>Status</th></tr></thead><tbody>
<%
try {
  ResultSet rs2 = DBConnection.getConnection().createStatement().executeQuery("SELECT * FROM tasks ORDER BY id DESC");
  while(rs2.next()){
    String dtype = rs2.getString("data_type");
    String bc = "badge-normal";
    if("ATTACK".equals(dtype)) bc = "badge-attack";
    else if("SENSITIVE".equals(dtype)) bc = "badge-sensitive";
    String priColor = "HIGH".equals(rs2.getString("priority")) ? "var(--red)" : "var(--muted)";
%>
          <tr>
            <td style="color:var(--muted);font-size:0.78rem"><%=rs2.getInt("id")%></td>
            <td style="font-weight:500;font-size:0.82rem"><%=rs2.getString("task_name")%></td>
            <td><span class="badge <%=bc%>"><%=dtype%></span></td>
            <td style="font-size:0.8rem;color:<%=priColor%>"><%=rs2.getString("priority")%></td>
            <td><span class="server-tag"><%=rs2.getString("assigned_server")%></span></td>
            <td><span class="status-chip"><%=rs2.getString("status")%></span></td>
          </tr>
<% } } catch(Exception e){ e.printStackTrace(); } %>
      </tbody></table>
    </div>
  </div>
</main>
<script src="theme.js"></script>
</body>
</html>
