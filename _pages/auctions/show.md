---
title: Auction show
excerpt: None
---

{% include head.html %}
<body class="no-js layout-auctions-show">
  <a class="a-skip-to-main" href="#main">Skip to main content</a>
  {% include site-header.html %}
  <nav class="breadcrumbs">
    <div class="wrapper">
      <a href="/">&larr; All auctions</a>
    </div>
  </nav>
  <main class="auction h-entry" role="main" id="main">
    <div class="wrapper">
      <header class="auction-header">
        <h1 class="p-name">
          Open Opportunities: Create Agency Admin User Role
        </h1>
        <dl>
          <dt class="auction-time-remaining">Time remaining</dt>
          <dd class="auction-time-remaining">
            12 days
            <span class="auction-time-left-alternate">Ends: 05/25/2016 at 5:00pm EST</span>
          </dd>
          <dt class="auction-status">Status</dt>
          <dd class="auction-status auction-status-open"><span>Open</span></dd>
          <dt class="auction-current-bid">Current bid</dt>
          <dd class="auction-current-bid">
            $3,500.00
          </dd>
        </dl>
        <section class="auction-place-bid">
          <p>The maximum (current) bid is $3414.00. Please enter a lower amount.</p>
          <form>
            <div class="field"> 
              <label>
                <span class="label-text">Your bid</span>
                <input type="number"></input>
              </label>
            </div>
            <button>Place bid</button>
          </form>
        </section>

      </header>
      <div class="page">
        <p class="issue-description p-summary">Open Opportunities uses the open source sails.js MVC framework (Node.js / Express). Currently, a task creator should receive the following notification if a task they created receives a comment. However, this functionality has broken, without breaking the build's test suite. This issue sees the creation of a failing test (or tests) that will only pass when the notification functionality is restored, along with the fix to make those tests pass.</p>
        <h2>Auction rules</h2>
        <p>Registered users on micropurchase.18f.gov may bid to deliver the requirements in this auction. The lowest bidder at the time the auction closes shall receive the award. The awarded bidder shall have five business days to deliver the requirements. Upon successful completion of the requirements, 18F shall pay the winning bidder. See our <a href="https://micropurchase.18f.gov/faq">rules</a> page</p>
        <h2>Acceptance criteria</h2>
        <h3>1. Conditions for the test to fail</h3>
        <p>When the bug is present, and a user who is not the task creator comments on the task, and no email is generated</p>
        <p>Then test(s) written as part of this micro-purchase will fail.</p>        
      </div>
      <footer class="auction-footer">
        <section class="auction-place-bid">
        <p>The maximum (current) bid is $3414.00. Please enter a lower amount.</p>
          <form>
            <div class="field"> 
              <label>
                <span class="label-text">Your bid</span>
                <input type="number"></input>
              </label>
            </div>
            <button>Place bid</button>
          </form>
        </section>
        <dl>
          <dt class="auction-author">Submitted by</dt>
          <dd class="auction-author p-author"><img src="#">Patrick Bateman</dd>
          <dt class="auction-language">Language</dt>
          <dd class="auction-language">Ruby</dd>
          <dt class="auction-project">Project</dt>
          <dd class="auction-project">Open Opportunities</dd>
          <dt class="auction-agency">Agency</dt>
          <dd class="auction-agency">General Services Administration</dd>
        </dl>
      </footer>
    </div>
  </main>
  {% include site-footer.html %}
</body>