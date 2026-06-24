/* shared JS across all pages */

// cursor
const cur  = document.getElementById('cur');
const ring = document.getElementById('cur-ring');
let mx=0,my=0,rx=0,ry=0;
document.addEventListener('mousemove', e => { mx=e.clientX; my=e.clientY; });
(function tick(){
  rx+=(mx-rx)*.14; ry+=(my-ry)*.14;
  if(cur)  cur.style.cssText=`left:${mx}px;top:${my}px`;
  if(ring) ring.style.cssText=`left:${rx}px;top:${ry}px`;
  requestAnimationFrame(tick);
})();
document.querySelectorAll('a,button').forEach(el=>{
  el.addEventListener('mouseenter',()=>document.body.classList.add('ch'));
  el.addEventListener('mouseleave',()=>document.body.classList.remove('ch'));
});

// scroll reveal
const ro = new IntersectionObserver(
  es=>es.forEach(e=>{ if(e.isIntersecting) e.target.classList.add('in'); }),
  { threshold:.08 }
);
document.querySelectorAll('.rv').forEach(el=>ro.observe(el));

// stagger siblings
['art-card','exp-item','wc','what-card'].forEach(cls=>{
  document.querySelectorAll('.'+cls).forEach((el,i)=>{
    el.style.transitionDelay = (i*.05)+'s';
  });
});
