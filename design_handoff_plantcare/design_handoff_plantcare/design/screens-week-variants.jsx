// PlantCare — Экран 11 «График» — альтернативные варианты
// A · День-селектор + сгруппированная повестка
// B · Матрица растения × дни (обзор недели)
// C · Редакторская лента-таймлайн
// Хелперы: window.Icon, window.MiniBottomNav, window.PC_THEMES, иллюстрации Monstera/Fern/...

const PLANT_ART_WV = {
  monstera: () => window.Monstera, fern: () => window.Fern,
  succulent: () => window.Succulent, pothos: () => window.Pothos, cactus: () => window.Cactus,
};

// палитра действий
function actionTints(t) {
  return {
    water: { tint: t.primary, icon: 'drop', ru: 'Полить' },
    spray: { tint: t.terracotta, icon: 'spray', ru: 'Опрыскать' },
    fert:  { tint: t.leafDark, icon: 'fert', ru: 'Подкормить' },
    check: { tint: t.leaf, icon: 'thermo', ru: 'Осмотр' },
  };
}

const WEEK = [
  { d: 'Пн', n: 11 }, { d: 'Вт', n: 12 }, { d: 'Ср', n: 13 },
  { d: 'Чт', n: 14 }, { d: 'Пт', n: 15 }, { d: 'Сб', n: 16 }, { d: 'Вс', n: 17 },
];

// растение → действия по дням (индекс дня 0..6)
const PLANT_GRID = [
  { name: 'Моника', art: 'monstera', acts: { 1: 'water', 2: 'spray', 3: 'water' } },
  { name: 'Фернандо', art: 'fern', acts: { 1: 'spray', 2: 'spray', 4: 'spray' } },
  { name: 'Сьюзи', art: 'succulent', acts: { 1: 'water', 4: 'spray', 5: 'water' } },
  { name: 'Перси', art: 'pothos', acts: { 2: 'fert', 4: 'fert' } },
  { name: 'Колючка', art: 'cactus', acts: { 0: 'water', 2: 'water', 5: 'check' } },
];

function wvBtn(t) {
  return {
    width: 40, height: 40, borderRadius: 14, background: t.surface,
    border: `1px solid ${t.line}`, display: 'grid', placeItems: 'center', cursor: 'pointer',
  };
}

// ═════════════════════════════════════════════════════════════
// ВАРИАНТ A — День-селектор + сгруппированная повестка
// Горизонтальная лента дней с точками-нагрузкой → чистый список
// задач выбранного дня, сгруппированный по времени суток.
// ═════════════════════════════════════════════════════════════
function WeekCalA({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];
  const A = actionTints(t);
  const counts = [2, 3, 5, 1, 4, 2, 0];

  const morning = [
    { plant: 'Моника', species: 'Монстера', art: 'monstera', act: 'spray' },
    { plant: 'Фернандо', species: 'Папоротник', art: 'fern', act: 'spray', overdue: true },
  ];
  const evening = [
    { plant: 'Сьюзи', species: 'Суккулент', art: 'succulent', act: 'water' },
    { plant: 'Перси', species: 'Эпипремнум', art: 'pothos', act: 'fert' },
  ];
  const done = [
    { plant: 'Колючка', species: 'Кактус', art: 'cactus', act: 'water' },
  ];

  const Row = ({ task, dim }) => {
    const a = A[task.act];
    const Art = PLANT_ART_WV[task.art]();
    return (
      <div style={{
        display: 'flex', alignItems: 'center', gap: 12,
        padding: '10px 12px', borderRadius: 18,
        background: t.surface, border: `1px solid ${task.overdue ? t.terracotta : t.line}`,
        opacity: dim ? 0.5 : 1,
      }}>
        <div style={{ width: 44, height: 44, borderRadius: 14, background: t.surfaceWarm, display: 'grid', placeItems: 'center', flexShrink: 0 }}>
          <Art t={t} size={40} />
        </div>
        <div style={{ flex: 1, minWidth: 0 }}>
          <div style={{ fontSize: 15, fontWeight: 700, textDecoration: dim ? 'line-through' : 'none' }}>{task.plant}</div>
          <div style={{ fontSize: 12, color: task.overdue ? t.terracotta : t.inkSoft, fontWeight: 600 }}>
            {task.overdue ? 'Просрочено · со вчера' : `${a.ru} · ${task.species}`}
          </div>
        </div>
        <div style={{
          width: 34, height: 34, borderRadius: 12, flexShrink: 0,
          background: dim ? 'transparent' : a.tint,
          border: dim ? `2px solid ${t.line}` : 'none',
          display: 'grid', placeItems: 'center',
        }}>
          <window.Icon name={dim ? 'check' : a.icon} size={17} color={dim ? t.inkMute : '#fff'} stroke={2} />
        </div>
      </div>
    );
  };

  const Group = ({ label, time, items, dim }) => (
    <div style={{ marginBottom: 20 }}>
      <div style={{ display: 'flex', alignItems: 'baseline', gap: 8, padding: '0 4px 10px' }}>
        <span style={{ fontSize: 12, fontWeight: 700, letterSpacing: '0.06em', textTransform: 'uppercase', color: t.inkSoft }}>{label}</span>
        <span style={{ fontSize: 12, color: t.inkMute }}>{time}</span>
        <span style={{ flex: 1, height: 1, background: t.line, transform: 'translateY(-3px)' }} />
      </div>
      <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
        {items.map((task, i) => <Row key={i} task={task} dim={dim} />)}
      </div>
    </div>
  );

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'auto', position: 'relative' }}>
      <div style={{ padding: '20px 22px 6px', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <div>
          <div style={{ fontSize: 11, color: t.inkSoft, fontWeight: 700, letterSpacing: '0.06em', textTransform: 'uppercase' }}>Май 2026</div>
          <h1 style={{ fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 30, lineHeight: 1.04, margin: '2px 0 0' }}>График ухода</h1>
        </div>
        <button style={wvBtn(t)}><window.Icon name="calendar" size={18} color={t.ink} /></button>
      </div>

      {/* день-селектор */}
      <div style={{ display: 'flex', gap: 7, padding: '14px 16px 4px', overflowX: 'auto' }}>
        {WEEK.map((day, i) => {
          const sel = i === 2;
          const c = counts[i];
          return (
            <div key={i} style={{
              flex: '1 0 auto', minWidth: 46, padding: '10px 0 8px', borderRadius: 18,
              textAlign: 'center', cursor: 'pointer',
              background: sel ? t.primary : t.surface,
              border: `1px solid ${sel ? t.primary : t.line}`,
            }}>
              <div style={{ fontSize: 10, fontWeight: 700, letterSpacing: '0.04em', color: sel ? 'rgba(255,255,255,0.8)' : t.inkSoft, textTransform: 'uppercase' }}>{day.d}</div>
              <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 22, lineHeight: 1.1, color: sel ? '#fff' : t.ink }}>{day.n}</div>
              <div style={{ height: 6, marginTop: 4, display: 'flex', gap: 2, justifyContent: 'center' }}>
                {c === 0
                  ? <span style={{ fontSize: 9, color: sel ? 'rgba(255,255,255,0.7)' : t.inkMute }}>—</span>
                  : Array.from({ length: Math.min(c, 3) }).map((_, k) => (
                      <span key={k} style={{ width: 5, height: 5, borderRadius: 3, background: sel ? 'rgba(255,255,255,0.85)' : t.leaf }} />
                    ))}
              </div>
            </div>
          );
        })}
      </div>

      <div style={{ padding: '16px 16px 4px' }}>
        <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', padding: '0 6px 16px' }}>
          <div style={{ fontSize: 15, fontWeight: 700 }}>Среда, 13 мая</div>
          <div style={{ fontSize: 13, color: t.inkSoft }}>1 из 5 готово</div>
        </div>

        <Group label="Утро" time="9:00" items={morning} />
        <Group label="Вечер" time="19:00" items={evening} />
        <Group label="Сделано" time="" items={done} dim />

        <div style={{ height: 110 }} />
      </div>

      <window.MiniBottomNav t={t} active="cal" />
    </div>
  );
}

// ═════════════════════════════════════════════════════════════
// ВАРИАНТ B — Матрица «растения × дни»
// Весь сад на одном экране: строки — растения, столбцы — дни.
// Цветная точка = действие. Сегодняшний столбец подсвечен.
// ═════════════════════════════════════════════════════════════
function WeekCalB({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];
  const A = actionTints(t);
  const todayIdx = 2;
  const colCount = WEEK.reduce((acc, _, i) => {
    acc[i] = PLANT_GRID.filter(p => p.acts[i]).length;
    return acc;
  }, {});

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'auto', position: 'relative' }}>
      <div style={{ padding: '20px 22px 6px', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <div>
          <div style={{ fontSize: 11, color: t.inkSoft, fontWeight: 700, letterSpacing: '0.06em', textTransform: 'uppercase' }}>11 – 17 мая</div>
          <h1 style={{ fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 30, lineHeight: 1.04, margin: '2px 0 0' }}>Неделя ухода</h1>
        </div>
        <button style={wvBtn(t)}><window.Icon name="calendar" size={18} color={t.ink} /></button>
      </div>

      <div style={{ fontSize: 13, color: t.inkSoft, padding: '4px 22px 14px' }}>17 забот · сегодня загруженный день</div>

      {/* матрица */}
      <div style={{ padding: '0 14px' }}>
        <div style={{ background: t.surface, border: `1px solid ${t.line}`, borderRadius: 24, padding: '6px 8px 10px', overflow: 'hidden' }}>
          {/* шапка дней */}
          <div style={{ display: 'grid', gridTemplateColumns: '92px repeat(7, 1fr)', alignItems: 'center' }}>
            <div />
            {WEEK.map((day, i) => (
              <div key={i} style={{
                textAlign: 'center', padding: '8px 0 6px', borderRadius: 12,
                background: i === todayIdx ? t.primarySoft : 'transparent',
              }}>
                <div style={{ fontSize: 9, fontWeight: 700, letterSpacing: '0.03em', textTransform: 'uppercase', color: i === todayIdx ? t.primary : t.inkSoft }}>{day.d}</div>
                <div style={{ fontSize: 13, fontWeight: 700, color: i === todayIdx ? t.primary : t.ink }}>{day.n}</div>
              </div>
            ))}
          </div>

          {/* строки растений */}
          {PLANT_GRID.map((p, ri) => {
            const Art = PLANT_ART_WV[p.art]();
            return (
              <div key={ri} style={{
                display: 'grid', gridTemplateColumns: '92px repeat(7, 1fr)', alignItems: 'center',
                borderTop: `1px solid ${t.line}`, minHeight: 52,
              }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 7, paddingLeft: 4 }}>
                  <div style={{ width: 30, height: 30, borderRadius: 9, background: t.surfaceWarm, display: 'grid', placeItems: 'center', flexShrink: 0 }}>
                    <Art t={t} size={26} />
                  </div>
                  <span style={{ fontSize: 12, fontWeight: 600, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{p.name}</span>
                </div>
                {WEEK.map((_, ci) => {
                  const act = p.acts[ci];
                  const a = act ? A[act] : null;
                  return (
                    <div key={ci} style={{
                      display: 'grid', placeItems: 'center', alignSelf: 'stretch',
                      background: ci === todayIdx ? (theme === 'dark' ? 'rgba(183,208,140,0.07)' : 'rgba(63,107,58,0.05)') : 'transparent',
                    }}>
                      {a ? (
                        <div style={{ width: 26, height: 26, borderRadius: 9, background: a.tint, display: 'grid', placeItems: 'center' }}>
                          <window.Icon name={a.icon} size={13} color="#fff" stroke={2.2} />
                        </div>
                      ) : (
                        <span style={{ width: 4, height: 4, borderRadius: 2, background: t.line }} />
                      )}
                    </div>
                  );
                })}
              </div>
            );
          })}

          {/* итоговая строка нагрузки */}
          <div style={{ display: 'grid', gridTemplateColumns: '92px repeat(7, 1fr)', alignItems: 'center', borderTop: `1px solid ${t.line}`, paddingTop: 6, marginTop: 2 }}>
            <div style={{ fontSize: 10, fontWeight: 700, color: t.inkSoft, textTransform: 'uppercase', letterSpacing: '0.04em', paddingLeft: 4 }}>Нагрузка</div>
            {WEEK.map((_, ci) => (
              <div key={ci} style={{ display: 'flex', justifyContent: 'center' }}>
                <div style={{
                  fontSize: 11, fontWeight: 700,
                  color: colCount[ci] === 0 ? t.inkMute : (ci === todayIdx ? t.primary : t.ink),
                }}>{colCount[ci] || '·'}</div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* легенда */}
      <div style={{ display: 'flex', flexWrap: 'wrap', gap: 14, padding: '16px 22px 0' }}>
        {Object.values(A).map((a, i) => (
          <div key={i} style={{ display: 'flex', alignItems: 'center', gap: 7 }}>
            <span style={{ width: 16, height: 16, borderRadius: 6, background: a.tint, display: 'grid', placeItems: 'center' }}>
              <window.Icon name={a.icon} size={9} color="#fff" stroke={2.4} />
            </span>
            <span style={{ fontSize: 12, color: t.inkSoft, fontWeight: 600 }}>{a.ru}</span>
          </div>
        ))}
      </div>

      <div style={{
        margin: '18px 16px 120px', padding: '14px 16px', borderRadius: 18,
        background: t.surface, border: `1px solid ${t.line}`, display: 'flex', alignItems: 'center', gap: 12,
      }}>
        <div style={{ width: 36, height: 36, borderRadius: 12, background: t.primarySoft, display: 'grid', placeItems: 'center' }}>
          <window.Icon name="calendar" size={18} color={t.primary} stroke={1.8} />
        </div>
        <div style={{ flex: 1 }}>
          <div style={{ fontSize: 13, fontWeight: 700 }}>Свободные выходные</div>
          <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 1 }}>Сб и Вс — почти ничего. Можно уехать 🌳</div>
        </div>
      </div>

      <window.MiniBottomNav t={t} active="cal" />
    </div>
  );
}

// ═════════════════════════════════════════════════════════════
// ВАРИАНТ C — Редакторская лента-таймлайн
// Спокойная вертикальная лента: крупная serif-дата слева,
// карточка дня справа с чипами задач. Выходные — особый блок.
// ═════════════════════════════════════════════════════════════
function WeekCalC({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];
  const A = actionTints(t);

  const days = [
    { d: 'Пн', n: 11, past: true, tasks: [['Колючка', 'water'], ['Перси', 'spray']] },
    { d: 'Вт', n: 12, past: true, tasks: [['Моника', 'water'], ['Сьюзи', 'water'], ['Фернандо', 'spray']] },
    { d: 'Ср', n: 13, today: true, tasks: [['Моника', 'spray'], ['Фернандо', 'spray'], ['Сьюзи', 'water'], ['Перси', 'fert'], ['Колючка', 'water']] },
    { d: 'Чт', n: 14, tasks: [['Моника', 'water']] },
    { d: 'Пт', n: 15, tasks: [['Перси', 'fert'], ['Фернандо', 'spray'], ['Сьюзи', 'spray'], ['Моника', 'check']] },
    { d: 'Сб', n: 16, free: true, tasks: [['Колючка', 'check'], ['Сьюзи', 'water']] },
    { d: 'Вс', n: 17, free: true, tasks: [] },
  ];

  const Chip = ({ name, act }) => {
    const a = A[act];
    return (
      <div style={{
        display: 'inline-flex', alignItems: 'center', gap: 6, padding: '5px 11px 5px 5px',
        borderRadius: 999, background: t.bg, border: `1px solid ${t.line}`,
      }}>
        <span style={{ width: 20, height: 20, borderRadius: 10, background: a.tint, display: 'grid', placeItems: 'center' }}>
          <window.Icon name={a.icon} size={11} color="#fff" stroke={2.4} />
        </span>
        <span style={{ fontSize: 12, fontWeight: 600 }}>{name}</span>
      </div>
    );
  };

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'auto', position: 'relative' }}>
      <div style={{ padding: '22px 24px 4px', display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between' }}>
        <div>
          <div style={{ fontSize: 11, color: t.inkSoft, fontWeight: 700, letterSpacing: '0.06em', textTransform: 'uppercase' }}>Май 2026</div>
          <h1 style={{ fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 40, lineHeight: 1, margin: '4px 0 0', letterSpacing: '-0.01em' }}>
            Неделя<br /><em style={{ color: t.primary, fontStyle: 'italic' }}>11 – 17</em>
          </h1>
        </div>
        <button style={wvBtn(t)}><window.Icon name="calendar" size={18} color={t.ink} /></button>
      </div>
      <div style={{ fontSize: 13, color: t.inkSoft, padding: '12px 24px 6px' }}>17 забот за неделю · выходные свободны</div>

      {/* лента */}
      <div style={{ padding: '8px 20px 0', position: 'relative' }}>
        {days.map((day, i) => (
          <div key={i} style={{ display: 'flex', gap: 14, opacity: day.past ? 0.5 : 1 }}>
            {/* дата + ось */}
            <div style={{ width: 42, flexShrink: 0, display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
              <div style={{ textAlign: 'center' }}>
                <div style={{ fontSize: 10, fontWeight: 700, letterSpacing: '0.04em', textTransform: 'uppercase', color: day.today ? t.primary : t.inkSoft }}>{day.d}</div>
                <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: day.today ? 30 : 24, lineHeight: 1, color: day.today ? t.primary : t.ink }}>{day.n}</div>
              </div>
              {i < days.length - 1 && (
                <div style={{ width: 2, flex: 1, minHeight: 18, background: t.line, marginTop: 8, borderRadius: 1 }} />
              )}
            </div>

            {/* карточка дня */}
            <div style={{ flex: 1, paddingBottom: 16 }}>
              {day.free && day.tasks.length === 0 ? (
                <div style={{
                  borderRadius: 22, padding: '18px 18px', background: t.primarySoft,
                  border: `1px solid ${t.line}`, display: 'flex', alignItems: 'center', gap: 12,
                }}>
                  <span style={{ fontSize: 26 }}>🌿</span>
                  <div>
                    <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 19, color: t.leafDark }}>Свободный день</div>
                    <div style={{ fontSize: 12, color: t.inkSoft }}>Сад справится сам</div>
                  </div>
                </div>
              ) : (
                <div style={{
                  borderRadius: 22, padding: 14,
                  background: day.today ? t.surface : 'transparent',
                  border: day.today ? `2px solid ${t.primary}` : `1px solid ${t.line}`,
                }}>
                  {day.today && (
                    <div style={{ fontSize: 11, fontWeight: 700, color: t.primary, letterSpacing: '0.04em', textTransform: 'uppercase', marginBottom: 10 }}>
                      Сегодня · {day.tasks.length} забот
                    </div>
                  )}
                  <div style={{ display: 'flex', flexWrap: 'wrap', gap: 7 }}>
                    {day.tasks.map(([name, act], j) => <Chip key={j} name={name} act={act} />)}
                  </div>
                </div>
              )}
            </div>
          </div>
        ))}
        <div style={{ height: 110 }} />
      </div>

      <window.MiniBottomNav t={t} active="cal" />
    </div>
  );
}

Object.assign(window, { WeekCalA, WeekCalB, WeekCalC, WeekCalendarScreen: WeekCalA });
