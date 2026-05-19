<%-- Author: Rijam Shrestha --%>
<div id="user-sidebar-nav" class="sidebar user-sidebar">
  <div class="user-side-brand">
    <h2>ChargeHub Nepal</h2>
    <p>USER PANEL</p>
  </div>

  <nav class="user-side-nav" aria-label="User navigation">
    <a class="${activePage == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/user/dashboard"><i class="fa-solid fa-house"></i><span>Dashboard</span></a>
    <a class="${activePage == 'stations' ? 'active' : ''}" href="${pageContext.request.contextPath}/user/stations"><i class="fa-solid fa-magnifying-glass"></i><span>Search Stations</span></a>
    <a class="${activePage == 'station-list' ? 'active' : ''}" href="${pageContext.request.contextPath}/user/station-list"><i class="fa-solid fa-location-dot"></i><span>Station List</span></a>
    <a class="${activePage == 'bookings' ? 'active' : ''}" href="${pageContext.request.contextPath}/user/bookings"><i class="fa-regular fa-clock"></i><span>Booking History</span></a>
    <a class="${activePage == 'payments' ? 'active' : ''}" href="${pageContext.request.contextPath}/user/payments"><i class="fa-regular fa-credit-card"></i><span>Payment History</span></a>
    <a class="${activePage == 'favorites' ? 'active' : ''}" href="${pageContext.request.contextPath}/user/favorites"><i class="fa-regular fa-heart"></i><span>Favorites</span></a>
    <a class="${activePage == 'reviews' ? 'active' : ''}" href="${pageContext.request.contextPath}/user/reviews"><i class="fa-regular fa-star"></i><span>Reviews</span></a>
    <a class="${activePage == 'profile' ? 'active' : ''}" href="${pageContext.request.contextPath}/user/profile"><i class="fa-regular fa-user"></i><span>Profile</span></a>
  </nav>

  <a class="user-side-logout" href="${pageContext.request.contextPath}/logout">Logout</a>
</div>

<button type="button" class="mobile-nav-toggle user-mobile-toggle" aria-label="Toggle navigation" aria-controls="user-sidebar-nav" aria-expanded="false">
  <i class="fa-solid fa-bars"></i>
</button>
<div class="mobile-nav-backdrop user-mobile-backdrop" aria-hidden="true"></div>

<script>
  (function () {
    const body = document.body;
    const toggle = document.querySelector('.user-mobile-toggle');
    const backdrop = document.querySelector('.user-mobile-backdrop');
    const navLinks = document.querySelectorAll('.user-sidebar a');
    const openClass = 'user-mobile-nav-open';

    if (!toggle || !backdrop) {
      return;
    }

    function setOpenState(isOpen) {
      body.classList.toggle(openClass, isOpen);
      toggle.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
    }

    toggle.addEventListener('click', function () {
      setOpenState(!body.classList.contains(openClass));
    });

    backdrop.addEventListener('click', function () {
      setOpenState(false);
    });

    navLinks.forEach(function (link) {
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
