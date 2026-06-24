// Shared CMS loader — included on every portfolio page
// Reads from Supabase and renders into the DOM

const db = _supabase; // from config.js

// ── HELPERS ──────────────────────────────────────────────────

function tag(type, attrs = {}, ...children) {
  const el = document.createElement(type);
  Object.entries(attrs).forEach(([k, v]) => {
    if (k === 'class') el.className = v;
    else if (k === 'html') el.innerHTML = v;
    else el.setAttribute(k, v);
  });
  children.forEach(c => c && el.appendChild(typeof c === 'string' ? document.createTextNode(c) : c));
  return el;
}

function revealAll() {
  requestAnimationFrame(() => {
    document.querySelectorAll('.rv:not(.in)').forEach((el, i) => {
      el.style.transitionDelay = (i * 0.04) + 's';
      setTimeout(() => el.classList.add('in'), 50);
    });
  });
}

// ── LOADERS ──────────────────────────────────────────────────

async function cmsProfile() {
  const { data } = await db.from('profile').select('*').single();
  return data;
}

async function cmsStats() {
  const { data } = await db.from('stats').select('*').order('sort_order');
  return data || [];
}

async function cmsArticles() {
  const { data } = await db.from('articles').select('*').order('sort_order');
  return data || [];
}

async function cmsExperience(type = 'work') {
  const { data } = await db.from('experience').select('*')
    .eq('exp_type', type).order('sort_order');
  return data || [];
}

async function cmsCertifications() {
  const { data } = await db.from('certifications').select('*').order('sort_order');
  return data || [];
}

async function cmsLanguages() {
  const { data } = await db.from('languages').select('*').order('sort_order');
  return data || [];
}

async function cmsSkills() {
  const { data } = await db.from('skills').select('*').order('sort_order');
  return data || [];
}

async function cmsCaseStudies() {
  const { data } = await db.from('case_studies').select('*').order('sort_order');
  return data || [];
}

// ── RENDERERS ────────────────────────────────────────────────

function renderStats(stats, container) {
  if (!container || !stats.length) return;
  container.innerHTML = stats.map(s => `
    <div>
      <div class="stat-num">${s.value}</div>
      <div class="stat-lbl">${s.label}</div>
    </div>`).join('');
}

function renderArticles(articles, container, filterBar) {
  if (!container) return;
  const cats = [...new Set(articles.map(a => a.category))];

  if (filterBar) {
    filterBar.innerHTML = `<button class="filter-btn active" data-cat="all">All</button>` +
      cats.map(c => `<button class="filter-btn" data-cat="${c}">${c}</button>`).join('');
    filterBar.querySelectorAll('.filter-btn').forEach(btn => {
      btn.addEventListener('click', () => {
        filterBar.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        container.querySelectorAll('.art-card').forEach(card => {
          card.style.display = (btn.dataset.cat === 'all' || card.dataset.cat === btn.dataset.cat) ? 'flex' : 'none';
        });
      });
    });
  }

  container.innerHTML = articles.map((a, i) => `
    <a class="art-card rv ${a.featured ? 'featured' : ''}" href="${a.url}" target="_blank" data-cat="${a.category}">
      <div>
        <div class="art-cat">${a.category}</div>
        <div class="art-title">${a.title}</div>
      </div>
      <div class="art-meta">${a.date_str}</div>
      <div class="art-arrow">↗</div>
    </a>`).join('');
  revealAll();
}

function renderExperience(entries, container) {
  if (!container) return;
  container.innerHTML = entries.map(e => {
    const desc = e.description || e.bullets || '';
    const bullets = desc.split('\n').filter(Boolean)
      .map(b => `<li>${b.trim()}</li>`).join('');
    const tagsArr = Array.isArray(e.tags) ? e.tags : (e.tags||'').split(',').filter(Boolean);
    const tags = tagsArr.map(t => `<span class="exp-tag">${t.trim()}</span>`).join('');
    const now = e.is_current ? '<span class="now-pill">NOW</span>' : '';
    return `
      <div class="exp-item rv">
        <div class="exp-l">
          <div class="exp-org">${e.org} ${now}</div>
          <div class="exp-date">${e.date_range}</div>
          ${e.location ? `<div class="exp-type">${e.location}</div>` : ''}
        </div>
        <div class="exp-r">
          <div class="exp-role">${e.role}</div>
          <div class="exp-desc">${bullets ? `<ul>${bullets}</ul>` : desc}</div>
          ${tags ? `<div class="exp-tags">${tags}</div>` : ''}
        </div>
      </div>`;
  }).join('');
  revealAll();
}

function renderCertifications(certs, container) {
  if (!container) return;
  if (!certs.length) {
    container.innerHTML = `<div class="cert-placeholder">No certifications added yet — add them in the admin panel.</div>`;
    return;
  }
  container.innerHTML = certs.map(c => `
    <div class="cert-card rv">
      <div class="cert-name">${c.name}</div>
      <div class="cert-issuer">${c.issuer}</div>
      ${c.date_str ? `<div class="cert-date">${c.date_str}</div>` : ''}
      ${c.cert_url ? `<a href="${c.cert_url}" target="_blank" style="font-size:.72rem;color:var(--coral);">View ↗</a>` : ''}
    </div>`).join('');
  revealAll();
}

function renderLanguages(langs, container) {
  if (!container || !langs.length) return;
  container.innerHTML = langs.map(l => `
    <div class="lang-row">
      <span class="lang-name">${l.name}</span>
      <div class="lang-bar">
        <div class="lang-fill" style="width:0;background:${l.color}" data-w="${l.level_pct}"></div>
      </div>
      <span class="lang-level">${l.level_label}</span>
    </div>`).join('');

  // animate bars on intersection
  const obs = new IntersectionObserver(es => {
    es.forEach(e => {
      if (e.isIntersecting) {
        e.target.querySelectorAll('.lang-fill').forEach(b => b.style.width = b.dataset.w + '%');
      }
    });
  }, { threshold: .3 });
  obs.observe(container);
}

function renderSkills(skills, container) {
  if (!container || !skills.length) return;
  container.innerHTML = skills.map(s => `<span class="chip">${s.name}</span>`).join('');
}

function renderCaseStudies(studies, container) {
  if (!container || !studies.length) return;
  container.innerHTML = studies.map((s, i) => `
    <div class="cs-item rv">
      <div class="cs-meta">
        <div class="cs-num">${String(i+1).padStart(2,'0')}</div>
        <div>
          <div class="cs-tag">${s.tags || ''}</div>
          <div class="cs-org">${s.org} · ${s.year || ''}</div>
        </div>
      </div>
      <div class="cs-body">
        <div class="cs-title">${s.title}</div>
        <div class="cs-problem">The problem</div>
        <p class="cs-text">${s.problem || ''}</p>
        <div class="cs-problem">What I did</div>
        <p class="cs-text">${s.approach || ''}</p>
        <div class="cs-results">
          ${(s.results || '').split('\n').filter(Boolean).map(r => {
            const [num, ...rest] = r.split('|');
            return `<div class="cs-result"><span class="cs-result-num">${num.trim()}</span><span class="cs-result-lbl">${rest.join('|').trim()}</span></div>`;
          }).join('')}
        </div>
      </div>
    </div>`).join('');
  revealAll();
}
