<%-- Shared sidebar — include this in every dashboard page --%>
<%-- Usage: <%@ include file="sidebar.jsp" %> --%>
<%-- Set String activePage = "dashboard" before including --%>
<aside class="sidebar">
  <div class="logo">Smart<span>Balance</span></div>
  <a href="commondashboard.jsp" class="nav-item <%="dashboard".equals(activePage)?"active":""%>"><span>🏠</span> Dashboard</a>
  <a href="index.jsp"           class="nav-item <%="upload".equals(activePage)?"active":""%>"><span>📤</span> Upload Task</a>
  <a href="dashboard.jsp"       class="nav-item <%="tasks".equals(activePage)?"active":""%>"><span>📋</span> View Tasks</a>
  <a href="attack_monitor.jsp"  class="nav-item <%="attack".equals(activePage)?"active":""%>"><span>🛡️</span> Attack Monitor</a>
  <a href="server_status.jsp"   class="nav-item <%="server".equals(activePage)?"active":""%>"><span>📊</span> Server Status</a>
  <a href="admin_login.jsp"     class="nav-item <%="admin".equals(activePage)?"active":""%>"><span>🔑</span> Admin Panel</a>
  <div class="spacer"></div>
  <button class="theme-toggle-btn" onclick="toggleTheme()">
    <span class="theme-icon">☀️</span>
    <span class="theme-label">Light Mode</span>
  </button>
  <a href="logout.jsp" class="nav-item logout"><span>🚪</span> Sign Out</a>
</aside>
