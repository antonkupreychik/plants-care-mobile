// PlantCare screens — Home + Plant Card
// Organic / botanical aesthetic. Russian copy. Light + Dark.

// ─────────────────────────────────────────────────────────────
// Theme tokens
// ─────────────────────────────────────────────────────────────
const PC_THEMES = {
  light: {
    bg: '#F1ECE0',
    surface: '#FBF7EC',
    surfaceWarm: '#EDE5D2',
    ink: '#1F2A1E',
    inkSoft: '#5C6650',
    inkMute: '#8C9180',
    line: 'rgba(31,42,30,0.10)',
    primary: '#3F6B3A',       // deep botanical green
    primarySoft: '#DCE7C9',
    leaf: '#6F8A4F',
    leafDark: '#3F5A2E',
    leafLight: '#A8C081',
    terracotta: '#C77B5C',
    pot: '#B9876B',
    potShadow: '#8A5E48',
    chipBg: '#E7E0CE',
    fab: '#1F2A1E',
    fabInk: '#FBF7EC',
  },
  dark: {
    bg: '#141A14',
    surface: '#1E251D',
    surfaceWarm: '#252D24',
    ink: '#EFE7D4',
    inkSoft: '#A8AE96',
    inkMute: '#6E7466',
    line: 'rgba(239,231,212,0.10)',
    primary: '#B7D08C',
    primarySoft: '#2C3826',
    leaf: '#8FAE65',
    leafDark: '#5E7A3F',
    leafLight: '#C2D89A',
    terracotta: '#D89172',
    pot: '#8A5E48',
    potShadow: '#5F3F30',
    chipBg: '#2A3128',
    fab: '#EFE7D4',
    fabInk: '#141A14',
  },
};

// ─────────────────────────────────────────────────────────────
// Botanical illustrations (simple flat SVGs)
// ─────────────────────────────────────────────────────────────
function Monstera({ t, size = 100 }) {
  return (
    <svg width={size} height={size} viewBox="0 0 120 120" fill="none">
      {/* back leaf */}
      <g transform="translate(60 60) rotate(-25)">
        <path d="M 0 0 C -22 -10 -34 -32 -28 -50 C -10 -52 14 -38 18 -16 C 18 -8 12 0 0 0 Z"
          fill={t.leafDark} />
        <path d="M -8 -12 L -22 -38 M 0 -8 L -2 -42 M 8 -14 L 12 -36"
          stroke={t.bg} strokeWidth="2" strokeLinecap="round" opacity="0.4" />
        {/* fenestrations */}
        <circle cx="-12" cy="-22" r="3" fill={t.bg} opacity="0.5" />
        <circle cx="2" cy="-30" r="2.5" fill={t.bg} opacity="0.5" />
      </g>
      {/* front leaf */}
      <g transform="translate(60 60) rotate(15)">
        <path d="M 0 0 C -18 -6 -32 -30 -22 -52 C -2 -58 22 -42 26 -18 C 26 -8 18 2 0 0 Z"
          fill={t.leaf} />
        <path d="M -6 -10 L -18 -42 M 2 -6 L 4 -48 M 10 -10 L 18 -38"
          stroke={t.leafDark} strokeWidth="1.8" strokeLinecap="round" opacity="0.5" />
        <ellipse cx="-10" cy="-26" rx="3" ry="2" fill={t.leafDark} opacity="0.45" />
        <ellipse cx="4" cy="-36" rx="2.5" ry="1.8" fill={t.leafDark} opacity="0.45" />
        <ellipse cx="14" cy="-22" rx="2.5" ry="1.8" fill={t.leafDark} opacity="0.45" />
      </g>
      {/* pot */}
      <path d="M 36 64 L 84 64 L 80 96 Q 78 102 72 102 L 48 102 Q 42 102 40 96 Z"
        fill={t.pot} />
      <ellipse cx="60" cy="64" rx="24" ry="3.5" fill={t.potShadow} />
    </svg>
  );
}

function Fern({ t, size = 100 }) {
  return (
    <svg width={size} height={size} viewBox="0 0 120 120" fill="none">
      {/* fronds */}
      {[-40, -20, 0, 20, 40].map((rot, i) => (
        <g key={i} transform={`translate(60 62) rotate(${rot})`}>
          <path d="M 0 0 Q -2 -20 -1 -42 Q 0 -50 2 -42 Q 3 -20 1 0 Z"
            fill={i === 2 ? t.leaf : t.leafDark} />
          {[-8, -16, -24, -32, -38].map((y, j) => (
            <g key={j}>
              <ellipse cx="-3" cy={y} rx="4" ry="1.6" fill={i === 2 ? t.leaf : t.leafDark} transform={`rotate(-30 -3 ${y})`} />
              <ellipse cx="3" cy={y} rx="4" ry="1.6" fill={i === 2 ? t.leaf : t.leafDark} transform={`rotate(30 3 ${y})`} />
            </g>
          ))}
        </g>
      ))}
      {/* pot */}
      <path d="M 38 62 L 82 62 L 78 96 Q 76 102 70 102 L 50 102 Q 44 102 42 96 Z"
        fill={t.terracotta} />
      <ellipse cx="60" cy="62" rx="22" ry="3" fill={t.potShadow} opacity="0.7" />
    </svg>
  );
}

function Succulent({ t, size = 100 }) {
  return (
    <svg width={size} height={size} viewBox="0 0 120 120" fill="none">
      {/* rosette */}
      {[0, 45, 90, 135, 180, 225, 270, 315].map((rot, i) => (
        <ellipse key={i} cx="60" cy="48" rx="8" ry="20"
          transform={`rotate(${rot} 60 60)`}
          fill={i % 2 === 0 ? t.leafLight : t.leaf} />
      ))}
      <circle cx="60" cy="60" r="9" fill={t.leafDark} />
      {/* pot */}
      <path d="M 38 70 L 82 70 L 80 100 Q 78 106 72 106 L 48 106 Q 42 106 40 100 Z"
        fill={t.pot} />
      <ellipse cx="60" cy="70" rx="22" ry="3" fill={t.potShadow} opacity="0.6" />
    </svg>
  );
}

function Pothos({ t, size = 100 }) {
  return (
    <svg width={size} height={size} viewBox="0 0 120 120" fill="none">
      {/* trailing vines */}
      <path d="M 60 62 Q 30 62 22 88 Q 18 100 14 110" stroke={t.leafDark} strokeWidth="2" fill="none" />
      <path d="M 60 62 Q 90 62 98 86 Q 102 98 106 108" stroke={t.leafDark} strokeWidth="2" fill="none" />
      <path d="M 60 62 Q 60 84 56 104" stroke={t.leafDark} strokeWidth="2" fill="none" />
      {/* heart leaves */}
      {[
        [22, 88, -30], [30, 78, -45], [44, 70, -20],
        [56, 104, 0], [62, 88, 10],
        [98, 86, 30], [88, 76, 45], [76, 68, 20],
      ].map(([x, y, r], i) => (
        <g key={i} transform={`translate(${x} ${y}) rotate(${r})`}>
          <path d="M 0 -6 C -6 -6 -10 -2 -10 4 C -10 10 0 16 0 16 C 0 16 10 10 10 4 C 10 -2 6 -6 0 -6 Z"
            fill={i % 2 === 0 ? t.leaf : t.leafLight} />
        </g>
      ))}
      {/* center leaf cluster */}
      <ellipse cx="60" cy="56" rx="14" ry="10" fill={t.leaf} />
      <ellipse cx="60" cy="56" rx="6" ry="4" fill={t.leafDark} opacity="0.3" />
      {/* pot */}
      <path d="M 40 60 L 80 60 L 78 78 Q 76 84 70 84 L 50 84 Q 44 84 42 78 Z"
        fill={t.pot} />
    </svg>
  );
}

function Cactus({ t, size = 100 }) {
  return (
    <svg width={size} height={size} viewBox="0 0 120 120" fill="none">
      <ellipse cx="42" cy="58" rx="8" ry="14" fill={t.leaf} />
      <ellipse cx="78" cy="54" rx="8" ry="18" fill={t.leaf} />
      <rect x="50" y="22" width="20" height="50" rx="10" fill={t.leafDark} />
      {/* spines */}
      {[28, 36, 44, 52, 60].map((y, i) => (
        <g key={i}>
          <line x1="50" y1={y} x2="46" y2={y - 2} stroke={t.surface} strokeWidth="1" />
          <line x1="70" y1={y} x2="74" y2={y - 2} stroke={t.surface} strokeWidth="1" />
        </g>
      ))}
      {/* flower */}
      <circle cx="60" cy="22" r="5" fill={t.terracotta} />
      <circle cx="60" cy="22" r="2" fill={t.leafLight} />
      {/* pot */}
      <path d="M 36 70 L 84 70 L 80 100 Q 78 106 72 106 L 48 106 Q 42 106 40 100 Z"
        fill={t.terracotta} />
      <ellipse cx="60" cy="70" rx="24" ry="3" fill={t.potShadow} opacity="0.6" />
    </svg>
  );
}

const PLANT_ART = { monstera: Monstera, fern: Fern, succulent: Succulent, pothos: Pothos, cactus: Cactus };

// ─────────────────────────────────────────────────────────────
// Tiny icons
// ─────────────────────────────────────────────────────────────
function Icon({ name, size = 20, color = 'currentColor', stroke = 1.8 }) {
  const p = { width: size, height: size, viewBox: '0 0 24 24', fill: 'none', stroke: color, strokeWidth: stroke, strokeLinecap: 'round', strokeLinejoin: 'round' };
  switch (name) {
    case 'drop': return <svg {...p}><path d="M12 3 C 7 9 5 13 5 16 a7 7 0 0 0 14 0 c0-3-2-7-7-13z" /></svg>;
    case 'spray': return <svg {...p}><path d="M5 14h6v6H5z M11 11h6 M11 17h6" /><circle cx="19" cy="6" r="1" /><circle cx="22" cy="9" r="1" /><circle cx="20" cy="11" r="1" /></svg>;
    case 'fert': return <svg {...p}><path d="M12 2 v4 M8 4 l4 2 4-2 M5 12 c0-4 3-6 7-6 s7 2 7 6 v6 H5z M9 22 v-4 M15 22 v-4" /></svg>;
    case 'sun': return <svg {...p}><circle cx="12" cy="12" r="4" /><path d="M12 2v2 M12 20v2 M2 12h2 M20 12h2 M5 5l1.5 1.5 M17.5 17.5L19 19 M5 19l1.5-1.5 M17.5 6.5L19 5" /></svg>;
    case 'search': return <svg {...p}><circle cx="11" cy="11" r="7" /><path d="m20 20-3.5-3.5" /></svg>;
    case 'bell': return <svg {...p}><path d="M6 8a6 6 0 1 1 12 0c0 7 3 8 3 8H3s3-1 3-8M10 21h4" /></svg>;
    case 'home': return <svg {...p}><path d="M3 11l9-8 9 8v9a2 2 0 0 1-2 2h-4v-7h-6v7H5a2 2 0 0 1-2-2z" /></svg>;
    case 'calendar': return <svg {...p}><rect x="3" y="5" width="18" height="16" rx="2" /><path d="M3 10h18 M8 3v4 M16 3v4" /></svg>;
    case 'user': return <svg {...p}><circle cx="12" cy="8" r="4" /><path d="M4 21c0-4 4-7 8-7s8 3 8 7" /></svg>;
    case 'plus': return <svg {...p}><path d="M12 5v14 M5 12h14" /></svg>;
    case 'arrow-left': return <svg {...p}><path d="M19 12H5 M12 5l-7 7 7 7" /></svg>;
    case 'more': return <svg {...p}><circle cx="6" cy="12" r="1.6" fill={color} stroke="none" /><circle cx="12" cy="12" r="1.6" fill={color} stroke="none" /><circle cx="18" cy="12" r="1.6" fill={color} stroke="none" /></svg>;
    case 'check': return <svg {...p}><path d="m5 13 5 5L20 7" /></svg>;
    case 'leaf': return <svg {...p}><path d="M20 4c-9 0-15 5-15 12 0 2 1 4 2 4 7 0 13-6 13-16z M5 20c5-7 9-10 14-12" /></svg>;
    case 'thermo': return <svg {...p}><path d="M14 14V5a2 2 0 1 0-4 0v9a4 4 0 1 0 4 0z" /></svg>;
    case 'heart': return <svg {...p}><path d="M12 21s-8-5-8-12a5 5 0 0 1 9-3 5 5 0 0 1 9 3c0 7-8 12-8 12z" fill={color} stroke="none" /></svg>;
    default: return null;
  }
}

// ─────────────────────────────────────────────────────────────
// Decorative botanical edge (simple repeating leaves)
// ─────────────────────────────────────────────────────────────
function LeafBorder({ t, w = 380, color }) {
  const c = color || t.leaf;
  return (
    <svg width={w} height="14" viewBox={`0 0 ${w} 14`} style={{ display: 'block' }}>
      {Array.from({ length: Math.floor(w / 16) }).map((_, i) => (
        <ellipse key={i} cx={8 + i * 16} cy="7" rx="5" ry="2.5"
          transform={`rotate(${i % 2 ? 25 : -25} ${8 + i * 16} 7)`}
          fill={c} opacity="0.35" />
      ))}
    </svg>
  );
}

// ─────────────────────────────────────────────────────────────
// HOME SCREEN — Мои растения
// ─────────────────────────────────────────────────────────────
function HomeScreen({ theme = 'light' }) {
  const t = PC_THEMES[theme];

  const todayTasks = [
    { id: 1, plant: 'Моника', sub: 'Монстера', action: 'Полить', icon: 'drop', tint: '#4A90D9', art: 'monstera' },
    { id: 2, plant: 'Фернандо', sub: 'Папоротник', action: 'Опрыскать', icon: 'spray', tint: '#7BA6C9', art: 'fern' },
  ];

  const plants = [
    { id: 1, name: 'Моника', species: 'Монстера', next: 'Полить завтра', mood: 'Счастливая', art: 'monstera', status: 'happy' },
    { id: 2, name: 'Фернандо', species: 'Папоротник', next: 'Опрыскать сегодня', mood: 'Пить хочу!', art: 'fern', status: 'thirsty' },
    { id: 3, name: 'Колючка', species: 'Кактус', next: 'Полить через 12 дн.', mood: 'Бодрый', art: 'cactus', status: 'happy' },
    { id: 4, name: 'Сьюзи', species: 'Суккулент', next: 'Полить через 5 дн.', mood: 'Греется', art: 'succulent', status: 'happy' },
    { id: 5, name: 'Перси', species: 'Эпипремнум', next: 'Удобрить в пт', mood: 'Растёт', art: 'pothos', status: 'happy' },
  ];

  return (
    <div style={{
      width: '100%', height: '100%', background: t.bg, color: t.ink,
      fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif',
      overflow: 'auto',
    }}>
      {/* HEADER */}
      <div style={{ padding: '20px 22px 8px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 18 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
            <div style={{
              width: 36, height: 36, borderRadius: 12, background: t.primary,
              display: 'grid', placeItems: 'center', color: t.surface,
            }}>
              <Icon name="leaf" size={20} color={t.surface} stroke={1.6} />
            </div>
            <span style={{ fontWeight: 600, letterSpacing: '-0.01em', fontSize: 17 }}>PlantCare</span>
          </div>
          <div style={{ display: 'flex', gap: 6 }}>
            <button style={iconBtn(t)}><Icon name="search" size={20} color={t.ink} /></button>
            <button style={{ ...iconBtn(t), position: 'relative' }}>
              <Icon name="bell" size={20} color={t.ink} />
              <span style={{
                position: 'absolute', top: 8, right: 8, width: 8, height: 8,
                borderRadius: 4, background: t.terracotta, border: `2px solid ${t.bg}`,
              }} />
            </button>
          </div>
        </div>

        <div style={{ fontSize: 13, color: t.inkSoft, fontWeight: 500, letterSpacing: '0.04em', textTransform: 'uppercase' }}>
          Среда · 13 мая
        </div>
        <h1 style={{
          fontFamily: '"Instrument Serif", "Cormorant Garamond", serif',
          fontWeight: 400, fontSize: 38, lineHeight: 1.05, margin: '4px 0 0',
          letterSpacing: '-0.01em',
        }}>
          Доброе утро,<br />
          <em style={{ color: t.primary, fontStyle: 'italic' }}>Алина</em>
        </h1>
      </div>

      {/* DIAGNOSIS ALERT */}
      <div style={{ padding: '14px 16px 0' }}>
        <div style={{
          background: theme === 'dark' ? 'rgba(199,123,92,0.12)' : '#FBEFE4',
          borderRadius: 20, padding: '12px 14px',
          border: `1px solid ${theme === 'dark' ? 'rgba(216,145,114,0.25)' : '#F0DDC8'}`,
          display: 'flex', alignItems: 'center', gap: 12,
        }}>
          <div style={{
            width: 36, height: 36, borderRadius: 12, background: t.terracotta,
            display: 'grid', placeItems: 'center', flexShrink: 0,
            color: '#fff', fontFamily: '"Instrument Serif", serif', fontSize: 18,
          }}>!</div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 13, fontWeight: 700, color: t.terracotta }}>
              Фернандо грустит
            </div>
            <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 1 }}>
              Похоже, расписание не подходит. Посмотри предложение →
            </div>
          </div>
          <Icon name="arrow-left" size={14} color={t.terracotta} stroke={2} style={{ transform: 'scaleX(-1)' }} />
        </div>
      </div>

      {/* WEATHER STRIP */}
      <div style={{ padding: '10px 22px 0', display: 'flex', alignItems: 'center', gap: 10, fontSize: 11, color: t.inkSoft }}>
        <span style={{ fontSize: 14 }}>☀️</span>
        <span style={{ fontWeight: 600 }}>+22°, сухо · 38%</span>
        <span style={{ width: 4, height: 4, borderRadius: 2, background: t.inkMute }} />
        <span style={{ color: t.primary, fontWeight: 600 }}>Опрыскивать почаще</span>
      </div>

      {/* TODAY CARD */}
      <div style={{ padding: '14px 16px 8px' }}>
        <div style={{
          background: t.surface, borderRadius: 28, padding: '18px 18px 8px',
          position: 'relative', overflow: 'hidden',
          border: `1px solid ${t.line}`,
        }}>
          {/* corner leaf decoration */}
          <svg width="120" height="120" viewBox="0 0 120 120"
            style={{ position: 'absolute', right: -20, top: -20, opacity: 0.18 }}>
            <path d="M 100 20 C 60 20 30 50 30 90 C 50 90 80 60 100 20 Z" fill={t.leaf} />
            <path d="M 100 20 C 80 60 50 90 30 90" stroke={t.leafDark} strokeWidth="2" fill="none" />
          </svg>

          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 12, position: 'relative' }}>
            <div>
              <div style={{ fontSize: 12, color: t.inkSoft, fontWeight: 600, letterSpacing: '0.06em', textTransform: 'uppercase' }}>
                Сегодня
              </div>
              <div style={{
                fontFamily: '"Instrument Serif", serif', fontSize: 24, fontWeight: 400,
                marginTop: 2, letterSpacing: '-0.01em',
              }}>
                2 заботы
              </div>
            </div>
            <div style={{
              padding: '6px 10px', borderRadius: 999, background: t.primarySoft,
              color: t.primary, fontSize: 11, fontWeight: 600, letterSpacing: '0.04em',
            }}>
              50% ✓
            </div>
          </div>

          {/* progress dots */}
          <div style={{ display: 'flex', gap: 4, marginBottom: 14 }}>
            {[1, 1, 0, 0].map((done, i) => (
              <div key={i} style={{
                flex: 1, height: 4, borderRadius: 2,
                background: done ? t.primary : t.line,
              }} />
            ))}
          </div>

          {todayTasks.map(task => {
            const Art = PLANT_ART[task.art];
            return (
              <div key={task.id} style={{
                display: 'flex', alignItems: 'center', gap: 12,
                padding: '10px 0', borderTop: `1px solid ${t.line}`,
              }}>
                <div style={{
                  width: 48, height: 48, borderRadius: 16, background: t.surfaceWarm,
                  display: 'grid', placeItems: 'center', flexShrink: 0,
                }}>
                  <Art t={t} size={42} />
                </div>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{ fontSize: 15, fontWeight: 600, lineHeight: 1.2 }}>{task.plant}</div>
                  <div style={{ fontSize: 12, color: t.inkSoft, marginTop: 2 }}>
                    «{task.action === 'Полить' ? 'Полей меня, пожалуйста!' : 'Я хочу пить, опрыскай!'}»
                  </div>
                </div>
                <button style={{
                  display: 'flex', alignItems: 'center', gap: 6,
                  padding: '8px 12px', borderRadius: 999,
                  background: t.ink, color: t.surface, border: 'none',
                  fontSize: 12, fontWeight: 600, fontFamily: 'inherit',
                }}>
                  <Icon name={task.icon} size={14} color={t.surface} />
                  {task.action}
                </button>
              </div>
            );
          })}
        </div>
      </div>

      {/* MY GARDEN */}
      <div style={{ padding: '20px 22px 6px', display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
        <div>
          <div style={{ fontSize: 12, color: t.inkSoft, fontWeight: 600, letterSpacing: '0.06em', textTransform: 'uppercase' }}>
            Мой сад
          </div>
          <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 24, marginTop: 2, letterSpacing: '-0.01em' }}>
            12 растений
          </div>
        </div>
        <div style={{ fontSize: 13, color: t.primary, fontWeight: 600 }}>Все →</div>
      </div>

      {/* CATEGORY CHIPS */}
      <div style={{
        display: 'flex', gap: 8, padding: '8px 22px 14px', overflowX: 'auto',
      }}>
        {[
          { l: 'Все', active: true, n: 12 },
          { l: 'Гостиная', n: 5 },
          { l: 'Спальня', n: 3 },
          { l: 'Кухня', n: 2 },
          { l: 'Балкон', n: 2 },
        ].map((c, i) => (
          <div key={i} style={{
            padding: '8px 14px', borderRadius: 999, whiteSpace: 'nowrap',
            background: c.active ? t.ink : t.chipBg,
            color: c.active ? t.surface : t.ink,
            fontSize: 13, fontWeight: 600, display: 'flex', alignItems: 'center', gap: 6,
          }}>
            {c.l}
            <span style={{
              fontSize: 11, opacity: 0.65, fontWeight: 500,
            }}>{c.n}</span>
          </div>
        ))}
      </div>

      {/* PLANT GRID */}
      <div style={{
        display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12,
        padding: '0 16px 100px',
      }}>
        {plants.map((p, i) => {
          const Art = PLANT_ART[p.art];
          return (
            <div key={p.id} style={{
              background: t.surface, borderRadius: 24, padding: 14,
              border: `1px solid ${t.line}`,
              position: 'relative', overflow: 'hidden',
            }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 2 }}>
                <div style={{
                  fontSize: 10, color: t.inkSoft, fontWeight: 600,
                  letterSpacing: '0.06em', textTransform: 'uppercase',
                }}>
                  {p.species}
                </div>
                {p.status === 'thirsty' && (
                  <div style={{
                    width: 22, height: 22, borderRadius: 11,
                    background: t.terracotta, display: 'grid', placeItems: 'center',
                  }}>
                    <Icon name="drop" size={12} color="#fff" stroke={2.2} />
                  </div>
                )}
              </div>

              <div style={{
                fontFamily: '"Instrument Serif", serif', fontSize: 22,
                lineHeight: 1.1, letterSpacing: '-0.01em', marginBottom: 8,
                display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 6,
              }}>
                <span>{p.name}</span>
                {/* health score ring */}
                <div style={{
                  width: 26, height: 26, borderRadius: 13,
                  background: p.status === 'thirsty' ? `conic-gradient(${t.terracotta} 0 70%, ${t.surfaceWarm} 70% 100%)` : `conic-gradient(${t.primary} 0 ${85 + (i*3) % 14}%, ${t.surfaceWarm} 0 100%)`,
                  display: 'grid', placeItems: 'center', flexShrink: 0,
                }}>
                  <div style={{
                    width: 19, height: 19, borderRadius: 10, background: t.surface,
                    display: 'grid', placeItems: 'center',
                    fontSize: 9, fontWeight: 700,
                    color: p.status === 'thirsty' ? t.terracotta : t.primary,
                    fontFamily: '"Plus Jakarta Sans", sans-serif',
                  }}>{p.status === 'thirsty' ? 70 : 85 + (i*3) % 14}</div>
                </div>
              </div>

              <div style={{
                aspectRatio: '1', background: i % 2 === 0 ? t.surfaceWarm : t.primarySoft,
                borderRadius: 18, display: 'grid', placeItems: 'center',
                marginBottom: 10, position: 'relative', overflow: 'hidden',
              }}>
                {/* subtle stripes */}
                <svg style={{ position: 'absolute', inset: 0, opacity: 0.12 }} width="100%" height="100%">
                  <defs>
                    <pattern id={`stripe-${p.id}`} width="6" height="6" patternUnits="userSpaceOnUse">
                      <line x1="0" y1="0" x2="0" y2="6" stroke={t.leafDark} strokeWidth="0.5" />
                    </pattern>
                  </defs>
                  <rect width="100%" height="100%" fill={`url(#stripe-${p.id})`} />
                </svg>
                <Art t={t} size={110} />
              </div>

              <div style={{
                fontSize: 11, color: t.inkSoft, marginBottom: 4,
                display: 'flex', alignItems: 'center', gap: 4,
              }}>
                <span style={{ width: 6, height: 6, borderRadius: 3, background: p.status === 'thirsty' ? t.terracotta : t.primary }} />
                {p.mood}
              </div>
              <div style={{ fontSize: 13, fontWeight: 600 }}>
                {p.next}
              </div>
            </div>
          );
        })}
      </div>

      {/* BOTTOM NAV (absolute) */}
      <BottomNav t={t} active="home" />

      {/* FAB */}
      <button style={{
        position: 'absolute', bottom: 92, right: 20,
        width: 56, height: 56, borderRadius: 18,
        background: t.fab, color: t.fabInk, border: 'none',
        display: 'grid', placeItems: 'center',
        boxShadow: '0 12px 30px rgba(0,0,0,0.25)',
      }}>
        <Icon name="plus" size={26} color={t.fabInk} stroke={2.2} />
      </button>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// PLANT CARD SCREEN — Карточка растения
// ─────────────────────────────────────────────────────────────
function PlantCardScreen({ theme = 'light' }) {
  const t = PC_THEMES[theme];

  const careSchedule = [
    { id: 'water', label: 'Полив', sub: 'каждые 7 дней', next: 'Завтра', icon: 'drop', tint: t.primary, progress: 0.86, days: '1д', daysLeft: 1, total: 7 },
    { id: 'spray', label: 'Опрыскивание', sub: 'каждые 3 дня', next: 'Сегодня', icon: 'spray', tint: t.terracotta, progress: 1.0, days: 'сейчас', daysLeft: 0, total: 3 },
    { id: 'fert', label: 'Подкормка', sub: 'раз в месяц', next: 'Через 12 дн.', icon: 'fert', tint: t.leafDark, progress: 0.6, days: '12д', daysLeft: 12, total: 30 },
  ];

  const stats = [
    { label: 'Свет', value: 'Рассеянный', icon: 'sun' },
    { label: 'Темп.', value: '+18…24°', icon: 'thermo' },
    { label: 'Влажн.', value: '60–80%', icon: 'drop' },
  ];

  const journal = [
    { date: '12 мая', action: 'Полила', note: '~200 мл, земля была сухая' },
    { date: '9 мая', action: 'Опрыскала', note: 'Новый лист разворачивается!' },
    { date: '4 мая', action: 'Полила + удобрение', note: 'Pokon универсальный' },
  ];

  return (
    <div style={{
      width: '100%', height: '100%', color: t.ink, background: t.bg,
      fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif',
      overflow: 'auto',
    }}>
      {/* HERO */}
      <div style={{
        background: t.primarySoft, padding: '16px 22px 0',
        position: 'relative', overflow: 'hidden',
      }}>
        {/* decorative leaves bg */}
        <svg width="100%" height="100%" viewBox="0 0 400 360"
          style={{ position: 'absolute', inset: 0, opacity: 0.22 }} preserveAspectRatio="xMaxYMax slice">
          <g transform="translate(280 -30) rotate(25)">
            <path d="M 0 0 C -40 -20 -60 -80 -50 -140 C -10 -150 40 -100 50 -40 C 50 -20 30 0 0 0 Z" fill={t.leafDark} />
            <path d="M -30 -30 L -45 -120 M -10 -20 L -2 -130 M 20 -30 L 35 -120" stroke={t.surface} strokeWidth="2" opacity="0.4" />
          </g>
          <g transform="translate(80 300) rotate(-30)">
            <path d="M 0 0 C -30 -10 -45 -50 -38 -90 C -10 -92 28 -60 32 -22 C 32 -10 18 4 0 0 Z" fill={t.leafDark} />
          </g>
        </svg>

        {/* top bar */}
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 8, position: 'relative' }}>
          <button style={iconBtn(t, true)}><Icon name="arrow-left" size={20} color={t.ink} /></button>
          <div style={{ fontSize: 12, fontWeight: 600, letterSpacing: '0.06em', color: t.inkSoft, textTransform: 'uppercase' }}>
            Карточка
          </div>
          <button style={iconBtn(t, true)}><Icon name="more" size={20} color={t.ink} /></button>
        </div>

        {/* plant illustration */}
        <div style={{ display: 'grid', placeItems: 'center', padding: '14px 0 6px', position: 'relative' }}>
          <Monstera t={t} size={210} />
        </div>
      </div>

      {/* TITLE */}
      <div style={{
        background: t.bg, borderTopLeftRadius: 28, borderTopRightRadius: 28,
        marginTop: -18, padding: '22px 22px 0', position: 'relative',
      }}>
        <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', gap: 12 }}>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{ fontSize: 12, color: t.inkSoft, fontWeight: 600, letterSpacing: '0.06em', textTransform: 'uppercase' }}>
              Monstera deliciosa · Гостиная
            </div>
            <h2 style={{
              fontFamily: '"Instrument Serif", serif', fontSize: 36, fontWeight: 400,
              margin: '4px 0 0', letterSpacing: '-0.01em', lineHeight: 1,
            }}>
              Моника <em style={{ color: t.primary, fontStyle: 'italic', fontSize: 28 }}>♥</em>
            </h2>
            <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginTop: 8, fontSize: 13, color: t.inkSoft, flexWrap: 'wrap' }}>
              <span style={{ width: 8, height: 8, borderRadius: 4, background: t.primary }} />
              Счастливая · со мной уже 1 год 4 мес.
            </div>
            {/* badges row */}
            <div style={{ display: 'flex', gap: 6, marginTop: 10, flexWrap: 'wrap' }}>
              <span style={{
                display: 'inline-flex', alignItems: 'center', gap: 4,
                padding: '4px 8px', borderRadius: 8,
                background: theme === 'dark' ? 'rgba(216,145,114,0.18)' : '#FBEFE4',
                color: t.terracotta, fontSize: 10, fontWeight: 700, letterSpacing: '0.04em',
              }}>⚠ ТОКСИЧНО · 🐈</span>
              <span style={{
                display: 'inline-flex', alignItems: 'center', gap: 4,
                padding: '4px 8px', borderRadius: 8,
                background: theme === 'dark' ? 'rgba(143,174,101,0.18)' : '#E2EDD0',
                color: t.primary, fontSize: 10, fontWeight: 700, letterSpacing: '0.04em',
              }}>♥ HEALTH 92</span>
              <span style={{
                display: 'inline-flex', alignItems: 'center', gap: 4,
                padding: '4px 8px', borderRadius: 8,
                background: t.surfaceWarm,
                color: t.inkSoft, fontSize: 10, fontWeight: 700, letterSpacing: '0.04em',
              }}>🌱 1 ЧЕРЕНОК</span>
            </div>
          </div>
          <button style={iconBtn(t, true, 44)}>
            <Icon name="heart" size={20} color={t.terracotta} />
          </button>
        </div>

        {/* speech bubble */}
        <div style={{
          marginTop: 16, background: t.surface, borderRadius: 20,
          padding: '12px 16px', border: `1px solid ${t.line}`,
          position: 'relative',
        }}>
          <div style={{
            position: 'absolute', top: -6, left: 24, width: 12, height: 12,
            background: t.surface, transform: 'rotate(45deg)',
            borderTop: `1px solid ${t.line}`, borderLeft: `1px solid ${t.line}`,
          }} />
          <div style={{
            fontFamily: '"Instrument Serif", serif', fontSize: 17, fontStyle: 'italic',
            lineHeight: 1.3, color: t.ink,
          }}>
            «Эй! Опрыскай меня сегодня, пожалуйста — я тоскую по тропикам.»
          </div>
          <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 6, fontWeight: 600 }}>
            — Моника, 9:30
          </div>
        </div>
      </div>

      {/* CARE SCHEDULE */}
      <div style={{ padding: '22px 22px 0' }}>
        <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', marginBottom: 12 }}>
          <h3 style={{
            fontFamily: '"Instrument Serif", serif', fontSize: 22,
            fontWeight: 400, margin: 0, letterSpacing: '-0.01em',
          }}>Расписание ухода</h3>
          <span style={{ fontSize: 13, color: t.primary, fontWeight: 600 }}>Изменить</span>
        </div>

        <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
          {careSchedule.map(c => (
            <div key={c.id} style={{
              background: t.surface, borderRadius: 22, padding: 14,
              border: `1px solid ${t.line}`,
              display: 'flex', alignItems: 'center', gap: 14,
            }}>
              <div style={{ position: 'relative', width: 54, height: 54, flexShrink: 0 }}>
                <svg width="54" height="54" viewBox="0 0 54 54" style={{ transform: 'rotate(-90deg)' }}>
                  <circle cx="27" cy="27" r="22" stroke={t.surfaceWarm} strokeWidth="4" fill="none" />
                  <circle cx="27" cy="27" r="22" stroke={c.tint} strokeWidth="4" fill="none"
                    strokeDasharray={`${2 * Math.PI * 22}`} strokeDashoffset={`${2 * Math.PI * 22 * (1 - c.progress)}`}
                    strokeLinecap="round" />
                </svg>
                <div style={{
                  position: 'absolute', inset: 0, display: 'grid', placeItems: 'center',
                }}>
                  <Icon name={c.icon} size={22} color={c.tint} stroke={1.8} />
                </div>
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 15, fontWeight: 600 }}>{c.label}</div>
                <div style={{ fontSize: 12, color: t.inkSoft, marginTop: 1 }}>{c.sub}</div>
              </div>
              <div style={{ textAlign: 'right' }}>
                <div style={{ fontSize: 11, color: t.inkSoft, fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.04em' }}>
                  Через
                </div>
                <div style={{
                  fontFamily: '"Instrument Serif", serif', fontSize: 22, lineHeight: 1,
                  color: c.next === 'Сегодня' ? t.terracotta : t.ink,
                }}>
                  {c.next === 'Сегодня' ? 'Сегодня' : c.days}
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* CONDITIONS */}
      <div style={{ padding: '20px 22px 0' }}>
        <h3 style={{
          fontFamily: '"Instrument Serif", serif', fontSize: 22,
          fontWeight: 400, margin: '0 0 12px', letterSpacing: '-0.01em',
        }}>Условия</h3>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 10 }}>
          {stats.map(s => (
            <div key={s.label} style={{
              background: t.surface, borderRadius: 18, padding: '14px 12px',
              border: `1px solid ${t.line}`,
              display: 'flex', flexDirection: 'column', gap: 8,
            }}>
              <Icon name={s.icon} size={18} color={t.primary} stroke={1.8} />
              <div>
                <div style={{ fontSize: 11, color: t.inkSoft, fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.04em' }}>
                  {s.label}
                </div>
                <div style={{ fontSize: 14, fontWeight: 600, marginTop: 2 }}>{s.value}</div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* JOURNAL */}
      <div style={{ padding: '20px 22px 0' }}>
        <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', marginBottom: 12 }}>
          <h3 style={{
            fontFamily: '"Instrument Serif", serif', fontSize: 22,
            fontWeight: 400, margin: 0, letterSpacing: '-0.01em',
          }}>Дневник ухода</h3>
          <span style={{ fontSize: 13, color: t.primary, fontWeight: 600 }}>Всё →</span>
        </div>

        <div style={{
          background: t.surface, borderRadius: 22, padding: '4px 16px',
          border: `1px solid ${t.line}`,
        }}>
          {journal.map((j, i) => (
            <div key={i} style={{
              display: 'flex', gap: 14, padding: '14px 0',
              borderTop: i === 0 ? 'none' : `1px solid ${t.line}`,
            }}>
              <div style={{
                width: 28, height: 28, borderRadius: 14, background: t.primarySoft,
                display: 'grid', placeItems: 'center', flexShrink: 0, marginTop: 2,
              }}>
                <Icon name="check" size={16} color={t.primary} stroke={2.2} />
              </div>
              <div style={{ flex: 1 }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
                  <span style={{ fontSize: 14, fontWeight: 600 }}>{j.action}</span>
                  <span style={{ fontSize: 11, color: t.inkSoft }}>{j.date}</span>
                </div>
                <div style={{ fontSize: 12, color: t.inkSoft, marginTop: 2 }}>{j.note}</div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* BIG ACTION BUTTON */}
      <div style={{ padding: '22px 22px 110px' }}>
        <button style={{
          width: '100%', padding: '16px', borderRadius: 20,
          background: t.ink, color: t.surface, border: 'none',
          fontSize: 15, fontWeight: 600, fontFamily: 'inherit',
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10,
        }}>
          <Icon name="spray" size={18} color={t.surface} stroke={1.8} />
          Опрыскать Монику сейчас
        </button>
      </div>

      <BottomNav t={t} active="home" />
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Bottom nav (absolute positioned over screen)
// ─────────────────────────────────────────────────────────────
function BottomNav({ t, active = 'home' }) {
  const items = [
    { id: 'home', label: 'Сад', icon: 'home' },
    { id: 'cal', label: 'График', icon: 'calendar' },
    { id: 'plus', label: '', icon: 'plus', special: true },
    { id: 'lib', label: 'Каталог', icon: 'leaf' },
    { id: 'me', label: 'Я', icon: 'user' },
  ];
  return (
    <div style={{
      position: 'absolute', left: 12, right: 12, bottom: 12,
      background: t.surface, borderRadius: 28, padding: '8px 6px',
      border: `1px solid ${t.line}`,
      boxShadow: '0 18px 40px rgba(0,0,0,0.10)',
      display: 'flex', justifyContent: 'space-around', alignItems: 'center',
    }}>
      {items.map(it => (
        it.special ? (
          <div key={it.id} style={{ display: 'none' }} />
        ) : (
          <div key={it.id} style={{
            display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 2,
            padding: '6px 14px', borderRadius: 16,
            background: active === it.id ? t.primarySoft : 'transparent',
          }}>
            <Icon name={it.icon} size={20} color={active === it.id ? t.primary : t.inkSoft} stroke={1.8} />
            <div style={{
              fontSize: 10, fontWeight: 600,
              color: active === it.id ? t.primary : t.inkSoft,
            }}>{it.label}</div>
          </div>
        )
      ))}
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// helpers
// ─────────────────────────────────────────────────────────────
function iconBtn(t, transparent = false, size = 40) {
  return {
    width: size, height: size, borderRadius: size / 2.5,
    background: transparent ? 'transparent' : t.surface,
    border: transparent ? 'none' : `1px solid ${t.line}`,
    display: 'grid', placeItems: 'center', cursor: 'pointer',
  };
}

Object.assign(window, {
  HomeScreen, PlantCardScreen, PC_THEMES,
  Monstera, Fern, Succulent, Pothos, Cactus, Icon,
});
