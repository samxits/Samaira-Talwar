// Page view tracker — records a visit to Supabase on every page load
(async () => {
  try {
    const page = location.pathname.split('/').pop() || 'index.html';
    await _supabase.from('page_views').insert({
      page,
      referrer: document.referrer || null,
    });
  } catch(e) {}
})();
