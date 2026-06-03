<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String user = (String) session.getAttribute("user");
if(user == null){ response.sendRedirect("login.jsp"); }
%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Upload Task — SmartBalance</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="theme.css">
<link rel="stylesheet" href="dashboard.css">
<style>
  .upload-container { width: 100%; max-width: 640px; padding-top: 2rem; }
  .card { background: var(--surface2); border: 1px solid var(--border); border-radius: 1.5rem; padding: 2rem; }
  .form-group { margin-bottom: 1.5rem; }
  label { display: block; font-size: 0.8rem; font-weight: 500; color: var(--muted); margin-bottom: 0.6rem; letter-spacing: 0.04em; text-transform: uppercase; }
  input[type="text"] { width: 100%; background: var(--input-bg); border: 1px solid var(--border); border-radius: 0.75rem; color: var(--text); font-family: 'DM Sans', sans-serif; font-size: 0.95rem; padding: 0.85rem 1.1rem; outline: none; transition: all 0.2s; }
  input[type="text"]:focus { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(0,229,255,0.1); }
  input::placeholder { color: var(--muted); }
  .drop-zone { border: 2px dashed var(--border); border-radius: 1rem; padding: 2.5rem; text-align: center; cursor: pointer; transition: all 0.3s; position: relative; background: var(--surface2); }
  .drop-zone:hover, .drop-zone.drag-over { border-color: var(--accent); background: rgba(0,229,255,0.04); }
  .drop-zone input[type="file"] { position: absolute; inset: 0; opacity: 0; cursor: pointer; width: 100%; height: 100%; }
  .drop-icon { font-size: 2.5rem; margin-bottom: 1rem; }
  .drop-zone h4 { font-size: 1rem; font-weight: 600; color: var(--text2); margin-bottom: 0.4rem; }
  .drop-zone p { font-size: 0.85rem; color: var(--muted); }
  .file-name { margin-top: 1rem; font-size: 0.875rem; color: var(--accent); font-weight: 500; display: none; }
  .info-banner { display: flex; align-items: flex-start; gap: 0.75rem; background: rgba(0,229,255,0.05); border: 1px solid rgba(0,229,255,0.15); border-radius: 0.875rem; padding: 1rem 1.25rem; margin-bottom: 1.5rem; font-size: 0.85rem; color: var(--muted); line-height: 1.6; }
  .btn-submit { width: 100%; background: var(--accent); color: #000; border: none; cursor: pointer; font-family: 'DM Sans', sans-serif; font-size: 0.95rem; font-weight: 600; padding: 0.9rem; border-radius: 0.75rem; transition: all 0.2s; box-shadow: 0 0 30px rgba(0,229,255,0.2); }
  .btn-submit:hover { transform: translateY(-1px); box-shadow: 0 0 50px rgba(0,229,255,0.4); }
  .flow-steps { display: grid; grid-template-columns: repeat(3,1fr); gap: 1rem; margin-top: 1.5rem; }
  .flow-step { text-align: center; padding: 1rem; background: var(--surface2); border: 1px solid var(--border); border-radius: 1rem; }
  .flow-step .step-num { font-family: 'Syne', sans-serif; font-size: 1.4rem; font-weight: 800; color: var(--accent); margin-bottom: 0.4rem; }
  .flow-step p { font-size: 0.78rem; color: var(--muted); line-height: 1.5; }
</style>
</head>
<body>
<aside class="sidebar">
  <div class="logo">Smart<span>Balance</span></div>
  <a href="commondashboard.jsp" class="nav-item"><span>🏠</span> Dashboard</a>
  <a href="index.jsp"           class="nav-item active"><span>📤</span> Upload Task</a>
  <a href="dashboard.jsp"       class="nav-item"><span>📋</span> View Tasks</a>
  <a href="attack_monitor.jsp"  class="nav-item"><span>🛡️</span> Attack Monitor</a>
  <a href="server_status.jsp"   class="nav-item"><span>📊</span> Server Status</a>
  <a href="admin_login.jsp"     class="nav-item"><span>🔑</span> Admin Panel</a>
  <div class="spacer"></div>
  <button class="theme-toggle-btn" onclick="toggleTheme()"><span class="theme-icon">☀️</span><span class="theme-label">Light Mode</span></button>
  <a href="logout.jsp" class="nav-item logout"><span>🚪</span> Sign Out</a>
</aside>
<main class="main" style="display:flex;align-items:flex-start;justify-content:center">
  <div class="upload-container">
    <div class="page-header"><h1>Upload Task</h1><p>Submit a file for intelligent analysis and server routing</p></div>
    <div class="card">
      <div class="info-banner"><span>ℹ️</span><span>Files are automatically classified as <strong>Normal</strong>, <strong>Sensitive</strong>, or <strong>Attack</strong> traffic and routed to the most appropriate server.</span></div>
      <form action="TaskServlet" method="post" enctype="multipart/form-data">
        <div class="form-group"><label>Task Name</label><input type="text" name="taskName" placeholder="e.g. Daily log analysis" required></div>
        <div class="form-group">
          <label>Upload File</label>
          <div class="drop-zone" id="dropZone">
            <input type="file" name="file" id="fileInput" required onchange="updateFileName(this)">
            <div class="drop-icon">📁</div>
            <h4>Drop your file here</h4>
            <p>or click to browse — TXT files will be analyzed for threats</p>
            <div class="file-name" id="fileName"></div>
          </div>
        </div>
        <button type="submit" class="btn-submit">⚡ Submit Task</button>
      </form>
    </div>
    <div class="flow-steps">
      <div class="flow-step"><div class="step-num">01</div><p>File uploaded & saved to server</p></div>
      <div class="flow-step"><div class="step-num">02</div><p>AI classifies content & threat level</p></div>
      <div class="flow-step"><div class="step-num">03</div><p>Routed to optimal server automatically</p></div>
    </div>
  </div>
</main>
<script src="theme.js"></script>
<script>
function updateFileName(input) {
  if (input.files && input.files[0]) {
    document.getElementById('fileName').textContent = '✓ ' + input.files[0].name;
    document.getElementById('fileName').style.display = 'block';
    document.querySelector('.drop-icon').textContent = '✅';
  }
}
const dz = document.getElementById('dropZone');
dz.addEventListener('dragover', e => { e.preventDefault(); dz.classList.add('drag-over'); });
dz.addEventListener('dragleave', () => dz.classList.remove('drag-over'));
</script>
</body>
</html>
