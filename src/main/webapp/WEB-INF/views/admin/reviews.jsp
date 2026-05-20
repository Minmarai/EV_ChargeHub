<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Author: Rijam Shrestha --%>
<html>
<head>
  <title>Manage Reviews</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
  <style>
    .admin-reviews-page .admin-content {
      background: #F5F7FA;
    }

    .admin-reviews-head {
      margin-top: 18px;
      display: flex;
      align-items: flex-end;
      justify-content: space-between;
      gap: 14px;
      flex-wrap: wrap;
    }

    .admin-reviews-head h1 {
      margin: 0;
      font-size: 56px;
      line-height: 1.05;
      letter-spacing: -1px;
      color: #1A1F2B;
    }

    .admin-reviews-head p {
      margin: 6px 0 0;
      color: #6B7280;
      font-size: 17px;
    }

    .admin-reviews-actions {
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

    .admin-reviews-stats {
      margin-top: 16px;
      display: grid;
      grid-template-columns: repeat(3, minmax(0, 1fr));
      gap: 12px;
    }

    .review-stat {
      background: #FFFFFF;
      border: 1px solid #E5E7EB;
      border-radius: 16px;
      padding: 18px;
      min-height: 130px;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
    }

    .review-stat-top {
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 10px;
    }

    .review-stat label {
      color: #7B8798;
      font-size: 14px;
      font-weight: 600;
      margin: 0;
    }

    .review-stat h3 {
      margin: 8px 0 0;
      color: #1F2937;
      font-size: 42px;
      line-height: 1;
      letter-spacing: -0.8px;
    }

    .review-stat p {
      margin: 8px 0 0;
      font-size: 13px;
      color: #9CA3AF;
    }

    .review-stat-icon {
      width: 52px;
      height: 52px;
      border-radius: 14px;
      display: grid;
      place-items: center;
      font-size: 20px;
    }

    .review-stat-icon.blue {
      background: #EAF3FF;
      color: #1976D2;
    }

    .review-stat-icon.green {
      background: #ECF8EE;
      color: #2E7D32;
    }

    .review-stat-icon.orange {
      background: #FFF6EB;
      color: #FF9800;
    }

    .admin-review-filter-card {
      margin-top: 14px;
      background: #FFFFFF;
      border: 1px solid #E5E7EB;
      border-radius: 16px;
      overflow: hidden;
    }

    .admin-review-filters {
      padding: 14px;
      border-bottom: 1px solid #E5E7EB;
      display: grid;
      grid-template-columns: minmax(300px, 1fr) 1fr 1fr 1fr auto auto;
      gap: 10px;
      align-items: center;
    }

    .admin-filter-input,
    .admin-filter-select {
      height: 56px;
      border: 1px solid #CBD5E1;
      border-radius: 14px;
      background: #FFFFFF;
      display: inline-flex;
      align-items: center;
      gap: 10px;
      padding: 0 14px;
      color: #94A3B8;
    }

    .admin-filter-input input,
    .admin-filter-select select {
      width: 100%;
      border: 0 !important;
      outline: 0;
      padding: 0 !important;
      margin: 0 !important;
      height: auto !important;
      background: transparent !important;
      color: #1F2937;
      box-shadow: none !important;
      font-size: 15px;
      font-family: inherit;
    }

    .admin-filter-select select {
      appearance: none;
    }

    .admin-filter-actions {
      height: 56px;
      border: 0;
      background: transparent;
      color: #6B7280;
      font-size: 18px;
      font-weight: 600;
      cursor: pointer;
      padding: 0 8px;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
    }

    .admin-filter-actions:hover {
      color: #1976D2;
    }

    .admin-filter-submit {
      height: 56px;
      border-radius: 14px;
      border: 1px solid #D1D5DB;
      background: #FFFFFF;
      color: #4B5563;
      font-size: 15px;
      font-weight: 700;
      padding: 0 14px;
      font-family: inherit;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      justify-content: center;
    }

    .admin-filter-submit:hover {
      border-color: #1976D2;
      color: #1976D2;
      background: #F8FBFF;
    }

    .admin-reviews-table-wrap {
      overflow-x: auto;
    }

    .admin-reviews-table {
      width: 100%;
      border-collapse: collapse;
      min-width: 1180px;
    }

    .admin-reviews-table thead th {
      background: #F8FAFC;
      color: #4B5563;
      font-size: 16px;
      font-weight: 700;
      border-bottom: 1px solid #E5E7EB;
      padding: 14px 12px;
      text-align: left;
    }

    .admin-reviews-table tbody td {
      padding: 14px 12px;
      border-bottom: 1px solid #EEF2F7;
      font-size: 15px;
      color: #333333;
      vertical-align: middle;
    }

    .admin-reviews-table tbody tr:hover {
      background: #FAFCFF;
    }

    .col-check {
      width: 44px;
      text-align: center;
    }

    .admin-reviews-table input[type="checkbox"] {
      width: 20px;
      height: 20px;
      accent-color: #1976D2;
      cursor: pointer;
    }

    .station-name {
      color: #1F2937;
      font-size: 16px;
      font-weight: 700;
      line-height: 1.25;
    }

    .user-cell {
      display: flex;
      align-items: center;
      gap: 12px;
    }

    .user-avatar {
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

    .user-cell strong {
      display: block;
      color: #1F2937;
      font-size: 16px;
      line-height: 1.2;
    }

    .user-cell small {
      color: #9CA3AF;
      font-size: 13px;
    }

    .rating-stars {
      display: inline-flex;
      gap: 3px;
      color: #FF9800;
      font-size: 17px;
      letter-spacing: 0.3px;
    }

    .rating-stars .off {
      color: #D1D5DB;
    }

    .rating-date {
      margin-top: 6px;
      color: #6B7280;
      font-size: 13px;
      font-weight: 600;
    }

    .comment-text {
      color: #374151;
      line-height: 1.45;
      max-width: 480px;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }

    .status-pill {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 6px 14px;
      border-radius: 999px;
      border: 1px solid #D1D5DB;
      font-size: 14px;
      font-weight: 700;
      text-transform: lowercase;
    }

    .status-pill.visible {
      background: #ECF8EE;
      border-color: #CDE8CF;
      color: #2E7D32;
    }

    .status-pill.hidden {
      background: #F3F4F6;
      border-color: #E5E7EB;
      color: #6B7280;
    }

    .actions-cell {
      min-width: 260px;
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

    .action-btn.hide {
      border-color: #FFD59B;
      color: #B86A00;
      background: #FFF9F0;
    }

    .action-btn.show {
      border-color: #CFE3FF;
      color: #1976D2;
      background: #F4F9FF;
    }

    .action-btn.delete {
      border-color: #FFC9CE;
      color: #DC2626;
      background: #FFF1F2;
    }

    .action-btn:disabled {
      opacity: 0.5;
      cursor: not-allowed;
    }

    .table-empty {
      text-align: center;
      padding: 44px 12px;
      color: #9CA3AF;
      font-size: 15px;
    }

    .admin-reviews-footer {
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

    .admin-reviews-pager {
      display: inline-flex;
      gap: 8px;
      align-items: center;
    }

    .admin-reviews-pager button,
    .admin-reviews-pager span {
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

    .admin-reviews-pager .active {
      border-color: #2E7D32;
      background: #2E7D32;
      color: #FFFFFF;
    }

    @media (max-width: 1400px) {
      .admin-review-filters {
        grid-template-columns: 1fr 1fr;
      }

      .admin-reviews-stats {
        grid-template-columns: 1fr;
      }
    }

    @media (max-width: 1024px) {
      .admin-reviews-head {
        flex-direction: column;
        align-items: flex-start;
      }

      .admin-reviews-head h1 {
        font-size: 42px;
      }
    }

    @media (max-width: 760px) {
      .admin-review-filters {
        grid-template-columns: 1fr;
      }

      .admin-reviews-head h1 {
        font-size: 34px;
      }

      .admin-reviews-actions {
        width: 100%;
      }

      .admin-btn {
        width: 100%;
        justify-content: center;
      }
    }
  </style>
</head>
<body class="admin-dashboard-page admin-reviews-page">
<div class="admin-shell">
  <jsp:include page="../common/admin-sidebar.jsp"/>

  <main class="admin-content">
    <section class="admin-topbar">
      <div class="admin-breadcrumb">
        <span>Dashboard</span>
        <i class="fa-solid fa-chevron-right"></i>
        <span>Management</span>
        <i class="fa-solid fa-chevron-right"></i>
        <strong>Reviews</strong>
      </div>
      <div class="admin-topbar-actions">
        <div class="admin-user-chip">
          <div><strong>Admin User</strong><small>Super Administrator</small></div>
          <span>A</span>
        </div>
      </div>
    </section>

    <section class="admin-reviews-head">
      <div>
        <h1>Manage Reviews</h1>
        <p>Moderating user feedback across all charging stations in the network.</p>
      </div>
      <div class="admin-reviews-actions">
        <a class="admin-btn" href="${pageContext.request.contextPath}/admin/reviews"><i class="fa-solid fa-rotate-right"></i> Refresh Data</a>
      </div>
    </section>

    <section class="admin-reviews-stats">
      <article class="review-stat">
        <div class="review-stat-top">
          <div>
            <label>Total Reviews</label>
            <h3>${allReviewsCount}</h3>
          </div>
          <span class="review-stat-icon blue"><i class="fa-regular fa-message"></i></span>
        </div>
        <p>all review records in moderation</p>
      </article>

      <article class="review-stat">
        <div class="review-stat-top">
          <div>
            <label>Visible Reviews</label>
            <h3>${visibleReviews}</h3>
          </div>
          <span class="review-stat-icon green"><i class="fa-regular fa-eye"></i></span>
        </div>
        <p>currently public on station pages</p>
      </article>

      <article class="review-stat">
        <div class="review-stat-top">
          <div>
            <label>Hidden Reviews</label>
            <h3>${hiddenReviews}</h3>
          </div>
          <span class="review-stat-icon orange"><i class="fa-regular fa-eye-slash"></i></span>
        </div>
        <p>suppressed by moderation actions</p>
      </article>
    </section>

    <section class="admin-review-filter-card">
      <form class="admin-review-filters" method="get" action="${pageContext.request.contextPath}/admin/reviews">
        <input type="hidden" name="pageSize" value="${pageSize}">
        <label class="admin-filter-input">
          <i class="fa-solid fa-magnifying-glass"></i>
          <input type="text" name="q" value="${q}" placeholder="Search reviews by content, user, or station...">
        </label>

        <label class="admin-filter-select">
          <i class="fa-solid fa-location-dot"></i>
          <select name="station">
            <option value="">All Stations</option>
            <c:forEach var="s" items="${stations}">
              <option value="${s}" ${station == s ? 'selected' : ''}>${s}</option>
            </c:forEach>
          </select>
        </label>

        <label class="admin-filter-select">
          <i class="fa-solid fa-star"></i>
          <select name="rating">
            <option value="">All Ratings</option>
            <option value="5" ${rating == '5' ? 'selected' : ''}>5 Stars</option>
            <option value="4" ${rating == '4' ? 'selected' : ''}>4 Stars</option>
            <option value="3" ${rating == '3' ? 'selected' : ''}>3 Stars</option>
            <option value="2" ${rating == '2' ? 'selected' : ''}>2 Stars</option>
            <option value="1" ${rating == '1' ? 'selected' : ''}>1 Star</option>
          </select>
        </label>

        <label class="admin-filter-select">
          <i class="fa-solid fa-filter"></i>
          <select name="status">
            <option value="">All Status</option>
            <option value="visible" ${status == 'visible' ? 'selected' : ''}>Visible</option>
            <option value="hidden" ${status == 'hidden' ? 'selected' : ''}>Hidden</option>
          </select>
        </label>

        <button class="admin-filter-submit" type="submit"><i class="fa-solid fa-filter"></i> More Filters</button>
        <a class="admin-filter-actions" href="${pageContext.request.contextPath}/admin/reviews">Reset</a>
      </form>

      <div class="admin-reviews-table-wrap">
        <table class="admin-reviews-table">
          <thead>
          <tr>
            <th class="col-check"><input type="checkbox" id="checkAllReviews"></th>
            <th>Station</th>
            <th>User</th>
            <th>Rating</th>
            <th>Comment</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="r" items="${reviews}">
            <tr>
              <td class="col-check"><input type="checkbox" name="selectedReviews" value="${r.review_id}"></td>
              <td>
                <div class="station-name">${empty r.station_name ? '-' : r.station_name}</div>
              </td>
              <td>
                <div class="user-cell">
                  <span class="user-avatar">${empty r.full_name ? 'U' : fn:substring(r.full_name, 0, 1)}</span>
                  <div>
                    <strong>${empty r.full_name ? '-' : r.full_name}</strong>
                    <small>User ID: ${r.user_id}</small>
                  </div>
                </div>
              </td>
              <td>
                <div class="rating-stars">
                  <c:forEach begin="1" end="5" var="i">
                    <span class="${i <= r.rating ? '' : 'off'}"><i class="fa-solid fa-star"></i></span>
                  </c:forEach>
                </div>
                <div class="rating-date">
                  <c:choose>
                    <c:when test="${not empty r.review_date}">${r.review_date}</c:when>
                    <c:when test="${not empty r.created_at}">${r.created_at}</c:when>
                    <c:otherwise>Review #${r.review_id}</c:otherwise>
                  </c:choose>
                </div>
              </td>
              <td>
                <div class="comment-text">${empty r.comment ? '-' : r.comment}</div>
              </td>
              <td>
                <span class="status-pill ${r.status}">
                  <i class="fa-regular fa-circle-dot"></i>
                  ${empty r.status ? '-' : r.status}
                </span>
              </td>
              <td class="actions-cell">
                <div class="row-actions">
                  <form method="post" action="${pageContext.request.contextPath}/admin/reviews">
                    <input type="hidden" name="action" value="reviewStatus">
                    <input type="hidden" name="reviewId" value="${r.review_id}">
                    <input type="hidden" name="status" value="hidden">
                    <button class="action-btn hide" type="submit" ${r.status == 'hidden' ? 'disabled' : ''}><i class="fa-regular fa-eye-slash"></i> Hide</button>
                  </form>

                  <form method="post" action="${pageContext.request.contextPath}/admin/reviews">
                    <input type="hidden" name="action" value="reviewStatus">
                    <input type="hidden" name="reviewId" value="${r.review_id}">
                    <input type="hidden" name="status" value="visible">
                    <button class="action-btn show" type="submit" ${r.status == 'visible' ? 'disabled' : ''}><i class="fa-regular fa-eye"></i> Show</button>
                  </form>

                  <form method="post" action="${pageContext.request.contextPath}/admin/reviews">
                    <input type="hidden" name="action" value="deleteReview">
                    <input type="hidden" name="reviewId" value="${r.review_id}">
                    <button class="action-btn delete" type="submit"><i class="fa-regular fa-trash-can"></i> Delete</button>
                  </form>
                </div>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty reviews}">
            <tr>
              <td colspan="7" class="table-empty">No reviews found for the selected filters.</td>
            </tr>
          </c:if>
          </tbody>
        </table>
      </div>

      <div class="admin-reviews-footer">
        <span>Showing ${reviewsFrom}-${reviewsTo} of ${reviewsFilteredCount} reviews</span>
        <div class="admin-reviews-pager">
          <a class="admin-btn" href="${pageContext.request.contextPath}/admin/reviews?q=${q}&station=${station}&rating=${rating}&status=${status}&pageSize=${pageSize}&page=${page - 1}" ${page <= 1 ? 'aria-disabled="true" style="height:42px;pointer-events:none;opacity:.5"' : 'style="height:42px"'}><i class="fa-solid fa-chevron-left"></i> Previous</a>
          <c:forEach begin="1" end="${totalPages}" var="pNum">
            <a class="admin-btn ${pNum == page ? 'active' : ''}" style="height:42px;min-width:42px;padding:0 12px;justify-content:center" href="${pageContext.request.contextPath}/admin/reviews?q=${q}&station=${station}&rating=${rating}&status=${status}&pageSize=${pageSize}&page=${pNum}">${pNum}</a>
          </c:forEach>
          <a class="admin-btn" href="${pageContext.request.contextPath}/admin/reviews?q=${q}&station=${station}&rating=${rating}&status=${status}&pageSize=${pageSize}&page=${page + 1}" ${page >= totalPages ? 'aria-disabled="true" style="height:42px;pointer-events:none;opacity:.5"' : 'style="height:42px"'}>Next <i class="fa-solid fa-chevron-right"></i></a>
        </div>
      </div>
    </section>
  </main>
</div>

<script>
  document.getElementById('checkAllReviews')?.addEventListener('change', function() {
    document.querySelectorAll('input[name="selectedReviews"]').forEach((checkbox) => {
      checkbox.checked = this.checked;
    });
  });
</script>
</body>
</html>
