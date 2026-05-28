// PlantCate — batch 5 — закрываем навигационные тупики
// Карточка вида (из каталога/мастера), Полная история ухода, Редактирование расписания

// ─────────────────────────────────────────────────────────────
// Shared helpers (экспортируются для v6)
// ─────────────────────────────────────────────────────────────
function pcIconBtn(t, transparent = false, size = 40) {
  return {
    width: size, height: size, borderRadius: size / 2.5,
    background: transparent ? 'transparent' : t.surface,
    border: transparent ? 'none' : `1px solid ${t.line}`,
    display: 'grid', placeItems: 'center', cursor: 'pointer',
  };
}

function PcSectionLabel({ t, children, style }) {
  return (
    <div style={{
      fontSize: 11, color: t.inkSoft, fontWeight: 700,
      letterSpacing: '0.06em', textTransform: 'uppercase',
      padding: '6px 6px 10px', ...style,
    }}>{children}</div>
  );
}

function PcToggle({ t, on }) {
  return (
    <div style={{
      width: 44, height: 26, borderRadius: 13,
      background: on ? t.primary : t.surfaceWarm,
      position: 'relative', flexShrink: 0, transition: 'background .2s',
    }}>
      <div style={{
        position: 'absolute', top: 3, left: on ? 21 : 3,
        width: 20, height: 20, borderRadius: 10, background: t.surface,
        boxShadow: '0 1px 3px rgba(0,0,0,0.2)', transition: 'left .2s',
      }} />
    </div>
  );
}

// Stepper «− N +» pill
function PcStepper({ t, value, unit, dim }) {
  return (
    <div style={{
      display: 'inline-flex', alignItems: 'center', gap: 2,
      background: t.surfaceWarm, borderRadius: 999, padding: 3,
      opacity: dim ? 0.4 : 1,
    }}>
      <button style={{
        width: 30, height: 30, borderRadius: 15, border: 'none',
        background: t.surface, color: t.ink, cursor: 'pointer',
        display: 'grid', placeItems: 'center', fontFamily: 'inherit',
      }}><window.Icon name="arrow-left" size={13} color={t.ink} stroke={2.4} style={{ transform: 'rotate(90deg)' }} /></button>
      <div style={{
        minWidth: 64, textAlign: 'center', fontSize: 13, fontWeight: 700,
        color: t.ink, padding: '0 4px', fontVariantNumeric: 'tabular-nums',
      }}>
        {value}<span style={{ fontWeight: 500, color: t.inkSoft, marginLeft: 3 }}>{unit}</span>
      </div>
      <button style={{
        width: 30, height: 30, borderRadius: 15, border: 'none',
        background: t.ink, color: t.surface, cursor: 'pointer',
        display: 'grid', placeItems: 'center', fontFamily: 'inherit',
      }}><window.Icon name="plus" size={14} color={t.surface} stroke={2.4} /></button>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 20 · КАРТОЧКА ВИДА — справочник (GET /species/{id})
//      вход: Каталог (12) и Шаг 1 мастера (04a)
// ─────────────────────────────────────────────────────────────
function SpeciesDetailScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];

  const facts = [
    { l: 'Сложность', v: 'Лёгкая', icon: 'leaf', ok: true },
    { l: 'Свет', v: 'Рассеянный', icon: 'sun' },
    { l: 'Полив', v: 'раз в 7 дн.', icon: 'drop' },
    { l: 'Рост', v: 'Быстрый', icon: 'fert' },
  ];

  const care = [
    { id: 'water', label: 'Полив', sub: 'когда верхний слой подсох', every: '7 дней', icon: 'drop', tint: t.primary },
    { id: 'spray', label: 'Опрыскивание', sub: 'любит тропическую влажность', every: '3 дня', icon: 'spray', tint: t.terracotta },
    { id: 'fert', label: 'Подкормка', sub: 'весна–лето, реже зимой', every: '30 дней', icon: 'fert', tint: t.leafDark },
    { id: 'soil', label: 'Проверка грунта', sub: 'рыхлость и дренаж', every: '14 дней', icon: 'thermo', tint: t.leaf },
  ];

  // шкала света: позиция «Рассеянный» = 2 из 4
  const lightSteps = ['Тень', 'Полутень', 'Рассеянный', 'Прямое'];
  const lightActive = 2;

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'auto', position: 'relative' }}>
      {/* HERO */}
      <div style={{ background: t.primarySoft, padding: '16px 22px 0', position: 'relative', overflow: 'hidden' }}>
        <svg width="100%" height="100%" viewBox="0 0 400 340" style={{ position: 'absolute', inset: 0, opacity: 0.20 }} preserveAspectRatio="xMaxYMax slice">
          <g transform="translate(300 -20) rotate(28)">
            <path d="M 0 0 C -40 -20 -60 -80 -50 -140 C -10 -150 40 -100 50 -40 C 50 -20 30 0 0 0 Z" fill={t.leafDark} />
            <path d="M -30 -30 L -45 -120 M -10 -20 L -2 -130 M 20 -30 L 35 -120" stroke={t.surface} strokeWidth="2" opacity="0.4" />
          </g>
        </svg>

        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', position: 'relative' }}>
          <button style={pcIconBtn(t, true)}><window.Icon name="arrow-left" size={20} color={t.ink} /></button>
          <div style={{ fontSize: 12, fontWeight: 600, letterSpacing: '0.06em', color: t.inkSoft, textTransform: 'uppercase' }}>Каталог видов</div>
          <button style={pcIconBtn(t, true)}>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke={t.ink} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"><path d="M6 4h12v16l-6-4-6 4z" /></svg>
          </button>
        </div>

        <div style={{ display: 'grid', placeItems: 'center', padding: '16px 0 8px', position: 'relative' }}>
          <window.Monstera t={t} size={200} />
        </div>
      </div>

      {/* TITLE block */}
      <div style={{ background: t.bg, borderTopLeftRadius: 28, borderTopRightRadius: 28, marginTop: -18, padding: '22px 22px 0', position: 'relative' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, flexWrap: 'wrap' }}>
          <h2 style={{ fontFamily: '"Instrument Serif", serif', fontSize: 38, fontWeight: 400, margin: 0, letterSpacing: '-0.01em', lineHeight: 1 }}>Монстера</h2>
          <span style={{ fontSize: 10, fontWeight: 700, color: t.terracotta, background: theme === 'dark' ? 'rgba(216,145,114,0.15)' : '#F9E3D8', padding: '3px 7px', borderRadius: 6, letterSpacing: '0.04em' }}>ХИТ КАТАЛОГА</span>
        </div>
        <div style={{ fontSize: 13, color: t.inkSoft, fontStyle: 'italic', marginTop: 4, fontFamily: '"Instrument Serif", serif', fontSize: 16 }}>Monstera deliciosa · Ароидные</div>

        {/* tagline */}
        <div style={{ fontSize: 14, color: t.inkSoft, lineHeight: 1.5, marginTop: 12, textWrap: 'pretty' }}>
          Тропическая лиана с резными листьями. Прощает забывчивым хозяевам, растёт быстро и эффектно — отличный выбор для начала.
        </div>

        {/* FACTS grid */}
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10, marginTop: 16 }}>
          {facts.map(f => (
            <div key={f.l} style={{
              background: t.surface, borderRadius: 18, padding: '12px 14px',
              border: `1px solid ${t.line}`, display: 'flex', alignItems: 'center', gap: 12,
            }}>
              <div style={{ width: 38, height: 38, borderRadius: 12, background: t.primarySoft, display: 'grid', placeItems: 'center', flexShrink: 0 }}>
                <window.Icon name={f.icon} size={18} color={t.primary} stroke={1.8} />
              </div>
              <div style={{ minWidth: 0 }}>
                <div style={{ fontSize: 11, color: t.inkSoft, fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.04em' }}>{f.l}</div>
                <div style={{ fontSize: 14, fontWeight: 700, marginTop: 1, display: 'flex', alignItems: 'center', gap: 5 }}>
                  {f.ok && <span style={{ width: 6, height: 6, borderRadius: 3, background: t.primary }} />}
                  {f.v}
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* TOXICITY banner */}
      <div style={{ padding: '16px 16px 0' }}>
        <div style={{
          background: theme === 'dark' ? 'rgba(199,123,92,0.12)' : '#FBEFE4',
          borderRadius: 18, padding: '14px 16px',
          border: `1px solid ${theme === 'dark' ? 'rgba(216,145,114,0.25)' : '#F0DDC8'}`,
          display: 'flex', alignItems: 'center', gap: 12,
        }}>
          <div style={{ fontSize: 24, flexShrink: 0 }}>🐈</div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 13, fontWeight: 700, color: t.terracotta }}>Токсично для кошек, собак и детей</div>
            <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 1 }}>Сок листьев раздражает слизистую. Держи повыше.</div>
          </div>
        </div>
      </div>

      {/* RECOMMENDED CARE */}
      <div style={{ padding: '20px 22px 0' }}>
        <h3 style={{ fontFamily: '"Instrument Serif", serif', fontSize: 22, fontWeight: 400, margin: '0 0 4px', letterSpacing: '-0.01em' }}>Рекомендованный уход</h3>
        <div style={{ fontSize: 12, color: t.inkSoft, marginBottom: 12 }}>Подставится в расписание при добавлении</div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
          {care.map(c => (
            <div key={c.id} style={{
              background: t.surface, borderRadius: 18, padding: '12px 14px',
              border: `1px solid ${t.line}`, display: 'flex', alignItems: 'center', gap: 12,
            }}>
              <div style={{ width: 40, height: 40, borderRadius: 13, background: t.surfaceWarm, display: 'grid', placeItems: 'center', flexShrink: 0 }}>
                <window.Icon name={c.icon} size={19} color={c.tint} stroke={1.8} />
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 14, fontWeight: 600 }}>{c.label}</div>
                <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 1 }}>{c.sub}</div>
              </div>
              <div style={{ textAlign: 'right', flexShrink: 0 }}>
                <div style={{ fontSize: 10, color: t.inkSoft, fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.04em' }}>каждые</div>
                <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 18, lineHeight: 1.1, color: t.ink }}>{c.every}</div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* LIGHT meter */}
      <div style={{ padding: '20px 22px 0' }}>
        <h3 style={{ fontFamily: '"Instrument Serif", serif', fontSize: 22, fontWeight: 400, margin: '0 0 12px', letterSpacing: '-0.01em' }}>Свет</h3>
        <div style={{ background: t.surface, borderRadius: 22, padding: '18px 16px', border: `1px solid ${t.line}` }}>
          <div style={{ display: 'flex', gap: 4, marginBottom: 10 }}>
            {lightSteps.map((s, i) => (
              <div key={i} style={{ flex: 1, height: 8, borderRadius: 4, background: i === lightActive ? t.primary : t.surfaceWarm }} />
            ))}
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between' }}>
            {lightSteps.map((s, i) => (
              <div key={i} style={{ fontSize: 10, fontWeight: i === lightActive ? 700 : 500, color: i === lightActive ? t.primary : t.inkMute, flex: 1, textAlign: 'center' }}>{s}</div>
            ))}
          </div>
          <div style={{ fontSize: 13, color: t.inkSoft, lineHeight: 1.5, marginTop: 14, textWrap: 'pretty' }}>
            Яркий рассеянный свет в паре метров от окна. Прямое солнце в полдень обожжёт листья, в глубокой тени рост замедлится.
          </div>
        </div>
      </div>

      {/* ABOUT */}
      <div style={{ padding: '20px 22px 0' }}>
        <h3 style={{ fontFamily: '"Instrument Serif", serif', fontSize: 22, fontWeight: 400, margin: '0 0 10px', letterSpacing: '-0.01em' }}>О растении</h3>
        <div style={{ fontSize: 14, color: t.inkSoft, lineHeight: 1.6, textWrap: 'pretty' }}>
          Родом из тропических лесов Центральной Америки. Молодые листья цельные, с возрастом покрываются характерными прорезями и отверстиями — так растение пропускает свет к нижним ярусам. В природе взбирается по стволам деревьев, дома ей пригодится опора-мохошест.
        </div>
      </div>

      {/* CTA */}
      <div style={{ height: 96 }} />
      <div style={{
        position: 'absolute', left: 0, right: 0, bottom: 0, padding: '14px 16px 18px',
        background: `linear-gradient(to top, ${t.bg} 72%, ${t.bg}00)`,
      }}>
        <button style={{
          width: '100%', padding: '16px', borderRadius: 20,
          background: t.ink, color: t.surface, border: 'none',
          fontSize: 15, fontWeight: 600, fontFamily: 'inherit',
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10,
        }}>
          <window.Icon name="plus" size={18} color={t.surface} stroke={2.2} />
          Добавить в мой сад
        </button>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 21 · ПОЛНАЯ ИСТОРИЯ УХОДА (GET /plants/{id}/history)
//      вход: Карточка растения 02 → «Дневник ухода · Всё»
// ─────────────────────────────────────────────────────────────
function CareHistoryScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];

  const filters = [
    { l: 'Всё', n: 17, active: true },
    { l: 'Полив', n: 8 },
    { l: 'Опрыскивание', n: 6 },
    { l: 'Подкормка', n: 3 },
  ];

  const groups = [
    {
      month: 'Май 2026', items: [
        { type: 'water', label: 'Полила', icon: 'drop', tint: t.primary, day: '12', dow: 'Пн', time: '8:10', note: '~200 мл, земля была сухая', onTime: true },
        { type: 'spray', label: 'Опрыскала', icon: 'spray', tint: t.terracotta, day: '9', dow: 'Пт', time: '9:30', note: 'Новый лист разворачивается!', onTime: true },
        { type: 'fert', label: 'Полила + удобрение', icon: 'fert', tint: t.leafDark, day: '4', dow: 'Вс', time: '19:40', note: 'Pokon универсальный, половина дозы', onTime: false },
        { type: 'spray', label: 'Опрыскала', icon: 'spray', tint: t.terracotta, day: '2', dow: 'Пт', time: '8:55', note: '', onTime: true },
      ],
    },
    {
      month: 'Апрель 2026', items: [
        { type: 'water', label: 'Полила', icon: 'drop', tint: t.primary, day: '27', dow: 'Вс', time: '9:05', note: 'Протёрла листья от пыли', onTime: true },
        { type: 'spray', label: 'Опрыскала', icon: 'spray', tint: t.terracotta, day: '24', dow: 'Чт', time: '8:40', note: '', onTime: true },
        { type: 'water', label: 'Полила', icon: 'drop', tint: t.primary, day: '20', dow: 'Вс', time: '18:20', note: 'Пересадила в горшок побольше 🪴', onTime: true },
      ],
    },
  ];

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'auto', position: 'relative' }}>
      <div style={{ padding: '16px 22px 8px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 12 }}>
          <button style={pcIconBtn(t)}><window.Icon name="arrow-left" size={20} color={t.ink} /></button>
          <div style={{ textAlign: 'center' }}>
            <div style={{ fontSize: 11, color: t.inkSoft, fontWeight: 600, letterSpacing: '0.06em', textTransform: 'uppercase' }}>Дневник ухода</div>
            <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 20, lineHeight: 1.1 }}>Моника</div>
          </div>
          <button style={pcIconBtn(t)}><window.Icon name="plus" size={20} color={t.ink} /></button>
        </div>

        {/* summary */}
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 8 }}>
          {[
            { v: '17', l: 'забот\nвсего' },
            { v: '94%', l: 'вовремя', accent: true },
            { v: '7', l: 'дней\nстрик' },
          ].map((s, i) => (
            <div key={i} style={{
              background: s.accent ? t.primary : t.surface, color: s.accent ? t.surface : t.ink,
              borderRadius: 18, padding: '12px 10px', textAlign: 'center',
              border: s.accent ? 'none' : `1px solid ${t.line}`,
            }}>
              <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 28, lineHeight: 1, color: s.accent ? t.surface : t.primary }}>{s.v}</div>
              <div style={{ fontSize: 10, marginTop: 4, opacity: 0.78, whiteSpace: 'pre-line', lineHeight: 1.2 }}>{s.l}</div>
            </div>
          ))}
        </div>
      </div>

      {/* filters */}
      <div style={{ display: 'flex', gap: 8, padding: '14px 22px 8px', overflowX: 'auto' }}>
        {filters.map((f, i) => (
          <div key={i} style={{
            padding: '8px 14px', borderRadius: 999, whiteSpace: 'nowrap',
            background: f.active ? t.ink : t.chipBg, color: f.active ? t.surface : t.ink,
            fontSize: 13, fontWeight: 600, display: 'flex', alignItems: 'center', gap: 6,
          }}>
            {f.l}<span style={{ fontSize: 11, opacity: 0.6 }}>{f.n}</span>
          </div>
        ))}
      </div>

      {/* TIMELINE */}
      <div style={{ padding: '8px 22px 40px' }}>
        {groups.map((g, gi) => (
          <div key={gi}>
            <div style={{ fontSize: 12, color: t.inkSoft, fontWeight: 700, letterSpacing: '0.04em', textTransform: 'uppercase', margin: '16px 0 6px' }}>{g.month}</div>
            <div style={{ position: 'relative' }}>
              {/* vertical line */}
              <div style={{ position: 'absolute', left: 19, top: 14, bottom: 14, width: 2, background: t.line }} />
              {g.items.map((it, i) => (
                <div key={i} style={{ display: 'flex', gap: 16, padding: '10px 0', position: 'relative' }}>
                  <div style={{
                    width: 40, height: 40, borderRadius: 20, background: t.surface,
                    border: `2px solid ${it.tint}`, display: 'grid', placeItems: 'center',
                    flexShrink: 0, zIndex: 1,
                  }}>
                    <window.Icon name={it.icon} size={18} color={it.tint} stroke={1.8} />
                  </div>
                  <div style={{
                    flex: 1, background: t.surface, borderRadius: 18, padding: '12px 14px',
                    border: `1px solid ${t.line}`,
                  }}>
                    <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', gap: 8 }}>
                      <span style={{ fontSize: 14, fontWeight: 700 }}>{it.label}</span>
                      <span style={{ fontSize: 11, color: t.inkSoft, flexShrink: 0 }}>{it.dow} {it.day} · {it.time}</span>
                    </div>
                    {it.note && <div style={{ fontSize: 12, color: t.inkSoft, marginTop: 4, lineHeight: 1.4 }}>{it.note}</div>}
                    <div style={{ marginTop: 8, display: 'flex', alignItems: 'center', gap: 5 }}>
                      <span style={{ width: 6, height: 6, borderRadius: 3, background: it.onTime ? t.primary : t.terracotta }} />
                      <span style={{ fontSize: 10, fontWeight: 700, color: it.onTime ? t.primary : t.terracotta, letterSpacing: '0.04em' }}>
                        {it.onTime ? 'ВОВРЕМЯ' : 'С ОПОЗДАНИЕМ'}
                      </span>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        ))}

        {/* beginning marker */}
        <div style={{ display: 'flex', gap: 16, alignItems: 'center', marginTop: 8 }}>
          <div style={{ width: 40, display: 'grid', placeItems: 'center' }}>
            <div style={{ width: 10, height: 10, borderRadius: 5, background: t.primary }} />
          </div>
          <div style={{ fontSize: 12, color: t.inkSoft, fontStyle: 'italic', fontFamily: '"Instrument Serif", serif', fontSize: 15 }}>
            Моника появилась у тебя · 14 января 2025
          </div>
        </div>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 22 · РЕДАКТИРОВАНИЕ РАСПИСАНИЯ (PUT /plants/{id}/schedules/{type})
//      вход: Карточка растения 02 → «Расписание ухода · Изменить»
// ─────────────────────────────────────────────────────────────
function EditScheduleScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];

  const items = [
    { id: 'water', label: 'Полив', icon: 'drop', tint: t.primary, on: true, every: 7, amount: 200, next: 'завтра' },
    { id: 'spray', label: 'Опрыскивание', icon: 'spray', tint: t.terracotta, on: true, every: 3, next: 'сегодня' },
    { id: 'fert', label: 'Подкормка', icon: 'fert', tint: t.leafDark, on: true, every: 30, next: 'через 12 дн.' },
    { id: 'soil', label: 'Проверка грунта', icon: 'thermo', tint: t.leaf, on: false, every: 14, next: '—' },
  ];

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'auto', position: 'relative' }}>
      <div style={{ padding: '16px 22px 8px', position: 'sticky', top: 0, background: t.bg, zIndex: 5 }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <button style={pcIconBtn(t)}><window.Icon name="arrow-left" size={20} color={t.ink} /></button>
          <div style={{ fontSize: 12, fontWeight: 600, letterSpacing: '0.06em', color: t.inkSoft, textTransform: 'uppercase' }}>Расписание · Моника</div>
          <button style={{
            ...pcIconBtn(t), width: 'auto', padding: '0 16px', background: t.ink, color: t.surface, border: 'none',
            fontSize: 13, fontWeight: 600, fontFamily: 'inherit',
          }}>Готово</button>
        </div>
      </div>

      <div style={{ padding: '8px 22px 0' }}>
        <h1 style={{ fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 32, lineHeight: 1.05, margin: '6px 0 4px', letterSpacing: '-0.01em' }}>
          Как часто <em style={{ color: t.primary, fontStyle: 'italic' }}>заботиться</em>?
        </h1>
        <div style={{ fontSize: 13, color: t.inkSoft }}>Интервалы влияют на напоминания и стрик</div>
      </div>

      <div style={{ padding: '16px 16px 0', display: 'flex', flexDirection: 'column', gap: 12 }}>
        {items.map(c => (
          <div key={c.id} style={{
            background: t.surface, borderRadius: 22, padding: 16,
            border: `1px solid ${c.on ? t.line : t.line}`, opacity: c.on ? 1 : 0.7,
          }}>
            {/* head row */}
            <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
              <div style={{ width: 40, height: 40, borderRadius: 13, background: t.surfaceWarm, display: 'grid', placeItems: 'center', flexShrink: 0 }}>
                <window.Icon name={c.icon} size={19} color={c.tint} stroke={1.8} />
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 15, fontWeight: 700 }}>{c.label}</div>
                <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 1 }}>
                  {c.on ? <>Следующий уход · <b style={{ color: c.next === 'сегодня' ? t.terracotta : t.ink, fontWeight: 700 }}>{c.next}</b></> : 'Выключено'}
                </div>
              </div>
              <PcToggle t={t} on={c.on} />
            </div>

            {/* controls */}
            <div style={{ marginTop: 14, paddingTop: 14, borderTop: `1px solid ${t.line}`, display: 'flex', flexDirection: 'column', gap: 12 }}>
              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 10 }}>
                <div style={{ fontSize: 13, color: t.ink, fontWeight: 600 }}>Каждые</div>
                <PcStepper t={t} value={c.every} unit="дн." dim={!c.on} />
              </div>
              {c.amount && (
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 10 }}>
                  <div style={{ fontSize: 13, color: t.ink, fontWeight: 600 }}>Объём воды</div>
                  <PcStepper t={t} value={c.amount} unit="мл" dim={!c.on} />
                </div>
              )}
            </div>
          </div>
        ))}
      </div>

      {/* reset to species defaults */}
      <div style={{ padding: '18px 16px 0' }}>
        <div style={{
          background: t.primarySoft, borderRadius: 18, padding: '14px 16px',
          display: 'flex', alignItems: 'center', gap: 12,
        }}>
          <div style={{ width: 36, height: 36, borderRadius: 12, background: 'rgba(255,255,255,0.5)', display: 'grid', placeItems: 'center', flexShrink: 0 }}>
            <window.Icon name="leaf" size={18} color={t.primary} stroke={1.8} />
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 13, fontWeight: 700, color: t.primary }}>Сбросить к рекомендованным</div>
            <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 1 }}>Интервалы для монстеры из каталога</div>
          </div>
          <window.Icon name="arrow-left" size={16} color={t.primary} stroke={2} style={{ transform: 'scaleX(-1)' }} />
        </div>
      </div>

      {/* note */}
      <div style={{
        margin: '14px 16px 40px', padding: '12px 14px', borderRadius: 14,
        border: `1px dashed ${t.line}`, fontSize: 12, color: t.inkSoft, lineHeight: 1.5,
        display: 'flex', gap: 10, alignItems: 'flex-start',
      }}>
        <span style={{ fontSize: 16, flexShrink: 0 }}>🌱</span>
        <span style={{ fontFamily: '"Instrument Serif", serif', fontSize: 15, fontStyle: 'italic', color: t.ink }}>
          «Летом я пью чаще — можешь поставить полив раз в 5 дней, а зимой вернуть на 9.»
        </span>
      </div>
    </div>
  );
}

Object.assign(window, {
  SpeciesDetailScreen, CareHistoryScreen, EditScheduleScreen,
  pcIconBtn, PcSectionLabel, PcToggle, PcStepper,
});
