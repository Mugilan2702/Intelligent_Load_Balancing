// SmartBalance — Global Theme Manager
// Include this in every JSP page — MUST be in <head>

const HTML = document.documentElement;
const KEY  = 'sb-theme';

// 1. Apply saved theme IMMEDIATELY (prevents white flash)
(function () {
  const saved = localStorage.getItem(KEY) || 'dark';
  HTML.setAttribute('data-theme', saved);
})();

// 2. After DOM ready — sync dropdown value to current theme
document.addEventListener('DOMContentLoaded', function () {
  const current = HTML.getAttribute('data-theme');
  document.querySelectorAll('.theme-select').forEach(function (sel) {
    sel.value = current;
  });
  updateToggleUI();
});

// 3. SELECT dropdown — onchange="applyTheme(this.value)"
function applyTheme(val) {
  HTML.setAttribute('data-theme', val);
  localStorage.setItem(KEY, val);
  document.querySelectorAll('.theme-select').forEach(function (sel) {
    sel.value = val;
  });
  updateToggleUI();
  if (typeof rebuildChart === 'function') rebuildChart();
}

// 4. TOGGLE BUTTON — onclick="toggleTheme()"
function toggleTheme() {
  const next = HTML.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
  applyTheme(next);
}

// 5. Update icon/label on toggle buttons (if any page uses them)
function updateToggleUI() {
  const isDark = HTML.getAttribute('data-theme') === 'dark';
  document.querySelectorAll('.theme-icon').forEach(function (el) {
    el.textContent = isDark ? '☀️' : '🌙';
  });
  document.querySelectorAll('.theme-label').forEach(function (el) {
    el.textContent = isDark ? 'Light Mode' : 'Dark Mode';
  });
}
