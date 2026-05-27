// PlantCate — batch 4 — продвинутые экраны под фичи roadmap

// ─────────────────────────────────────────────────────────────
// 11 · ГРАФИК — Календарь ухода на неделю (#52)
// ─────────────────────────────────────────────────────────────
function WeekCalendarScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];
  const days = [
    { d: 'Пн', n: 11, count: 2, done: 2, tasks: [{ p: 'Колючка', a: 'water', tint: t.primary }, { p: 'Перси', a: 'spray', tint: t.terracotta }], past: true },
    { d: 'Вт', n: 12, count: 3, done: 3, tasks: [{ p: 'Моника', a: 'water', tint: t.primary }, { p: 'Сьюзи', a: 'water', tint: t.primary }, { p: 'Фернандо', a: 'spray', tint: t.terracotta }], past: true },
    { d: 'Ср', n: 13, count: 5, done: 1, today: true,
      tasks: [
        { p: 'Моника', a: 'spray', tint: t.terracotta, time: '9:00' },
        { p: 'Фернандо', a: 'spray', tint: t.terracotta, time: '9:00', overdue: true },
        { p: 'Сьюзи', a: 'water', tint: t.primary, time: '19:00' },
        { p: 'Перси', a: 'fert', tint: t.leafDark, time: '19:00' },
        { p: 'Колючка', a: 'water', tint: t.primary, done: true },
      ] },
    { d: 'Чт', n: 14, count: 1, done: 0, tasks: [{ p: 'Моника', a: 'water', tint: t.primary }] },
    { d: 'Пт', n: 15, count: 4, done: 0, tasks: [{ p: 'Перси', a: 'fert', tint: t.leafDark }, { p: 'Фернандо', a: 'spray', tint: t.terracotta }, { p: 'Сьюзи', a: 'spray', tint: t.terracotta }, { p: 'Моника', a: 'check', tint: t.leaf }] },
    { d: 'Сб', n: 16, count: 2, done: 0, tasks: [{ p: 'Колючка', a: 'check', tint: t.leaf }, { p: 'Сьюзи', a: 'water', tint: t.primary }], free: true },
    { d: 'Вс', n: 17, count: 0, done: 0, tasks: [], free: true },
  ];

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'auto', position: 'relative' }}>
      <div style={{ padding: '20px 22px 8px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 14 }}>
          <button style={iconBtnV4(t)}><window.Icon name="arrow-left" size={20} color={t.ink} /></button>
          <div style={{ textAlign: 'center' }}>
            <div style={{ fontSize: 11, color: t.inkSoft, fontWeight: 600, letterSpacing: '0.06em', textTransform: 'uppercase' }}>Май 2026</div>
            <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 20 }}>11 – 17 мая</div>
          </div>
          <button style={iconBtnV4(t)}><window.Icon name="calendar" size={18} color={t.ink} /></button>
        </div>

        <h1 style={{ fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 32, lineHeight: 1.05, margin: '6px 0 4px', letterSpacing: '-0.01em' }}>
          На этой неделе <em style={{ color: t.primary, fontStyle: 'italic' }}>17</em><br />забот в саду
        </h1>
        <div style={{ fontSize: 13, color: t.inkSoft }}>Сб и Вс — свободные. Можно уехать за город 🌳</div>
      </div>

      <div style={{ padding: '14px 16px 0' }}>
        {days.map((day, i) => (
          <div key={i} style={{
            background: day.today ? t.surface : 'transparent',
            borderRadius: day.today ? 24 : 0,
            border: day.today ? `2px solid ${t.primary}` : 'none',
            padding: day.today ? 14 : '12px 6px',
            marginBottom: day.today ? 12 : 0,
            borderBottom: !day.today && i < days.length - 1 ? `1px solid ${t.line}` : 'none',
            opacity: day.past ? 0.55 : 1,
          }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 14, marginBottom: day.tasks.length > 0 ? 10 : 0 }}>
              <div style={{ width: 44, textAlign: 'center', flexShrink: 0 }}>
                <div style={{ fontSize: 10, color: day.today ? t.primary : t.inkSoft, fontWeight: 700, letterSpacing: '0.06em', textTransform: 'uppercase' }}>{day.d}</div>
                <div style={{
                  fontFamily: '"Instrument Serif", serif', fontSize: day.today ? 30 : 24, lineHeight: 1,
                  color: day.today ? t.primary : t.ink, marginTop: 2,
                }}>{day.n}</div>
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                {day.free ? (
                  <div style={{ fontSize: 13, color: t.inkSoft, fontStyle: 'italic', fontFamily: '"Instrument Serif", serif', fontSize: 15 }}>
                    {day.tasks.length ? `${day.count} лёгких задач` : 'Свободный день 🌿'}
                  </div>
                ) : (
                  <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                    <div style={{
                      flex: 1, height: 6, borderRadius: 3, background: t.surfaceWarm, overflow: 'hidden',
                    }}>
                      <div style={{
                        width: `${(day.done / Math.max(day.count, 1)) * 100}%`, height: '100%',
                        background: t.primary, borderRadius: 3,
                      }} />
                    </div>
                    <div style={{ fontSize: 11, color: t.inkSoft, fontWeight: 600, minWidth: 30, textAlign: 'right' }}>
                      {day.done}/{day.count}
                    </div>
                  </div>
                )}
              </div>
            </div>

            {day.today && day.tasks.length > 0 && (
              <div style={{ display: 'flex', flexDirection: 'column', gap: 6, paddingTop: 4 }}>
                {day.tasks.map((task, j) => (
                  <div key={j} style={{
                    display: 'flex', alignItems: 'center', gap: 10,
                    padding: '8px 10px', borderRadius: 14,
                    background: task.done ? t.surfaceWarm : t.bg,
                    border: task.overdue ? `1px solid ${t.terracotta}` : `1px solid ${t.line}`,
                    opacity: task.done ? 0.6 : 1,
                  }}>
                    <div style={{
                      width: 28, height: 28, borderRadius: 14, background: task.tint,
                      display: 'grid', placeItems: 'center', flexShrink: 0,
                    }}>
                      <window.Icon name={task.a === 'check' ? 'thermo' : task.a} size={14} color="#fff" stroke={2} />
                    </div>
                    <div style={{ flex: 1 }}>
                      <div style={{ fontSize: 13, fontWeight: 600, textDecoration: task.done ? 'line-through' : 'none' }}>{task.p}</div>
                      {task.time && !task.done && (
                        <div style={{ fontSize: 11, color: task.overdue ? t.terracotta : t.inkSoft, fontWeight: 600 }}>
                          {task.overdue ? 'Просрочено · вчера' : task.time}
                        </div>
                      )}
                      {task.done && <div style={{ fontSize: 11, color: t.inkSoft }}>Готово · 7:42</div>}
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        ))}

        {/* ICS export hint */}
        <div style={{
          marginTop: 18, marginBottom: 110, padding: '14px 16px', borderRadius: 18,
          background: t.surface, border: `1px solid ${t.line}`,
          display: 'flex', alignItems: 'center', gap: 12,
        }}>
          <div style={{ width: 36, height: 36, borderRadius: 12, background: t.primarySoft, display: 'grid', placeItems: 'center' }}>
            <window.Icon name="calendar" size={18} color={t.primary} stroke={1.8} />
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 13, fontWeight: 700 }}>Подписаться в календаре</div>
            <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 1 }}>Google / Apple Calendar — .ics</div>
          </div>
          <window.Icon name="arrow-left" size={16} color={t.inkSoft} stroke={2} style={{ transform: 'scaleX(-1)' }} />
        </div>
      </div>

      <window.MiniBottomNav t={t} active="cal" />
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 12 · КАТАЛОГ — Справочник видов (#8, #128 токсичность)
// ─────────────────────────────────────────────────────────────
function CatalogScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];
  const list = [
    { id: 'monstera', ru: 'Монстера', latin: 'Monstera deliciosa', diff: 'Лёгкая', diffOk: true, light: 'Рассеянный', toxic: true, art: 'monstera', popular: true },
    { id: 'pothos', ru: 'Эпипремнум', latin: 'Epipremnum aureum', diff: 'Лёгкая', diffOk: true, light: 'Рассеянный', toxic: true, art: 'pothos' },
    { id: 'succulent', ru: 'Эчеверия', latin: 'Echeveria', diff: 'Очень лёгкая', diffOk: true, light: 'Прямое', toxic: false, art: 'succulent' },
    { id: 'fern', ru: 'Папоротник', latin: 'Nephrolepis', diff: 'Средне', diffOk: false, light: 'Полутень', toxic: false, art: 'fern' },
    { id: 'cactus', ru: 'Кактус', latin: 'Cactaceae', diff: 'Очень лёгкая', diffOk: true, light: 'Прямое', toxic: false, art: 'cactus' },
  ];
  const PLANT_ART = { monstera: window.Monstera, fern: window.Fern, succulent: window.Succulent, pothos: window.Pothos, cactus: window.Cactus };

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'auto', position: 'relative' }}>
      <div style={{ padding: '20px 22px 8px' }}>
        <h1 style={{ fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 38, lineHeight: 1.04, margin: '0 0 4px', letterSpacing: '-0.01em' }}>
          Каталог <em style={{ color: t.primary, fontStyle: 'italic' }}>растений</em>
        </h1>
        <div style={{ fontSize: 13, color: t.inkSoft }}>30 видов с готовыми расписаниями и заметками о токсичности</div>
      </div>

      <div style={{ padding: '14px 22px 0' }}>
        <div style={{
          display: 'flex', alignItems: 'center', gap: 10,
          background: t.surface, borderRadius: 18, padding: '12px 14px',
          border: `1px solid ${t.line}`,
        }}>
          <window.Icon name="search" size={18} color={t.inkSoft} stroke={1.8} />
          <input type="text" placeholder="Найти вид…" style={{
            flex: 1, border: 'none', outline: 'none', background: 'transparent',
            fontFamily: 'inherit', fontSize: 14, color: t.ink,
          }} />
        </div>
      </div>

      <div style={{ display: 'flex', gap: 8, padding: '12px 22px 12px', overflowX: 'auto' }}>
        {[
          { l: 'Все', n: 30, active: true },
          { l: 'Для новичка', n: 12 },
          { l: 'Безопасно для котов', n: 8, icon: '🐈' },
          { l: 'Цветущие', n: 6 },
        ].map((c, i) => (
          <div key={i} style={{
            padding: '8px 14px', borderRadius: 999, whiteSpace: 'nowrap',
            background: c.active ? t.ink : t.chipBg, color: c.active ? t.surface : t.ink,
            fontSize: 13, fontWeight: 600, display: 'flex', alignItems: 'center', gap: 6,
          }}>
            {c.icon}{c.l}
            <span style={{ fontSize: 11, opacity: 0.6 }}>{c.n}</span>
          </div>
        ))}
      </div>

      <div style={{ padding: '0 16px 110px', display: 'flex', flexDirection: 'column', gap: 10 }}>
        {list.map(s => {
          const Art = PLANT_ART[s.art];
          return (
            <div key={s.id} style={{
              background: t.surface, borderRadius: 22, padding: 14,
              border: `1px solid ${t.line}`,
              display: 'flex', alignItems: 'center', gap: 14,
            }}>
              <div style={{
                width: 72, height: 72, borderRadius: 18, background: t.surfaceWarm,
                display: 'grid', placeItems: 'center', flexShrink: 0,
              }}>
                <Art t={t} size={62} />
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 6, flexWrap: 'wrap' }}>
                  <span style={{ fontFamily: '"Instrument Serif", serif', fontSize: 22, lineHeight: 1, letterSpacing: '-0.01em' }}>{s.ru}</span>
                  {s.popular && (
                    <span style={{
                      fontSize: 9, fontWeight: 700, color: t.terracotta,
                      background: theme === 'dark' ? 'rgba(216,145,114,0.15)' : '#F9E3D8',
                      padding: '2px 5px', borderRadius: 4,
                    }}>HIT</span>
                  )}
                </div>
                <div style={{ fontSize: 11, color: t.inkSoft, fontStyle: 'italic', marginTop: 2 }}>{s.latin}</div>
                <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 6, flexWrap: 'wrap' }}>
                  <span style={{ display: 'flex', alignItems: 'center', gap: 4, fontSize: 11, color: t.inkSoft, fontWeight: 600 }}>
                    <span style={{ width: 6, height: 6, borderRadius: 3, background: s.diffOk ? t.primary : t.terracotta }} />
                    {s.diff}
                  </span>
                  <span style={{ fontSize: 11, color: t.inkSoft, fontWeight: 600 }}>· {s.light}</span>
                  {s.toxic && (
                    <span style={{
                      display: 'inline-flex', alignItems: 'center', gap: 3,
                      padding: '2px 6px', borderRadius: 6,
                      background: theme === 'dark' ? 'rgba(216,145,114,0.18)' : '#FBEFE4',
                      color: t.terracotta, fontSize: 10, fontWeight: 700, letterSpacing: '0.04em',
                    }}>
                      ⚠ ТОКСИЧНО · 🐈
                    </span>
                  )}
                </div>
              </div>
              <div style={{ fontSize: 18, color: t.inkMute, flexShrink: 0 }}>›</div>
            </div>
          );
        })}
      </div>

      <window.MiniBottomNav t={t} active="lib" />
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 13 · ПРОФИЛЬ / НАСТРОЙКИ — Я (#116 тихие часы, #53 отпуск, #77 шеринг)
// ─────────────────────────────────────────────────────────────
function ProfileScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'auto', position: 'relative' }}>
      {/* HERO */}
      <div style={{ padding: '24px 22px 20px', background: t.primarySoft, position: 'relative', overflow: 'hidden' }}>
        <svg width="180" height="160" viewBox="0 0 180 160" style={{ position: 'absolute', right: -20, top: -10, opacity: 0.20 }}>
          <path d="M 160 10 C 100 10 50 50 50 130 C 90 130 140 80 160 10 Z" fill={t.leafDark} />
        </svg>
        <div style={{ display: 'flex', alignItems: 'center', gap: 14, position: 'relative' }}>
          <div style={{
            width: 64, height: 64, borderRadius: 32, background: t.surface,
            display: 'grid', placeItems: 'center',
            fontFamily: '"Instrument Serif", serif', fontSize: 28, color: t.primary,
            border: `3px solid ${t.bg}`,
          }}>А</div>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 28, lineHeight: 1.1 }}>Алина</div>
            <div style={{ fontSize: 12, color: t.inkSoft, marginTop: 2 }}>@alina · Telegram · с января 2024</div>
          </div>
        </div>

        {/* STATS */}
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 8, marginTop: 16, position: 'relative' }}>
          {[
            { v: '47', l: 'дней\nподряд', accent: true },
            { v: '12', l: 'растений' },
            { v: '189', l: 'забот\nза месяц' },
          ].map((s, i) => (
            <div key={i} style={{
              background: s.accent ? t.ink : t.surface,
              color: s.accent ? t.surface : t.ink,
              borderRadius: 18, padding: '12px 10px', textAlign: 'center',
            }}>
              <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 30, lineHeight: 1, color: s.accent ? t.primarySoft : t.primary }}>
                {s.v}
              </div>
              <div style={{ fontSize: 10, marginTop: 4, opacity: 0.8, whiteSpace: 'pre-line', lineHeight: 1.2 }}>{s.l}</div>
            </div>
          ))}
        </div>
      </div>

      {/* QUIET HOURS */}
      <div style={{ padding: '20px 16px 0' }}>
        <SectionLabel t={t}>Уведомления и время</SectionLabel>
        <div style={{ background: t.surface, borderRadius: 22, border: `1px solid ${t.line}`, overflow: 'hidden' }}>
          <SettingsRow t={t} title="Тихие часы" value="22:00 – 8:00" />
          <SettingsRow t={t} title="Таймзона" value="Europe/Moscow · GMT+3" divider />
          <SettingsRow t={t} title="Утренний дайджест" value="9:00" divider />
          <div style={{ borderTop: `1px solid ${t.line}`, padding: '14px 16px', display: 'flex', alignItems: 'center', gap: 12 }}>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 14, fontWeight: 600 }}>Push‑уведомления</div>
              <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 1 }}>За каждое растение голосом</div>
            </div>
            <Toggle t={t} on />
          </div>
        </div>
      </div>

      {/* VACATION */}
      <div style={{ padding: '20px 16px 0' }}>
        <SectionLabel t={t}>Отпуск</SectionLabel>
        <div style={{
          background: t.surface, borderRadius: 22, padding: 16, border: `1px solid ${t.line}`,
          display: 'flex', alignItems: 'flex-start', gap: 14,
        }}>
          <div style={{ width: 44, height: 44, borderRadius: 14, background: t.primarySoft, display: 'grid', placeItems: 'center', flexShrink: 0 }}>
            🏖
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 18, lineHeight: 1.2 }}>Уезжаешь?</div>
            <div style={{ fontSize: 12, color: t.inkSoft, marginTop: 2 }}>Поставим напоминания на паузу или передадим уход другому.</div>
            <div style={{ display: 'flex', gap: 8, marginTop: 12 }}>
              <button style={{
                padding: '8px 12px', borderRadius: 12,
                background: t.ink, color: t.surface, border: 'none',
                fontSize: 12, fontWeight: 600, fontFamily: 'inherit',
              }}>Включить режим</button>
              <button style={{
                padding: '8px 12px', borderRadius: 12,
                background: t.surfaceWarm, color: t.ink, border: 'none',
                fontSize: 12, fontWeight: 600, fontFamily: 'inherit',
              }}>Передать уход →</button>
            </div>
          </div>
        </div>
      </div>

      {/* SHARING */}
      <div style={{ padding: '20px 16px 0' }}>
        <SectionLabel t={t}>Совместный уход</SectionLabel>
        <div style={{ background: t.surface, borderRadius: 22, border: `1px solid ${t.line}`, padding: '12px 16px' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            <div style={{ width: 40, height: 40, borderRadius: 20, background: '#E4B673', display: 'grid', placeItems: 'center', fontFamily: '"Instrument Serif", serif', color: '#fff', fontSize: 18, flexShrink: 0 }}>М</div>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 14, fontWeight: 600 }}>Миша</div>
              <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 1 }}>Помогает с 3 растениями · приглашён</div>
            </div>
            <div style={{
              fontSize: 11, color: t.terracotta, fontWeight: 700, letterSpacing: '0.04em',
              padding: '2px 8px', borderRadius: 6,
              background: theme === 'dark' ? 'rgba(216,145,114,0.15)' : '#FBEFE4',
            }}>ОЖИДАЕТ</div>
          </div>
          <div style={{
            marginTop: 10, paddingTop: 10, borderTop: `1px dashed ${t.line}`,
            display: 'flex', alignItems: 'center', gap: 10, color: t.primary,
            fontSize: 13, fontWeight: 600,
          }}>
            <window.Icon name="plus" size={16} color={t.primary} stroke={2} />
            Пригласить ещё кого‑то
          </div>
        </div>
      </div>

      {/* MORE */}
      <div style={{ padding: '20px 16px 110px' }}>
        <SectionLabel t={t}>Ещё</SectionLabel>
        <div style={{ background: t.surface, borderRadius: 22, border: `1px solid ${t.line}`, overflow: 'hidden' }}>
          <SettingsRow t={t} title="Сезонные интервалы" value="Авто (лето)" link />
          <SettingsRow t={t} title="Дома и места" value="1 дом · 6 комнат" link divider />
          <SettingsRow t={t} title="Архив растений" value="3 в памяти" link divider />
          <SettingsRow t={t} title="Список покупок" value="2 позиции" link divider />
          <SettingsRow t={t} title="Язык / Language" value="Русский" link divider />
          <SettingsRow t={t} title="Тема оформления" value={theme === 'dark' ? 'Тёмная' : 'Авто'} link divider />
          <SettingsRow t={t} title="Выйти" value="" link divider danger />
        </div>
      </div>

      <window.MiniBottomNav t={t} active="me" />
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 14 · МЕСЯЧНЫЙ ОТЧЁТ (#137)
// ─────────────────────────────────────────────────────────────
function MonthlyReportScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'auto', position: 'relative' }}>
      <div style={{ padding: '16px 22px 8px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <button style={iconBtnV4(t)}><window.Icon name="arrow-left" size={20} color={t.ink} /></button>
          <button style={{ ...iconBtnV4(t), background: t.ink, color: t.surface, border: 'none', padding: '0 14px', width: 'auto', fontSize: 12, fontWeight: 600, fontFamily: 'inherit', display: 'flex', alignItems: 'center', gap: 6 }}>
            Поделиться
          </button>
        </div>
      </div>

      {/* HERO */}
      <div style={{ padding: '14px 22px 12px', position: 'relative' }}>
        <div style={{ fontSize: 12, color: t.inkSoft, fontWeight: 600, letterSpacing: '0.06em', textTransform: 'uppercase' }}>
          Отчёт · май 2026
        </div>
        <h1 style={{ fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 48, lineHeight: 1.0, margin: '6px 0 4px', letterSpacing: '-0.02em' }}>
          Май был <em style={{ color: t.primary, fontStyle: 'italic' }}>зелёным</em>
        </h1>
        <div style={{ fontSize: 14, color: t.inkSoft, lineHeight: 1.4 }}>
          Ты вырастил(а) <b style={{ color: t.ink, fontWeight: 700 }}>47‑дневный стрик</b> и не забыл(а) Монику ни разу. Так держать.
        </div>
      </div>

      {/* BIG NUMBERS */}
      <div style={{ padding: '12px 16px 0', display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
        {[
          { v: '47', l: 'дней\nподряд', tint: t.primary, sub: '+12 к рекорду' },
          { v: '189', l: 'забот\nвыполнено', tint: t.terracotta },
          { v: '94%', l: 'вовремя', tint: t.leafDark, sub: '+8% к апрелю' },
          { v: '0', l: 'пропусков\nза май', tint: t.primary, accent: true },
        ].map((s, i) => (
          <div key={i} style={{
            background: s.accent ? t.primary : t.surface,
            color: s.accent ? t.surface : t.ink,
            borderRadius: 22, padding: 16,
            border: s.accent ? 'none' : `1px solid ${t.line}`,
            position: 'relative', overflow: 'hidden',
          }}>
            <div style={{ fontSize: 11, fontWeight: 700, letterSpacing: '0.04em', textTransform: 'uppercase', opacity: 0.65 }}>
              {s.sub || '·'}
            </div>
            <div style={{
              fontFamily: '"Instrument Serif", serif', fontSize: 52, lineHeight: 1,
              marginTop: 8, color: s.accent ? t.surface : s.tint,
              letterSpacing: '-0.02em',
            }}>{s.v}</div>
            <div style={{ fontSize: 12, marginTop: 4, opacity: 0.75, whiteSpace: 'pre-line', lineHeight: 1.3 }}>{s.l}</div>
          </div>
        ))}
      </div>

      {/* TOP MOMENTS */}
      <div style={{ padding: '20px 22px 0' }}>
        <SectionLabel t={t}>Звёзды месяца</SectionLabel>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
          {[
            { name: 'Моника', species: 'Монстера', art: 'monstera', stat: '8 поливов · 4 опрыска', medal: '🥇', bg: '#F7E5C8' },
            { name: 'Сьюзи', species: 'Суккулент', art: 'succulent', stat: 'Распустила цветок 🌸', medal: '🥈', bg: t.primarySoft },
            { name: 'Колючка', species: 'Кактус', art: 'cactus', stat: '47 дней без пропусков', medal: '🥉', bg: t.surfaceWarm },
          ].map((p, i) => {
            const Art = { monstera: window.Monstera, succulent: window.Succulent, cactus: window.Cactus }[p.art];
            return (
              <div key={i} style={{
                background: t.surface, borderRadius: 18, padding: 12,
                border: `1px solid ${t.line}`,
                display: 'flex', alignItems: 'center', gap: 12,
              }}>
                <div style={{ width: 52, height: 52, borderRadius: 14, background: p.bg, display: 'grid', placeItems: 'center', flexShrink: 0 }}>
                  <Art t={t} size={46} />
                </div>
                <div style={{ flex: 1 }}>
                  <div style={{ fontSize: 14, fontWeight: 700 }}>{p.name}</div>
                  <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 1 }}>{p.species} · {p.stat}</div>
                </div>
                <div style={{ fontSize: 26 }}>{p.medal}</div>
              </div>
            );
          })}
        </div>
      </div>

      {/* QUIET TIME */}
      <div style={{ padding: '20px 16px 0' }}>
        <div style={{
          background: t.primarySoft, borderRadius: 24, padding: '20px 22px',
          position: 'relative', overflow: 'hidden',
        }}>
          <svg width="120" height="120" viewBox="0 0 120 120" style={{ position: 'absolute', right: -20, bottom: -20, opacity: 0.25 }}>
            <path d="M 100 20 C 60 20 30 50 30 90 C 50 90 80 60 100 20 Z" fill={t.leafDark} />
          </svg>
          <div style={{ fontSize: 11, color: t.primary, fontWeight: 700, letterSpacing: '0.06em', textTransform: 'uppercase' }}>
            Личный рекорд
          </div>
          <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 28, lineHeight: 1.2, margin: '6px 0 6px', position: 'relative' }}>
            Самое спокойное растение — <em style={{ color: t.primary, fontStyle: 'italic' }}>Колючка</em>
          </div>
          <div style={{ fontSize: 13, color: t.inkSoft, position: 'relative' }}>
            Полито 2 раза за месяц. Идеальный сосед.
          </div>
        </div>
      </div>

      <div style={{ height: 30 }} />

      {/* SHARE CTA */}
      <div style={{ padding: '0 16px 30px' }}>
        <button style={{
          width: '100%', padding: '14px', borderRadius: 18,
          background: t.ink, color: t.surface, border: 'none',
          fontSize: 14, fontWeight: 600, fontFamily: 'inherit',
        }}>
          📤 Поделиться отчётом
        </button>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 15 · ПРОБЛЕМНОЕ РАСТЕНИЕ · детальная диагностика (#73)
// ─────────────────────────────────────────────────────────────
function PlantDiagnosisScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'auto', position: 'relative' }}>
      {/* HERO */}
      <div style={{
        background: theme === 'dark' ? '#3a2419' : '#FBEFE4',
        padding: '16px 22px 24px', position: 'relative', overflow: 'hidden',
      }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 12 }}>
          <button style={iconBtnV4(t, true)}><window.Icon name="arrow-left" size={20} color={t.ink} /></button>
          <button style={iconBtnV4(t, true)}><window.Icon name="more" size={20} color={t.ink} /></button>
        </div>

        <div style={{ display: 'flex', gap: 14, alignItems: 'center' }}>
          <div style={{
            width: 88, height: 88, borderRadius: 26,
            background: theme === 'dark' ? 'rgba(255,255,255,0.05)' : '#fff',
            display: 'grid', placeItems: 'center', flexShrink: 0,
            border: `2px solid ${t.terracotta}`,
          }}>
            <window.Fern t={t} size={76} />
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 11, color: t.terracotta, fontWeight: 700, letterSpacing: '0.06em', textTransform: 'uppercase' }}>
              ⚠ Что‑то не так
            </div>
            <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 28, lineHeight: 1.1, marginTop: 4 }}>
              Фернандо <em style={{ color: t.terracotta, fontStyle: 'italic' }}>грустит</em>
            </div>
            <div style={{ fontSize: 13, color: t.inkSoft, marginTop: 2 }}>Папоротник · Гостиная</div>
          </div>
        </div>
      </div>

      {/* DIAGNOSIS */}
      <div style={{ padding: '18px 16px 0' }}>
        <div style={{
          background: t.surface, borderRadius: 22, padding: 18,
          border: `1px solid ${t.line}`,
        }}>
          <div style={{
            fontSize: 11, color: t.inkSoft, fontWeight: 700,
            letterSpacing: '0.06em', textTransform: 'uppercase',
          }}>Анализ · последние 30 дней</div>

          <div style={{ display: 'flex', gap: 20, marginTop: 10, alignItems: 'flex-end' }}>
            {[
              { d: 'Назначено', v: 10, total: 10, color: t.line, label: '10 раз' },
              { d: 'Сделано', v: 6, total: 10, color: t.terracotta, label: '6 раз', accent: true },
            ].map((g, i) => (
              <div key={i} style={{ flex: 1 }}>
                <div style={{ fontSize: 11, color: t.inkSoft, fontWeight: 600 }}>{g.d}</div>
                <div style={{
                  fontFamily: '"Instrument Serif", serif', fontSize: 32, lineHeight: 1,
                  color: g.accent ? t.terracotta : t.ink, marginTop: 4,
                }}>{g.v}<span style={{ fontSize: 18, opacity: 0.5 }}>/{g.total}</span></div>
              </div>
            ))}
          </div>

          <div style={{
            marginTop: 14, padding: '14px 14px', borderRadius: 16,
            background: theme === 'dark' ? 'rgba(216,145,114,0.10)' : '#FBEFE4',
            display: 'flex', gap: 12, alignItems: 'flex-start',
          }}>
            <div style={{ width: 28, height: 28, borderRadius: 14, background: t.terracotta, display: 'grid', placeItems: 'center', flexShrink: 0, color: '#fff', fontFamily: '"Instrument Serif", serif', fontSize: 16 }}>
              !
            </div>
            <div style={{ flex: 1, fontSize: 13, color: t.ink, lineHeight: 1.4 }}>
              <b style={{ fontWeight: 700 }}>40% пропусков опрыскивания.</b><br />
              Похоже, расписание не подходит твоему ритму. Папоротникам нужно влажно, попробуй реже, но регулярно.
            </div>
          </div>
        </div>
      </div>

      {/* SUGGESTION */}
      <div style={{ padding: '14px 16px 0' }}>
        <div style={{
          background: t.primarySoft, borderRadius: 22, padding: 18,
          position: 'relative', overflow: 'hidden',
        }}>
          <svg width="120" height="100" viewBox="0 0 120 100" style={{ position: 'absolute', right: -10, top: -10, opacity: 0.2 }}>
            <path d="M 100 10 C 60 10 30 40 30 80 C 50 80 80 50 100 10 Z" fill={t.leafDark} />
          </svg>
          <div style={{ fontSize: 11, color: t.primary, fontWeight: 700, letterSpacing: '0.06em', textTransform: 'uppercase', position: 'relative' }}>
            Моё предложение
          </div>
          <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 22, lineHeight: 1.2, marginTop: 6, position: 'relative' }}>
            Опрыскивать раз в <em style={{ color: t.primary, fontStyle: 'italic' }}>4 дня</em><br />вместо каждых 3
          </div>

          <div style={{
            marginTop: 14, padding: '10px 14px', borderRadius: 14,
            background: 'rgba(255,255,255,0.5)',
            display: 'flex', alignItems: 'center', gap: 14,
            position: 'relative',
          }}>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 11, color: t.inkSoft, fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.04em' }}>Было</div>
              <div style={{ fontSize: 14, fontWeight: 700, color: t.ink, textDecoration: 'line-through', opacity: 0.5 }}>каждые 3 дня</div>
            </div>
            <div style={{ color: t.primary, fontSize: 20 }}>→</div>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 11, color: t.primary, fontWeight: 700, textTransform: 'uppercase', letterSpacing: '0.04em' }}>Станет</div>
              <div style={{ fontSize: 14, fontWeight: 700, color: t.primary }}>каждые 4 дня</div>
            </div>
          </div>

          <div style={{ display: 'flex', gap: 8, marginTop: 14, position: 'relative' }}>
            <button style={{
              flex: 1, padding: '12px', borderRadius: 14,
              background: t.ink, color: t.surface, border: 'none',
              fontSize: 13, fontWeight: 600, fontFamily: 'inherit',
            }}>
              Принять →
            </button>
            <button style={{
              padding: '12px 16px', borderRadius: 14,
              background: t.surface, color: t.ink, border: `1px solid ${t.line}`,
              fontSize: 13, fontWeight: 600, fontFamily: 'inherit',
            }}>
              Сам(а)
            </button>
          </div>
        </div>
      </div>

      {/* WHY */}
      <div style={{ padding: '14px 16px 110px' }}>
        <SectionLabel t={t}>Почему так получилось</SectionLabel>
        <div style={{ background: t.surface, borderRadius: 22, border: `1px solid ${t.line}`, padding: '4px 16px' }}>
          {[
            'Реальные интервалы между опрысками — 4.2 дня',
            'Дома сухо: 40% влажность вместо 60%',
            'Папоротник не любит сухой воздух',
          ].map((line, i) => (
            <div key={i} style={{
              padding: '12px 0', borderTop: i === 0 ? 'none' : `1px solid ${t.line}`,
              display: 'flex', alignItems: 'center', gap: 12,
            }}>
              <div style={{ width: 6, height: 6, borderRadius: 3, background: t.primary, flexShrink: 0 }} />
              <div style={{ fontSize: 13, color: t.ink, flex: 1 }}>{line}</div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 16 · AI ДОКТОР · фото-диагноз (топ-1 из бэклога)
// ─────────────────────────────────────────────────────────────
function AIDoctorScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'auto', position: 'relative' }}>
      <div style={{ padding: '16px 22px 8px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <button style={iconBtnV4(t, true)}><window.Icon name="arrow-left" size={20} color={t.ink} /></button>
          <span style={{
            fontSize: 11, fontWeight: 700, letterSpacing: '0.06em',
            padding: '4px 10px', borderRadius: 999,
            background: t.primary, color: t.surface,
          }}>AI · BETA</span>
        </div>
      </div>

      <div style={{ padding: '14px 22px 0' }}>
        <div style={{ fontSize: 12, color: t.inkSoft, fontWeight: 600, letterSpacing: '0.06em', textTransform: 'uppercase' }}>
          Доктор PlantCate
        </div>
        <h1 style={{ fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 36, lineHeight: 1.05, margin: '4px 0 6px', letterSpacing: '-0.01em' }}>
          Что <em style={{ color: t.primary, fontStyle: 'italic' }}>беспокоит</em>?
        </h1>
        <div style={{ fontSize: 14, color: t.inkSoft }}>Сфотографируй лист — определю болезнь и расскажу, что делать.</div>
      </div>

      {/* PHOTO RESULT */}
      <div style={{ padding: '18px 16px 0' }}>
        <div style={{
          background: t.surface, borderRadius: 28, padding: 14,
          border: `1px solid ${t.line}`, position: 'relative',
        }}>
          {/* mock leaf photo */}
          <div style={{
            aspectRatio: '1.4', borderRadius: 20, overflow: 'hidden',
            background: `linear-gradient(135deg, ${t.leafDark} 0%, ${t.leaf} 50%, #6c2e1c 100%)`,
            position: 'relative',
          }}>
            <svg width="100%" height="100%" viewBox="0 0 200 140" style={{ position: 'absolute', inset: 0 }}>
              <path d="M 100 10 C 40 30 30 90 50 130 C 100 130 150 110 170 60 C 180 30 150 -10 100 10 Z"
                fill={t.leaf} opacity="0.9" />
              {/* yellow patches */}
              <ellipse cx="80" cy="60" rx="14" ry="10" fill="#d9a64a" opacity="0.75" />
              <ellipse cx="120" cy="90" rx="18" ry="12" fill="#a85535" opacity="0.7" />
              <ellipse cx="60" cy="100" rx="8" ry="6" fill="#c47a3b" opacity="0.8" />
              {/* veins */}
              <path d="M 100 10 L 100 130 M 100 40 L 60 70 M 100 60 L 150 50 M 100 80 L 60 110 M 100 100 L 150 110"
                stroke={t.leafDark} strokeWidth="1.5" opacity="0.6" fill="none" />
            </svg>
            <div style={{
              position: 'absolute', top: 12, right: 12,
              padding: '4px 8px', borderRadius: 6,
              background: 'rgba(0,0,0,0.5)', color: '#fff',
              fontSize: 10, fontWeight: 600, letterSpacing: '0.04em',
            }}>ФОТО</div>
          </div>

          {/* DIAGNOSIS */}
          <div style={{ marginTop: 14, padding: '0 4px' }}>
            <div style={{ fontSize: 11, color: t.terracotta, fontWeight: 700, letterSpacing: '0.06em', textTransform: 'uppercase' }}>
              Похоже на · 87% уверенности
            </div>
            <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 26, lineHeight: 1.1, marginTop: 4 }}>
              Хлороз — нехватка железа
            </div>

            {/* alternatives */}
            <div style={{ display: 'flex', gap: 6, marginTop: 12, flexWrap: 'wrap' }}>
              {[
                { l: 'Хлороз', p: 87, active: true },
                { l: 'Солнечный ожог', p: 8 },
                { l: 'Перелив', p: 5 },
              ].map((d, i) => (
                <div key={i} style={{
                  padding: '6px 10px', borderRadius: 999,
                  background: d.active ? t.terracotta : t.surfaceWarm,
                  color: d.active ? '#fff' : t.inkSoft,
                  fontSize: 11, fontWeight: 700,
                  display: 'flex', alignItems: 'center', gap: 6,
                }}>
                  {d.l}<span style={{ opacity: 0.7 }}>{d.p}%</span>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* TREATMENT */}
      <div style={{ padding: '16px 16px 0' }}>
        <SectionLabel t={t}>Что делать</SectionLabel>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
          {[
            { n: 1, t: 'Полить с железосодержащим удобрением', sub: 'Феровит, Микро‑Fe или хелат железа' },
            { n: 2, t: 'Переставить в место с рассеянным светом', sub: 'Прямые лучи усиливают хлороз' },
            { n: 3, t: 'Проверить кислотность грунта', sub: 'Щелочная почва мешает усвоить железо' },
          ].map((s, i) => (
            <div key={i} style={{
              background: t.surface, borderRadius: 18, padding: '14px 16px',
              border: `1px solid ${t.line}`,
              display: 'flex', alignItems: 'flex-start', gap: 12,
            }}>
              <div style={{
                width: 28, height: 28, borderRadius: 14, background: t.primary,
                color: t.surface, display: 'grid', placeItems: 'center', flexShrink: 0,
                fontFamily: '"Instrument Serif", serif', fontSize: 16,
              }}>{s.n}</div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 14, fontWeight: 600 }}>{s.t}</div>
                <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 2 }}>{s.sub}</div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* DISCLAIMER */}
      <div style={{
        margin: '14px 16px 0', padding: '10px 14px', borderRadius: 14,
        background: 'transparent', border: `1px dashed ${t.line}`,
        fontSize: 11, color: t.inkSoft, lineHeight: 1.4,
      }}>
        AI‑совет, а не диагноз. Если не уверен(а) — сравни с базой болезней или спроси у садовника.
      </div>

      <div style={{ height: 100 }} />

      {/* BOTTOM CTA */}
      <div style={{
        position: 'absolute', left: 0, right: 0, bottom: 0,
        padding: '14px 16px 16px',
        background: `linear-gradient(to top, ${t.bg} 70%, ${t.bg}00)`,
        display: 'flex', gap: 10,
      }}>
        <button style={{
          padding: '14px 18px', borderRadius: 18,
          background: t.surfaceWarm, color: t.ink, border: `1px solid ${t.line}`,
          fontSize: 14, fontWeight: 600, fontFamily: 'inherit',
        }}>Ещё фото</button>
        <button style={{
          flex: 1, padding: '14px 18px', borderRadius: 18,
          background: t.ink, color: t.surface, border: 'none',
          fontSize: 14, fontWeight: 600, fontFamily: 'inherit',
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
        }}>
          Спасти Фернандо
          <window.Icon name="heart" size={16} color={t.terracotta} />
        </button>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 17 · АРХИВ — Memorial (#117)
// ─────────────────────────────────────────────────────────────
function ArchiveScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];

  const archived = [
    { name: 'Алоэ Вера', species: 'Алоэ', lived: '11 месяцев', cause: 'Перелив', date: 'апрель 2026', art: 'succulent', soft: '#9D6F4E' },
    { name: 'Босс', species: 'Бонсай', lived: '3 года 2 мес.', cause: 'Подарили родителям', date: 'март 2026', art: 'cactus', soft: '#7A8A60', gifted: true },
    { name: 'Пушистик', species: 'Папоротник', lived: '4 месяца', cause: 'Сухой воздух', date: 'январь 2026', art: 'fern', soft: '#A89878' },
  ];
  const PLANT_ART = { monstera: window.Monstera, fern: window.Fern, succulent: window.Succulent, pothos: window.Pothos, cactus: window.Cactus };

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'auto', position: 'relative' }}>
      <div style={{ padding: '16px 22px 8px' }}>
        <button style={iconBtnV4(t, true)}><window.Icon name="arrow-left" size={20} color={t.ink} /></button>
      </div>

      <div style={{ padding: '12px 22px 0' }}>
        <div style={{ fontSize: 12, color: t.inkSoft, fontWeight: 600, letterSpacing: '0.06em', textTransform: 'uppercase' }}>
          Архив · 3 растения
        </div>
        <h1 style={{ fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 42, lineHeight: 1.0, margin: '6px 0 6px', letterSpacing: '-0.02em' }}>
          В <em style={{ color: t.primary, fontStyle: 'italic' }}>памяти</em>
        </h1>
        <div style={{ fontSize: 14, color: t.inkSoft, lineHeight: 1.4 }}>
          Растения, с которыми пути разошлись. Их история — здесь, а не в корзине.
        </div>
      </div>

      <div style={{ padding: '20px 16px 0', display: 'flex', flexDirection: 'column', gap: 12 }}>
        {archived.map((p, i) => {
          const Art = PLANT_ART[p.art];
          return (
            <div key={i} style={{
              background: t.surface, borderRadius: 24, padding: 16,
              border: `1px solid ${t.line}`,
              display: 'flex', gap: 14,
            }}>
              <div style={{
                width: 80, height: 96, borderRadius: 18,
                background: t.surfaceWarm,
                display: 'grid', placeItems: 'center', flexShrink: 0,
                filter: 'grayscale(0.7)',
                opacity: 0.85,
              }}>
                <Art t={t} size={72} />
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', gap: 8 }}>
                  <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 22, lineHeight: 1, letterSpacing: '-0.01em' }}>
                    {p.name}
                  </div>
                  <div style={{ fontSize: 10, color: t.inkSoft, fontWeight: 600 }}>{p.date}</div>
                </div>
                <div style={{ fontSize: 12, color: t.inkSoft, marginTop: 2 }}>{p.species}</div>

                <div style={{
                  marginTop: 8, padding: '6px 0', borderTop: `1px solid ${t.line}`,
                  fontSize: 11, color: t.inkSoft, display: 'flex', gap: 6, alignItems: 'center',
                }}>
                  <span style={{ width: 6, height: 6, borderRadius: 3, background: p.gifted ? t.primary : t.terracotta }} />
                  Прожил{p.gifted ? '' : 'о'} рядом · <b style={{ color: t.ink, fontWeight: 700 }}>{p.lived}</b>
                </div>
                <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 4, fontStyle: 'italic', fontFamily: '"Instrument Serif", serif', fontSize: 13 }}>
                  «{p.cause}»
                </div>

                <div style={{ display: 'flex', gap: 6, marginTop: 10 }}>
                  <div style={{
                    padding: '5px 10px', borderRadius: 8,
                    background: t.surfaceWarm, fontSize: 11, fontWeight: 600,
                  }}>Открыть дневник</div>
                  <div style={{
                    padding: '5px 10px', borderRadius: 8,
                    background: t.surfaceWarm, fontSize: 11, fontWeight: 600,
                  }}>Вспомнить</div>
                </div>
              </div>
            </div>
          );
        })}
      </div>

      {/* RETROSPECTIVE */}
      <div style={{ padding: '20px 16px 110px' }}>
        <div style={{
          background: t.primarySoft, borderRadius: 24, padding: 20,
          position: 'relative', overflow: 'hidden',
        }}>
          <div style={{ fontSize: 11, color: t.primary, fontWeight: 700, letterSpacing: '0.06em', textTransform: 'uppercase' }}>
            Ретроспектива
          </div>
          <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 22, lineHeight: 1.2, marginTop: 6 }}>
            Растения живут с тобой <em style={{ color: t.primary, fontStyle: 'italic' }}>в среднем 1 год 4 мес.</em>
          </div>
          <div style={{ fontSize: 13, color: t.ink, marginTop: 6, opacity: 0.75 }}>
            Это нормально. Каждое — память и опыт.
          </div>
        </div>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 18 · РАЗМНОЖЕНИЕ / ЧЕРЕНОК — Родословная (#139)
// ─────────────────────────────────────────────────────────────
function PropagationScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'auto', position: 'relative' }}>
      <div style={{ padding: '16px 22px 8px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <button style={iconBtnV4(t, true)}><window.Icon name="arrow-left" size={20} color={t.ink} /></button>
          <span style={{ fontSize: 13, color: t.inkSoft, fontWeight: 600 }}>Новый росток</span>
          <div style={{ width: 40 }} />
        </div>
      </div>

      {/* LINEAGE VIZ */}
      <div style={{ padding: '12px 22px 8px', textAlign: 'center' }}>
        <div style={{ display: 'inline-flex', alignItems: 'center', gap: 0 }}>
          {/* parent */}
          <div style={{ textAlign: 'center' }}>
            <div style={{ width: 80, height: 80, borderRadius: 20, background: t.primarySoft, display: 'grid', placeItems: 'center' }}>
              <window.Monstera t={t} size={72} />
            </div>
            <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 16, marginTop: 6 }}>Моника</div>
            <div style={{ fontSize: 10, color: t.inkSoft, marginTop: -2 }}>Родитель</div>
          </div>
          {/* arrow */}
          <div style={{ padding: '0 14px', position: 'relative' }}>
            <svg width="50" height="80" viewBox="0 0 50 80">
              <path d="M 5 40 Q 25 20 45 40" stroke={t.primary} strokeWidth="2" fill="none" strokeDasharray="3 4" />
              <path d="M 38 35 L 45 40 L 38 45" stroke={t.primary} strokeWidth="2" fill="none" />
            </svg>
            <div style={{
              position: 'absolute', top: 8, left: '50%', transform: 'translateX(-50%)',
              fontSize: 22,
            }}>🌱</div>
          </div>
          {/* child */}
          <div style={{ textAlign: 'center' }}>
            <div style={{
              width: 80, height: 80, borderRadius: 20, background: t.surfaceWarm,
              border: `2px dashed ${t.primary}`,
              display: 'grid', placeItems: 'center',
            }}>
              <span style={{ fontFamily: '"Instrument Serif", serif', fontSize: 32, color: t.inkSoft }}>?</span>
            </div>
            <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 16, marginTop: 6, fontStyle: 'italic', color: t.primary }}>Имя?</div>
            <div style={{ fontSize: 10, color: t.inkSoft, marginTop: -2 }}>Росток</div>
          </div>
        </div>

        <h1 style={{ fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 30, lineHeight: 1.1, margin: '14px 0 4px', letterSpacing: '-0.01em' }}>
          Черенок от <em style={{ color: t.primary, fontStyle: 'italic' }}>Моники</em>
        </h1>
        <div style={{ fontSize: 13, color: t.inkSoft, textAlign: 'left', padding: '0 0' }}>
          Сохраним связь — увидишь, как растёт семья
        </div>
      </div>

      {/* NAME INPUT */}
      <div style={{ padding: '20px 22px 0' }}>
        <SectionLabel t={t}>Имя ростка</SectionLabel>
        <div style={{
          background: t.surface, borderRadius: 18, padding: '14px 16px',
          border: `2px solid ${t.primary}`,
          display: 'flex', alignItems: 'center', gap: 10,
        }}>
          <input type="text" defaultValue="Моник" style={{
            flex: 1, border: 'none', outline: 'none', background: 'transparent',
            fontFamily: '"Instrument Serif", serif', fontSize: 22, color: t.ink,
          }} />
        </div>
        <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap', marginTop: 10 }}>
          {['Моник', 'Мини‑Моника', 'Зелёныш‑2', 'Дочка'].map(n => (
            <div key={n} style={{
              padding: '5px 10px', borderRadius: 999,
              background: t.surface, border: `1px solid ${t.line}`,
              fontFamily: '"Instrument Serif", serif', fontSize: 14, color: t.ink,
            }}>{n}</div>
          ))}
        </div>
      </div>

      {/* PROPAGATION TYPE */}
      <div style={{ padding: '20px 22px 0' }}>
        <SectionLabel t={t}>Как размножается</SectionLabel>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 8 }}>
          {[
            { l: 'В воду', icon: '💧', active: true, sub: '~3 нед.' },
            { l: 'В грунт', icon: '🪴', sub: '~5 нед.' },
            { l: 'Мох', icon: '🌿', sub: 'долго' },
          ].map((m, i) => (
            <div key={i} style={{
              background: m.active ? t.ink : t.surface,
              color: m.active ? t.surface : t.ink,
              borderRadius: 18, padding: 14, textAlign: 'center',
              border: m.active ? 'none' : `1px solid ${t.line}`,
            }}>
              <div style={{ fontSize: 28 }}>{m.icon}</div>
              <div style={{ fontSize: 13, fontWeight: 700, marginTop: 4 }}>{m.l}</div>
              <div style={{ fontSize: 10, opacity: 0.75, marginTop: 2 }}>{m.sub}</div>
            </div>
          ))}
        </div>
      </div>

      {/* DATE */}
      <div style={{ padding: '20px 22px 0' }}>
        <SectionLabel t={t}>Когда срезал(а)</SectionLabel>
        <div style={{
          background: t.surface, borderRadius: 18, padding: '14px 16px',
          border: `1px solid ${t.line}`,
          display: 'flex', alignItems: 'center', gap: 12,
        }}>
          <div style={{ width: 36, height: 36, borderRadius: 12, background: t.primarySoft, display: 'grid', placeItems: 'center' }}>
            <window.Icon name="calendar" size={18} color={t.primary} stroke={1.8} />
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 14, fontWeight: 600 }}>13 мая 2026</div>
            <div style={{ fontSize: 11, color: t.inkSoft }}>Сегодня · день рождения семьи</div>
          </div>
          <window.Icon name="arrow-left" size={16} color={t.inkSoft} stroke={2} style={{ transform: 'scaleX(-1)' }} />
        </div>
      </div>

      <div style={{ height: 110 }} />

      <div style={{
        position: 'absolute', left: 0, right: 0, bottom: 0,
        padding: '14px 16px 16px',
        background: `linear-gradient(to top, ${t.bg} 70%, ${t.bg}00)`,
        display: 'flex', gap: 10,
      }}>
        <button style={{
          padding: '14px 18px', borderRadius: 18,
          background: t.surfaceWarm, color: t.ink, border: `1px solid ${t.line}`,
          fontSize: 14, fontWeight: 600, fontFamily: 'inherit',
        }}>Отмена</button>
        <button style={{
          flex: 1, padding: '14px 18px', borderRadius: 18,
          background: t.primary, color: t.surface, border: 'none',
          fontSize: 14, fontWeight: 600, fontFamily: 'inherit',
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
        }}>
          🌱 Завести в семью
        </button>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 19 · СПИСОК ПОКУПОК (#136)
// ─────────────────────────────────────────────────────────────
function ShoppingListScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];

  const sections = [
    { cat: 'Грунт и дренаж', items: [
      { l: 'Грунт для суккулентов', sub: '2 л · для пересадки Сьюзи', done: false, auto: true },
      { l: 'Керамзит дренажный', sub: '500 г', done: true },
    ]},
    { cat: 'Удобрения', items: [
      { l: 'Феровит', sub: 'Для Фернандо — AI порекомендовал', done: false, auto: true, ai: true },
      { l: 'Pokon универсальный', sub: 'Заканчивается', done: false },
    ]},
    { cat: 'Горшки', items: [
      { l: 'Терракотовый Ø 18 см', sub: 'Пересадка Моники в июне', done: false },
    ]},
  ];

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'auto', position: 'relative' }}>
      <div style={{ padding: '16px 22px 8px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <button style={iconBtnV4(t, true)}><window.Icon name="arrow-left" size={20} color={t.ink} /></button>
          <span style={{ fontSize: 13, color: t.primary, fontWeight: 600 }}>📤</span>
        </div>
      </div>

      <div style={{ padding: '12px 22px 0' }}>
        <div style={{ fontSize: 12, color: t.inkSoft, fontWeight: 600, letterSpacing: '0.06em', textTransform: 'uppercase' }}>
          5 позиций · 1 куплено
        </div>
        <h1 style={{ fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 38, lineHeight: 1.04, margin: '4px 0 0', letterSpacing: '-0.01em' }}>
          В <em style={{ color: t.primary, fontStyle: 'italic' }}>магазин</em> зайти
        </h1>
      </div>

      {/* AI BANNER */}
      <div style={{ padding: '14px 16px 0' }}>
        <div style={{
          background: t.primarySoft, borderRadius: 18, padding: '12px 14px',
          display: 'flex', alignItems: 'center', gap: 12,
        }}>
          <div style={{
            width: 32, height: 32, borderRadius: 10, background: t.primary,
            display: 'grid', placeItems: 'center', color: t.surface,
            fontSize: 14, fontWeight: 700,
          }}>AI</div>
          <div style={{ flex: 1, fontSize: 12, color: t.ink, lineHeight: 1.4 }}>
            <b>2 авто‑подсказки</b> — добавил из расписания ухода и диагностики
          </div>
        </div>
      </div>

      <div style={{ padding: '12px 16px 110px' }}>
        {sections.map((s, si) => (
          <div key={si} style={{ marginBottom: 12 }}>
            <div style={{
              fontSize: 11, color: t.inkSoft, fontWeight: 700,
              letterSpacing: '0.06em', textTransform: 'uppercase',
              padding: '12px 8px 6px',
            }}>{s.cat}</div>
            <div style={{ background: t.surface, borderRadius: 22, border: `1px solid ${t.line}`, overflow: 'hidden' }}>
              {s.items.map((it, i) => (
                <div key={i} style={{
                  padding: '14px 16px', display: 'flex', alignItems: 'flex-start', gap: 12,
                  borderTop: i === 0 ? 'none' : `1px solid ${t.line}`,
                  opacity: it.done ? 0.55 : 1,
                }}>
                  <div style={{
                    width: 24, height: 24, borderRadius: 12, marginTop: 1,
                    background: it.done ? t.primary : 'transparent',
                    border: it.done ? 'none' : `1.5px solid ${t.inkMute}`,
                    display: 'grid', placeItems: 'center', flexShrink: 0,
                  }}>
                    {it.done && <window.Icon name="check" size={14} color={t.surface} stroke={3} />}
                  </div>
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ fontSize: 14, fontWeight: 600, textDecoration: it.done ? 'line-through' : 'none' }}>
                      {it.l}
                    </div>
                    <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 2, display: 'flex', alignItems: 'center', gap: 6 }}>
                      {it.ai && (
                        <span style={{
                          fontSize: 9, fontWeight: 700, color: t.primary,
                          padding: '1px 5px', borderRadius: 4,
                          background: theme === 'dark' ? 'rgba(143,174,101,0.18)' : '#E2EDD0',
                          letterSpacing: '0.04em',
                        }}>AI</span>
                      )}
                      {it.auto && !it.ai && (
                        <span style={{
                          fontSize: 9, fontWeight: 700, color: t.terracotta,
                          padding: '1px 5px', borderRadius: 4,
                          background: theme === 'dark' ? 'rgba(216,145,114,0.18)' : '#FBEFE4',
                          letterSpacing: '0.04em',
                        }}>АВТО</span>
                      )}
                      {it.sub}
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        ))}

        {/* add row */}
        <div style={{
          marginTop: 4, padding: '14px 16px', borderRadius: 22,
          background: 'transparent', border: `1.5px dashed ${t.line}`,
          display: 'flex', alignItems: 'center', gap: 12, color: t.inkSoft,
          fontSize: 14, fontWeight: 600,
        }}>
          <window.Icon name="plus" size={18} color={t.inkSoft} stroke={2} />
          Добавить позицию
        </div>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────
function iconBtnV4(t, transparent = false, size = 40) {
  return {
    width: size, height: size, borderRadius: size / 2.5,
    background: transparent ? 'transparent' : t.surface,
    border: transparent ? 'none' : `1px solid ${t.line}`,
    display: 'grid', placeItems: 'center', cursor: 'pointer',
  };
}

function SectionLabel({ t, children }) {
  return (
    <div style={{
      fontSize: 11, color: t.inkSoft, fontWeight: 700,
      letterSpacing: '0.06em', textTransform: 'uppercase',
      padding: '6px 6px 10px',
    }}>{children}</div>
  );
}

function SettingsRow({ t, title, value, divider, link, danger }) {
  return (
    <div style={{
      padding: '14px 16px', display: 'flex', alignItems: 'center', gap: 12,
      borderTop: divider ? `1px solid ${t.line}` : 'none',
    }}>
      <div style={{ flex: 1, fontSize: 14, fontWeight: 600, color: danger ? t.terracotta : t.ink }}>{title}</div>
      <div style={{ fontSize: 13, color: t.inkSoft }}>{value}</div>
      {link && <window.Icon name="arrow-left" size={14} color={t.inkSoft} stroke={2} style={{ transform: 'scaleX(-1)' }} />}
    </div>
  );
}

function Toggle({ t, on }) {
  return (
    <div style={{
      width: 44, height: 26, borderRadius: 13,
      background: on ? t.primary : t.surfaceWarm,
      position: 'relative', flexShrink: 0,
    }}>
      <div style={{
        position: 'absolute', top: 3, left: on ? 21 : 3,
        width: 20, height: 20, borderRadius: 10, background: t.surface,
        boxShadow: '0 1px 3px rgba(0,0,0,0.2)',
      }} />
    </div>
  );
}

function MiniBottomNav({ t, active = 'home' }) {
  const items = [
    { id: 'home', label: 'Сад', icon: 'home' },
    { id: 'cal', label: 'График', icon: 'calendar' },
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
        <div key={it.id} style={{
          display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 2,
          padding: '6px 14px', borderRadius: 16,
          background: active === it.id ? t.primarySoft : 'transparent',
        }}>
          <window.Icon name={it.icon} size={20} color={active === it.id ? t.primary : t.inkSoft} stroke={1.8} />
          <div style={{ fontSize: 10, fontWeight: 600, color: active === it.id ? t.primary : t.inkSoft }}>{it.label}</div>
        </div>
      ))}
    </div>
  );
}

Object.assign(window, {
  WeekCalendarScreen, CatalogScreen, ProfileScreen, MonthlyReportScreen,
  PlantDiagnosisScreen, AIDoctorScreen, ArchiveScreen, PropagationScreen,
  ShoppingListScreen, MiniBottomNav,
});
