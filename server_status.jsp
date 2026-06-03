<%@ page import="java.sql.*" %>
<%@ page import="com.db.DBConnection" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
List<String>  serverNames = new ArrayList<>();
List<Integer> serverLoads = new ArrayList<>();
List<Integer> serverCaps  = new ArrayList<>();
try {
    ResultSet rsPre = DBConnection.getConnection().createStatement().executeQuery("SELECT * FROM servers");
    while(rsPre.next()){
        serverNames.add(rsPre.getString("name"));
        serverLoads.add(rsPre.getInt("current_load"));
        serverCaps.add(rsPre.getInt("capacity"));
    }
} catch(Exception e){ e.printStackTrace(); }
StringBuilder jsNames=new StringBuilder("["), jsLoads=new StringBuilder("["), jsCaps=new StringBuilder("[");
for(int i=0;i<serverNames.size();i++){
    jsNames.append("'").append(serverNames.get(i)).append("'");
    jsLoads.append(serverLoads.get(i));
    jsCaps.append(serverCaps.get(i));
    if(i<serverNames.size()-1){ jsNames.append(","); jsLoads.append(","); jsCaps.append(","); }
}
jsNames.append("]"); jsLoads.append("]"); jsCaps.append("]");
%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Server Status — SmartBalance</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="theme.css">
<link rel="stylesheet" href="dashboard.css">

<%-- theme.js in <head> so applyTheme() ready before body renders --%>
<script src="theme.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.min.js"></script>

<style>
  /* SERVER CARDS */
  .servers-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 1.25rem; margin-bottom: 2.5rem;
  }
  .server-card {
    background: var(--surface2); border: 1px solid var(--border);
    border-radius: 1.25rem; padding: 1.5rem;
    transition: all 0.3s; position: relative; overflow: hidden;
  }
  .server-card:hover { transform: translateY(-3px); border-color: var(--card-hover); }
  .server-card.overload { border-color: rgba(255,77,109,0.35); }
  .server-card.overload::before {
    content: ''; position: absolute; inset: 0;
    background: radial-gradient(circle at 50% 0%, rgba(255,77,109,0.06), transparent 60%);
  }
  .server-top { display: flex; align-items: flex-start; justify-content: space-between; margin-bottom: 1.25rem; }
  .server-name { font-family: 'Syne', sans-serif; font-size: 1rem; font-weight: 700; color: var(--text2); }
  .server-cat  { font-size: 0.75rem; color: var(--muted); margin-top: 0.2rem; }
  .status-dot  { width: 9px; height: 9px; border-radius: 50%; flex-shrink: 0; margin-top: 5px; }
  .status-active   { background: var(--green); box-shadow: 0 0 8px var(--green); animation: pulse 2s infinite; }
  .status-overload { background: var(--red);   box-shadow: 0 0 8px var(--red);   animation: pulse 1s infinite; }
  .load-section { margin-bottom: 1rem; }
  .load-header  { display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.45rem; }
  .load-label   { font-size: 0.72rem; color: var(--muted); text-transform: uppercase; letter-spacing: 0.05em; }
  .load-pct     { font-size: 0.82rem; font-weight: 700; }
  .load-bar     { height: 7px; background: var(--border); border-radius: 100px; overflow: hidden; }
  .load-fill    { height: 100%; border-radius: 100px; transition: width 0.8s ease; }
  .fill-green   { background: linear-gradient(90deg, #16a34a, var(--green)); }
  .fill-yellow  { background: linear-gradient(90deg, #d97706, var(--yellow)); }
  .fill-red     { background: linear-gradient(90deg, #be123c, var(--red)); }
  .server-stats { display: flex; gap: 1.25rem; }
  .server-stat .val { color: var(--text2); font-weight: 600; font-size: 0.82rem; }
  .server-stat .lbl { color: var(--muted); font-size: 0.75rem; }

  /* TWO CHARTS SIDE BY SIDE */
  .charts-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1.5rem;
    margin-bottom: 2.5rem;
  }
  @media (max-width: 860px) { .charts-row { grid-template-columns: 1fr; } }

  .chart-card {
    background: var(--surface2); border: 1px solid var(--border);
    border-radius: 1.5rem; padding: 1.75rem;
  }
  .chart-card-title {
    font-family: 'Syne', sans-serif; font-size: 0.95rem;
    font-weight: 700; color: var(--text2); margin-bottom: 0.2rem;
  }
  .chart-card-sub { font-size: 0.75rem; color: var(--muted); margin-bottom: 1.25rem; }
  .chart-wrap { position: relative; height: 270px; }

  .sec-title {
    font-family: 'Syne', sans-serif; font-size: 1.1rem; font-weight: 700;
    color: var(--text2); margin-bottom: 1.25rem;
    display: flex; align-items: center; gap: 0.75rem;
  }
  .sec-title::after { content: ''; flex: 1; height: 1px; background: var(--border); }

  /* Theme select in sidebar */
  .theme-select {
    appearance: none; -webkit-appearance: none;
    width: 100%;
    background: var(--toggle-bg);
    border: 1px solid var(--border);
    border-radius: 0.75rem;
    padding: 0.6rem 2rem 0.6rem 0.9rem;
    font-size: 0.85rem; font-weight: 500;
    color: var(--text);
    font-family: 'DM Sans', sans-serif;
    cursor: pointer; outline: none;
    transition: all 0.2s;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='10' height='6' viewBox='0 0 10 6'%3E%3Cpath fill='%236b7280' d='M0 0l5 6 5-6z'/%3E%3C/svg%3E");
    background-repeat: no-repeat;
    background-position: right 0.75rem center;
    margin-bottom: 0.5rem;
  }
  .theme-select:hover { border-color: var(--accent); color: var(--accent); }
  .theme-select:focus { border-color: var(--accent); box-shadow: 0 0 0 2px rgba(0,229,255,0.15); }
</style>
</head>
<body>

<!-- SIDEBAR -->
<aside class="sidebar">
  <div class="logo">Smart<span>Balance</span></div>

  <a href="commondashboard.jsp" class="nav-item"><span>🏠</span> Dashboard</a>
  <a href="index.jsp"           class="nav-item"><span>📤</span> Upload Task</a>
  <a href="dashboard.jsp"       class="nav-item"><span>📋</span> View Tasks</a>
  <a href="attack_monitor.jsp"  class="nav-item"><span>🛡️</span> Attack Monitor</a>
  <a href="server_status.jsp"   class="nav-item active"><span>📊</span> Server Status</a>
  <a href="admin_login.jsp"     class="nav-item"><span>🔑</span> Admin Panel</a>

  <div class="spacer"></div>

  <select class="theme-select" onchange="applyTheme(this.value)">
    <option value="dark">🌙 Dark Mode</option>
    <option value="light">☀️ Light Mode</option>
  </select>

  <a href="logout.jsp" class="nav-item logout"><span>🚪</span> Sign Out</a>
</aside>

<!-- MAIN -->
<main class="main">

  <div class="page-header">
    <h1>Server Status</h1>
    <p>Live capacity and load monitoring across all servers</p>
  </div>

  <!-- SERVER CARDS -->
  <div class="servers-grid">
<%
try {
    ResultSet rs = DBConnection.getConnection().createStatement().executeQuery("SELECT * FROM servers");
    while(rs.next()){
        int load = rs.getInt("current_load");
        int cap  = rs.getInt("capacity");
        boolean ov = load > cap;
        int sc  = cap == 0 ? 1 : cap;
        int pct = Math.min((load * 100) / sc, 100);
        String fc = pct < 50 ? "fill-green" : pct < 80 ? "fill-yellow" : "fill-red";
        String pc = pct < 50 ? "#22c55e"    : pct < 80 ? "#fbbf24"     : "#ff4d6d";
%>
    <div class="server-card <%=ov?"overload":""%>">
      <div class="server-top">
        <div>
          <div class="server-name"><%=rs.getString("name")%></div>
          <div class="server-cat"><%=rs.getString("category")%></div>
        </div>
        <div style="display:flex;flex-direction:column;align-items:flex-end;gap:0.5rem">
          <div class="status-dot <%=ov?"status-overload":"status-active"%>"></div>
          <span class="badge <%=ov?"badge-over":"badge-ok"%>"><%=ov?"OVERLOAD":"ACTIVE"%></span>
        </div>
      </div>
      <div class="load-section">
        <div class="load-header">
          <span class="load-label">Load</span>
          <span class="load-pct" style="color:<%=pc%>"><%=pct%>%</span>
        </div>
        <div class="load-bar">
          <div class="load-fill <%=fc%>" style="width:<%=pct%>%"></div>
        </div>
      </div>
      <div class="server-stats">
        <div class="server-stat"><span class="val"><%=load%></span><span class="lbl"> / <%=cap%></span></div>
        <div class="server-stat"><span class="val">ID #<%=rs.getInt("id")%></span></div>
      </div>
    </div>
<%  } } catch(Exception e){ e.printStackTrace(); } %>
  </div>

  <!-- TWO CHARTS SIDE BY SIDE -->
  <div class="sec-title">📈 Analytics</div>

  <div class="charts-row">
    <div class="chart-card">
      <div class="chart-card-title">📊 Load vs Capacity</div>
      <div class="chart-card-sub">Current load compared to max capacity per server</div>
      <div class="chart-wrap">
        <canvas id="barChart"></canvas>
      </div>
    </div>
    <div class="chart-card">
      <div class="chart-card-title">🍩 Load Distribution</div>
      <div class="chart-card-sub">Share of total load across all servers</div>
      <div class="chart-wrap">
        <canvas id="donutChart"></canvas>
      </div>
    </div>
  </div>

  <!-- TABLE -->
  <div class="sec-title">📋 Full Server Report</div>
  <div class="table-wrap">
    <table>
      <thead>
        <tr><th>#</th><th>Server Name</th><th>Category</th><th>Capacity</th><th>Load</th><th>Status</th></tr>
      </thead>
      <tbody>
<%
try {
    ResultSet rs2 = DBConnection.getConnection().createStatement().executeQuery("SELECT * FROM servers");
    while(rs2.next()){
        int l2 = rs2.getInt("current_load"), c2 = rs2.getInt("capacity");
        boolean ov2 = l2 > c2;
%>
        <tr>
          <td style="color:var(--muted)"><%=rs2.getInt("id")%></td>
          <td style="font-weight:500"><%=rs2.getString("name")%></td>
          <td><span class="cat-tag"><%=rs2.getString("category")%></span></td>
          <td><%=c2%></td>
          <td style="color:<%=ov2?"var(--red)":"var(--green)"%>;font-weight:600"><%=l2%></td>
          <td><span class="badge <%=ov2?"badge-over":"badge-ok"%>"><%=ov2?"OVERLOAD":"ACTIVE"%></span></td>
        </tr>
<%  } } catch(Exception e){ e.printStackTrace(); } %>
      </tbody>
    </table>
  </div>

</main>

<script>
  const names = <%=jsNames%>;
  const loads = <%=jsLoads%>;
  const caps  = <%=jsCaps%>;

  const COLORS = [
    'rgba(0,229,255,0.85)', 'rgba(124,58,237,0.85)', 'rgba(34,197,94,0.85)',
    'rgba(251,191,36,0.85)', 'rgba(255,77,109,0.85)', 'rgba(99,102,241,0.85)',
  ];

  Chart.defaults.font.family = "'DM Sans', sans-serif";
  Chart.defaults.font.size   = 12;

  let barChart = null, donutChart = null;

  function tv() {
    const dark = document.documentElement.getAttribute('data-theme') === 'dark';
    return {
      grid: dark ? 'rgba(255,255,255,0.05)' : 'rgba(0,0,0,0.07)',
      tick: dark ? '#6b7280' : '#9ca3af',
      leg : dark ? '#9ca3af' : '#6b7280',
      ttBg: dark ? '#0d1117' : '#ffffff',
      ttBd: dark ? 'rgba(255,255,255,0.1)' : 'rgba(0,0,0,0.1)',
      ttTi: dark ? '#ffffff' : '#111827',
      bdr : dark ? '#060810' : '#f0f4f8',
    };
  }

  function buildBarChart() {
    if (barChart) { barChart.destroy(); barChart = null; }
    const t = tv();
    barChart = new Chart(document.getElementById('barChart'), {
      type: 'bar',
      data: {
        labels: names,
        datasets: [
          { label:'Current Load', data:loads, backgroundColor:'rgba(0,229,255,0.8)',   borderColor:'rgba(0,229,255,1)',    borderWidth:1, borderRadius:6, borderSkipped:false },
          { label:'Capacity',     data:caps,  backgroundColor:'rgba(124,58,237,0.2)', borderColor:'rgba(124,58,237,0.8)', borderWidth:1, borderRadius:6, borderSkipped:false }
        ]
      },
      options: {
        responsive:true, maintainAspectRatio:false,
        plugins: {
          legend: { position:'top', labels:{ color:t.leg, boxWidth:12, padding:14 } },
          tooltip:{ backgroundColor:t.ttBg, borderColor:t.ttBd, borderWidth:1, titleColor:t.ttTi, bodyColor:t.tick, padding:12 }
        },
        scales: {
          x:{ grid:{ color:t.grid }, ticks:{ color:t.tick } },
          y:{ beginAtZero:true, grid:{ color:t.grid }, ticks:{ color:t.tick } }
        }
      }
    });
  }

  function buildDonutChart() {
    if (donutChart) { donutChart.destroy(); donutChart = null; }
    const t = tv();
    donutChart = new Chart(document.getElementById('donutChart'), {
      type: 'doughnut',
      data: {
        labels: names,
        datasets:[{ data:loads, backgroundColor:COLORS, borderColor:t.bdr, borderWidth:3, hoverOffset:10 }]
      },
      options: {
        responsive:true, maintainAspectRatio:false, cutout:'62%',
        plugins: {
          legend:{ position:'bottom', labels:{ color:t.leg, boxWidth:12, padding:14, font:{size:11} } },
          tooltip:{ backgroundColor:t.ttBg, borderColor:t.ttBd, borderWidth:1, titleColor:t.ttTi, bodyColor:t.tick, padding:12 }
        }
      }
    });
  }

  // Called by theme.js when theme switches
  window.rebuildChart = function () {
    buildBarChart();
    buildDonutChart();
  };

  buildBarChart();
  buildDonutChart();
</script>

</body>
</html>
