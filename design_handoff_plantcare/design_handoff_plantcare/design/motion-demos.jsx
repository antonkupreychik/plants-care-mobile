// PlantCare — Motion showcase · 6 ключевых микровзаимодействий
// Лупы на CSS, общая длительность цикла 4.2s, брендовые токены из PC_THEMES.

const M_DUR = '4200ms';

function MotionCard({ t, title, desc, dur, ease, trigger, children }) {
  return (
    <div style={{ background: t.surface, borderRadius: 24, border: `1px solid ${t.line}`, overflow: 'hidden', display: 'flex', flexDirection: 'column' }}>
      <div style={{ height: 200, background: t.bg, display: 'grid', placeItems: 'center', position: 'relative', overflow: 'hidden', borderBottom: `1px solid ${t.line}` }}>
        {children}
      </div>
      <div style={{ padding: '16px 18px 18px' }}>
        <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 22, lineHeight: 1.1, letterSpacing: '-0.01em' }}>{title}</div>
        <div style={{ fontSize: 13, color: t.inkSoft, marginTop: 4, lineHeight: 1.45, textWrap: 'pretty' }}>{desc}</div>
        <div style={{ display: 'flex', gap: 6, marginTop: 12, flexWrap: 'wrap' }}>
          <span style={{ fontSize: 11, fontWeight: 700, color: t.primary, background: t.primarySoft, padding: '4px 9px', borderRadius: 7, letterSpacing: '0.02em', whiteSpace: 'nowrap' }}>{dur}</span>
          <span style={{ fontSize: 11, fontWeight: 600, color: t.inkSoft, background: t.surfaceWarm, padding: '4px 9px', borderRadius: 7, fontFamily: 'monospace', whiteSpace: 'nowrap' }}>{ease}</span>
          <span style={{ fontSize: 11, fontWeight: 600, color: t.inkSoft, background: t.surfaceWarm, padding: '4px 9px', borderRadius: 7, whiteSpace: 'nowrap' }}>↳ {trigger}</span>
        </div>
      </div>
    </div>
  );
}

// 1 · Отметка ухода — кнопка морфится в галочку
function DemoCareButton({ t }) {
  return (
    <div className="m-carebtn" style={{ position: 'relative', width: 150, height: 54 }}>
      <div className="m-carebtn-bg" style={{ position: 'absolute', inset: 0, borderRadius: 999, background: t.ink, display: 'grid', placeItems: 'center' }}>
        <span className="m-carebtn-label" style={{ color: t.surface, fontSize: 15, fontWeight: 600, fontFamily: '"Plus Jakarta Sans", sans-serif' }}>Полить</span>
        <span className="m-carebtn-check" style={{ position: 'absolute', display: 'grid', placeItems: 'center' }}>
          <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke={t.surface} strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"><path d="M5 12l5 5L20 7" /></svg>
        </span>
      </div>
      <div className="m-carebtn-ripple" style={{ position: 'absolute', inset: 0, borderRadius: 999, border: `2px solid ${t.primary}` }} />
    </div>
  );
}

// 2 · Галочка успеха — круг масштабируется, чек прорисовывается, листики разлетаются
function DemoSuccessCheck({ t }) {
  return (
    <div style={{ position: 'relative', width: 120, height: 120, display: 'grid', placeItems: 'center' }}>
      {[0, 1, 2, 3, 4].map(i => (
        <span key={i} className={`m-leaf m-leaf-${i}`} style={{ position: 'absolute', fontSize: 16 }}>🌿</span>
      ))}
      <div className="m-success-circle" style={{ width: 84, height: 84, borderRadius: 42, background: t.primary, display: 'grid', placeItems: 'center' }}>
        <svg className="m-success-check" width="44" height="44" viewBox="0 0 48 48" fill="none" stroke={t.surface} strokeWidth="5" strokeLinecap="round" strokeLinejoin="round">
          <path d="M10 25l10 10 18-20" style={{ strokeDasharray: 60, strokeDashoffset: 60 }} />
        </svg>
      </div>
    </div>
  );
}

// 3 · Реакция растения на полив — капли падают, растение «оживает»
function DemoWaterReact({ t }) {
  return (
    <div style={{ position: 'relative', width: 140, height: 160, display: 'grid', placeItems: 'end center' }}>
      {[0, 1, 2].map(i => (
        <span key={i} className={`m-drop m-drop-${i}`} style={{ position: 'absolute', top: 0, fontSize: 18 }}>💧</span>
      ))}
      <div className="m-plant" style={{ transformOrigin: 'bottom center' }}>
        <window.Monstera t={t} size={130} />
      </div>
      <span className="m-sparkle" style={{ position: 'absolute', top: 18, right: 22, fontSize: 20 }}>✨</span>
    </div>
  );
}

// 4 · Инкремент стрика — число перещёлкивается с подскоком
function DemoStreak({ t }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
      <span className="m-streak-emoji" style={{ fontSize: 34 }}>🌱</span>
      <div style={{ position: 'relative', height: 56, width: 84, overflow: 'hidden' }}>
        <div className="m-streak-roll" style={{ position: 'absolute', inset: 0 }}>
          <div style={{ height: 56, display: 'grid', placeItems: 'center', fontFamily: '"Instrument Serif", serif', fontSize: 48, color: t.inkSoft, lineHeight: 1 }}>46</div>
          <div style={{ height: 56, display: 'grid', placeItems: 'center', fontFamily: '"Instrument Serif", serif', fontSize: 48, color: t.primary, lineHeight: 1 }}>47</div>
        </div>
      </div>
      <span style={{ fontSize: 14, color: t.inkSoft, fontWeight: 600 }}>дней</span>
    </div>
  );
}

// 5 · Pull-to-refresh — росток прорастает по мере оттягивания
function DemoPullRefresh({ t }) {
  return (
    <div style={{ position: 'relative', width: 150, height: 170, overflow: 'hidden', borderRadius: 16 }}>
      {/* indicator zone */}
      <div style={{ position: 'absolute', top: 0, left: 0, right: 0, height: 56, display: 'grid', placeItems: 'center' }}>
        <svg className="m-sprout" width="40" height="40" viewBox="0 0 40 40" fill="none">
          <path d="M20 38 V20" stroke={t.leafDark} strokeWidth="3" strokeLinecap="round" />
          <path className="m-sprout-leafL" d="M20 24 C12 22 8 16 9 10 C16 11 20 17 20 24 Z" fill={t.primary} />
          <path className="m-sprout-leafR" d="M20 26 C28 24 32 18 31 12 C24 13 20 19 20 26 Z" fill={t.leaf} />
        </svg>
      </div>
      {/* sheet pulled down */}
      <div className="m-sheet" style={{ position: 'absolute', left: 0, right: 0, top: 0, height: 170, background: t.surfaceWarm, borderRadius: 16, padding: 14, border: `1px solid ${t.line}` }}>
        <div style={{ height: 12, width: '60%', borderRadius: 6, background: t.line }} />
        <div style={{ height: 12, width: '85%', borderRadius: 6, background: t.line, marginTop: 10 }} />
        <div style={{ height: 12, width: '45%', borderRadius: 6, background: t.line, marginTop: 10 }} />
      </div>
    </div>
  );
}

// 6 · Тост — выезжает снизу, держится, уезжает
function DemoToast({ t }) {
  return (
    <div style={{ position: 'relative', width: 170, height: 160, overflow: 'hidden' }}>
      <div className="m-toast" style={{
        position: 'absolute', left: 8, right: 8, bottom: 14,
        background: t.ink, borderRadius: 16, padding: '12px 14px',
        display: 'flex', alignItems: 'center', gap: 10, boxShadow: '0 10px 30px rgba(0,0,0,0.25)',
      }}>
        <div style={{ width: 28, height: 28, borderRadius: 8, background: t.primary, display: 'grid', placeItems: 'center', flexShrink: 0 }}>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke={t.surface} strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"><path d="M5 12l5 5L20 7" /></svg>
        </div>
        <div style={{ minWidth: 0 }}>
          <div style={{ fontSize: 12, fontWeight: 700, color: t.surface }}>Моника полита</div>
          <div style={{ fontSize: 10, color: t.surface, opacity: 0.7 }}>Отменить</div>
        </div>
      </div>
    </div>
  );
}

Object.assign(window, {
  MotionCard, DemoCareButton, DemoSuccessCheck, DemoWaterReact,
  DemoStreak, DemoPullRefresh, DemoToast,
});
