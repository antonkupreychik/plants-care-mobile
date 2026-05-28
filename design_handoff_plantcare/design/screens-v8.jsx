// PlantCate — batch 6 (часть 2) — системные состояния
// Загрузка (skeleton), Офлайн/ошибка, Пустой поиск

// ─────────────────────────────────────────────────────────────
// 28 · ЗАГРУЗКА — скелетон главной
// ─────────────────────────────────────────────────────────────
function LoadingScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];
  const shimmer = theme === 'dark' ? 'rgba(239,231,212,0.06)' : 'rgba(31,42,30,0.06)';
  const shimmerHi = theme === 'dark' ? 'rgba(239,231,212,0.12)' : 'rgba(31,42,30,0.11)';

  const Bone = ({ w, h, r = 10, mt = 0, style }) => (
    <div style={{
      width: w, height: h, borderRadius: r, marginTop: mt,
      background: `linear-gradient(90deg, ${shimmer} 25%, ${shimmerHi} 50%, ${shimmer} 75%)`,
      backgroundSize: '200% 100%', animation: 'pcShimmer 1.3s ease-in-out infinite',
      ...style,
    }} />
  );

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'hidden', position: 'relative' }}>
      <style>{`@keyframes pcShimmer { 0% { background-position: 200% 0; } 100% { background-position: -200% 0; } }`}</style>

      {/* header */}
      <div style={{ padding: '20px 22px 8px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 18 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
            <Bone w={36} h={36} r={12} />
            <Bone w={96} h={16} />
          </div>
          <div style={{ display: 'flex', gap: 6 }}>
            <Bone w={40} h={40} r={14} />
            <Bone w={40} h={40} r={14} />
          </div>
        </div>
        <Bone w={120} h={12} />
        <Bone w={200} h={34} mt={10} r={12} />
      </div>

      {/* today card skeleton */}
      <div style={{ padding: '16px 16px 0' }}>
        <div style={{ background: t.surface, borderRadius: 28, padding: 18, border: `1px solid ${t.line}` }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <div><Bone w={70} h={12} /><Bone w={110} h={22} mt={8} /></div>
            <Bone w={60} h={26} r={999} />
          </div>
          <Bone w="100%" h={4} mt={16} r={2} />
          {[0, 1].map(i => (
            <div key={i} style={{ display: 'flex', alignItems: 'center', gap: 12, marginTop: 16 }}>
              <Bone w={48} h={48} r={16} />
              <div style={{ flex: 1 }}><Bone w="55%" h={14} /><Bone w="80%" h={11} mt={6} /></div>
              <Bone w={84} h={32} r={999} />
            </div>
          ))}
        </div>
      </div>

      {/* section title */}
      <div style={{ padding: '22px 22px 6px' }}>
        <Bone w={70} h={12} />
        <Bone w={140} h={22} mt={8} />
      </div>

      {/* grid skeleton */}
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12, padding: '8px 16px 0' }}>
        {[0, 1, 2, 3].map(i => (
          <div key={i} style={{ background: t.surface, borderRadius: 24, padding: 14, border: `1px solid ${t.line}` }}>
            <Bone w="60%" h={10} />
            <Bone w="80%" h={20} mt={8} />
            <Bone w="100%" h={120} r={18} mt={10} />
            <Bone w="50%" h={12} mt={10} />
          </div>
        ))}
      </div>

      {/* growing caption */}
      <div style={{
        position: 'absolute', left: 0, right: 0, bottom: 28, textAlign: 'center',
        display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 8,
      }}>
        <div style={{ fontSize: 22 }}>🌱</div>
        <div style={{ fontSize: 13, color: t.inkSoft, fontStyle: 'italic', fontFamily: '"Instrument Serif", serif', fontSize: 15 }}>
          Собираю твой сад…
        </div>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 29 · ОФЛАЙН / ОШИБКА СВЯЗИ
// ─────────────────────────────────────────────────────────────
function OfflineScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'hidden', position: 'relative', display: 'flex', flexDirection: 'column' }}>
      {/* offline banner */}
      <div style={{ padding: '14px 16px 0' }}>
        <div style={{
          background: theme === 'dark' ? 'rgba(199,123,92,0.12)' : '#FBEFE4',
          border: `1px solid ${theme === 'dark' ? 'rgba(216,145,114,0.25)' : '#F0DDC8'}`,
          borderRadius: 14, padding: '10px 14px', display: 'flex', alignItems: 'center', gap: 10,
        }}>
          <span style={{ width: 8, height: 8, borderRadius: 4, background: t.terracotta, flexShrink: 0 }} />
          <span style={{ fontSize: 12, fontWeight: 700, color: t.terracotta }}>Нет связи с садом</span>
          <span style={{ fontSize: 11, color: t.inkSoft, marginLeft: 'auto' }}>офлайн</span>
        </div>
      </div>

      {/* center illustration */}
      <div style={{ flex: 1, display: 'grid', placeItems: 'center', position: 'relative' }}>
        <div style={{ textAlign: 'center', padding: '0 32px' }}>
          <div style={{ position: 'relative', display: 'inline-block', marginBottom: 8 }}>
            <div style={{ position: 'absolute', inset: -30, borderRadius: '50%', background: t.surfaceWarm, opacity: 0.6 }} />
            <div style={{ position: 'relative', filter: 'grayscale(0.5)', opacity: 0.85 }}>
              <window.Fern t={t} size={150} />
            </div>
            {/* cloud-off glyph */}
            <div style={{
              position: 'absolute', bottom: 6, right: -8, width: 48, height: 48, borderRadius: 16,
              background: t.surface, border: `1px solid ${t.line}`, display: 'grid', placeItems: 'center',
            }}>
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={t.inkSoft} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
                <path d="M5 17h11a4 4 0 0 0 1.5-7.7A6 6 0 0 0 6.5 8" />
                <path d="M3 3l18 18" />
              </svg>
            </div>
          </div>

          <h1 style={{ fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 32, lineHeight: 1.1, margin: '14px 0 8px', letterSpacing: '-0.01em' }}>
            Сад на минутку <em style={{ color: t.primary, fontStyle: 'italic' }}>вне зоны</em>
          </h1>
          <div style={{ fontSize: 14, color: t.inkSoft, lineHeight: 1.5, textWrap: 'pretty' }}>
            Не получается достучаться до сервера. Проверь интернет — твои растения никуда не денутся.
          </div>
        </div>
      </div>

      {/* actions */}
      <div style={{ padding: '0 22px 18px' }}>
        <div style={{
          background: t.surface, borderRadius: 14, padding: '10px 14px', marginBottom: 12,
          border: `1px dashed ${t.line}`, fontSize: 12, color: t.inkSoft, display: 'flex', alignItems: 'center', gap: 8,
        }}>
          <window.Icon name="check" size={14} color={t.primary} stroke={2.2} />
          Показываю последнее сохранённое · 9:30
        </div>
        <button style={{
          width: '100%', padding: '16px', borderRadius: 20, background: t.ink, color: t.surface,
          border: 'none', fontSize: 15, fontWeight: 600, fontFamily: 'inherit',
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10,
        }}>
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={t.surface} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M21 12a9 9 0 1 1-3-6.7M21 3v5h-5" /></svg>
          Повторить
        </button>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 30 · ПУСТОЙ ПОИСК — каталог, ничего не найдено
// ─────────────────────────────────────────────────────────────
function EmptySearchScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'auto', position: 'relative' }}>
      <div style={{ padding: '20px 22px 8px' }}>
        <h1 style={{ fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 38, lineHeight: 1.04, margin: '0 0 4px', letterSpacing: '-0.01em' }}>
          Каталог <em style={{ color: t.primary, fontStyle: 'italic' }}>растений</em>
        </h1>
        <div style={{ fontSize: 13, color: t.inkSoft }}>30 видов с готовыми расписаниями</div>
      </div>

      {/* search with query */}
      <div style={{ padding: '14px 22px 0' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10, background: t.surface, borderRadius: 18, padding: '12px 14px', border: `1px solid ${t.primary}` }}>
          <window.Icon name="search" size={18} color={t.primary} stroke={1.8} />
          <span style={{ flex: 1, fontSize: 14, color: t.ink }}>монстерра</span>
          <div style={{ width: 20, height: 20, borderRadius: 10, background: t.surfaceWarm, display: 'grid', placeItems: 'center', fontSize: 12, color: t.inkSoft }}>×</div>
        </div>
      </div>

      {/* empty illustration */}
      <div style={{ display: 'grid', placeItems: 'center', padding: '40px 0 8px' }}>
        <div style={{ position: 'relative' }}>
          <div style={{ position: 'absolute', inset: -24, borderRadius: '50%', background: t.surfaceWarm, opacity: 0.6 }} />
          <div style={{ position: 'relative', opacity: 0.6 }}>
            <window.Cactus t={t} size={120} />
          </div>
          <div style={{
            position: 'absolute', top: -4, right: -10, width: 40, height: 40, borderRadius: 14,
            background: t.surface, border: `1px solid ${t.line}`, display: 'grid', placeItems: 'center',
          }}>
            <window.Icon name="search" size={18} color={t.inkMute} stroke={2} />
          </div>
        </div>
      </div>

      <div style={{ textAlign: 'center', padding: '8px 40px 0' }}>
        <h2 style={{ fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 26, lineHeight: 1.15, margin: '0 0 8px', letterSpacing: '-0.01em' }}>
          Не нашли «монстерра»
        </h2>
        <div style={{ fontSize: 14, color: t.inkSoft, lineHeight: 1.5, textWrap: 'pretty' }}>
          Возможно, опечатка. Попробуй иначе или загляни в популярное.
        </div>
      </div>

      {/* suggestions */}
      <div style={{ padding: '20px 22px 0' }}>
        <window.PcSectionLabel t={t}>Может, ты искал(а)</window.PcSectionLabel>
        <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
          {['Монстера', 'Маранта', 'Мирт', 'Замиокулькас'].map((s, i) => (
            <div key={i} style={{
              padding: '10px 16px', borderRadius: 999, background: t.chipBg, color: t.ink,
              fontSize: 14, fontWeight: 600,
            }}>{s}</div>
          ))}
        </div>
      </div>

      {/* add manually */}
      <div style={{ padding: '24px 16px 0' }}>
        <div style={{
          background: t.primarySoft, borderRadius: 20, padding: '16px 18px',
          display: 'flex', alignItems: 'center', gap: 14, position: 'relative', overflow: 'hidden',
        }}>
          <svg width="100" height="100" viewBox="0 0 120 120" style={{ position: 'absolute', right: -16, bottom: -20, opacity: 0.22 }}>
            <path d="M 100 20 C 60 20 30 50 30 90 C 50 90 80 60 100 20 Z" fill={t.leafDark} />
          </svg>
          <div style={{ flex: 1, position: 'relative' }}>
            <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 18, lineHeight: 1.2 }}>Нет в каталоге?</div>
            <div style={{ fontSize: 12, color: t.inkSoft, marginTop: 2 }}>Заведи растение вручную — расписание настроишь сам(а).</div>
          </div>
          <button style={{
            padding: '10px 14px', borderRadius: 14, background: t.ink, color: t.surface, border: 'none',
            fontSize: 13, fontWeight: 600, fontFamily: 'inherit', flexShrink: 0, position: 'relative',
          }}>Добавить</button>
        </div>
      </div>

      <window.MiniBottomNav t={t} active="lib" />
      <div style={{ height: 100 }} />
    </div>
  );
}

Object.assign(window, { LoadingScreen, OfflineScreen, EmptySearchScreen });
