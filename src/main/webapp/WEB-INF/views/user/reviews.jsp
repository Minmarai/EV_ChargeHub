<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Author: Rijam Shrestha --%>
<html>
<head>
  <title>My Reviews</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
  <style>
    .user-reviews-page {
      --primary-green: #2E7D32;
      --secondary-blue: #1976D2;
      --accent-orange: #FF9800;
      --light-bg: #F5F7FA;
      --white-card: #FFFFFF;
      --text-dark: #333333;
      background: var(--light-bg);
      color: var(--text-dark);
    }

    .user-topbar {
      height: 72px;
      background: #FFFFFF;
      border-bottom: 1px solid #E5E7EB;
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 0 20px;
    }

    .topbar-brand {
      display: flex;
      align-items: center;
      gap: 12px;
    }

    .topbar-brand-mark {
      width: 36px;
      height: 36px;
      border-radius: 10px;
      background: #00B300;
      color: #FFFFFF;
      display: grid;
      place-items: center;
      font-size: 16px;
    }

    .topbar-brand-text {
      margin: 0;
      color: #00B300;
      font-size: 24px;
      line-height: 1;
      font-weight: 800;
      letter-spacing: -0.4px;
    }

    .topbar-actions {
      display: flex;
      align-items: center;
      gap: 18px;
    }

    .topbar-bell {
      color: #9CA3AF;
      font-size: 18px;
      line-height: 1;
    }

    .topbar-avatar {
      width: 40px;
      height: 40px;
      border-radius: 999px;
      border: 1px solid #E5E7EB;
      background: #EEF3FC;
      color: #64748B;
      display: grid;
      place-items: center;
      font-size: 14px;
      font-weight: 700;
      position: relative;
      overflow: hidden;
    }

    .topbar-avatar::after {
      content: "";
      width: 9px;
      height: 9px;
      border-radius: 999px;
      border: 2px solid #FFFFFF;
      background: #2E7D32;
      position: absolute;
      right: 1px;
      bottom: 1px;
    }

    .user-reviews-page .layout {
      min-height: calc(100vh - 72px);
      background: #F5F7FA;
    }

    .user-reviews-page .user-sidebar {
      width: 315px;
      min-height: calc(100vh - 72px);
      position: sticky;
      top: 72px;
      background: #F8FAFC;
      border-right: 1px solid #E5E7EB;
      padding: 16px;
      display: flex;
      flex-direction: column;
      gap: 8px;
    }

    .user-reviews-page .user-side-brand,
    .user-reviews-page .user-side-logout {
      display: none;
    }

    .user-reviews-page .user-side-nav {
      display: grid;
      gap: 6px;
    }

    .user-reviews-page .user-side-nav a {
      border-radius: 12px;
      border: 1px solid transparent;
      color: #8C95A3;
      text-decoration: none;
      padding: 12px 14px;
      display: flex;
      align-items: center;
      gap: 12px;
      font-size: 14px;
      font-weight: 500;
      line-height: 1.2;
    }

    .user-reviews-page .user-side-nav a i {
      width: 28px;
      text-align: center;
      color: #8C95A3;
      font-size: 18px;
      line-height: 1;
    }

    .user-reviews-page .user-side-nav a:hover {
      background: #FFFFFF;
      border-color: #E5E7EB;
      color: #4B5563;
    }

    .user-reviews-page .user-side-nav a.active {
      background: #00B300;
      border-color: #00B300;
      color: #FFFFFF;
      font-weight: 700;
    }

    .user-reviews-page .user-side-nav a.active i {
      color: #FFFFFF;
    }

    .user-reviews-page .main {
      background: #F5F7FA;
      padding: 18px;
    }

    .reviews-shell {
      max-width: 1260px;
      margin: 0 auto;
      display: grid;
      gap: 14px;
    }

    .head h1 {
      margin: 0;
      color: #111827;
      font-size: 30px;
      line-height: 1.05;
      letter-spacing: -0.7px;
      font-weight: 800;
      overflow-wrap: anywhere;
    }

    .head p {
      margin: 9px 0 0;
      color: #8C95A3;
      font-size: 13px;
      line-height: 1.35;
      font-weight: 500;
    }

    .panel,
    .review-item {
      background: #FFFFFF;
      border: 1px solid #E5E7EB;
      border-radius: 16px;
      box-shadow: 0 1px 2px rgba(15, 23, 42, 0.04);
      overflow: hidden;
    }

    .form-head {
      border-bottom: 1px solid #EDF1F6;
      padding: 16px;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .form-head i {
      width: 36px;
      height: 36px;
      border-radius: 10px;
      background: #ECF8EE;
      color: #2E7D32;
      display: grid;
      place-items: center;
      font-size: 16px;
    }

    .form-head h2 {
      margin: 0;
      color: #111827;
      font-size: 34px;
      line-height: 1;
      letter-spacing: -0.5px;
      font-weight: 800;
    }

    .form-head p {
      margin: 5px 0 0;
      color: #8C95A3;
      font-size: 15px;
      line-height: 1.3;
      font-weight: 500;
    }

    .form-body {
      padding: 16px;
      display: grid;
      gap: 12px;
    }

    .row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 12px;
    }

    .field {
      display: grid;
      gap: 6px;
    }

    .field label {
      color: #1F2937;
      font-size: 13px;
      line-height: 1;
      font-weight: 700;
      min-height: 14px;
      display: inline-flex;
      align-items: center;
    }

    .field select,
    .field textarea,
    .stars-wrap {
      width: 100%;
      border: 1px solid #D1D5DB;
      border-radius: 12px;
      background: #FFFFFF;
      color: #1F2937;
      font-size: 14px;
      font-family: inherit;
      box-sizing: border-box;
      margin: 0;
      display: block;
    }

    .field select {
      min-height: 42px;
      padding: 0 12px;
    }

    .field textarea {
      min-height: 110px;
      padding: 10px 12px;
      resize: vertical;
    }

    .field select:focus,
    .field textarea:focus {
      outline: none;
      border-color: #1976D2;
      box-shadow: 0 0 0 3px rgba(25, 118, 210, 0.12);
    }

    .stars-wrap {
      min-height: 42px;
      padding: 0 12px;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      justify-content: flex-start;
    }

    .stars-wrap input {
      display: none;
    }

    .stars-wrap label {
      color: #D1D5DB;
      font-size: 22px;
      line-height: 1;
      cursor: pointer;
    }

    .stars-wrap input:checked ~ label,
    .stars-wrap label:hover,
    .stars-wrap label:hover ~ label {
      color: #FF9800;
    }

    .stars-wrap {
      direction: rtl;
      unicode-bidi: bidi-override;
    }

    .form-actions {
      display: flex;
      justify-content: flex-end;
    }

    .submit-btn {
      min-height: 42px;
      border-radius: 12px;
      border: 1px solid #00B300;
      background: #00B300;
      color: #FFFFFF;
      font-size: 14px;
      line-height: 1;
      font-weight: 700;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 7px;
      padding: 0 20px;
      cursor: pointer;
      font-family: inherit;
    }

    .submit-btn:hover {
      background: #059A05;
      border-color: #059A05;
    }

    .section-head {
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 10px;
      flex-wrap: wrap;
      margin-top: 8px;
    }

    .section-head h3 {
      margin: 0;
      color: #111827;
      font-size: 35px;
      line-height: 1;
      letter-spacing: -0.5px;
      font-weight: 800;
    }

    .count-chip {
      border-radius: 999px;
      border: 1px solid #E5E7EB;
      background: #FFFFFF;
      color: #8C95A3;
      padding: 6px 12px;
      font-size: 13px;
      line-height: 1;
      font-weight: 700;
    }

    .review-list {
      display: grid;
      gap: 10px;
    }

    .review-item {
      padding: 14px;
      display: grid;
      gap: 8px;
    }

    .review-row {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      gap: 10px;
      flex-wrap: wrap;
    }

    .review-row h4 {
      margin: 0;
      color: #111827;
      font-size: 22px;
      line-height: 1.2;
      letter-spacing: -0.2px;
      font-weight: 800;
    }

    .review-date {
      color: #8C95A3;
      font-size: 13px;
      line-height: 1;
      font-weight: 500;
      display: inline-flex;
      align-items: center;
      gap: 6px;
      margin-top: 4px;
    }

    .review-status {
      border-radius: 999px;
      border: 1px solid #E5E7EB;
      background: #FFFFFF;
      color: #6B7280;
      padding: 6px 11px;
      font-size: 12px;
      line-height: 1;
      font-weight: 700;
      text-transform: capitalize;
      display: inline-flex;
      align-items: center;
      gap: 6px;
      white-space: nowrap;
    }

    .review-status.visible,
    .review-status.published {
      border-color: #BCE7C2;
      background: #ECF8EE;
      color: #2E7D32;
    }

    .review-status.pending {
      border-color: #FFD9B0;
      background: #FFF4E8;
      color: #B45309;
    }

    .star-line {
      color: #FF9800;
      font-size: 16px;
      line-height: 1;
      font-weight: 700;
      display: inline-flex;
      align-items: center;
      gap: 7px;
    }

    .star-line .empty-star {
      color: #D1D5DB;
    }

    .comment {
      margin: 0;
      color: #374151;
      font-size: 14px;
      line-height: 1.45;
      font-weight: 500;
    }

    .empty-card {
      background: #FFFFFF;
      border: 1px solid #E5E7EB;
      border-radius: 16px;
      box-shadow: 0 1px 2px rgba(15, 23, 42, 0.04);
      padding: 30px 18px;
      text-align: center;
      color: #8C95A3;
      font-size: 14px;
      line-height: 1.4;
      font-weight: 500;
    }

    @media (max-width: 980px) {
      .user-reviews-page .layout {
        flex-direction: column;
      }

      .user-reviews-page .user-sidebar {
        position: static;
        width: 100%;
        min-height: auto;
        padding: 10px 12px;
        overflow: hidden;
      }

      .user-reviews-page .user-side-nav {
        display: flex;
        gap: 8px;
        overflow-x: auto;
        padding-bottom: 2px;
        scrollbar-width: thin;
        -webkit-overflow-scrolling: touch;
      }

      .user-reviews-page .user-side-nav a {
        flex: 0 0 auto;
        min-width: max-content;
        padding: 10px 12px;
        border-radius: 10px;
      }

      .user-reviews-page .main {
        padding: 14px;
      }

      .head h1 {
        font-size: 26px;
      }

      .head p {
        font-size: 13px;
      }

      .row {
        grid-template-columns: 1fr;
      }
    }

    @media (max-width: 700px) {
      .section-head h3,
      .form-head h2 {
        font-size: 28px;
      }
    }

    @media (max-width: 640px) {
      .user-topbar {
        height: 64px;
        padding: 0 12px;
      }

      .topbar-brand {
        gap: 8px;
      }

      .topbar-brand-mark {
        width: 30px;
        height: 30px;
        border-radius: 8px;
        font-size: 13px;
      }

      .topbar-brand-text {
        font-size: 18px;
        max-width: 160px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }

      .topbar-avatar {
        width: 34px;
        height: 34px;
        font-size: 12px;
      }

      .user-reviews-page .main {
        padding: 10px;
      }
    }

    @media (max-width: 420px) {
      .user-topbar {
        padding: 0 10px;
      }

      .topbar-brand-text {
        max-width: 126px;
        font-size: 16px;
      }

      .topbar-actions {
        gap: 10px;
      }

      .head h1,
      .section-head h3,
      .form-head h2 {
        font-size: 22px;
      }

      .head p,
      .form-head p {
        font-size: 12px;
      }
    }
  </style>
</head>
<body class="user-reviews-page">
<header class="user-topbar">
  <div class="topbar-brand">
    <span class="topbar-brand-mark"><i class="fa-solid fa-bolt"></i></span>
    <h1 class="topbar-brand-text">ChargeHub Nepal</h1>
  </div>

  <div class="topbar-actions">
    <a class="topbar-avatar" href="${pageContext.request.contextPath}/user/profile" aria-label="Open profile">${sessionScope.fullName != null ? fn:substring(sessionScope.fullName, 0, 1) : 'U'}</a>
  </div>
</header>

<div class="layout">
  <jsp:include page="../common/user-sidebar.jsp"/>

  <main class="main">
    <div class="reviews-shell">
      <section class="head">
        <h1>My Reviews</h1>
        <p>Share your charging experience with the community and track your feedback history.</p>
      </section>

      <section class="panel">
        <div class="form-head">
          <i class="fa-regular fa-comment"></i>
          <div>
            <h2>Write a Review</h2>
            <p>Rate a station you have recently visited.</p>
          </div>
        </div>

        <form class="form-body" method="post" action="${pageContext.request.contextPath}/user/reviews">
          <input type="hidden" name="action" value="review">
          <input type="hidden" name="redirectToReviews" value="true">

          <div class="row">
            <div class="field">
              <label for="stationId">Select Station</label>
              <select id="stationId" name="stationId" required>
                <option value="">Choose a station</option>
                <c:forEach var="s" items="${stations}">
                  <option value="${s.stationId}">${s.stationName} - ${s.districtName}</option>
                </c:forEach>
              </select>
            </div>

            <div class="field">
              <label>Overall Rating</label>
              <div class="stars-wrap">
                <input id="star5" type="radio" name="rating" value="5" required><label for="star5"><i class="fa-solid fa-star"></i></label>
                <input id="star4" type="radio" name="rating" value="4"><label for="star4"><i class="fa-solid fa-star"></i></label>
                <input id="star3" type="radio" name="rating" value="3"><label for="star3"><i class="fa-solid fa-star"></i></label>
                <input id="star2" type="radio" name="rating" value="2"><label for="star2"><i class="fa-solid fa-star"></i></label>
                <input id="star1" type="radio" name="rating" value="1"><label for="star1"><i class="fa-solid fa-star"></i></label>
              </div>
            </div>
          </div>

          <div class="field">
            <label for="comment">Your Comment</label>
            <textarea id="comment" name="comment" required placeholder="Detail your experience with charging speed, location, and amenities."></textarea>
          </div>

          <div class="form-actions">
            <button class="submit-btn" type="submit"><i class="fa-regular fa-paper-plane"></i>Submit Review</button>
          </div>
        </form>
      </section>

      <section class="section-head">
        <h3>Past Reviews</h3>
        <span class="count-chip">${fn:length(userReviews)} Reviews</span>
      </section>

      <c:choose>
        <c:when test="${not empty userReviews}">
          <section class="review-list">
            <c:forEach var="rv" items="${userReviews}">
              <article class="review-item">
                <div class="review-row">
                  <div>
                    <h4>${rv.station_name}</h4>
                    <span class="review-date"><i class="fa-regular fa-calendar"></i>${rv.review_date}</span>
                  </div>
                  <span class="review-status ${fn:toLowerCase(rv.status)}"><i class="fa-regular fa-circle-check"></i>${rv.status}</span>
                </div>

                <div class="star-line">
                  <c:set var="score" value="${rv.rating}"/>
                  <c:forEach begin="1" end="5" var="idx">
                    <c:choose>
                      <c:when test="${idx <= score}"><i class="fa-solid fa-star"></i></c:when>
                      <c:otherwise><i class="fa-solid fa-star empty-star"></i></c:otherwise>
                    </c:choose>
                  </c:forEach>
                  <strong>${rv.rating}.0</strong>
                </div>

                <p class="comment">"${rv.comment}"</p>
              </article>
            </c:forEach>
          </section>
        </c:when>
        <c:otherwise>
          <div class="empty-card">No reviews submitted yet. Share feedback after your next charging session.</div>
        </c:otherwise>
      </c:choose>
    </div>
  </main>
</div>

<c:if test="${param.submitted == '1'}">
  <div id="successToast" class="toast-popup">
    <div class="toast-content">
      <i class="fa-solid fa-circle-check"></i>
      <span>Review successfully submitted!</span>
    </div>
  </div>
</c:if>

<style>
.toast-popup {
  position: fixed;
  top: 20px;
  right: 20px;
  z-index: 9999;
  animation: slideIn 0.3s ease-out, fadeOut 0.5s ease-in 2.5s forwards;
}
.toast-content {
  background: #ECF8EE;
  border: 1px solid #C5E8CD;
  border-radius: 12px;
  padding: 14px 20px;
  display: flex;
  align-items: center;
  gap: 10px;
  color: #2E7D32;
  font-size: 14px;
  font-weight: 600;
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}
.toast-content i {
  font-size: 18px;
}
@keyframes slideIn {
  from { transform: translateX(100%); opacity: 0; }
  to { transform: translateX(0); opacity: 1; }
}
@keyframes fadeOut {
  from { opacity: 1; }
  to { opacity: 0; visibility: hidden; }
}
</style>

<script>
(function() {
  var toast = document.getElementById('successToast');
  if (toast) {
    setTimeout(function() {
      toast.style.display = 'none';
    }, 3000);
  }
})();
</script>
</body>
</html>
