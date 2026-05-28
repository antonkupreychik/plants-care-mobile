// PlantCate — batch 5 (часть 2) — Настройки тихих часов + Лента уведомлений
// Использует хелперы из screens-v5.jsx: window.pcIconBtn, PcSectionLabel, PcToggle

// ─────────────────────────────────────────────────────────────
// 23 · ТИХИЕ ЧАСЫ И ВРЕМЯ (PATCH /me · #116)
//      вход: Профиль 13 → «Тихие часы» / «Таймзона»
// ─────────────────────────────────────────────────────────────
function QuietHoursScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];
  const IB = window.pcIconBtn;

  // 24h циферблат: тихо 22:00→8:00. 0:00 наверху, час = деление 15°
  const quietColor = theme === 'dark' ? '#2B3550' : '#C9CFE0';
  const activeColor = t.primary;
  // conic от 12 часов (0:00). 0–8 тихо (0–120deg), 8–22 активно (120–330deg), 22–24 тихо (330–360deg)
  const ringBg = `conic-gradient(${quietColor} 0deg 120deg, ${activeColor} 120deg 330deg, ${quietColor} 330deg 360deg)`;

  const hourMarks = [
    { h: 0, label: '0', x: '50%', y: '7%' },
    { h: 6, label: '6', x: '93%', y: '50%' },
    { h: 12, label: '12', x: '50%', y: '93%' },
    { h: 18, label: '18', x: '7%', y: '50%' },
  ];

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'auto', position: 'relative' }}>
      <div style={{ padding: '16px 22px 8px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <button style={IB(t)}><window.Icon name="arrow-left" size={20} color={t.ink} /></button>
          <div style={{ fontSize: 12, fontWeight: 600, letterSpacing: '0.06em', color: t.inkSoft, textTransform: 'uppercase' }}>Уведомления и время</div>
          <div style={{ width: 40 }} />
        </div>
      </div>

      <div style={{ padding: '8px 22px 0' }}>
        <h1 style={{ fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 34, lineHeight: 1.05, margin: '4px 0 4px', letterSpacing: '-0.01em' }}>
          Тихие <em style={{ color: t.primary, fontStyle: 'italic' }}>часы</em>
        </h1>
        <div style={{ fontSize: 13, color: t.inkSoft }}>Ночью растения подождут до утра — не разбудят пушем</div>
      </div>

      {/* CLOCK DIAL */}
      <div style={{ display: 'grid', placeItems: 'center', padding: '22px 0 6px' }}>
        <div style={{ position: 'relative', width: 230, height: 230 }}>
          <div style={{ position: 'absolute', inset: 0, borderRadius: '50%', background: ringBg }} />
          {/* hour marks */}
          {hourMarks.map(m => (
            <div key={m.h} style={{
              position: 'absolute', left: m.x, top: m.y, transform: 'translate(-50%,-50%)',
              fontSize: 11, fontWeight: 700, color: 'rgba(255,255,255,0.9)',
            }}>{m.label}</div>
          ))}
          {/* inner hole */}
          <div style={{
            position: 'absolute', inset: 34, borderRadius: '50%', background: t.bg,
            display: 'grid', placeItems: 'center', textAlign: 'center',
            boxShadow: 'inset 0 2px 8px rgba(0,0,0,0.06)',
          }}>
            <div>
              <div style={{ fontSize: 26 }}>🌙</div>
              <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 30, lineHeight: 1, marginTop: 4, letterSpacing: '-0.01em' }}>
                22:00<span style={{ color: t.inkMute }}> – </span>8:00
              </div>
              <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 4, fontWeight: 600 }}>10 часов тишины</div>
            </div>
          </div>
        </div>
        {/* legend */}
        <div style={{ display: 'flex', gap: 18, marginTop: 16 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: 11, color: t.inkSoft, fontWeight: 600 }}>
            <span style={{ width: 10, height: 10, borderRadius: 3, background: activeColor }} /> Напоминания идут
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: 11, color: t.inkSoft, fontWeight: 600 }}>
            <span style={{ width: 10, height: 10, borderRadius: 3, background: quietColor }} /> Тишина
          </div>
        </div>
      </div>

      {/* TIME FIELDS */}
      <div style={{ padding: '18px 16px 0' }}>
        <div style={{ display: 'flex', gap: 10 }}>
          {[
            { l: 'Засыпаю в', v: '22:00' },
            { l: 'Просыпаюсь в', v: '8:00' },
          ].map((f, i) => (
            <div key={i} style={{
              flex: 1, background: t.surface, borderRadius: 18, padding: '14px 16px',
              border: `1px solid ${t.line}`,
            }}>
              <div style={{ fontSize: 11, color: t.inkSoft, fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.04em' }}>{f.l}</div>
              <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', marginTop: 4 }}>
                <span style={{ fontFamily: '"Instrument Serif", serif', fontSize: 30, lineHeight: 1, letterSpacing: '-0.01em' }}>{f.v}</span>
                <window.Icon name="arrow-left" size={14} color={t.inkSoft} stroke={2} style={{ transform: 'rotate(-90deg)' }} />
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* OPTIONS */}
      <div style={{ padding: '20px 16px 0' }}>
        <window.PcSectionLabel t={t}>Параметры</window.PcSectionLabel>
        <div style={{ background: t.surface, borderRadius: 22, border: `1px solid ${t.line}`, overflow: 'hidden' }}>
          <div style={{ padding: '14px 16px', display: 'flex', alignItems: 'center', gap: 12 }}>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 14, fontWeight: 600 }}>Не беспокоить ночью</div>
              <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 1 }}>Перенести просроченное на утро</div>
            </div>
            <window.PcToggle t={t} on />
          </div>
          <div style={{ borderTop: `1px solid ${t.line}`, padding: '14px 16px', display: 'flex', alignItems: 'center', gap: 12 }}>
            <div style={{ flex: 1, fontSize: 14, fontWeight: 600 }}>Таймзона</div>
            <div style={{ fontSize: 13, color: t.inkSoft }}>Europe/Moscow · GMT+3</div>
            <window.Icon name="arrow-left" size={14} color={t.inkSoft} stroke={2} style={{ transform: 'scaleX(-1)' }} />
          </div>
          <div style={{ borderTop: `1px solid ${t.line}`, padding: '14px 16px', display: 'flex', alignItems: 'center', gap: 12 }}>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 14, fontWeight: 600 }}>Утренний дайджест</div>
              <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 1 }}>Все заботы дня одним сообщением</div>
            </div>
            <div style={{ fontSize: 13, color: t.inkSoft }}>9:00</div>
            <window.Icon name="arrow-left" size={14} color={t.inkSoft} stroke={2} style={{ transform: 'scaleX(-1)' }} />
          </div>
        </div>
      </div>

      {/* voice note */}
      <div style={{
        margin: '16px 16px 40px', padding: '14px 16px', borderRadius: 18,
        background: t.primarySoft, display: 'flex', gap: 12, alignItems: 'flex-start',
        position: 'relative', overflow: 'hidden',
      }}>
        <span style={{ fontSize: 20, flexShrink: 0 }}>🌿</span>
        <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 16, fontStyle: 'italic', lineHeight: 1.4, color: t.ink }}>
          «Если меня надо полить в 3 ночи — напомню в 8 утра. Спи спокойно.»
        </div>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 24 · ЛЕНТА УВЕДОМЛЕНИЙ (GET /notifications · #12.9)
//      вход: тап по 🔔 на Главной 01
// ─────────────────────────────────────────────────────────────
function NotificationsInboxScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];
  const IB = window.pcIconBtn;

  // kind: care | alert | report | award | system  → визуальный значок
  const groups = [
    {
      label: 'Сегодня', items: [
        { kind: 'alert', art: 'fern', plant: 'Фернандо', text: '«Мне совсем сухо — опрыскай, пожалуйста!»', meta: 'Опрыскивание · просрочено вчера', time: '9:00', unread: true, action: 'Опрыскать', tint: t.terracotta, over: true },
        { kind: 'care', art: 'monstera', plant: 'Моника', text: '«Доброе утро! Загляни ко мне сегодня вечером 💧»', meta: 'Полив · сегодня в 19:00', time: '8:00', unread: true, action: 'Полить', tint: t.primary },
        { kind: 'alert', icon: 'heart', plant: 'Доктор PlantCate', text: 'Фернандо грустит уже 3 дня. Посмотри, что можно поправить.', meta: 'Авто‑диагностика', time: '7:30', unread: true, action: 'Открыть диагноз', tint: t.terracotta },
      ],
    },
    {
      label: 'Вчера', items: [
        { kind: 'award', icon: 'check', plant: 'Стрик 47 дней!', text: 'Почти семь недель без единого пропуска. Ты лучший(ая) садовник.', meta: 'Достижение', time: 'вчера, 23:01', tint: t.primary },
        { kind: 'system', art: 'monstera', plant: 'Черенок Моники', text: 'Дал первый корешок 🌱 Можно пересаживать в грунт.', meta: 'Размножение', time: 'вчера, 14:20', tint: t.leaf },
      ],
    },
    {
      label: 'Ранее', items: [
        { kind: 'report', icon: 'calendar', plant: 'Отчёт за апрель', text: 'Апрель был зелёным: 94% забот вовремя. Загляни в итоги месяца.', meta: 'Месячный отчёт', time: '1 мая', tint: t.leafDark, action: 'Смотреть отчёт' },
        { kind: 'care', art: 'succulent', plant: 'Сьюзи', text: '«Распустила цветок 🌸 спасибо за свет!»', meta: 'Заметка растения', time: '28 апр', tint: t.primary },
      ],
    },
  ];

  const PLANT_ART = { monstera: window.Monstera, fern: window.Fern, succulent: window.Succulent, pothos: window.Pothos, cactus: window.Cactus };

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'auto', position: 'relative' }}>
      <div style={{ padding: '16px 22px 8px', position: 'sticky', top: 0, background: t.bg, zIndex: 5 }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 8 }}>
          <button style={IB(t)}><window.Icon name="arrow-left" size={20} color={t.ink} /></button>
          <div style={{ fontSize: 12, fontWeight: 600, letterSpacing: '0.06em', color: t.inkSoft, textTransform: 'uppercase' }}>Уведомления</div>
          <button style={{ ...IB(t), width: 'auto', padding: '0 12px', fontSize: 12, fontWeight: 600, fontFamily: 'inherit', color: t.primary }}>Прочитать</button>
        </div>
        <h1 style={{ fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 32, lineHeight: 1.05, margin: '4px 0 0', letterSpacing: '-0.01em' }}>
          <em style={{ color: t.primary, fontStyle: 'italic' }}>3</em> новых от твоего сада
        </h1>
      </div>

      <div style={{ padding: '8px 16px 40px' }}>
        {groups.map((g, gi) => (
          <div key={gi}>
            <window.PcSectionLabel t={t} style={{ padding: '14px 6px 8px' }}>{g.label}</window.PcSectionLabel>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
              {g.items.map((n, i) => {
                const Art = n.art ? PLANT_ART[n.art] : null;
                return (
                  <div key={i} style={{
                    background: n.unread ? (theme === 'dark' ? 'rgba(183,208,140,0.07)' : '#FBF7EC') : t.surface,
                    borderRadius: 20, padding: 14,
                    border: `1px solid ${n.unread ? (theme === 'dark' ? 'rgba(183,208,140,0.18)' : t.primarySoft) : t.line}`,
                    display: 'flex', gap: 12, position: 'relative',
                  }}>
                    {/* avatar */}
                    <div style={{
                      width: 48, height: 48, borderRadius: 16, flexShrink: 0,
                      background: Art ? t.surfaceWarm : n.tint,
                      display: 'grid', placeItems: 'center', position: 'relative',
                    }}>
                      {Art ? <Art t={t} size={42} /> : <window.Icon name={n.icon} size={22} color="#fff" stroke={2} />}
                      {/* type badge for plant notifs */}
                      {Art && (
                        <div style={{
                          position: 'absolute', bottom: -3, right: -3, width: 20, height: 20, borderRadius: 10,
                          background: n.tint, border: `2px solid ${n.unread ? (theme === 'dark' ? '#1b2218' : '#FBF7EC') : t.surface}`,
                          display: 'grid', placeItems: 'center',
                        }}>
                          <window.Icon name={n.kind === 'alert' ? 'spray' : (n.kind === 'system' ? 'leaf' : 'drop')} size={11} color="#fff" stroke={2.4} />
                        </div>
                      )}
                    </div>

                    <div style={{ flex: 1, minWidth: 0 }}>
                      <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', gap: 8 }}>
                        <span style={{ fontSize: 14, fontWeight: 700, color: n.over ? t.terracotta : t.ink }}>{n.plant}</span>
                        <span style={{ fontSize: 11, color: t.inkSoft, flexShrink: 0 }}>{n.time}</span>
                      </div>
                      <div style={{
                        fontSize: 13, color: t.ink, marginTop: 3, lineHeight: 1.4,
                        fontFamily: n.text.startsWith('«') ? '"Instrument Serif", serif' : 'inherit',
                        fontStyle: n.text.startsWith('«') ? 'italic' : 'normal',
                        fontSize: n.text.startsWith('«') ? 15 : 13,
                      }}>{n.text}</div>
                      <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 8, flexWrap: 'wrap' }}>
                        <span style={{ fontSize: 10, fontWeight: 700, color: t.inkSoft, letterSpacing: '0.04em', textTransform: 'uppercase' }}>{n.meta}</span>
                        {n.action && (
                          <button style={{
                            marginLeft: 'auto', padding: '7px 12px', borderRadius: 999,
                            background: n.over ? t.terracotta : t.ink, color: '#fff', border: 'none',
                            fontSize: 12, fontWeight: 600, fontFamily: 'inherit', whiteSpace: 'nowrap', flexShrink: 0,
                          }}>{n.action}</button>
                        )}
                      </div>
                    </div>

                    {n.unread && <span style={{ position: 'absolute', top: 16, right: 14, width: 8, height: 8, borderRadius: 4, background: t.terracotta }} />}
                  </div>
                );
              })}
            </div>
          </div>
        ))}

        {/* end */}
        <div style={{ textAlign: 'center', padding: '24px 0 0', fontSize: 12, color: t.inkMute, fontStyle: 'italic', fontFamily: '"Instrument Serif", serif', fontSize: 14 }}>
          Это всё. Твой сад в порядке 🌿
        </div>
      </div>
    </div>
  );
}

Object.assign(window, { QuietHoursScreen, NotificationsInboxScreen });
