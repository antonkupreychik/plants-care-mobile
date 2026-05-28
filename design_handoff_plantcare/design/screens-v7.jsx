// PlantCate — batch 6 — отпуск, совместный уход, онбординг пушей
// Хелперы из v5: window.pcIconBtn, PcSectionLabel, PcToggle, PcStepper

// ─────────────────────────────────────────────────────────────
// 25 · РЕЖИМ ОТПУСКА (POST /vacation · #53)
//      вход: Профиль 13 → «Включить режим»
// ─────────────────────────────────────────────────────────────
function VacationScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];
  const IB = window.pcIconBtn;

  // мини-полоса июня, выбран диапазон 1–14
  const days = Array.from({ length: 14 }, (_, i) => i + 1);
  const selFrom = 1, selTo = 14;

  const plants = [
    { name: 'Колючка', species: 'Кактус', art: 'cactus', wait: true, msg: 'продержусь месяц' },
    { name: 'Сьюзи', species: 'Суккулент', art: 'succulent', wait: true, msg: 'мне хватит запаса' },
    { name: 'Моника', species: 'Монстера', art: 'monstera', wait: false, msg: 'полей меня 8 июня' },
    { name: 'Фернандо', species: 'Папоротник', art: 'fern', wait: false, msg: 'не забудь опрыскать меня' },
  ];
  const PLANT_ART = { monstera: window.Monstera, fern: window.Fern, succulent: window.Succulent, pothos: window.Pothos, cactus: window.Cactus };
  const needSitter = plants.filter(p => !p.wait).length;

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'auto', position: 'relative' }}>
      <div style={{ padding: '16px 22px 8px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <button style={IB(t)}><window.Icon name="arrow-left" size={20} color={t.ink} /></button>
          <div style={{ fontSize: 12, fontWeight: 600, letterSpacing: '0.06em', color: t.inkSoft, textTransform: 'uppercase' }}>Режим отпуска</div>
          <div style={{ width: 40 }} />
        </div>
      </div>

      <div style={{ padding: '8px 22px 0' }}>
        <div style={{ fontSize: 40 }}>🏖</div>
        <h1 style={{ fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 34, lineHeight: 1.05, margin: '6px 0 4px', letterSpacing: '-0.01em' }}>
          Уезжаешь? <em style={{ color: t.primary, fontStyle: 'italic' }}>Сад подождёт</em>
        </h1>
        <div style={{ fontSize: 13, color: t.inkSoft, lineHeight: 1.5 }}>Поставим напоминания на паузу и подскажем, кому нужен догляд</div>
      </div>

      {/* DATE RANGE */}
      <div style={{ padding: '18px 16px 0' }}>
        <div style={{ background: t.surface, borderRadius: 22, padding: 16, border: `1px solid ${t.line}` }}>
          <div style={{ display: 'flex', gap: 10, marginBottom: 14 }}>
            {[{ l: 'С', v: '1 июня', d: 'Пн' }, { l: 'По', v: '14 июня', d: 'Вс' }].map((f, i) => (
              <div key={i} style={{ flex: 1, background: t.surfaceWarm, borderRadius: 16, padding: '12px 14px' }}>
                <div style={{ fontSize: 11, color: t.inkSoft, fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.04em' }}>{f.l}</div>
                <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 24, lineHeight: 1.1, marginTop: 2 }}>{f.v}</div>
                <div style={{ fontSize: 11, color: t.inkSoft }}>{f.d}</div>
              </div>
            ))}
          </div>
          {/* day strip */}
          <div style={{ display: 'flex', gap: 3 }}>
            {days.map(d => {
              const inRange = d >= selFrom && d <= selTo;
              const edge = d === selFrom || d === selTo;
              return (
                <div key={d} style={{
                  flex: 1, height: 30, borderRadius: 8,
                  background: edge ? t.primary : inRange ? t.primarySoft : t.surfaceWarm,
                  color: edge ? t.surface : inRange ? t.primary : t.inkMute,
                  display: 'grid', placeItems: 'center', fontSize: 10, fontWeight: 700,
                }}>{d}</div>
              );
            })}
          </div>
          <div style={{ textAlign: 'center', marginTop: 12, fontSize: 13, fontWeight: 700, color: t.primary }}>14 дней без забот</div>
        </div>
      </div>

      {/* WHAT HAPPENS */}
      <div style={{ padding: '20px 16px 0' }}>
        <window.PcSectionLabel t={t}>Что будет с садом</window.PcSectionLabel>
        <div style={{ display: 'flex', gap: 10 }}>
          <div style={{ flex: 1, background: t.surface, borderRadius: 18, padding: 14, border: `1px solid ${t.line}` }}>
            <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 30, color: t.primary, lineHeight: 1 }}>{plants.length - needSitter}</div>
            <div style={{ fontSize: 12, color: t.inkSoft, marginTop: 4, lineHeight: 1.3 }}>переживут сами</div>
          </div>
          <div style={{ flex: 1, background: theme === 'dark' ? 'rgba(199,123,92,0.12)' : '#FBEFE4', borderRadius: 18, padding: 14, border: `1px solid ${theme === 'dark' ? 'rgba(216,145,114,0.25)' : '#F0DDC8'}` }}>
            <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 30, color: t.terracotta, lineHeight: 1 }}>{needSitter}</div>
            <div style={{ fontSize: 12, color: t.inkSoft, marginTop: 4, lineHeight: 1.3 }}>нужен догляд</div>
          </div>
        </div>
      </div>

      {/* PLANT LIST */}
      <div style={{ padding: '16px 16px 0', display: 'flex', flexDirection: 'column', gap: 8 }}>
        {plants.map((p, i) => {
          const Art = PLANT_ART[p.art];
          return (
            <div key={i} style={{
              background: t.surface, borderRadius: 18, padding: '10px 14px',
              border: `1px solid ${t.line}`, display: 'flex', alignItems: 'center', gap: 12,
              opacity: p.wait ? 0.72 : 1,
            }}>
              <div style={{ width: 42, height: 42, borderRadius: 13, background: t.surfaceWarm, display: 'grid', placeItems: 'center', flexShrink: 0 }}>
                <Art t={t} size={38} />
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 14, fontWeight: 700 }}>{p.name}</div>
                <div style={{ fontSize: 12, color: t.inkSoft, fontStyle: 'italic', fontFamily: '"Instrument Serif", serif', fontSize: 13, marginTop: 1 }}>«{p.msg}»</div>
              </div>
              <span style={{
                fontSize: 10, fontWeight: 700, letterSpacing: '0.04em', padding: '4px 8px', borderRadius: 8,
                background: p.wait ? t.primarySoft : (theme === 'dark' ? 'rgba(216,145,114,0.18)' : '#FBEFE4'),
                color: p.wait ? t.primary : t.terracotta,
              }}>{p.wait ? 'ОК' : 'ДОГЛЯД'}</span>
            </div>
          );
        })}
      </div>

      {/* HANDOFF */}
      <div style={{ padding: '18px 16px 0' }}>
        <div style={{ background: t.surface, borderRadius: 22, border: `1px solid ${t.line}`, overflow: 'hidden' }}>
          <div style={{ padding: '14px 16px', display: 'flex', alignItems: 'center', gap: 12 }}>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 14, fontWeight: 600 }}>Поставить пуши на паузу</div>
              <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 1 }}>Не будем напоминать до 14 июня</div>
            </div>
            <window.PcToggle t={t} on />
          </div>
          <div style={{ borderTop: `1px solid ${t.line}`, padding: '14px 16px', display: 'flex', alignItems: 'center', gap: 12 }}>
            <div style={{ width: 36, height: 36, borderRadius: 18, background: '#E4B673', display: 'grid', placeItems: 'center', color: '#fff', fontFamily: '"Instrument Serif", serif', fontSize: 16, flexShrink: 0 }}>М</div>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 14, fontWeight: 600 }}>Передать догляд Мише</div>
              <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 1 }}>Получит 4 растения с доглядом</div>
            </div>
            <window.PcToggle t={t} on={false} />
          </div>
        </div>
      </div>

      {/* CTA */}
      <div style={{ height: 96 }} />
      <div style={{ position: 'absolute', left: 0, right: 0, bottom: 0, padding: '14px 16px 18px', background: `linear-gradient(to top, ${t.bg} 72%, ${t.bg}00)` }}>
        <button style={{
          width: '100%', padding: '16px', borderRadius: 20, background: t.ink, color: t.surface,
          border: 'none', fontSize: 15, fontWeight: 600, fontFamily: 'inherit',
        }}>Включить отпуск · 1–14 июня</button>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 26 · СОВМЕСТНЫЙ УХОД (POST /sharing/invites · #77)
//      вход: Профиль 13 → «Передать уход» / «Пригласить ещё»
// ─────────────────────────────────────────────────────────────
function SharingScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];
  const IB = window.pcIconBtn;

  const plants = [
    { name: 'Моника', species: 'Монстера', art: 'monstera', on: true },
    { name: 'Фернандо', species: 'Папоротник', art: 'fern', on: true },
    { name: 'Колючка', species: 'Кактус', art: 'cactus', on: true },
    { name: 'Сьюзи', species: 'Суккулент', art: 'succulent', on: false },
    { name: 'Перси', species: 'Эпипремнум', art: 'pothos', on: false },
  ];
  const PLANT_ART = { monstera: window.Monstera, fern: window.Fern, succulent: window.Succulent, pothos: window.Pothos, cactus: window.Cactus };
  const chosen = plants.filter(p => p.on).length;

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'auto', position: 'relative' }}>
      <div style={{ padding: '16px 22px 8px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <button style={IB(t)}><window.Icon name="arrow-left" size={20} color={t.ink} /></button>
          <div style={{ fontSize: 12, fontWeight: 600, letterSpacing: '0.06em', color: t.inkSoft, textTransform: 'uppercase' }}>Совместный уход</div>
          <div style={{ width: 40 }} />
        </div>
      </div>

      <div style={{ padding: '8px 22px 0' }}>
        <h1 style={{ fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 34, lineHeight: 1.05, margin: '4px 0 4px', letterSpacing: '-0.01em' }}>
          Ухаживайте <em style={{ color: t.primary, fontStyle: 'italic' }}>вместе</em>
        </h1>
        <div style={{ fontSize: 13, color: t.inkSoft, lineHeight: 1.5 }}>Близкий человек сможет отмечать полив, пока тебя нет</div>
      </div>

      {/* CURRENT CARERS */}
      <div style={{ padding: '18px 16px 0' }}>
        <window.PcSectionLabel t={t}>Помогают сейчас</window.PcSectionLabel>
        <div style={{ background: t.surface, borderRadius: 22, border: `1px solid ${t.line}`, padding: '12px 16px', display: 'flex', alignItems: 'center', gap: 12 }}>
          <div style={{ width: 40, height: 40, borderRadius: 20, background: '#E4B673', display: 'grid', placeItems: 'center', color: '#fff', fontFamily: '"Instrument Serif", serif', fontSize: 18, flexShrink: 0 }}>М</div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 14, fontWeight: 600 }}>Миша</div>
            <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 1 }}>3 растения · приглашение отправлено</div>
          </div>
          <div style={{ fontSize: 10, color: t.terracotta, fontWeight: 700, letterSpacing: '0.04em', padding: '3px 8px', borderRadius: 6, background: theme === 'dark' ? 'rgba(216,145,114,0.15)' : '#FBEFE4' }}>ОЖИДАЕТ</div>
        </div>
      </div>

      {/* INVITE */}
      <div style={{ padding: '20px 16px 0' }}>
        <window.PcSectionLabel t={t}>Пригласить</window.PcSectionLabel>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10, background: t.surface, borderRadius: 18, padding: '14px 16px', border: `1px solid ${t.line}` }}>
          <window.Icon name="user" size={18} color={t.inkSoft} stroke={1.8} />
          <input type="text" placeholder="@username или телефон" style={{ flex: 1, border: 'none', outline: 'none', background: 'transparent', fontFamily: 'inherit', fontSize: 14, color: t.ink }} />
        </div>
      </div>

      {/* SELECT PLANTS */}
      <div style={{ padding: '20px 16px 0' }}>
        <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', padding: '0 6px' }}>
          <window.PcSectionLabel t={t} style={{ padding: '6px 0 10px' }}>Какие растения доверить</window.PcSectionLabel>
          <span style={{ fontSize: 12, color: t.primary, fontWeight: 700 }}>{chosen} выбрано</span>
        </div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
          {plants.map((p, i) => {
            const Art = PLANT_ART[p.art];
            return (
              <div key={i} style={{
                background: t.surface, borderRadius: 18, padding: '10px 14px',
                border: `1px solid ${p.on ? t.primarySoft : t.line}`,
                display: 'flex', alignItems: 'center', gap: 12,
              }}>
                <div style={{ width: 42, height: 42, borderRadius: 13, background: t.surfaceWarm, display: 'grid', placeItems: 'center', flexShrink: 0 }}>
                  <Art t={t} size={38} />
                </div>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{ fontSize: 14, fontWeight: 700 }}>{p.name}</div>
                  <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 1 }}>{p.species}</div>
                </div>
                {/* checkbox */}
                <div style={{
                  width: 26, height: 26, borderRadius: 9, flexShrink: 0,
                  background: p.on ? t.primary : 'transparent',
                  border: p.on ? 'none' : `2px solid ${t.line}`,
                  display: 'grid', placeItems: 'center',
                }}>
                  {p.on && <window.Icon name="check" size={15} color={t.surface} stroke={2.6} />}
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* PERMISSION */}
      <div style={{ padding: '18px 16px 0' }}>
        <div style={{ background: t.surface, borderRadius: 22, border: `1px solid ${t.line}`, padding: '14px 16px', display: 'flex', alignItems: 'center', gap: 12 }}>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 14, fontWeight: 600 }}>Может отмечать уход</div>
            <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 1 }}>Иначе — только смотреть расписание</div>
          </div>
          <window.PcToggle t={t} on />
        </div>
      </div>

      {/* CTA */}
      <div style={{ height: 96 }} />
      <div style={{ position: 'absolute', left: 0, right: 0, bottom: 0, padding: '14px 16px 18px', background: `linear-gradient(to top, ${t.bg} 72%, ${t.bg}00)` }}>
        <button style={{
          width: '100%', padding: '16px', borderRadius: 20, background: t.ink, color: t.surface,
          border: 'none', fontSize: 15, fontWeight: 600, fontFamily: 'inherit',
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10,
        }}>
          <window.Icon name="plus" size={18} color={t.surface} stroke={2.2} />
          Отправить приглашение
        </button>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 27 · ОНБОРДИНГ · разрешение на пуши (POST /devices)
//      вход: после Привет (09)
// ─────────────────────────────────────────────────────────────
function PushPermissionScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'hidden', position: 'relative', display: 'flex', flexDirection: 'column' }}>
      {/* skip */}
      <div style={{ padding: '16px 22px 0', display: 'flex', justifyContent: 'flex-end' }}>
        <span style={{ fontSize: 13, color: t.inkSoft, fontWeight: 600 }}>Позже</span>
      </div>

      {/* HERO illustration */}
      <div style={{ flex: 1, display: 'grid', placeItems: 'center', position: 'relative', overflow: 'hidden' }}>
        <div style={{ position: 'absolute', width: 280, height: 280, borderRadius: '50%', background: t.primarySoft, opacity: 0.7 }} />
        <div style={{ position: 'relative', textAlign: 'center' }}>
          <window.Monstera t={t} size={180} />
          {/* bell badge */}
          <div style={{
            position: 'absolute', top: 8, right: -6, width: 56, height: 56, borderRadius: 20,
            background: t.ink, display: 'grid', placeItems: 'center',
            boxShadow: '0 12px 30px rgba(0,0,0,0.25)', transform: 'rotate(8deg)',
          }}>
            <window.Icon name="bell" size={26} color={t.fabInk} stroke={1.8} />
            <span style={{ position: 'absolute', top: 12, right: 14, width: 10, height: 10, borderRadius: 5, background: t.terracotta, border: `2px solid ${t.ink}` }} />
          </div>
        </div>
      </div>

      {/* TEXT */}
      <div style={{ padding: '0 28px' }}>
        <h1 style={{ fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 38, lineHeight: 1.05, margin: '0 0 10px', letterSpacing: '-0.01em', textAlign: 'center' }}>
          Я напомню <em style={{ color: t.primary, fontStyle: 'italic' }}>вовремя</em>
        </h1>
        <div style={{ fontSize: 15, color: t.inkSoft, lineHeight: 1.5, textAlign: 'center', textWrap: 'pretty' }}>
          Растения будут писать тебе сами — когда захотят пить, и только в удобные часы. Без спама.
        </div>
      </div>

      {/* sample notification preview */}
      <div style={{ padding: '20px 22px 0' }}>
        <div style={{
          background: t.surface, borderRadius: 20, padding: '12px 14px', border: `1px solid ${t.line}`,
          display: 'flex', alignItems: 'center', gap: 12, boxShadow: '0 10px 30px rgba(0,0,0,0.08)',
        }}>
          <div style={{ width: 40, height: 40, borderRadius: 12, background: t.surfaceWarm, display: 'grid', placeItems: 'center', flexShrink: 0 }}>
            <window.Monstera t={t} size={36} />
          </div>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{ fontSize: 13, fontWeight: 700 }}>Моника · сейчас</div>
            <div style={{ fontSize: 13, color: t.inkSoft, fontStyle: 'italic', fontFamily: '"Instrument Serif", serif', fontSize: 14, marginTop: 1 }}>«Полей меня, пожалуйста!»</div>
          </div>
          <span style={{ fontSize: 18 }}>💧</span>
        </div>
      </div>

      {/* CTA */}
      <div style={{ padding: '22px 22px 28px' }}>
        <button style={{
          width: '100%', padding: '16px', borderRadius: 20, background: t.ink, color: t.surface,
          border: 'none', fontSize: 15, fontWeight: 600, fontFamily: 'inherit', marginBottom: 10,
        }}>Разрешить уведомления</button>
        <div style={{ textAlign: 'center', fontSize: 12, color: t.inkMute }}>Можно изменить в любой момент в настройках</div>
      </div>
    </div>
  );
}

Object.assign(window, { VacationScreen, SharingScreen, PushPermissionScreen });
