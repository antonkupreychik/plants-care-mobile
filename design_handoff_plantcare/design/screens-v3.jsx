// PlantCate — final batch
// 04a · Шаг 1 (Выбор вида) · 04b · Шаг 2 (Имя + комната) · 04c · Шаг 4 (Место и фото)
// 06a · Опрыскать (sheet) · 06b · Удобрить (sheet) · 10 · Пустое состояние главной

// ─────────────────────────────────────────────────────────────
// Add plant — STEP 1 · Выбор вида
// ─────────────────────────────────────────────────────────────
function AddPlantStep1Screen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];
  const Monstera = window.Monstera, Fern = window.Fern, Succulent = window.Succulent, Pothos = window.Pothos, Cactus = window.Cactus;

  const species = [
    { id: 'monstera', ru: 'Монстера', latin: 'Monstera deliciosa', art: 'monstera', diff: 'Лёгкая', diffColor: t.primary, popular: true },
    { id: 'pothos',   ru: 'Эпипремнум', latin: 'Epipremnum aureum', art: 'pothos', diff: 'Лёгкая', diffColor: t.primary },
    { id: 'fern',     ru: 'Папоротник', latin: 'Nephrolepis', art: 'fern', diff: 'Средне', diffColor: t.terracotta },
    { id: 'succulent',ru: 'Суккулент', latin: 'Echeveria', art: 'succulent', diff: 'Очень лёгкая', diffColor: t.primary },
    { id: 'cactus',   ru: 'Кактус',   latin: 'Cactaceae', art: 'cactus', diff: 'Очень лёгкая', diffColor: t.primary },
  ];
  const PLANT_ART = { monstera: Monstera, fern: Fern, succulent: Succulent, pothos: Pothos, cactus: Cactus };

  return (
    <div style={{
      width: '100%', height: '100%', background: t.bg, color: t.ink,
      fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif',
      overflow: 'auto', position: 'relative',
    }}>
      {/* HEADER */}
      <div style={{ padding: '16px 22px 8px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 18 }}>
          <button style={iconBtnV3(t, true)}><window.Icon name="arrow-left" size={20} color={t.ink} /></button>
          <span style={{ fontSize: 13, color: t.inkSoft, fontWeight: 600 }}>Шаг 1 из 4</span>
          <span style={{ fontSize: 13, color: t.primary, fontWeight: 600 }}>Пропустить</span>
        </div>
        <div style={{ display: 'flex', gap: 4 }}>
          {[1, 0, 0, 0].map((done, i) => (
            <div key={i} style={{ flex: 1, height: 4, borderRadius: 2, background: done ? t.primary : t.line }} />
          ))}
        </div>
      </div>

      {/* TITLE */}
      <div style={{ padding: '20px 22px 0' }}>
        <div style={{ fontSize: 12, color: t.inkSoft, fontWeight: 600, letterSpacing: '0.06em', textTransform: 'uppercase' }}>
          Новое растение
        </div>
        <h1 style={{
          fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 36,
          lineHeight: 1.05, margin: '4px 0 6px', letterSpacing: '-0.01em',
        }}>
          Какое растение <em style={{ color: t.primary, fontStyle: 'italic' }}>у тебя</em>?
        </h1>
        <div style={{ fontSize: 14, color: t.inkSoft, lineHeight: 1.4 }}>
          Найдём вид, подберём имя и расписание ухода. Если не знаешь — ничего страшного.
        </div>
      </div>

      {/* SEARCH */}
      <div style={{ padding: '18px 22px 0' }}>
        <div style={{
          display: 'flex', alignItems: 'center', gap: 10,
          background: t.surface, borderRadius: 18, padding: '12px 14px',
          border: `1px solid ${t.line}`,
        }}>
          <window.Icon name="search" size={18} color={t.inkSoft} stroke={1.8} />
          <input type="text" placeholder="монстера, фикус, суккулент…" style={{
            flex: 1, border: 'none', outline: 'none', background: 'transparent',
            fontFamily: 'inherit', fontSize: 14, color: t.ink,
          }} />
          <div style={{
            padding: '4px 10px', borderRadius: 999,
            background: t.primarySoft, color: t.primary,
            fontSize: 11, fontWeight: 700, letterSpacing: '0.04em',
          }}>
            FOTO
          </div>
        </div>
        <div style={{
          marginTop: 10, padding: '10px 12px', borderRadius: 14,
          background: theme === 'dark' ? 'rgba(199,123,92,0.10)' : '#FBEFE4',
          display: 'flex', alignItems: 'center', gap: 10,
          fontSize: 12, color: t.ink,
        }}>
          <div style={{
            width: 24, height: 24, borderRadius: 8, background: t.terracotta,
            display: 'grid', placeItems: 'center',
          }}>
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <rect x="3" y="6" width="18" height="14" rx="2" />
              <circle cx="12" cy="13" r="3.5" />
            </svg>
          </div>
          <span style={{ flex: 1 }}>Сфотографируй — определим по листу</span>
          <window.Icon name="arrow-left" size={14} color={t.inkSoft} stroke={2} style={{ transform: 'scaleX(-1)' }} />
        </div>
      </div>

      {/* CATEGORY ROW */}
      <div style={{
        display: 'flex', gap: 8, padding: '16px 22px 12px', overflowX: 'auto',
      }}>
        {[
          { l: 'Популярное', active: true },
          { l: 'Для новичка' },
          { l: 'Цветущие' },
          { l: 'Без полива' },
        ].map((c, i) => (
          <div key={i} style={{
            padding: '8px 14px', borderRadius: 999, whiteSpace: 'nowrap',
            background: c.active ? t.ink : t.chipBg,
            color: c.active ? t.surface : t.ink,
            fontSize: 13, fontWeight: 600,
          }}>{c.l}</div>
        ))}
      </div>

      {/* SPECIES LIST */}
      <div style={{ padding: '0 16px 110px', display: 'flex', flexDirection: 'column', gap: 10 }}>
        {species.map((s, i) => {
          const Art = PLANT_ART[s.art];
          const selected = i === 0;
          return (
            <div key={s.id} style={{
              background: t.surface, borderRadius: 22, padding: 14,
              border: selected ? `2px solid ${t.primary}` : `1px solid ${t.line}`,
              display: 'flex', alignItems: 'center', gap: 14,
              position: 'relative', overflow: 'hidden',
            }}>
              <div style={{
                width: 64, height: 64, borderRadius: 18, background: t.surfaceWarm,
                display: 'grid', placeItems: 'center', flexShrink: 0,
              }}>
                <Art t={t} size={58} />
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 6, flexWrap: 'wrap' }}>
                  <span style={{
                    fontFamily: '"Instrument Serif", serif', fontSize: 22, lineHeight: 1,
                    letterSpacing: '-0.01em',
                  }}>{s.ru}</span>
                  {s.popular && (
                    <span style={{
                      fontSize: 10, fontWeight: 700, color: t.terracotta,
                      background: theme === 'dark' ? 'rgba(216,145,114,0.15)' : '#F9E3D8',
                      padding: '2px 6px', borderRadius: 4, letterSpacing: '0.04em',
                    }}>HIT</span>
                  )}
                </div>
                <div style={{ fontSize: 12, color: t.inkSoft, fontStyle: 'italic', marginTop: 2 }}>
                  {s.latin}
                </div>
                <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginTop: 6 }}>
                  <span style={{ width: 6, height: 6, borderRadius: 3, background: s.diffColor }} />
                  <span style={{ fontSize: 11, color: t.inkSoft, fontWeight: 600 }}>{s.diff}</span>
                </div>
              </div>
              {selected ? (
                <div style={{
                  width: 28, height: 28, borderRadius: 14, background: t.primary,
                  display: 'grid', placeItems: 'center', flexShrink: 0,
                }}>
                  <window.Icon name="check" size={16} color={t.surface} stroke={2.4} />
                </div>
              ) : (
                <div style={{ fontSize: 18, color: t.inkMute }}>›</div>
              )}
            </div>
          );
        })}

        {/* unknown plant */}
        <div style={{
          marginTop: 6, padding: '14px 16px', borderRadius: 22,
          background: 'transparent', border: `1.5px dashed ${t.line}`,
          display: 'flex', alignItems: 'center', gap: 12,
        }}>
          <div style={{
            width: 40, height: 40, borderRadius: 14, background: t.surfaceWarm,
            display: 'grid', placeItems: 'center', flexShrink: 0,
            fontFamily: '"Instrument Serif", serif', fontSize: 22, color: t.inkSoft,
          }}>?</div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 14, fontWeight: 600 }}>Не знаю, что это</div>
            <div style={{ fontSize: 12, color: t.inkSoft, marginTop: 1 }}>
              Заведём как «Растение». Позже уточним.
            </div>
          </div>
          <window.Icon name="arrow-left" size={16} color={t.inkSoft} stroke={2} style={{ transform: 'scaleX(-1)' }} />
        </div>
      </div>

      {/* BOTTOM CTA */}
      <BottomActionBar t={t}>
        <button style={ctaPrimary(t)}>
          Дальше — имя
          <window.Icon name="arrow-left" size={18} color={t.surface} stroke={2} style={{ transform: 'scaleX(-1)' }} />
        </button>
      </BottomActionBar>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Add plant — STEP 2 · Имя и комната
// ─────────────────────────────────────────────────────────────
function AddPlantStep2Screen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];

  const rooms = [
    { id: 'living', label: 'Гостиная', icon: '🛋' },
    { id: 'bedroom', label: 'Спальня', icon: '🛏' },
    { id: 'kitchen', label: 'Кухня', icon: '🍳' },
    { id: 'bath', label: 'Ванная', icon: '🛁' },
    { id: 'balcony', label: 'Балкон', icon: '🌤' },
    { id: 'office', label: 'Кабинет', icon: '💻' },
  ];

  return (
    <div style={{
      width: '100%', height: '100%', background: t.bg, color: t.ink,
      fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif',
      overflow: 'auto', position: 'relative',
    }}>
      {/* HEADER */}
      <div style={{ padding: '16px 22px 8px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 18 }}>
          <button style={iconBtnV3(t, true)}><window.Icon name="arrow-left" size={20} color={t.ink} /></button>
          <span style={{ fontSize: 13, color: t.inkSoft, fontWeight: 600 }}>Шаг 2 из 4</span>
          <span style={{ fontSize: 13, color: t.primary, fontWeight: 600 }}>Пропустить</span>
        </div>
        <div style={{ display: 'flex', gap: 4 }}>
          {[1, 1, 0, 0].map((done, i) => (
            <div key={i} style={{ flex: 1, height: 4, borderRadius: 2, background: done ? t.primary : t.line }} />
          ))}
        </div>
      </div>

      {/* PLANT PREVIEW + TITLE */}
      <div style={{ padding: '12px 22px 0', textAlign: 'center', position: 'relative' }}>
        <div style={{
          background: t.primarySoft, borderRadius: 28, padding: '20px 18px 8px',
          position: 'relative', overflow: 'hidden',
        }}>
          <svg width="120" height="120" viewBox="0 0 120 120"
            style={{ position: 'absolute', right: -10, top: -10, opacity: 0.22 }}>
            <path d="M 100 20 C 60 20 30 50 30 90 C 50 90 80 60 100 20 Z" fill={t.leafDark} />
          </svg>
          <div style={{ display: 'grid', placeItems: 'center' }}>
            <window.Monstera t={t} size={140} />
          </div>
          <div style={{
            fontSize: 11, color: t.inkSoft, fontWeight: 600,
            letterSpacing: '0.06em', textTransform: 'uppercase', marginTop: 4,
          }}>
            Monstera deliciosa
          </div>
        </div>

        <h1 style={{
          fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 32,
          lineHeight: 1.05, margin: '18px 0 6px', letterSpacing: '-0.01em',
          textAlign: 'left',
        }}>
          Как <em style={{ color: t.primary, fontStyle: 'italic' }}>назовём</em>?
        </h1>
        <div style={{ fontSize: 14, color: t.inkSoft, textAlign: 'left' }}>
          Имя помогает запомнить характер. Растение будет «писать» от него.
        </div>
      </div>

      {/* NAME INPUT */}
      <div style={{ padding: '20px 22px 0' }}>
        <div style={{
          background: t.surface, borderRadius: 18, padding: '14px 16px',
          border: `2px solid ${t.primary}`,
          display: 'flex', alignItems: 'center', gap: 10,
        }}>
          <input type="text" defaultValue="Моника" style={{
            flex: 1, border: 'none', outline: 'none', background: 'transparent',
            fontFamily: '"Instrument Serif", serif', fontSize: 22, color: t.ink,
          }} />
          <div style={{ fontSize: 11, color: t.inkSoft, fontWeight: 600 }}>6/20</div>
        </div>
        <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap', marginTop: 10 }}>
          <span style={{ fontSize: 11, color: t.inkSoft, fontWeight: 600, alignSelf: 'center', marginRight: 4 }}>
            Идеи →
          </span>
          {['Зелёныш', 'Дора', 'Терри', 'Кустик', 'Шеф'].map(n => (
            <div key={n} style={{
              padding: '5px 10px', borderRadius: 999,
              background: t.surface, border: `1px solid ${t.line}`,
              fontFamily: '"Instrument Serif", serif', fontSize: 14,
              color: t.ink,
            }}>{n}</div>
          ))}
        </div>
      </div>

      {/* ROOM SELECT */}
      <div style={{ padding: '24px 22px 0' }}>
        <div style={{
          fontSize: 12, color: t.inkSoft, fontWeight: 600,
          letterSpacing: '0.06em', textTransform: 'uppercase', marginBottom: 10,
        }}>
          Где живёт
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 8 }}>
          {rooms.map((r, i) => {
            const sel = i === 0;
            return (
              <div key={r.id} style={{
                background: sel ? t.ink : t.surface,
                color: sel ? t.surface : t.ink,
                borderRadius: 16, padding: '12px 14px',
                border: sel ? 'none' : `1px solid ${t.line}`,
                display: 'flex', alignItems: 'center', gap: 10,
              }}>
                <div style={{
                  width: 32, height: 32, borderRadius: 10,
                  background: sel ? 'rgba(255,255,255,0.10)' : t.surfaceWarm,
                  display: 'grid', placeItems: 'center', fontSize: 16,
                }}>{r.icon}</div>
                <span style={{ fontSize: 14, fontWeight: 600 }}>{r.label}</span>
              </div>
            );
          })}
        </div>

        <div style={{
          marginTop: 10, padding: '10px 14px', borderRadius: 14,
          background: 'transparent', border: `1.5px dashed ${t.line}`,
          display: 'flex', alignItems: 'center', gap: 10, color: t.inkSoft,
          fontSize: 13, fontWeight: 600,
        }}>
          <window.Icon name="plus" size={16} color={t.inkSoft} stroke={2} />
          Добавить своё помещение
        </div>
      </div>

      <div style={{ height: 110 }} />

      <BottomActionBar t={t}>
        <button style={ctaSecondary(t)}>Назад</button>
        <button style={ctaPrimary(t)}>
          Дальше — расписание
          <window.Icon name="arrow-left" size={18} color={t.surface} stroke={2} style={{ transform: 'scaleX(-1)' }} />
        </button>
      </BottomActionBar>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Add plant — STEP 4 · Место и фото
// ─────────────────────────────────────────────────────────────
function AddPlantStep4Screen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];

  const windows = [
    { id: 'N', label: 'Север',  sub: 'мало света' },
    { id: 'E', label: 'Восток', sub: 'мягкое утро' },
    { id: 'S', label: 'Юг',     sub: 'много солнца' },
    { id: 'W', label: 'Запад',  sub: 'тёплый вечер', active: true },
  ];

  return (
    <div style={{
      width: '100%', height: '100%', background: t.bg, color: t.ink,
      fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif',
      overflow: 'auto', position: 'relative',
    }}>
      {/* HEADER */}
      <div style={{ padding: '16px 22px 8px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 18 }}>
          <button style={iconBtnV3(t, true)}><window.Icon name="arrow-left" size={20} color={t.ink} /></button>
          <span style={{ fontSize: 13, color: t.inkSoft, fontWeight: 600 }}>Шаг 4 из 4</span>
          <span style={{ fontSize: 13, color: t.primary, fontWeight: 600 }}>Пропустить</span>
        </div>
        <div style={{ display: 'flex', gap: 4 }}>
          {[1, 1, 1, 1].map((done, i) => (
            <div key={i} style={{ flex: 1, height: 4, borderRadius: 2, background: done ? t.primary : t.line }} />
          ))}
        </div>
      </div>

      {/* TITLE */}
      <div style={{ padding: '20px 22px 0' }}>
        <div style={{ fontSize: 12, color: t.inkSoft, fontWeight: 600, letterSpacing: '0.06em', textTransform: 'uppercase' }}>
          Последний штрих
        </div>
        <h1 style={{
          fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 36,
          lineHeight: 1.05, margin: '4px 0 6px', letterSpacing: '-0.01em',
        }}>
          Сделай <em style={{ color: t.primary, fontStyle: 'italic' }}>портрет</em>
        </h1>
        <div style={{ fontSize: 14, color: t.inkSoft, lineHeight: 1.4 }}>
          Фото поможет узнать растение и отслеживать его рост.
        </div>
      </div>

      {/* PHOTO UPLOAD */}
      <div style={{ padding: '18px 16px 0' }}>
        <div style={{
          background: t.primarySoft, borderRadius: 28, padding: 18,
          position: 'relative', overflow: 'hidden',
          display: 'flex', alignItems: 'center', gap: 14,
        }}>
          <svg width="160" height="120" viewBox="0 0 160 120"
            style={{ position: 'absolute', right: -20, top: -10, opacity: 0.22 }}>
            <path d="M 130 10 C 80 10 40 40 40 100 C 70 100 110 60 130 10 Z" fill={t.leafDark} />
          </svg>

          {/* preview frame */}
          <div style={{
            width: 96, height: 120, borderRadius: 18,
            background: t.surface, border: `1.5px dashed ${t.line}`,
            display: 'grid', placeItems: 'center', flexShrink: 0,
            position: 'relative',
          }}>
            <window.Monstera t={t} size={86} />
          </div>
          <div style={{ flex: 1, position: 'relative' }}>
            <div style={{
              fontFamily: '"Instrument Serif", serif', fontSize: 22, lineHeight: 1.1,
              letterSpacing: '-0.01em',
            }}>
              Моника
            </div>
            <div style={{ fontSize: 12, color: t.inkSoft, marginTop: 2 }}>
              Пока используется иллюстрация
            </div>
            <div style={{ display: 'flex', gap: 6, marginTop: 10 }}>
              <button style={{
                padding: '8px 12px', borderRadius: 12, border: 'none',
                background: t.ink, color: t.surface,
                fontSize: 12, fontWeight: 600, fontFamily: 'inherit',
                display: 'flex', alignItems: 'center', gap: 6,
              }}>
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke={t.surface} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <rect x="3" y="6" width="18" height="14" rx="2" />
                  <circle cx="12" cy="13" r="3.5" />
                </svg>
                Камера
              </button>
              <button style={{
                padding: '8px 12px', borderRadius: 12,
                background: t.surface, color: t.ink, border: `1px solid ${t.line}`,
                fontSize: 12, fontWeight: 600, fontFamily: 'inherit',
              }}>Из галереи</button>
            </div>
          </div>
        </div>
      </div>

      {/* WINDOW DIRECTION */}
      <div style={{ padding: '20px 22px 0' }}>
        <div style={{
          fontSize: 12, color: t.inkSoft, fontWeight: 600,
          letterSpacing: '0.06em', textTransform: 'uppercase', marginBottom: 10,
        }}>
          Куда смотрит окно
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 8 }}>
          {windows.map(w => (
            <div key={w.id} style={{
              background: w.active ? t.ink : t.surface,
              color: w.active ? t.surface : t.ink,
              borderRadius: 16, padding: '14px 14px',
              border: w.active ? 'none' : `1px solid ${t.line}`,
              display: 'flex', alignItems: 'center', gap: 12,
            }}>
              <div style={{
                width: 36, height: 36, borderRadius: 18,
                background: w.active ? 'rgba(255,255,255,0.10)' : t.surfaceWarm,
                display: 'grid', placeItems: 'center', flexShrink: 0,
                fontFamily: '"Instrument Serif", serif', fontSize: 18,
                color: w.active ? t.surface : t.primary,
              }}>{w.id}</div>
              <div>
                <div style={{ fontSize: 14, fontWeight: 700 }}>{w.label}</div>
                <div style={{ fontSize: 11, opacity: 0.75, marginTop: 1 }}>{w.sub}</div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* OPTIONAL TOGGLES */}
      <div style={{ padding: '16px 16px 0', display: 'flex', flexDirection: 'column', gap: 8 }}>
        {[
          { l: 'Растение в горшке с дренажем', sub: 'Поможем рассчитать объём полива', on: true },
          { l: 'Получил(а) от кого‑то', sub: 'Запишем как историю', on: false },
        ].map((o, i) => (
          <div key={i} style={{
            background: t.surface, borderRadius: 18, padding: '12px 14px',
            border: `1px solid ${t.line}`,
            display: 'flex', alignItems: 'center', gap: 12,
          }}>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 14, fontWeight: 600 }}>{o.l}</div>
              <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 1 }}>{o.sub}</div>
            </div>
            <div style={{
              width: 44, height: 26, borderRadius: 13,
              background: o.on ? t.primary : t.surfaceWarm,
              position: 'relative', flexShrink: 0,
            }}>
              <div style={{
                position: 'absolute', top: 3, left: o.on ? 21 : 3,
                width: 20, height: 20, borderRadius: 10, background: t.surface,
                boxShadow: '0 1px 3px rgba(0,0,0,0.2)',
              }} />
            </div>
          </div>
        ))}
      </div>

      <div style={{ height: 110 }} />

      <BottomActionBar t={t}>
        <button style={ctaSecondary(t)}>Назад</button>
        <button style={{ ...ctaPrimary(t), background: t.primary }}>
          <window.Icon name="check" size={18} color={t.surface} stroke={2.4} />
          Готово — добавить в сад
        </button>
      </BottomActionBar>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// SPRAY ACTION SHEET (вариант экрана 06)
// ─────────────────────────────────────────────────────────────
function SprayActionScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];

  return (
    <SheetShell t={t} theme={theme}>
      <SheetHeader t={t}
        kicker="Опрыскать Монику"
        title={<>Сегодня <em style={{ color: t.primary, fontStyle: 'italic' }}>освежим</em></>}
      />

      {/* big visual — mist of droplets */}
      <div style={{ padding: '12px 22px 4px', display: 'grid', placeItems: 'center' }}>
        <div style={{
          width: 200, height: 140, borderRadius: 24,
          background: t.primarySoft, position: 'relative', overflow: 'hidden',
          display: 'grid', placeItems: 'center',
        }}>
          {/* mist particles */}
          {Array.from({ length: 22 }).map((_, i) => {
            const x = 20 + (i * 37) % 160;
            const y = 14 + (i * 23) % 110;
            const r = 1.5 + (i % 4);
            return (
              <div key={i} style={{
                position: 'absolute', left: x, top: y,
                width: r * 2, height: r * 2, borderRadius: r,
                background: t.terracotta, opacity: 0.55,
              }} />
            );
          })}
          <window.Monstera t={t} size={120} />
        </div>
      </div>

      {/* intensity chips */}
      <div style={{ padding: '14px 22px 0' }}>
        <div style={{
          fontSize: 11, color: t.inkSoft, fontWeight: 600,
          letterSpacing: '0.06em', textTransform: 'uppercase', marginBottom: 8,
        }}>
          Сколько брызг
        </div>
        <div style={{ display: 'flex', gap: 8 }}>
          {[
            { v: 'Слегка', n: '5–8' },
            { v: 'Хорошо', n: '10–15', active: true },
            { v: 'От души', n: '20+' },
          ].map((c, i) => (
            <div key={i} style={{
              flex: 1, padding: '12px 8px', borderRadius: 16, textAlign: 'center',
              background: c.active ? t.terracotta : t.surface,
              color: c.active ? '#fff' : t.ink,
              border: `1px solid ${c.active ? t.terracotta : t.line}`,
            }}>
              <div style={{
                fontFamily: '"Instrument Serif", serif', fontSize: 22, lineHeight: 1,
              }}>{c.v}</div>
              <div style={{ fontSize: 10, marginTop: 4, opacity: 0.7 }}>~{c.n} пшиков</div>
            </div>
          ))}
        </div>
      </div>

      {/* options */}
      <div style={{ padding: '14px 16px 0' }}>
        {[
          { l: 'Заодно протёр(ла) листья', sub: 'Запишем — полезная привычка', on: true, icon: 'leaf' },
          { l: 'Заметка или фото', sub: 'необязательно', icon: null },
        ].map((opt, i) => (
          <div key={i} style={{
            background: t.surface, borderRadius: 18, padding: '12px 14px',
            border: `1px solid ${t.line}`, marginBottom: 8,
            display: 'flex', alignItems: 'center', gap: 12,
          }}>
            <div style={{
              width: 36, height: 36, borderRadius: 12,
              background: i === 0 ? (theme === 'dark' ? 'rgba(143,174,101,0.18)' : '#E2EDD0') : t.surfaceWarm,
              display: 'grid', placeItems: 'center', flexShrink: 0,
            }}>
              {opt.icon === 'leaf' ? (
                <window.Icon name="leaf" size={18} color={t.primary} stroke={1.8} />
              ) : (
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={t.ink} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
                  <rect x="3" y="6" width="18" height="14" rx="2" />
                  <circle cx="12" cy="13" r="3.5" />
                </svg>
              )}
            </div>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 14, fontWeight: 600 }}>{opt.l}</div>
              <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 1 }}>{opt.sub}</div>
            </div>
            {opt.on !== undefined ? (
              <div style={{
                width: 44, height: 26, borderRadius: 13,
                background: opt.on ? t.primary : t.surfaceWarm,
                position: 'relative', flexShrink: 0,
              }}>
                <div style={{
                  position: 'absolute', top: 3, left: opt.on ? 21 : 3,
                  width: 20, height: 20, borderRadius: 10, background: t.surface,
                  boxShadow: '0 1px 3px rgba(0,0,0,0.2)',
                }} />
              </div>
            ) : (
              <div style={{ fontSize: 18, color: t.inkSoft }}>›</div>
            )}
          </div>
        ))}
      </div>

      {/* confirm */}
      <div style={{ padding: '12px 16px 0' }}>
        <button style={{
          width: '100%', padding: '16px', borderRadius: 20,
          background: t.terracotta, color: '#fff', border: 'none',
          fontSize: 15, fontWeight: 600, fontFamily: 'inherit',
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10,
          boxShadow: `0 8px 20px ${t.terracotta}40`,
        }}>
          <window.Icon name="spray" size={18} color="#fff" stroke={2} />
          Опрыскано — спасибо! 💧
        </button>
        <div style={{
          textAlign: 'center', fontSize: 12, color: t.inkSoft, marginTop: 10,
          fontFamily: '"Instrument Serif", serif', fontStyle: 'italic',
        }}>
          «Хорошо! Чувствую тропики. Жду тебя 16 мая.»
        </div>
      </div>
    </SheetShell>
  );
}

// ─────────────────────────────────────────────────────────────
// FERT ACTION SHEET (вариант экрана 06)
// ─────────────────────────────────────────────────────────────
function FertActionScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];

  return (
    <SheetShell t={t} theme={theme}>
      <SheetHeader t={t}
        kicker="Подкормить Перси"
        title={<>Чем <em style={{ color: t.primary, fontStyle: 'italic' }}>накормим</em>?</>}
      />

      {/* fertilizer type cards */}
      <div style={{ padding: '12px 16px 0', display: 'flex', flexDirection: 'column', gap: 8 }}>
        {[
          { l: 'Универсальное жидкое', sub: 'Pokon, Bona Forte и др.', active: true, dose: '5 мл / 1 л' },
          { l: 'Минеральное в палочках', sub: 'Действует 1–2 месяца', dose: '1 палочка' },
          { l: 'Органика', sub: 'Биогумус, настой', dose: 'по инструкции' },
          { l: 'Своё', sub: 'опишу в заметке', dose: null },
        ].map((f, i) => (
          <div key={i} style={{
            background: t.surface, borderRadius: 18, padding: '14px 16px',
            border: f.active ? `2px solid ${t.leafDark}` : `1px solid ${t.line}`,
            display: 'flex', alignItems: 'center', gap: 12,
          }}>
            <div style={{
              width: 36, height: 36, borderRadius: 12,
              background: f.active ? t.leafDark : t.surfaceWarm,
              display: 'grid', placeItems: 'center', flexShrink: 0,
            }}>
              <window.Icon name="fert" size={18} color={f.active ? t.surface : t.inkSoft} stroke={1.8} />
            </div>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 14, fontWeight: 600 }}>{f.l}</div>
              <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 1 }}>{f.sub}</div>
            </div>
            {f.dose && (
              <div style={{
                fontFamily: '"Instrument Serif", serif', fontSize: 15,
                color: f.active ? t.leafDark : t.inkSoft,
              }}>{f.dose}</div>
            )}
            {f.active && (
              <div style={{
                width: 22, height: 22, borderRadius: 11, background: t.leafDark,
                display: 'grid', placeItems: 'center', flexShrink: 0,
              }}>
                <window.Icon name="check" size={13} color={t.surface} stroke={2.6} />
              </div>
            )}
          </div>
        ))}
      </div>

      {/* tip */}
      <div style={{ padding: '14px 16px 0' }}>
        <div style={{
          background: theme === 'dark' ? 'rgba(216,145,114,0.12)' : '#FBEFE4',
          borderRadius: 16, padding: '10px 14px',
          display: 'flex', alignItems: 'flex-start', gap: 10,
          border: `1px solid ${theme === 'dark' ? 'rgba(216,145,114,0.25)' : '#F0DDC8'}`,
        }}>
          <div style={{
            width: 22, height: 22, borderRadius: 11, background: t.terracotta,
            color: '#fff', display: 'grid', placeItems: 'center', flexShrink: 0,
            fontFamily: '"Instrument Serif", serif', fontSize: 13,
          }}>i</div>
          <div style={{ fontSize: 12, color: t.ink, lineHeight: 1.4 }}>
            Не подкармливай по сухой земле — сначала полей, через час дай удобрение.
          </div>
        </div>
      </div>

      {/* confirm */}
      <div style={{ padding: '14px 16px 0' }}>
        <button style={{
          width: '100%', padding: '16px', borderRadius: 20,
          background: t.leafDark, color: '#fff', border: 'none',
          fontSize: 15, fontWeight: 600, fontFamily: 'inherit',
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10,
          boxShadow: `0 8px 20px ${t.leafDark}40`,
        }}>
          <window.Icon name="fert" size={18} color="#fff" stroke={1.8} />
          Накормить — поехали 🌱
        </button>
        <div style={{
          textAlign: 'center', fontSize: 12, color: t.inkSoft, marginTop: 10,
          fontFamily: '"Instrument Serif", serif', fontStyle: 'italic',
        }}>
          «Сейчас будем расти! Жду новой порции в июне.»
        </div>
      </div>
    </SheetShell>
  );
}

// ─────────────────────────────────────────────────────────────
// HOME EMPTY STATE — 10
// ─────────────────────────────────────────────────────────────
function HomeEmptyScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];

  return (
    <div style={{
      width: '100%', height: '100%', background: t.bg, color: t.ink,
      fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif',
      position: 'relative', overflow: 'hidden',
    }}>
      {/* HEADER same as Home */}
      <div style={{ padding: '20px 22px 8px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 18 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
            <div style={{
              width: 36, height: 36, borderRadius: 12, background: t.primary,
              display: 'grid', placeItems: 'center', color: t.surface,
            }}>
              <window.Icon name="leaf" size={20} color={t.surface} stroke={1.6} />
            </div>
            <span style={{ fontWeight: 600, letterSpacing: '-0.01em', fontSize: 17 }}>PlantCate</span>
          </div>
          <button style={iconBtnV3(t)}><window.Icon name="user" size={20} color={t.ink} /></button>
        </div>

        <div style={{ fontSize: 13, color: t.inkSoft, fontWeight: 500, letterSpacing: '0.04em', textTransform: 'uppercase' }}>
          Среда · 13 мая
        </div>
        <h1 style={{
          fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 38,
          lineHeight: 1.05, margin: '4px 0 0', letterSpacing: '-0.01em',
        }}>
          Привет,<br />
          <em style={{ color: t.primary, fontStyle: 'italic' }}>Алина</em>
        </h1>
      </div>

      {/* EMPTY CARD */}
      <div style={{ padding: '24px 16px 0' }}>
        <div style={{
          background: t.surface, borderRadius: 32, padding: '28px 22px',
          border: `1px solid ${t.line}`, position: 'relative', overflow: 'hidden',
          textAlign: 'center',
        }}>
          {/* decorative back leaves */}
          <svg width="100%" height="220" viewBox="0 0 320 220"
            style={{ position: 'absolute', inset: 0, opacity: 0.20 }} preserveAspectRatio="xMidYMid slice">
            <g transform="translate(-20 220) rotate(-30)">
              <path d="M 0 0 C -30 -20 -50 -70 -40 -130 C 0 -130 40 -90 50 -30 C 50 -10 30 8 0 0 Z" fill={t.leaf} />
            </g>
            <g transform="translate(340 30) rotate(45)">
              <path d="M 0 0 C -36 -20 -56 -80 -44 -140 C -6 -142 40 -100 50 -36 C 50 -16 30 6 0 0 Z" fill={t.leafDark} />
            </g>
          </svg>

          {/* empty pot illustration */}
          <div style={{ position: 'relative', display: 'grid', placeItems: 'center', padding: '8px 0 18px' }}>
            <svg width="160" height="160" viewBox="0 0 160 160" fill="none">
              {/* sun spot */}
              <circle cx="118" cy="32" r="22" fill={t.primarySoft} opacity="0.6" />
              <circle cx="118" cy="32" r="10" fill={t.primary} opacity="0.4" />
              {/* soil */}
              <ellipse cx="80" cy="92" rx="34" ry="6" fill={t.potShadow} opacity="0.5" />
              {/* tiny seedling */}
              <path d="M 80 92 L 80 78" stroke={t.leafDark} strokeWidth="2.5" strokeLinecap="round" />
              <ellipse cx="74" cy="78" rx="8" ry="4" transform="rotate(-30 74 78)" fill={t.leaf} />
              <ellipse cx="86" cy="76" rx="9" ry="4.5" transform="rotate(30 86 76)" fill={t.leaf} />
              {/* pot */}
              <path d="M 50 92 L 110 92 L 104 142 Q 102 150 94 150 L 66 150 Q 58 150 56 142 Z" fill={t.pot} />
              <ellipse cx="80" cy="92" rx="30" ry="4" fill={t.potShadow} />
              {/* sparkle */}
              <g transform="translate(118 64)">
                <path d="M 0 -6 L 0 6 M -6 0 L 6 0" stroke={t.terracotta} strokeWidth="2" strokeLinecap="round" />
              </g>
            </svg>
          </div>

          <div style={{
            fontSize: 12, color: t.inkSoft, fontWeight: 600,
            letterSpacing: '0.06em', textTransform: 'uppercase', position: 'relative',
          }}>
            Сад пока пуст
          </div>
          <h2 style={{
            fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 30,
            lineHeight: 1.1, margin: '6px 0 8px', letterSpacing: '-0.01em', position: 'relative',
          }}>
            Заведём <em style={{ color: t.primary, fontStyle: 'italic' }}>первое</em><br />
            растение?
          </h2>
          <div style={{
            fontSize: 14, color: t.inkSoft, lineHeight: 1.4,
            maxWidth: 280, margin: '0 auto', position: 'relative',
          }}>
            Я подберу расписание ухода и буду напоминать — так, как ты любишь.
          </div>

          <div style={{ marginTop: 20, display: 'flex', flexDirection: 'column', gap: 8, position: 'relative' }}>
            <button style={{
              width: '100%', padding: '14px 18px', borderRadius: 18,
              background: t.ink, color: t.surface, border: 'none',
              fontSize: 15, fontWeight: 600, fontFamily: 'inherit',
              display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10,
              boxShadow: theme === 'dark' ? 'none' : '0 12px 24px rgba(31,42,30,0.20)',
            }}>
              <window.Icon name="plus" size={18} color={t.surface} stroke={2.2} />
              Добавить растение
            </button>
            <button style={{
              width: '100%', padding: '12px', borderRadius: 18,
              background: 'transparent', color: t.ink, border: `1px solid ${t.line}`,
              fontSize: 14, fontWeight: 600, fontFamily: 'inherit',
              display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
            }}>
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke={t.ink} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <rect x="3" y="6" width="18" height="14" rx="2" />
                <circle cx="12" cy="13" r="3.5" />
              </svg>
              Распознать по фото
            </button>
          </div>
        </div>
      </div>

      {/* secondary tips */}
      <div style={{ padding: '18px 22px 0' }}>
        <div style={{ fontSize: 12, color: t.inkSoft, fontWeight: 600, letterSpacing: '0.06em', textTransform: 'uppercase', marginBottom: 10 }}>
          Идеи на старт
        </div>
        <div style={{ display: 'flex', gap: 8, overflowX: 'auto' }}>
          {[
            { l: 'Монстера', sub: 'легко', art: 'monstera' },
            { l: 'Суккулент', sub: 'забыть можно', art: 'succulent' },
            { l: 'Эпипремнум', sub: 'для новичка', art: 'pothos' },
          ].map((p, i) => {
            const Art = ({ monstera: window.Monstera, succulent: window.Succulent, pothos: window.Pothos })[p.art];
            return (
              <div key={i} style={{
                background: t.surface, borderRadius: 20, padding: 10,
                border: `1px solid ${t.line}`, flexShrink: 0, width: 130,
              }}>
                <div style={{
                  aspectRatio: '1', background: i === 0 ? t.primarySoft : t.surfaceWarm,
                  borderRadius: 14, display: 'grid', placeItems: 'center', marginBottom: 6,
                }}>
                  <Art t={t} size={70} />
                </div>
                <div style={{ fontSize: 13, fontWeight: 700 }}>{p.l}</div>
                <div style={{ fontSize: 11, color: t.inkSoft }}>{p.sub}</div>
              </div>
            );
          })}
        </div>
      </div>

      {/* bottom nav */}
      <div style={{
        position: 'absolute', left: 12, right: 12, bottom: 12,
        background: t.surface, borderRadius: 28, padding: '8px 6px',
        border: `1px solid ${t.line}`,
        boxShadow: '0 18px 40px rgba(0,0,0,0.10)',
        display: 'flex', justifyContent: 'space-around', alignItems: 'center',
      }}>
        {[
          { id: 'home', label: 'Сад', icon: 'home', active: true },
          { id: 'cal', label: 'График', icon: 'calendar' },
          { id: 'lib', label: 'Каталог', icon: 'leaf' },
          { id: 'me', label: 'Я', icon: 'user' },
        ].map(it => (
          <div key={it.id} style={{
            display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 2,
            padding: '6px 14px', borderRadius: 16,
            background: it.active ? t.primarySoft : 'transparent',
          }}>
            <window.Icon name={it.icon} size={20} color={it.active ? t.primary : t.inkSoft} stroke={1.8} />
            <div style={{ fontSize: 10, fontWeight: 600, color: it.active ? t.primary : t.inkSoft }}>{it.label}</div>
          </div>
        ))}
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Shared sheet shell + helpers
// ─────────────────────────────────────────────────────────────
function SheetShell({ t, theme, children }) {
  return (
    <div style={{
      width: '100%', height: '100%', background: t.bg, color: t.ink,
      fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif',
      position: 'relative', overflow: 'hidden',
    }}>
      {/* dimmed background placeholder */}
      <div style={{
        position: 'absolute', inset: 0, opacity: 0.6, filter: 'blur(1px)',
      }}>
        <div style={{ background: t.primarySoft, padding: '20px 22px 30px' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between' }}>
            <div style={{ width: 40, height: 40, borderRadius: 20, background: t.surface }} />
            <div style={{ width: 40, height: 40, borderRadius: 20, background: t.surface }} />
          </div>
          <div style={{ display: 'grid', placeItems: 'center', padding: '8px 0' }}>
            <window.Monstera t={t} size={140} />
          </div>
        </div>
      </div>

      <div style={{
        position: 'absolute', inset: 0,
        background: theme === 'dark' ? 'rgba(0,0,0,0.5)' : 'rgba(31,42,30,0.35)',
      }} />

      <div style={{
        position: 'absolute', left: 0, right: 0, bottom: 0,
        background: t.bg,
        borderTopLeftRadius: 32, borderTopRightRadius: 32,
        padding: '8px 0 24px',
        boxShadow: '0 -20px 60px rgba(0,0,0,0.20)',
      }}>
        <div style={{ display: 'flex', justifyContent: 'center', marginBottom: 4 }}>
          <div style={{ width: 44, height: 4, borderRadius: 2, background: t.inkMute, opacity: 0.4 }} />
        </div>
        {children}
      </div>
    </div>
  );
}

function SheetHeader({ t, kicker, title }) {
  return (
    <div style={{
      padding: '14px 22px 4px', display: 'flex',
      alignItems: 'center', justifyContent: 'space-between',
    }}>
      <div>
        <div style={{ fontSize: 11, color: t.inkSoft, fontWeight: 600, letterSpacing: '0.06em', textTransform: 'uppercase' }}>
          {kicker}
        </div>
        <div style={{
          fontFamily: '"Instrument Serif", serif', fontSize: 32, lineHeight: 1,
          letterSpacing: '-0.01em', marginTop: 4,
        }}>
          {title}
        </div>
      </div>
      <button style={{
        width: 36, height: 36, borderRadius: 18, background: t.surfaceWarm,
        border: 'none', fontSize: 18, color: t.ink, lineHeight: 1,
      }}>×</button>
    </div>
  );
}

function iconBtnV3(t, transparent = false, size = 40) {
  return {
    width: size, height: size, borderRadius: size / 2.5,
    background: transparent ? 'transparent' : t.surface,
    border: transparent ? 'none' : `1px solid ${t.line}`,
    display: 'grid', placeItems: 'center', cursor: 'pointer',
  };
}

function BottomActionBar({ t, children }) {
  return (
    <div style={{
      position: 'absolute', left: 0, right: 0, bottom: 0,
      padding: '14px 16px 16px',
      background: `linear-gradient(to top, ${t.bg} 70%, ${t.bg}00)`,
      display: 'flex', gap: 10,
    }}>
      {children}
    </div>
  );
}

function ctaPrimary(t) {
  return {
    flex: 1, padding: '15px 18px', borderRadius: 18,
    background: t.ink, color: t.surface, border: 'none',
    fontSize: 15, fontWeight: 600, fontFamily: 'inherit',
    display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
  };
}

function ctaSecondary(t) {
  return {
    padding: '15px 18px', borderRadius: 18,
    background: t.surfaceWarm, color: t.ink, border: `1px solid ${t.line}`,
    fontSize: 15, fontWeight: 600, fontFamily: 'inherit',
  };
}

Object.assign(window, {
  AddPlantStep1Screen, AddPlantStep2Screen, AddPlantStep4Screen,
  SprayActionScreen, FertActionScreen, HomeEmptyScreen,
});
