// PlantCate — batch 8 — закрываем оставшиеся тупики настроек
// Дома и места (#70), Сезонные интервалы (#67), Пикер времени, Таймзона, Язык
// Хелперы из v5: window.pcIconBtn, PcSectionLabel, PcToggle

// ─────────────────────────────────────────────────────────────
// 34 · ДОМА И МЕСТА (locations CRUD + houses · #70)
//      вход: Профиль 13 → «Дома и места»
// ─────────────────────────────────────────────────────────────
function RoomsHomesScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];
  const IB = window.pcIconBtn;

  const homes = [
    {
      name: 'Квартира', sub: 'Москва · основной', active: true,
      rooms: [
        { emoji: '🛋', name: 'Гостиная', n: 5, def: true },
        { emoji: '🪟', name: 'Подоконник', n: 3 },
        { emoji: '🛏', name: 'Спальня', n: 2 },
        { emoji: '🍽', name: 'Кухня', n: 2 },
      ],
    },
    {
      name: 'Дача', sub: 'Калужская обл. · сезонный', active: false,
      rooms: [
        { emoji: '🌿', name: 'Веранда', n: 4 },
        { emoji: '🪴', name: 'Теплица', n: 6 },
      ],
    },
  ];

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'auto', position: 'relative' }}>
      <div style={{ padding: '16px 22px 8px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <button style={IB(t)}><window.Icon name="arrow-left" size={20} color={t.ink} /></button>
          <div style={{ fontSize: 12, fontWeight: 600, letterSpacing: '0.06em', color: t.inkSoft, textTransform: 'uppercase' }}>Дома и места</div>
          <div style={{ width: 40 }} />
        </div>
      </div>

      <div style={{ padding: '8px 22px 0' }}>
        <h1 style={{ fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 32, lineHeight: 1.05, margin: '4px 0 4px', letterSpacing: '-0.01em' }}>
          Где живёт твой <em style={{ color: t.primary, fontStyle: 'italic' }}>сад</em>
        </h1>
        <div style={{ fontSize: 13, color: t.inkSoft }}>Комнаты помогают группировать уход и фильтровать главную</div>
      </div>

      {homes.map((home, hi) => (
        <div key={hi} style={{ padding: '20px 16px 0' }}>
          {/* home header */}
          <div style={{
            display: 'flex', alignItems: 'center', gap: 12, padding: '0 6px 10px',
          }}>
            <div style={{ width: 36, height: 36, borderRadius: 12, background: home.active ? t.primary : t.surfaceWarm, display: 'grid', placeItems: 'center', flexShrink: 0, fontSize: 18 }}>
              {home.active ? <window.Icon name="home" size={18} color={t.surface} stroke={1.8} /> : '🏡'}
            </div>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ fontSize: 16, fontWeight: 700, display: 'flex', alignItems: 'center', gap: 8 }}>
                {home.name}
                {home.active && <span style={{ fontSize: 9, fontWeight: 700, color: t.primary, background: t.primarySoft, padding: '2px 6px', borderRadius: 5, letterSpacing: '0.04em' }}>ОСНОВНОЙ</span>}
              </div>
              <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 1 }}>{home.sub}</div>
            </div>
            <window.Icon name="more" size={18} color={t.inkSoft} />
          </div>

          {/* rooms */}
          <div style={{ background: t.surface, borderRadius: 22, border: `1px solid ${t.line}`, overflow: 'hidden' }}>
            {home.rooms.map((r, ri) => (
              <div key={ri} style={{
                padding: '12px 16px', display: 'flex', alignItems: 'center', gap: 12,
                borderTop: ri === 0 ? 'none' : `1px solid ${t.line}`,
              }}>
                <div style={{ width: 36, height: 36, borderRadius: 12, background: t.surfaceWarm, display: 'grid', placeItems: 'center', flexShrink: 0, fontSize: 18 }}>{r.emoji}</div>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{ fontSize: 14, fontWeight: 600, display: 'flex', alignItems: 'center', gap: 8 }}>
                    {r.name}
                    {r.def && <span style={{ fontSize: 9, fontWeight: 700, color: t.inkSoft, background: t.surfaceWarm, padding: '2px 6px', borderRadius: 5, letterSpacing: '0.04em' }}>ПО УМОЛЧАНИЮ</span>}
                  </div>
                  <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 1 }}>{r.n} {r.n === 1 ? 'растение' : r.n < 5 ? 'растения' : 'растений'}</div>
                </div>
                <window.Icon name="arrow-left" size={14} color={t.inkSoft} stroke={2} style={{ transform: 'scaleX(-1)' }} />
              </div>
            ))}
            <div style={{ borderTop: `1px dashed ${t.line}`, padding: '13px 16px', display: 'flex', alignItems: 'center', gap: 10, color: t.primary, fontSize: 13, fontWeight: 600 }}>
              <window.Icon name="plus" size={16} color={t.primary} stroke={2} />
              Добавить комнату
            </div>
          </div>
        </div>
      ))}

      {/* add home */}
      <div style={{ padding: '18px 16px 40px' }}>
        <div style={{
          borderRadius: 20, padding: '16px', border: `1.5px dashed ${t.line}`,
          display: 'flex', alignItems: 'center', gap: 12, justifyContent: 'center',
          color: t.inkSoft, fontSize: 14, fontWeight: 600,
        }}>
          <window.Icon name="plus" size={18} color={t.inkSoft} stroke={2} />
          Добавить ещё дом
        </div>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 35 · СЕЗОННЫЕ ИНТЕРВАЛЫ (#67)
//      вход: Профиль 13 → «Сезонные интервалы»
// ─────────────────────────────────────────────────────────────
function SeasonalIntervalsScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];
  const IB = window.pcIconBtn;

  const seasons = [
    { name: 'Весна', emoji: '🌱', mult: 0.9, factor: '+10%', note: 'просыпаются' },
    { name: 'Лето', emoji: '☀️', mult: 1.0, factor: '+20%', note: 'пьют чаще', now: true },
    { name: 'Осень', emoji: '🍂', mult: 0.65, factor: 'базовый', note: 'замедляются' },
    { name: 'Зима', emoji: '❄️', mult: 0.45, factor: '−30%', note: 'отдыхают' },
  ];

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'auto', position: 'relative' }}>
      <div style={{ padding: '16px 22px 8px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <button style={IB(t)}><window.Icon name="arrow-left" size={20} color={t.ink} /></button>
          <div style={{ fontSize: 12, fontWeight: 600, letterSpacing: '0.06em', color: t.inkSoft, textTransform: 'uppercase' }}>Сезонные интервалы</div>
          <div style={{ width: 40 }} />
        </div>
      </div>

      <div style={{ padding: '8px 22px 0' }}>
        <h1 style={{ fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 32, lineHeight: 1.05, margin: '4px 0 4px', letterSpacing: '-0.01em' }}>
          Уход <em style={{ color: t.primary, fontStyle: 'italic' }}>по сезону</em>
        </h1>
        <div style={{ fontSize: 13, color: t.inkSoft, lineHeight: 1.5 }}>Летом растения пьют чаще, зимой почти спят. Подстраиваем расписание автоматически.</div>
      </div>

      {/* auto toggle */}
      <div style={{ padding: '18px 16px 0' }}>
        <div style={{ background: t.surface, borderRadius: 22, border: `1px solid ${t.line}`, padding: '14px 16px', display: 'flex', alignItems: 'center', gap: 12 }}>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 14, fontWeight: 600 }}>Автоматически по сезону</div>
            <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 1 }}>Менять частоту полива и опрыскивания</div>
          </div>
          <window.PcToggle t={t} on />
        </div>
      </div>

      {/* current season highlight */}
      <div style={{ padding: '14px 16px 0' }}>
        <div style={{ background: t.primarySoft, borderRadius: 22, padding: '18px 20px', position: 'relative', overflow: 'hidden' }}>
          <svg width="120" height="120" viewBox="0 0 120 120" style={{ position: 'absolute', right: -16, top: -20, opacity: 0.25 }}>
            <path d="M 100 20 C 60 20 30 50 30 90 C 50 90 80 60 100 20 Z" fill={t.leafDark} />
          </svg>
          <div style={{ fontSize: 11, color: t.primary, fontWeight: 700, letterSpacing: '0.06em', textTransform: 'uppercase', position: 'relative' }}>Сейчас · лето ☀️</div>
          <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 24, lineHeight: 1.2, margin: '6px 0 4px', position: 'relative' }}>
            Поливаем на <em style={{ color: t.primary, fontStyle: 'italic' }}>20% чаще</em>
          </div>
          <div style={{ fontSize: 13, color: t.inkSoft, position: 'relative' }}>Монике — раз в 6 дней вместо 7</div>
        </div>
      </div>

      {/* seasons bars */}
      <div style={{ padding: '20px 16px 0' }}>
        <window.PcSectionLabel t={t}>Частота полива по году</window.PcSectionLabel>
        <div style={{ background: t.surface, borderRadius: 22, border: `1px solid ${t.line}`, padding: '18px 16px' }}>
          <div style={{ display: 'flex', gap: 12, alignItems: 'flex-end', height: 130 }}>
            {seasons.map((s, i) => (
              <div key={i} style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 8 }}>
                <div style={{ fontSize: 11, fontWeight: 700, color: s.now ? t.primary : t.inkSoft }}>{s.factor}</div>
                <div style={{
                  width: '100%', height: `${s.mult * 90}px`, borderRadius: 10,
                  background: s.now ? t.primary : t.surfaceWarm,
                  border: s.now ? 'none' : `1px solid ${t.line}`,
                }} />
                <div style={{ fontSize: 18 }}>{s.emoji}</div>
                <div style={{ fontSize: 11, fontWeight: s.now ? 700 : 500, color: s.now ? t.ink : t.inkSoft }}>{s.name}</div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* voice */}
      <div style={{
        margin: '16px 16px 40px', padding: '14px 16px', borderRadius: 18,
        border: `1px dashed ${t.line}`, display: 'flex', gap: 12, alignItems: 'flex-start',
      }}>
        <span style={{ fontSize: 18, flexShrink: 0 }}>❄️</span>
        <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 16, fontStyle: 'italic', lineHeight: 1.4, color: t.ink }}>
          «Зимой не заливай меня — я отдыхаю и пью совсем мало.»
        </div>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 36 · ПИКЕР ВРЕМЕНИ — bottom sheet
//      вход: Тихие часы 23 → тап по «Засыпаю в 22:00»
// ─────────────────────────────────────────────────────────────
function TimePickerSheet({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];
  const hours = [20, 21, 22, 23, 0];
  const mins = ['00', '15', '30', '45'];
  const selH = 22, selM = '00';

  const Col = ({ items, sel, fmt }) => (
    <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
      {items.map((v, i) => {
        const dist = Math.abs(items.indexOf(sel) - i);
        return (
          <div key={i} style={{
            fontFamily: '"Instrument Serif", serif',
            fontSize: v === sel ? 34 : 26,
            lineHeight: 1.5,
            color: v === sel ? t.ink : t.inkMute,
            opacity: v === sel ? 1 : Math.max(0.25, 0.7 - dist * 0.18),
            fontWeight: 400,
          }}>{fmt ? fmt(v) : v}</div>
        );
      })}
    </div>
  );

  return (
    <div style={{ width: '100%', height: '100%', position: 'relative', fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', background: t.bg, overflow: 'hidden' }}>
      {/* dimmed backdrop hint */}
      <div style={{ position: 'absolute', inset: 0, background: 'rgba(20,16,12,0.45)', backdropFilter: 'blur(2px)' }} />

      {/* sheet */}
      <div style={{
        position: 'absolute', left: 0, right: 0, bottom: 0,
        background: t.surface, borderTopLeftRadius: 30, borderTopRightRadius: 30,
        padding: '12px 22px 26px', boxShadow: '0 -20px 50px rgba(0,0,0,0.2)',
      }}>
        <div style={{ display: 'flex', justifyContent: 'center', marginBottom: 14 }}>
          <div style={{ width: 44, height: 4, borderRadius: 2, background: t.inkMute, opacity: 0.4 }} />
        </div>

        <div style={{ textAlign: 'center', marginBottom: 6 }}>
          <div style={{ fontSize: 11, color: t.inkSoft, fontWeight: 600, letterSpacing: '0.06em', textTransform: 'uppercase' }}>Тихие часы начинаются</div>
          <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 24, marginTop: 2 }}>Засыпаю в</div>
        </div>

        {/* wheel */}
        <div style={{ position: 'relative', margin: '8px 0' }}>
          {/* selection band */}
          <div style={{
            position: 'absolute', left: 30, right: 30, top: '50%', transform: 'translateY(-50%)',
            height: 52, borderRadius: 16, background: t.primarySoft, zIndex: 0,
          }} />
          <div style={{ display: 'flex', alignItems: 'center', position: 'relative', zIndex: 1, padding: '0 40px' }}>
            <Col items={hours} sel={selH} fmt={v => String(v).padStart(2, '0')} />
            <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 34, color: t.ink, padding: '0 4px' }}>:</div>
            <Col items={mins} sel={selM} />
          </div>
        </div>

        <button style={{
          width: '100%', padding: '16px', borderRadius: 20, background: t.ink, color: t.surface,
          border: 'none', fontSize: 15, fontWeight: 600, fontFamily: 'inherit', marginTop: 10,
        }}>Готово</button>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 37 · ВЫБОР ТАЙМЗОНЫ
//      вход: Тихие часы 23 / Профиль → «Таймзона»
// ─────────────────────────────────────────────────────────────
function TimezonePickerScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];
  const IB = window.pcIconBtn;

  const zones = [
    { city: 'Москва', zone: 'Europe/Moscow', off: 'GMT+3', sel: true },
    { city: 'Калининград', zone: 'Europe/Kaliningrad', off: 'GMT+2' },
    { city: 'Самара', zone: 'Europe/Samara', off: 'GMT+4' },
    { city: 'Екатеринбург', zone: 'Asia/Yekaterinburg', off: 'GMT+5' },
    { city: 'Новосибирск', zone: 'Asia/Novosibirsk', off: 'GMT+7' },
    { city: 'Владивосток', zone: 'Asia/Vladivostok', off: 'GMT+10' },
  ];

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'auto', position: 'relative' }}>
      <div style={{ padding: '16px 22px 8px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 4 }}>
          <button style={IB(t)}><window.Icon name="arrow-left" size={20} color={t.ink} /></button>
          <div style={{ fontSize: 12, fontWeight: 600, letterSpacing: '0.06em', color: t.inkSoft, textTransform: 'uppercase' }}>Таймзона</div>
          <div style={{ width: 40 }} />
        </div>
      </div>

      <div style={{ padding: '8px 22px 0' }}>
        <h1 style={{ fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 30, lineHeight: 1.05, margin: '4px 0 12px', letterSpacing: '-0.01em' }}>
          Когда у тебя <em style={{ color: t.primary, fontStyle: 'italic' }}>утро</em>?
        </h1>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10, background: t.surface, borderRadius: 18, padding: '12px 14px', border: `1px solid ${t.line}` }}>
          <window.Icon name="search" size={18} color={t.inkSoft} stroke={1.8} />
          <input type="text" placeholder="Город или регион…" style={{ flex: 1, border: 'none', outline: 'none', background: 'transparent', fontFamily: 'inherit', fontSize: 14, color: t.ink }} />
        </div>
      </div>

      <div style={{ padding: '18px 16px 40px' }}>
        <window.PcSectionLabel t={t}>Россия</window.PcSectionLabel>
        <div style={{ background: t.surface, borderRadius: 22, border: `1px solid ${t.line}`, overflow: 'hidden' }}>
          {zones.map((z, i) => (
            <div key={i} style={{
              padding: '14px 16px', display: 'flex', alignItems: 'center', gap: 12,
              borderTop: i === 0 ? 'none' : `1px solid ${t.line}`,
              background: z.sel ? t.primarySoft : 'transparent',
            }}>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 15, fontWeight: 600, color: z.sel ? t.primary : t.ink }}>{z.city}</div>
                <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 1, fontFamily: 'monospace' }}>{z.zone}</div>
              </div>
              <div style={{ fontSize: 13, fontWeight: 700, color: z.sel ? t.primary : t.inkSoft }}>{z.off}</div>
              {z.sel && <window.Icon name="check" size={18} color={t.primary} stroke={2.4} />}
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 38 · ЯЗЫК ПРИЛОЖЕНИЯ
//      вход: Профиль 13 → «Язык / Language»
// ─────────────────────────────────────────────────────────────
function LanguageScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];
  const IB = window.pcIconBtn;

  const langs = [
    { native: 'Русский', en: 'Russian', sel: true },
    { native: 'English', en: 'English', },
    { native: 'Українська', en: 'Ukrainian' },
    { native: 'Қазақша', en: 'Kazakh' },
    { native: "O‘zbekcha", en: 'Uzbek' },
  ];

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'auto', position: 'relative' }}>
      <div style={{ padding: '16px 22px 8px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <button style={IB(t)}><window.Icon name="arrow-left" size={20} color={t.ink} /></button>
          <div style={{ fontSize: 12, fontWeight: 600, letterSpacing: '0.06em', color: t.inkSoft, textTransform: 'uppercase' }}>Язык · Language</div>
          <div style={{ width: 40 }} />
        </div>
      </div>

      <div style={{ padding: '8px 22px 0' }}>
        <h1 style={{ fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 32, lineHeight: 1.05, margin: '4px 0 4px', letterSpacing: '-0.01em' }}>
          Язык <em style={{ color: t.primary, fontStyle: 'italic' }}>приложения</em>
        </h1>
        <div style={{ fontSize: 13, color: t.inkSoft }}>Реплики растений тоже переведём — характер сохранится</div>
      </div>

      <div style={{ padding: '18px 16px 0' }}>
        <div style={{ background: t.surface, borderRadius: 22, border: `1px solid ${t.line}`, overflow: 'hidden' }}>
          {langs.map((l, i) => (
            <div key={i} style={{
              padding: '15px 16px', display: 'flex', alignItems: 'center', gap: 12,
              borderTop: i === 0 ? 'none' : `1px solid ${t.line}`,
              background: l.sel ? t.primarySoft : 'transparent',
            }}>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 15, fontWeight: 600, color: l.sel ? t.primary : t.ink }}>{l.native}</div>
                <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 1 }}>{l.en}</div>
              </div>
              {l.sel
                ? <window.Icon name="check" size={18} color={t.primary} stroke={2.4} />
                : <div style={{ width: 20, height: 20, borderRadius: 10, border: `2px solid ${t.line}` }} />}
            </div>
          ))}
        </div>
      </div>

      <div style={{ padding: '16px 22px 40px', fontSize: 12, color: t.inkMute, lineHeight: 1.5 }}>
        Системный язык устройства — русский. Дату и время форматируем по выбранному языку.
      </div>
    </div>
  );
}

Object.assign(window, { RoomsHomesScreen, SeasonalIntervalsScreen, TimePickerSheet, TimezonePickerScreen, LanguageScreen });
