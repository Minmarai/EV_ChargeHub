<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- Author: Denisha Tamang --%>
<div class="topbar">
  <a class="brand" href="${pageContext.request.contextPath}/home">
    <span class="brand-icon" aria-hidden="true">
      <svg viewBox="0 0 24 24" role="img" focusable="false">
        <path d="M13.6 2.7L5.8 12h5.9l-1.1 8.9L18.2 12h-5.9l1.3-9.3z"></path>
      </svg>
    </span>
    ChargeHub Nepal
  </a>

  <button type="button" class="topbar-menu-toggle" aria-label="Toggle menu" aria-controls="public-topbar-menu" aria-expanded="false">
    <i class="fa-solid fa-bars"></i>
  </button>

  <div id="public-topbar-menu" class="topbar-menu">
    <nav class="nav nav-main">
      <a href="${pageContext.request.contextPath}/home">Home</a>
      <a href="${pageContext.request.contextPath}/about">About</a>
      <a href="${pageContext.request.contextPath}/contact">Contact</a>
    </nav>
    <nav class="nav nav-auth">
      <c:choose>
        <c:when test="${empty sessionScope.userId}">
          <a href="${pageContext.request.contextPath}/login">Login</a>
          <a class="btn" href="${pageContext.request.contextPath}/register">Register</a>
        </c:when>
        <c:otherwise>
          <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </c:otherwise>
      </c:choose>
    </nav>
  </div>
</div>

<script>
  (function () {
    const body = document.body;
    const toggle = document.querySelector('.topbar-menu-toggle');
    const menuLinks = document.querySelectorAll('.topbar-menu a');
    const openClass = 'topbar-menu-open';

    if (!toggle) {
      return;
    }

    function setOpenState(isOpen) {
      body.classList.toggle(openClass, isOpen);
      toggle.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
    }

    toggle.addEventListener('click', function () {
      setOpenState(!body.classList.contains(openClass));
    });

    menuLinks.forEach(function (link) {
      link.addEventListener('click', function () {
        setOpenState(false);
      });
    });

    document.addEventListener('keydown', function (event) {
      if (event.key === 'Escape') {
        setOpenState(false);
      }
    });
  })();
</script>
