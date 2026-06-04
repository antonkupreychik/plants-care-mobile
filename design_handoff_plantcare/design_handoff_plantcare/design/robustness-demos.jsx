// PlantCare — Robustness demos · «обычно vs под нагрузкой»
// Ключевые переиспользуемые компоненты под стресс-контентом.

// ── обёртка пары: норма | стресс
function RobustPair({ t, title, note, normal, stress }) {
  return (
    <div style={{ background: t.surface, borderRadius: 22, border: `1px solid ${t.line}`, overflow: 'hidden' }}>
      <div style={{ padding: '14px 18px 0' }}>
        <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 20, lineHeight: 1.1, letterSpacing: '-0.01em' }}>{title}</div>
      </div>
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 1, background: t.line, margin: '14px 0 0' }}>
        <div style={{ background: t.bg, padding: '14px 16px' }}>
          <div style={{ fontSize: 10, fontWeight: 700, color: t.inkSoft, letterSpacing: '0.06em', textTransform: 'uppercase', marginBottom: 10 }}>Обычно</div>
          {normal}
        </div>
        <div style={{ background: t.bg, padding: '14px 16px' }}>
          <div style={{ fontSize: 10, fontWeight: 700, color: t.terracotta, letterSpacing: '0.06em', textTransform: 'uppercase', marginBottom: 10 }}>Под нагрузкой</div>
          {stress}
        </div>
      </div>
      <div style={{ padding: '12px 18px', display: 'flex', gap: 10, alignItems: 'flex-start' }}>
        <window.Icon name="check" size={15} color={t.primary} stroke={2.4} style={{ marginTop: 2, flexShrink: 0 }} />
        <div style={{ fontSize: 12.5, color: t.inkSoft, lineHeight: 1.45 }}>{note}</div>
      </div>
    </div>
  );
}

// ── строка растения (используется в саду, отпуске, шеринге)
function PlantRow({ t, name, species }) {
  return (
    <div style={{ background: t.surface, borderRadius: 16, padding: '10px 12px', border: `1px solid ${t.line}`, display: 'flex', alignItems: 'center', gap: 10 }}>
      <div style={{ width: 40, height: 40, borderRadius: 12, background: t.surfaceWarm, display: 'grid', placeItems: 'center', flexShrink: 0 }}>
        <window.Monstera t={t} size={36} />
      </div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontSize: 14, fontWeight: 700, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{name}</div>
        <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 1, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{species}</div>
      </div>
      <button style={{ padding: '8px 14px', borderRadius: 999, background: t.ink, color: t.surface, border: 'none', fontSize: 12, fontWeight: 600, fontFamily: 'inherit', flexShrink: 0, whiteSpace: 'nowrap' }}>Полить</button>
    </div>
  );
}

// ── крупное число-статистика
function StatNum({ t, value, label }) {
  return (
    <div style={{ background: t.surface, borderRadius: 16, padding: '12px 14px', border: `1px solid ${t.line}`, textAlign: 'center' }}>
      <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 34, lineHeight: 1, color: t.primary, fontVariantNumeric: 'tabular-nums' }}>{value}</div>
      <div style={{ fontSize: 10, color: t.inkSoft, marginTop: 4, fontWeight: 600 }}>{label}</div>
    </div>
  );
}

// ── speech bubble
function Bubble({ t, children }) {
  return (
    <div style={{ background: t.primarySoft, borderRadius: 14, padding: '10px 14px' }}>
      <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 15, fontStyle: 'italic', lineHeight: 1.4, color: t.ink, textWrap: 'pretty' }}>{children}</div>
    </div>
  );
}

function plural(n) {
  const a = Math.abs(n) % 100, b = n % 10;
  if (a > 10 && a < 20) return 'растений';
  if (b > 1 && b < 5) return 'растения';
  if (b === 1) return 'растение';
  return 'растений';
}

function RobustnessDemos({ t }) {
  return (
    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(420px, 1fr))', gap: 18 }}>

      {/* 1 · длинное имя */}
      <RobustPair t={t}
        title="Имя и вид растения"
        note="Имя и вид — по одной строке с многоточием (numberOfLines=1). Кнопка фиксированной ширины, никогда не сжимается ниже хит-таргета."
        normal={<PlantRow t={t} name="Моника" species="Монстера" />}
        stress={<PlantRow t={t} name="Замиокулькас замиелистный пёстрый" species="Zamioculcas zamiifolia variegata" />}
      />

      {/* 2 · крупный шрифт (Dynamic Type) */}
      <RobustPair t={t}
        title="Крупный системный шрифт"
        note="При Dynamic Type ×1.3 строка растёт и переносится в 2 строки (numberOfLines=2). allowFontScaling=true, maxFontSizeMultiplier=1.4. Высота строки растёт вместе с кеглем."
        normal={<div style={{ background: t.surface, borderRadius: 16, padding: '12px 14px', border: `1px solid ${t.line}` }}>
          <div style={{ fontSize: 14, fontWeight: 700 }}>Полить Монику</div>
          <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 2 }}>Сегодня · до 19:00</div>
        </div>}
        stress={<div style={{ background: t.surface, borderRadius: 16, padding: '12px 14px', border: `1px solid ${t.line}` }}>
          <div style={{ fontSize: 19, fontWeight: 700, lineHeight: 1.25 }}>Полить Монику</div>
          <div style={{ fontSize: 15, color: t.inkSoft, marginTop: 3, lineHeight: 1.3 }}>Сегодня · до 19:00</div>
        </div>}
      />

      {/* 3 · числа разной величины */}
      <RobustPair t={t}
        title="Числа-статистика"
        note="tabular-nums держит выравнивание. Контейнер фиксированной высоты; 4+ знака — кегль чуть уменьшается, верстка не ломается. Ноль — валидное состояние, не «—»."
        normal={<div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 8 }}>
          <StatNum t={t} value="7" label="дней стрик" />
          <StatNum t={t} value="94%" label="вовремя" />
          <StatNum t={t} value="12" label="растений" />
        </div>}
        stress={<div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 8 }}>
          <StatNum t={t} value="0" label="дней стрик" />
          <StatNum t={t} value="100%" label="вовремя" />
          <StatNum t={t} value="1247" label="растений" />
        </div>}
      />

      {/* 4 · реплика растения */}
      <RobustPair t={t}
        title="Реплика растения"
        note="Голос растения НЕ обрезается — он выразительный. Свободно переносится, контейнер растёт по высоте. Ограничение ~4 строк, дальше — без скролла внутри пузыря."
        normal={<Bubble t={t}>«Полей меня, пожалуйста!»</Bubble>}
        stress={<Bubble t={t}>«Я уже третий день жду полива, земля совсем пересохла, нижние листья начали желтеть — загляни ко мне, пожалуйста, когда будет минутка!»</Bubble>}
      />

      {/* 5 · чипы-фильтры */}
      <RobustPair t={t}
        title="Чипы и фильтры"
        note="Ряд чипов переносится на несколько строк (flexWrap) с gap, а не уезжает за край и не сжимается. Горизонтальный скролл — только там, где он задуман (фильтры истории)."
        normal={<div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
          {['Все', 'Полив', 'Опрыскивание'].map((s, i) => <span key={i} style={{ padding: '7px 12px', borderRadius: 999, background: t.chipBg, fontSize: 13, fontWeight: 600 }}>{s}</span>)}
        </div>}
        stress={<div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
          {['Все', 'Полив', 'Опрыскивание', 'Подкормка', 'Проверка грунта', 'Пересадка', 'Обрезка'].map((s, i) => <span key={i} style={{ padding: '7px 12px', borderRadius: 999, background: t.chipBg, fontSize: 13, fontWeight: 600 }}>{s}</span>)}
        </div>}
      />

      {/* 6 · склонения */}
      <RobustPair t={t}
        title="Склонения и счётчики"
        note="Числительные согласуются с существительным (1 растение / 2 растения / 5 растений). Функция plural() по правилам русского языка. Эмодзи — не единственный носитель смысла."
        normal={<div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
          {[1, 3].map(n => <div key={n} style={{ background: t.surface, borderRadius: 12, padding: '8px 12px', border: `1px solid ${t.line}`, fontSize: 13, fontWeight: 600 }}>{n} {plural(n)} в саду</div>)}
        </div>}
        stress={<div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
          {[5, 11, 21].map(n => <div key={n} style={{ background: t.surface, borderRadius: 12, padding: '8px 12px', border: `1px solid ${t.line}`, fontSize: 13, fontWeight: 600 }}>{n} {plural(n)} в саду</div>)}
        </div>}
      />
    </div>
  );
}

Object.assign(window, { RobustnessDemos });
