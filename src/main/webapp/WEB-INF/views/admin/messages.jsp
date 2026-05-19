<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Author: Rijam Shrestha --%>
<html>
<head>
  <title>Manage Messages</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
  <style>
    .admin-messages-page .admin-content {
      background: #F5F7FA;
    }

    .admin-messages-head {
      margin-top: 18px;
      display: flex;
      align-items: flex-end;
      justify-content: space-between;
      gap: 14px;
      flex-wrap: wrap;
    }

    .admin-messages-head h1 {
      margin: 0;
      font-size: 56px;
      line-height: 1.05;
      letter-spacing: -1px;
      color: #1A1F2B;
    }

    .admin-messages-head p {
      margin: 6px 0 0;
      color: #6B7280;
      font-size: 17px;
    }

    .admin-messages-actions {
      display: inline-flex;
      align-items: center;
      gap: 10px;
      flex-wrap: wrap;
    }

    .admin-btn {
      height: 52px;
      border-radius: 14px;
      border: 1px solid #D1D5DB;
      background: #FFFFFF;
      color: #374151;
      padding: 0 20px;
      font-size: 15px;
      font-weight: 600;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      text-decoration: none;
      font-family: inherit;
      cursor: pointer;
    }

    .admin-btn:hover {
      border-color: #1976D2;
      color: #1976D2;
      background: #F8FBFF;
    }

    .admin-messages-tabs {
      margin-top: 14px;
      background: #FFFFFF;
      border: 1px solid #E5E7EB;
      border-radius: 16px;
      padding: 12px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 12px;
      flex-wrap: wrap;
    }

    .tabs-group {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      background: #F3F4F6;
      border-radius: 12px;
      padding: 4px;
    }

    .tab-btn {
      height: 42px;
      border-radius: 10px;
      border: 1px solid transparent;
      background: transparent;
      color: #4B5563;
      font-size: 15px;
      font-weight: 700;
      padding: 0 20px;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      white-space: nowrap;
    }

    .tab-btn.active {
      background: #FFFFFF;
      border-color: #E5E7EB;
      color: #111827;
    }

    .tab-count {
      margin-left: 6px;
      font-size: 12px;
      color: #6B7280;
    }

    .messages-filter-form {
      display: grid;
      grid-template-columns: minmax(320px, 1fr) 220px auto auto;
      gap: 10px;
      align-items: center;
      width: 100%;
    }

    .admin-filter-input,
    .admin-filter-date {
      height: 50px;
      border: 1px solid #CBD5E1;
      border-radius: 12px;
      background: #FFFFFF;
      display: inline-flex;
      align-items: center;
      gap: 10px;
      padding: 0 14px;
      color: #94A3B8;
    }

    .admin-filter-input input,
    .admin-filter-date input {
      width: 100%;
      border: 0 !important;
      outline: 0;
      padding: 0 !important;
      margin: 0 !important;
      background: transparent !important;
      color: #1F2937;
      box-shadow: none !important;
      font-size: 15px;
      font-family: inherit;
    }

    .filter-btn,
    .reset-link {
      height: 50px;
      border-radius: 12px;
      border: 1px solid #D1D5DB;
      background: #FFFFFF;
      color: #4B5563;
      font-size: 14px;
      font-weight: 700;
      padding: 0 16px;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      font-family: inherit;
      cursor: pointer;
      white-space: nowrap;
    }

    .filter-btn:hover,
    .reset-link:hover {
      border-color: #1976D2;
      color: #1976D2;
      background: #F8FBFF;
    }

    .admin-messages-card {
      margin-top: 14px;
      background: #FFFFFF;
      border: 1px solid #E5E7EB;
      border-radius: 16px;
      overflow: hidden;
    }

    .inbox-head {
      padding: 18px;
      border-bottom: 1px solid #E5E7EB;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 10px;
      flex-wrap: wrap;
    }

    .inbox-head h2 {
      margin: 0;
      font-size: 36px;
      letter-spacing: -0.6px;
      color: #111827;
    }

    .inbox-head span {
      color: #6B7280;
      font-size: 16px;
      font-weight: 600;
    }

    .messages-table-wrap {
      overflow-x: auto;
    }

    .messages-table {
      width: 100%;
      border-collapse: collapse;
      min-width: 1220px;
    }

    .messages-table thead th {
      background: #F8FAFC;
      color: #4B5563;
      font-size: 16px;
      font-weight: 700;
      border-bottom: 1px solid #E5E7EB;
      padding: 14px 12px;
      text-align: left;
    }

    .messages-table tbody td {
      padding: 14px 12px;
      border-bottom: 1px solid #EEF2F7;
      color: #333333;
      font-size: 15px;
      vertical-align: middle;
    }

    .messages-table tbody tr:hover {
      background: #FAFCFF;
    }

    .col-check {
      width: 44px;
      text-align: center;
    }

    .messages-table input[type="checkbox"] {
      width: 20px;
      height: 20px;
      accent-color: #1976D2;
      cursor: pointer;
    }

    .sender-cell {
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .sender-avatar {
      width: 42px;
      height: 42px;
      border-radius: 999px;
      background: #EAF3FF;
      color: #1976D2;
      display: grid;
      place-items: center;
      font-weight: 700;
      font-size: 15px;
      flex-shrink: 0;
    }

    .sender-cell strong {
      display: block;
      color: #1F2937;
      font-size: 16px;
      line-height: 1.2;
    }

    .sender-cell small {
      color: #6B7280;
      font-size: 14px;
    }

    .subject-text {
      color: #1F2937;
      font-size: 16px;
      font-weight: 700;
      line-height: 1.3;
      max-width: 290px;
    }

    .preview-text {
      color: #4B5563;
      max-width: 420px;
      display: -webkit-box;
      -webkit-line-clamp: 1;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }

    .date-text {
      color: #4B5563;
      font-size: 15px;
      font-weight: 600;
      white-space: nowrap;
    }

    .status-pill {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      border-radius: 999px;
      border: 1px solid #D1D5DB;
      padding: 6px 14px;
      font-size: 14px;
      font-weight: 700;
      text-transform: capitalize;
      white-space: nowrap;
    }

    .status-pill.unread {
      background: #EAF3FF;
      border-color: #CFE3FF;
      color: #1976D2;
    }

    .status-pill.read {
      background: #F3F4F6;
      border-color: #E5E7EB;
      color: #6B7280;
    }

    .actions-cell {
      min-width: 320px;
    }

    .row-actions {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      flex-wrap: wrap;
    }

    .row-actions form {
      margin: 0;
    }

    .action-btn {
      height: 36px;
      border-radius: 10px;
      border: 1px solid #D1D5DB;
      background: #FFFFFF;
      color: #4B5563;
      padding: 0 12px;
      font-size: 13px;
      font-weight: 700;
      font-family: inherit;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      gap: 6px;
    }

    .action-btn:hover {
      border-color: #1976D2;
      color: #1976D2;
      background: #F8FBFF;
    }

    .action-btn.read {
      border-color: #CFE3FF;
      color: #1976D2;
      background: #F4F9FF;
    }

    .action-btn.delete {
      border-color: #FFC9CE;
      color: #DC2626;
      background: #FFF1F2;
    }

    .action-btn.view {
      border-color: #CDE8CF;
      color: #2E7D32;
      background: #ECF8EE;
      text-decoration: none;
    }

    .action-btn:disabled {
      opacity: 0.55;
      cursor: not-allowed;
    }

    .table-empty {
      text-align: center;
      padding: 44px 12px;
      color: #9CA3AF;
      font-size: 15px;
    }

    .messages-footer {
      padding: 16px 18px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      color: #7B8798;
      font-size: 14px;
      border-top: 1px solid #E5E7EB;
      gap: 10px;
      flex-wrap: wrap;
    }

    .messages-pager {
      display: inline-flex;
      gap: 8px;
      align-items: center;
    }

    .messages-pager button,
    .messages-pager span {
      height: 42px;
      min-width: 42px;
      border-radius: 12px;
      border: 1px solid #D1D5DB;
      background: #FFFFFF;
      color: #4B5563;
      font-size: 15px;
      font-weight: 700;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      padding: 0 12px;
    }

    .messages-pager .active {
      border-color: #2E7D32;
      background: #2E7D32;
      color: #FFFFFF;
    }

    .message-dialog {
      border: 0;
      border-radius: 14px;
      width: min(680px, 92vw);
      padding: 0;
      box-shadow: 0 25px 60px rgba(15, 23, 42, 0.25);
    }

    .message-dialog::backdrop {
      background: rgba(15, 23, 42, 0.35);
    }

    .dialog-head {
      padding: 16px 18px;
      border-bottom: 1px solid #E5E7EB;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 8px;
    }

    .dialog-head h3 {
      margin: 0;
      color: #111827;
      font-size: 20px;
    }

    .dialog-close {
      width: 36px;
      height: 36px;
      border-radius: 10px;
      border: 1px solid #D1D5DB;
      background: #FFFFFF;
      color: #6B7280;
      cursor: pointer;
      font-size: 16px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
    }

    .dialog-close:hover {
      border-color: #1976D2;
      color: #1976D2;
      background: #F8FBFF;
    }

    .dialog-body {
      padding: 18px;
      color: #374151;
      font-size: 15px;
      line-height: 1.5;
      white-space: pre-wrap;
    }

    .dialog-meta {
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 10px;
      padding: 0 18px 14px;
    }

    .dialog-meta div {
      background: #F8FAFC;
      border: 1px solid #E5E7EB;
      border-radius: 10px;
      padding: 10px;
      font-size: 14px;
      color: #4B5563;
    }

    .dialog-meta strong {
      display: block;
      color: #1F2937;
      margin-bottom: 4px;
      font-size: 13px;
      text-transform: uppercase;
      letter-spacing: 0.4px;
    }

    @media (max-width: 1400px) {
      .messages-filter-form {
        grid-template-columns: 1fr 1fr;
      }
    }

    @media (max-width: 1024px) {
      .admin-messages-head {
        flex-direction: column;
        align-items: flex-start;
      }

      .admin-messages-head h1 {
        font-size: 42px;
      }
    }

    @media (max-width: 760px) {
      .messages-filter-form {
        grid-template-columns: 1fr;
      }

      .admin-messages-head h1 {
        font-size: 34px;
      }

      .admin-messages-actions {
        width: 100%;
      }

      .admin-btn {
        width: 100%;
        justify-content: center;
      }

      .inbox-head h2 {
        font-size: 30px;
      }

      .dialog-meta {
        grid-template-columns: 1fr;
      }
    }
  </style>
</head>
<body class="admin-dashboard-page admin-messages-page">
<div class="admin-shell">
  <jsp:include page="../common/admin-sidebar.jsp"/>

  <main class="admin-content">
    <section class="admin-topbar">
      <div class="admin-breadcrumb">
        <span>Dashboard</span>
        <i class="fa-solid fa-chevron-right"></i>
        <span>Support</span>
        <i class="fa-solid fa-chevron-right"></i>
        <strong>Messages</strong>
      </div>
      <div class="admin-topbar-actions">
        <div class="admin-user-chip">
          <div><strong>Admin User</strong><small>Super Administrator</small></div>
          <span>A</span>
        </div>
      </div>
    </section>

    <section class="admin-messages-head">
      <div>
        <h1>Manage Messages</h1>
        <p>Review and respond to user inquiries and support tickets.</p>
      </div>
      <div class="admin-messages-actions">
        <a class="admin-btn" href="${pageContext.request.contextPath}/admin/messages"><i class="fa-solid fa-rotate-right"></i> Refresh</a>
      </div>
    </section>

    <section class="admin-messages-tabs">
      <div class="tabs-group">
        <a class="tab-btn ${empty status ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/messages">All <span class="tab-count">${allMessagesCount}</span></a>
        <a class="tab-btn ${status == 'unread' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/messages?status=unread">Unread <span class="tab-count">${unreadCount}</span></a>
        <a class="tab-btn ${status == 'read' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/messages?status=read">Read <span class="tab-count">${readCount}</span></a>
      </div>

      <form class="messages-filter-form" method="get" action="${pageContext.request.contextPath}/admin/messages">
        <input type="hidden" name="status" value="${status}">
        <input type="hidden" name="pageSize" value="${pageSize}">
        <label class="admin-filter-input">
          <i class="fa-solid fa-magnifying-glass"></i>
          <input type="text" name="q" value="${q}" placeholder="Search sender or subject...">
        </label>
        <label class="admin-filter-date">
          <i class="fa-regular fa-calendar"></i>
          <input type="date" name="sentDate" value="${sentDate}">
        </label>
        <button class="filter-btn" type="submit"><i class="fa-solid fa-filter"></i> More Filters</button>
        <a class="reset-link" href="${pageContext.request.contextPath}/admin/messages">Reset</a>
      </form>
    </section>

    <section class="admin-messages-card">
      <header class="inbox-head">
        <h2>Inbox</h2>
        <span>Showing ${messagesCount} of ${allMessagesCount} messages</span>
      </header>

      <div class="messages-table-wrap">
        <table class="messages-table">
          <thead>
          <tr>
            <th class="col-check"><input type="checkbox" id="checkAllMessages"></th>
            <th>Sender</th>
            <th>Subject</th>
            <th>Message Preview</th>
            <th>Sent Date</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="m" items="${messages}">
            <c:set var="messageId" value="${m.message_id}"/>
            <c:set var="messageText" value="${empty m.message ? '-' : m.message}"/>
            <c:set var="sentAt" value="${not empty m.created_at ? m.created_at : (not empty m.submitted_at ? m.submitted_at : '-')}"/>
            <tr>
              <td class="col-check"><input type="checkbox" name="selectedMessages" value="${messageId}"></td>
              <td>
                <div class="sender-cell">
                  <span class="sender-avatar">${empty m.name ? 'U' : fn:substring(m.name, 0, 1)}</span>
                  <div>
                    <strong>${empty m.name ? '-' : m.name}</strong>
                    <small>${empty m.email ? '-' : m.email}</small>
                  </div>
                </div>
              </td>
              <td><div class="subject-text">${empty m.subject ? '-' : m.subject}</div></td>
              <td><div class="preview-text">${messageText}</div></td>
              <td><span class="date-text">${sentAt}</span></td>
              <td>
                <span class="status-pill ${m.status}">
                  <i class="fa-regular fa-circle-dot"></i>
                  ${empty m.status ? '-' : m.status}
                </span>
              </td>
              <td class="actions-cell">
                <div class="row-actions">
                  <button type="button" class="action-btn view" data-dialog-id="msg-${messageId}"><i class="fa-regular fa-eye"></i> View</button>

                  <form method="post" action="${pageContext.request.contextPath}/admin/messages">
                    <input type="hidden" name="action" value="readMessage">
                    <input type="hidden" name="messageId" value="${messageId}">
                    <button class="action-btn read" type="submit" ${m.status == 'read' ? 'disabled' : ''}><i class="fa-regular fa-envelope-open"></i> Mark Read</button>
                  </form>

                  <form method="post" action="${pageContext.request.contextPath}/admin/messages">
                    <input type="hidden" name="action" value="deleteMessage">
                    <input type="hidden" name="messageId" value="${messageId}">
                    <button class="action-btn delete" type="submit"><i class="fa-regular fa-trash-can"></i> Delete</button>
                  </form>
                </div>

                <dialog id="msg-${messageId}" class="message-dialog">
                  <div class="dialog-head">
                    <h3>${empty m.subject ? 'Message Details' : m.subject}</h3>
                    <button type="button" class="dialog-close" data-close-dialog="msg-${messageId}"><i class="fa-solid fa-xmark"></i></button>
                  </div>
                  <div class="dialog-meta">
                    <div><strong>Sender</strong>${empty m.name ? '-' : m.name}</div>
                    <div><strong>Email</strong>${empty m.email ? '-' : m.email}</div>
                    <div><strong>Sent Date</strong>${sentAt}</div>
                    <div><strong>Status</strong>${empty m.status ? '-' : m.status}</div>
                  </div>
                  <div class="dialog-body">${messageText}</div>
                </dialog>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty messages}">
            <tr>
              <td colspan="7" class="table-empty">No messages found for the selected filters.</td>
            </tr>
          </c:if>
          </tbody>
        </table>
      </div>

      <footer class="messages-footer">
        <span>Showing ${messagesFrom}-${messagesTo} of ${messagesFilteredCount} messages</span>
        <div class="messages-pager">
          <a class="admin-btn" href="${pageContext.request.contextPath}/admin/messages?q=${q}&status=${status}&sentDate=${sentDate}&pageSize=${pageSize}&page=${page - 1}" ${page <= 1 ? 'aria-disabled="true" style="height:42px;pointer-events:none;opacity:.5"' : 'style="height:42px"'}>Previous</a>
          <c:forEach begin="1" end="${totalPages}" var="pNum">
            <a class="admin-btn ${pNum == page ? 'active' : ''}" style="height:42px;min-width:42px;padding:0 12px;justify-content:center" href="${pageContext.request.contextPath}/admin/messages?q=${q}&status=${status}&sentDate=${sentDate}&pageSize=${pageSize}&page=${pNum}">${pNum}</a>
          </c:forEach>
          <a class="admin-btn" href="${pageContext.request.contextPath}/admin/messages?q=${q}&status=${status}&sentDate=${sentDate}&pageSize=${pageSize}&page=${page + 1}" ${page >= totalPages ? 'aria-disabled="true" style="height:42px;pointer-events:none;opacity:.5"' : 'style="height:42px"'}>Next</a>
        </div>
      </footer>
    </section>
  </main>
</div>

<script>
  document.getElementById('checkAllMessages')?.addEventListener('change', function() {
    document.querySelectorAll('input[name="selectedMessages"]').forEach((checkbox) => {
      checkbox.checked = this.checked;
    });
  });

  document.querySelectorAll('[data-dialog-id]').forEach((button) => {
    button.addEventListener('click', function() {
      const dialog = document.getElementById(this.getAttribute('data-dialog-id'));
      if (dialog) dialog.showModal();
    });
  });

  document.querySelectorAll('[data-close-dialog]').forEach((button) => {
    button.addEventListener('click', function() {
      const dialog = document.getElementById(this.getAttribute('data-close-dialog'));
      if (dialog) dialog.close();
    });
  });
</script>
</body>
</html>
