// PlantCare — second batch of screens
// Сегодня · Добавить растение · Уведомление · Полить (action sheet)
// Reuses PC_THEMES, Icon, plant illustrations from screens.jsx

// ─────────────────────────────────────────────────────────────
// TODAY SCREEN — Сегодня (полный список заботы)
// ─────────────────────────────────────────────────────────────
function TodayScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];
  const Monstera = window.Monstera, Fern = window.Fern, Succulent = window.Succulent, Pothos = window.Pothos, Cactus = window.Cactus;
  const PLANT_ART = { monstera: Monstera, fern: Fern, succulent: Succulent, pothos: Pothos, cactus: Cactus };

  const sections = [
    {
      label: 'Утром', count: 2,
      tasks: [
        { id: 1, plant: 'Моника', species: 'Монстера', art: 'monstera', action: 'Опрыскать', icon: 'spray', tint: t.terracotta, line: 'Я тоскую по тропикам!', overdue: false },
        { id: 2, plant: 'Фернандо', species: 'Папоротник', art: 'fern', action: 'Опрыскать', icon: 'spray', tint: t.terracotta, line: 'Я весь поник без воды :(', overdue: true },
      ],
    },
    {
      label: 'Вечером', count: 2,
      tasks: [
        { id: 3, plant: 'Сьюзи', species: 'Суккулент', art: 'succulent', action: 'Полить', icon: 'drop', tint: t.primary, line: 'Аккуратно, я не люблю много воды.', overdue: false },
        { id: 4, plant: 'Перси', species: 'Эпипремнум', art: 'pothos', action: 'Удобрить', icon: 'fert', tint: t.leafDark, line: 'Накорми меня — буду расти быстрее!', overdue: false },
      ],
    },
  ];

  const done = [
    { id: 5, plant: 'Колючка', species: 'Кактус', art: 'cactus', action: 'Полит', time: '7:42' },
  ];

  return (
    <div style={{
      width: '100%', height: '100%', background: t.bg, color: t.ink,
      fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif',
      overflow: 'auto',
    }}>
      {/* HEADER */}
      <div style={{ padding: '20px 22px 12px', position: 'relative' }}>
        {/* corner leaves */}
        <svg width="160" height="120" viewBox="0 0 160 120"
          style={{ position: 'absolute', right: 0, top: 0, opacity: 0.18 }}>
          <g transform="translate(120 20) rotate(20)">
            <path d="M 0 0 C -20 -10 -32 -34 -24 -54 C -6 -56 18 -38 22 -16 C 22 -8 14 4 0 0 Z" fill={t.leaf} />
          </g>
          <g transform="translate(150 60) rotate(50)">
            <path d="M 0 0 C -14 -8 -22 -28 -16 -42 C -2 -42 14 -28 18 -12 C 18 -4 12 4 0 0 Z" fill={t.leafDark} />
          </g>
        </svg>

        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 12 }}>
          <button style={iconBtnV2(t, true)}><window.Icon name="arrow-left" size={20} color={t.ink} /></button>
          <button style={iconBtnV2(t)}><window.Icon name="calendar" size={18} color={t.ink} /></button>
        </div>

        <div style={{ fontSize: 12, color: t.inkSoft, fontWeight: 600, letterSpacing: '0.06em', textTransform: 'uppercase' }}>
          Среда · 13 мая
        </div>
        <h1 style={{
          fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 44,
          lineHeight: 1, margin: '4px 0 14px', letterSpacing: '-0.01em',
        }}>
          Сегодня <em style={{ color: t.primary, fontStyle: 'italic' }}>5</em><br/>
          забот в саду
        </h1>

        {/* progress + summary */}
        <div style={{
          display: 'flex', alignItems: 'center', gap: 10,
          background: t.surface, padding: '10px 14px', borderRadius: 20,
          border: `1px solid ${t.line}`,
        }}>
          <div style={{ position: 'relative', width: 36, height: 36 }}>
            <svg width="36" height="36" viewBox="0 0 36 36" style={{ transform: 'rotate(-90deg)' }}>
              <circle cx="18" cy="18" r="14" stroke={t.surfaceWarm} strokeWidth="4" fill="none" />
              <circle cx="18" cy="18" r="14" stroke={t.primary} strokeWidth="4" fill="none"
                strokeDasharray={`${2 * Math.PI * 14}`} strokeDashoffset={`${2 * Math.PI * 14 * 0.8}`}
                strokeLinecap="round" />
            </svg>
            <div style={{ position: 'absolute', inset: 0, display: 'grid', placeItems: 'center', fontSize: 11, fontWeight: 700 }}>1</div>
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 13, fontWeight: 600 }}>1 из 5 выполнено</div>
            <div style={{ fontSize: 11, color: t.inkSoft }}>Осталось 4 · 1 просрочена</div>
          </div>
          <div style={{
            padding: '6px 10px', borderRadius: 999,
            background: t.terracotta, color: '#fff',
            fontSize: 11, fontWeight: 700, letterSpacing: '0.02em',
          }}>
            1 ⚠
          </div>
        </div>
      </div>

      {/* FILTER PILLS */}
      <div style={{ display: 'flex', gap: 8, padding: '8px 22px 14px', overflowX: 'auto' }}>
        {[
          { l: 'Всё', active: true, n: 5 },
          { l: 'Полив', n: 1 },
          { l: 'Опрыскивание', n: 2 },
          { l: 'Подкормка', n: 1 },
          { l: 'Просрочено', n: 1 },
        ].map((c, i) => (
          <div key={i} style={{
            padding: '8px 14px', borderRadius: 999, whiteSpace: 'nowrap',
            background: c.active ? t.ink : t.chipBg,
            color: c.active ? t.surface : t.ink,
            fontSize: 13, fontWeight: 600, display: 'flex', alignItems: 'center', gap: 6,
          }}>
            {c.l}
            <span style={{ fontSize: 11, opacity: 0.65, fontWeight: 500 }}>{c.n}</span>
          </div>
        ))}
      </div>

      {/* SECTIONS */}
      <div style={{ padding: '0 16px' }}>
        {sections.map((s, si) => (
          <div key={si} style={{ marginBottom: 16 }}>
            <div style={{
              display: 'flex', alignItems: 'baseline', justifyContent: 'space-between',
              padding: '4px 8px 8px',
            }}>
              <div style={{
                fontFamily: '"Instrument Serif", serif', fontSize: 20, letterSpacing: '-0.01em',
              }}>
                {s.label}
              </div>
              <div style={{ fontSize: 11, color: t.inkSoft, fontWeight: 600, letterSpacing: '0.04em' }}>
                {s.count} ЗАБОТЫ
              </div>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
              {s.tasks.map(task => {
                const Art = PLANT_ART[task.art];
                return (
                  <div key={task.id} style={{
                    background: t.surface, borderRadius: 22, padding: 14,
                    border: task.overdue ? `1.5px solid ${t.terracotta}` : `1px solid ${t.line}`,
                    display: 'flex', alignItems: 'center', gap: 12,
                    position: 'relative', overflow: 'hidden',
                  }}>
                    {/* avatar */}
                    <div style={{
                      width: 56, height: 56, borderRadius: 18,
                      background: t.surfaceWarm,
                      display: 'grid', placeItems: 'center', flexShrink: 0,
                      position: 'relative',
                    }}>
                      <Art t={t} size={50} />
                    </div>

                    <div style={{ flex: 1, minWidth: 0 }}>
                      <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                        <span style={{ fontSize: 15, fontWeight: 600 }}>{task.plant}</span>
                        {task.overdue && (
                          <span style={{
                            fontSize: 10, fontWeight: 700, color: t.terracotta,
                            background: theme === 'dark' ? 'rgba(216,145,114,0.15)' : '#F9E3D8',
                            padding: '2px 6px', borderRadius: 4, letterSpacing: '0.04em',
                          }}>
                            ВЧЕРА
                          </span>
                        )}
                      </div>
                      <div style={{ fontSize: 12, color: t.inkSoft, marginTop: 1 }}>{task.species}</div>
                      <div style={{
                        fontFamily: '"Instrument Serif", serif', fontStyle: 'italic',
                        fontSize: 13, color: t.ink, marginTop: 4, lineHeight: 1.2,
                      }}>
                        «{task.line}»
                      </div>
                    </div>

                    {/* tap button = circular check */}
                    <button style={{
                      width: 44, height: 44, borderRadius: 22,
                      background: task.tint, border: 'none',
                      display: 'grid', placeItems: 'center', flexShrink: 0,
                      boxShadow: `0 4px 12px ${task.tint}40`,
                    }}>
                      <window.Icon name={task.icon} size={20} color="#fff" stroke={2} />
                    </button>
                  </div>
                );
              })}
            </div>
          </div>
        ))}

        {/* DONE collapsed section */}
        <div style={{
          marginTop: 6, marginBottom: 110, padding: '14px 16px',
          background: t.surfaceWarm, borderRadius: 22,
          display: 'flex', alignItems: 'center', gap: 10,
        }}>
          <div style={{
            width: 28, height: 28, borderRadius: 14, background: t.primarySoft,
            display: 'grid', placeItems: 'center', flexShrink: 0,
          }}>
            <window.Icon name="check" size={16} color={t.primary} stroke={2.4} />
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 13, fontWeight: 600 }}>1 выполнено сегодня</div>
            <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 1 }}>
              Колючка · полит в 7:42
            </div>
          </div>
          <div style={{ fontSize: 18, color: t.inkSoft }}>▾</div>
        </div>
      </div>

      <BottomNavV2 t={t} active="cal" />
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// ADD PLANT SCREEN — Шаг 3: Расписание ухода
// ─────────────────────────────────────────────────────────────
function AddPlantScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];

  const care = [
    { id: 'water', label: 'Полив', icon: 'drop', tint: t.primary, on: true, every: 7, unit: 'дней', amount: '200 мл' },
    { id: 'spray', label: 'Опрыскивание', icon: 'spray', tint: t.terracotta, on: true, every: 3, unit: 'дня' },
    { id: 'fert', label: 'Подкормка', icon: 'fert', tint: t.leafDark, on: true, every: 4, unit: 'недели' },
  ];

  return (
    <div style={{
      width: '100%', height: '100%', background: t.bg, color: t.ink,
      fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif',
      overflow: 'auto',
    }}>
      {/* HEADER with step progress */}
      <div style={{ padding: '16px 22px 8px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 18 }}>
          <button style={iconBtnV2(t, true)}><window.Icon name="arrow-left" size={20} color={t.ink} /></button>
          <span style={{ fontSize: 13, color: t.inkSoft, fontWeight: 600 }}>Шаг 3 из 4</span>
          <span style={{ fontSize: 13, color: t.primary, fontWeight: 600 }}>Пропустить</span>
        </div>

        {/* progress dots */}
        <div style={{ display: 'flex', gap: 4 }}>
          {[1, 1, 1, 0].map((done, i) => (
            <div key={i} style={{
              flex: 1, height: 4, borderRadius: 2,
              background: done ? t.primary : t.line,
            }} />
          ))}
        </div>
      </div>

      {/* TITLE */}
      <div style={{ padding: '20px 22px 0' }}>
        <div style={{
          fontSize: 12, color: t.inkSoft, fontWeight: 600,
          letterSpacing: '0.06em', textTransform: 'uppercase',
        }}>
          Расписание
        </div>
        <h1 style={{
          fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 36,
          lineHeight: 1.05, margin: '4px 0 6px', letterSpacing: '-0.01em',
        }}>
          Как часто <em style={{ color: t.primary, fontStyle: 'italic' }}>поить</em><br />и баловать?
        </h1>
        <div style={{ fontSize: 14, color: t.inkSoft, lineHeight: 1.4 }}>
          Подобрали базовое расписание для монстеры. Можно подкрутить под свою квартиру.
        </div>
      </div>

      {/* PLANT PREVIEW CARD */}
      <div style={{ padding: '20px 16px 4px' }}>
        <div style={{
          background: t.primarySoft, borderRadius: 24, padding: '12px 16px',
          display: 'flex', alignItems: 'center', gap: 14, position: 'relative', overflow: 'hidden',
        }}>
          {/* small leaf bg */}
          <svg width="80" height="80" viewBox="0 0 80 80"
            style={{ position: 'absolute', right: -8, top: -8, opacity: 0.25 }}>
            <path d="M 70 10 C 40 10 20 30 20 60 C 40 60 65 40 70 10 Z" fill={t.leafDark} />
          </svg>
          <div style={{
            width: 64, height: 64, borderRadius: 18, background: t.surface,
            display: 'grid', placeItems: 'center', flexShrink: 0,
          }}>
            <window.Monstera t={t} size={58} />
          </div>
          <div style={{ flex: 1, minWidth: 0, position: 'relative' }}>
            <div style={{ fontSize: 11, color: t.inkSoft, fontWeight: 600, letterSpacing: '0.04em', textTransform: 'uppercase' }}>
              Monstera deliciosa
            </div>
            <div style={{
              fontFamily: '"Instrument Serif", serif', fontSize: 22, lineHeight: 1.1,
              letterSpacing: '-0.01em', marginTop: 2,
            }}>
              Моника
            </div>
            <div style={{ fontSize: 12, color: t.inkSoft, marginTop: 2 }}>Гостиная · западное окно</div>
          </div>
        </div>
      </div>

      {/* CARE ITEMS */}
      <div style={{ padding: '12px 16px 0', display: 'flex', flexDirection: 'column', gap: 10 }}>
        {care.map((c, i) => (
          <div key={c.id} style={{
            background: t.surface, borderRadius: 22, padding: '14px 16px',
            border: `1px solid ${t.line}`,
          }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: i === 0 ? 12 : 10 }}>
              <div style={{
                width: 40, height: 40, borderRadius: 14,
                background: theme === 'dark' ? `${c.tint}30` : `${c.tint}1A`,
                display: 'grid', placeItems: 'center', flexShrink: 0,
              }}>
                <window.Icon name={c.icon} size={20} color={c.tint} stroke={1.8} />
              </div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 15, fontWeight: 600 }}>{c.label}</div>
                <div style={{ fontSize: 12, color: t.inkSoft, marginTop: 1 }}>
                  каждые {c.every} {c.unit}{c.amount ? ` · ${c.amount}` : ''}
                </div>
              </div>
              {/* toggle */}
              <div style={{
                width: 44, height: 26, borderRadius: 13,
                background: c.on ? t.primary : t.surfaceWarm,
                position: 'relative', flexShrink: 0,
              }}>
                <div style={{
                  position: 'absolute', top: 3, left: c.on ? 21 : 3,
                  width: 20, height: 20, borderRadius: 10, background: t.surface,
                  boxShadow: '0 1px 3px rgba(0,0,0,0.2)', transition: 'left .2s',
                }} />
              </div>
            </div>

            {/* stepper for first item */}
            {i === 0 && (
              <div style={{
                display: 'flex', alignItems: 'center', gap: 10, marginTop: 4,
                padding: '4px 0 0', borderTop: `1px dashed ${t.line}`, paddingTop: 12,
              }}>
                <div style={{ fontSize: 12, color: t.inkSoft, fontWeight: 600 }}>Каждые</div>
                <div style={{
                  display: 'flex', alignItems: 'center', gap: 4,
                  background: t.surfaceWarm, borderRadius: 12, padding: 3,
                }}>
                  <button style={stepBtn(t)}>−</button>
                  <div style={{
                    minWidth: 32, textAlign: 'center', fontSize: 15, fontWeight: 600,
                  }}>7</div>
                  <button style={{ ...stepBtn(t), background: t.ink, color: t.surface }}>+</button>
                </div>
                <div style={{ fontSize: 12, color: t.inkSoft, fontWeight: 600 }}>дней</div>
                <div style={{ flex: 1 }} />
                <div style={{
                  fontSize: 11, color: t.primary, fontWeight: 600,
                }}>Точнее →</div>
              </div>
            )}
          </div>
        ))}
      </div>

      {/* TIP BANNER */}
      <div style={{ padding: '14px 16px 6px' }}>
        <div style={{
          background: theme === 'dark' ? 'rgba(199,123,92,0.12)' : '#FBEFE4',
          borderRadius: 18, padding: '12px 14px',
          display: 'flex', gap: 12, alignItems: 'flex-start',
          border: `1px solid ${theme === 'dark' ? 'rgba(216,145,114,0.25)' : '#F0DDC8'}`,
        }}>
          <div style={{
            width: 28, height: 28, borderRadius: 14, background: t.terracotta,
            display: 'grid', placeItems: 'center', flexShrink: 0, color: '#fff',
            fontFamily: '"Instrument Serif", serif', fontSize: 16,
          }}>i</div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 12, fontWeight: 700, color: t.terracotta, letterSpacing: '0.04em', textTransform: 'uppercase' }}>
              Совет
            </div>
            <div style={{
              fontFamily: '"Instrument Serif", serif', fontSize: 16, lineHeight: 1.3,
              marginTop: 2, color: t.ink,
            }}>
              Монстера любит, когда верхний слой земли успевает подсохнуть. Летом — чаще, зимой реже.
            </div>
          </div>
        </div>
      </div>

      {/* SPACER for bottom buttons */}
      <div style={{ height: 110 }} />

      {/* BOTTOM ACTION BAR */}
      <div style={{
        position: 'absolute', left: 0, right: 0, bottom: 0,
        padding: '14px 16px 16px',
        background: `linear-gradient(to top, ${t.bg} 70%, ${t.bg}00)`,
        display: 'flex', gap: 10,
      }}>
        <button style={{
          padding: '15px 18px', borderRadius: 18,
          background: t.surfaceWarm, color: t.ink, border: `1px solid ${t.line}`,
          fontSize: 15, fontWeight: 600, fontFamily: 'inherit',
        }}>
          Назад
        </button>
        <button style={{
          flex: 1, padding: '15px 18px', borderRadius: 18,
          background: t.ink, color: t.surface, border: 'none',
          fontSize: 15, fontWeight: 600, fontFamily: 'inherit',
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
        }}>
          Дальше — место и фото
          <window.Icon name="arrow-left" size={18} color={t.surface} stroke={2} style={{ transform: 'scaleX(-1)' }} />
        </button>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// LOCK SCREEN NOTIFICATION
// ─────────────────────────────────────────────────────────────
function NotificationScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];
  // dark mossy lock screen regardless of theme
  const bg = theme === 'dark' ? '#0B0F0B' : '#1E2A1B';

  return (
    <div style={{
      width: '100%', height: '100%',
      background: `radial-gradient(ellipse at 40% 20%, #2E4424 0%, ${bg} 70%)`,
      color: '#EFE7D4', position: 'relative', overflow: 'hidden',
      fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif',
    }}>
      {/* atmosphere leaves */}
      <svg width="100%" height="100%" viewBox="0 0 400 800"
        style={{ position: 'absolute', inset: 0, opacity: 0.18 }} preserveAspectRatio="xMidYMid slice">
        <g transform="translate(60 -20) rotate(15)">
          <path d="M 0 0 C -50 -10 -80 -100 -64 -180 C -10 -190 60 -120 70 -30 C 70 -10 40 10 0 0 Z" fill="#A8C081" />
        </g>
        <g transform="translate(380 100) rotate(40)">
          <path d="M 0 0 C -40 -20 -60 -90 -50 -160 C -10 -160 40 -100 50 -30 C 50 -10 20 10 0 0 Z" fill="#6F8A4F" />
        </g>
        <g transform="translate(20 760) rotate(-30)">
          <path d="M 0 0 C -30 -10 -50 -60 -42 -110 C -10 -110 30 -80 36 -30 C 36 -10 20 6 0 0 Z" fill="#A8C081" />
        </g>
      </svg>

      {/* time/date */}
      <div style={{ padding: '60px 28px 0', position: 'relative', textAlign: 'center' }}>
        <div style={{ fontSize: 14, fontWeight: 500, letterSpacing: '0.08em', textTransform: 'uppercase', opacity: 0.7 }}>
          Среда · 13 мая
        </div>
        <div style={{
          fontFamily: '"Instrument Serif", serif', fontSize: 96, fontWeight: 400,
          lineHeight: 1, letterSpacing: '-0.02em', marginTop: 4,
        }}>
          9:30
        </div>
      </div>

      {/* notification card */}
      <div style={{
        position: 'absolute', left: 12, right: 12, top: 280,
        background: 'rgba(28, 36, 28, 0.85)',
        backdropFilter: 'blur(20px)',
        WebkitBackdropFilter: 'blur(20px)',
        borderRadius: 24, padding: '14px 16px',
        border: '1px solid rgba(255,255,255,0.08)',
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 10 }}>
          <div style={{
            width: 28, height: 28, borderRadius: 8, background: '#3F6B3A',
            display: 'grid', placeItems: 'center',
          }}>
            <window.Icon name="leaf" size={16} color="#EFE7D4" stroke={1.8} />
          </div>
          <div style={{ flex: 1, fontSize: 12, fontWeight: 600, letterSpacing: '0.02em', opacity: 0.8 }}>
            PLANTCARE
          </div>
          <div style={{ fontSize: 12, opacity: 0.55 }}>сейчас</div>
        </div>
        <div style={{ display: 'flex', gap: 12 }}>
          <div style={{
            width: 56, height: 56, borderRadius: 16,
            background: 'rgba(255,255,255,0.06)',
            display: 'grid', placeItems: 'center', flexShrink: 0,
          }}>
            <window.Monstera t={window.PC_THEMES.dark} size={52} />
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 15, fontWeight: 700, marginBottom: 2 }}>
              Моника пишет:
            </div>
            <div style={{
              fontFamily: '"Instrument Serif", serif', fontSize: 17, fontStyle: 'italic',
              lineHeight: 1.25,
            }}>
              «Эй! Опрыскай меня сегодня, пожалуйста — я тоскую по тропикам.»
            </div>
          </div>
        </div>
        {/* quick actions */}
        <div style={{ display: 'flex', gap: 6, marginTop: 12 }}>
          <button style={{
            flex: 1.4, padding: '10px 12px', borderRadius: 12,
            background: '#3F6B3A', color: '#fff', border: 'none',
            fontSize: 13, fontWeight: 700, fontFamily: 'inherit',
            display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 6,
          }}>
            <window.Icon name="spray" size={14} color="#fff" stroke={2} />
            Опрыскано
          </button>
          <button style={{
            flex: 1, padding: '10px 4px', borderRadius: 12,
            background: 'rgba(255,255,255,0.08)', color: '#EFE7D4', border: 'none',
            fontSize: 12, fontWeight: 600, fontFamily: 'inherit',
            lineHeight: 1.2,
          }}>
            Через<br/>час
          </button>
          <button style={{
            flex: 1, padding: '10px 4px', borderRadius: 12,
            background: 'rgba(255,255,255,0.08)', color: '#EFE7D4', border: 'none',
            fontSize: 12, fontWeight: 600, fontFamily: 'inherit',
            lineHeight: 1.2,
          }}>
            Вече<br/>ром
          </button>
          <button style={{
            flex: 1, padding: '10px 4px', borderRadius: 12,
            background: 'rgba(255,255,255,0.08)', color: '#EFE7D4', border: 'none',
            fontSize: 12, fontWeight: 600, fontFamily: 'inherit',
            lineHeight: 1.2,
          }}>
            Зав<br/>тра
          </button>
        </div>
      </div>

      {/* second muted notification */}
      <div style={{
        position: 'absolute', left: 24, right: 24, top: 482,
        background: 'rgba(28, 36, 28, 0.55)',
        backdropFilter: 'blur(20px)',
        WebkitBackdropFilter: 'blur(20px)',
        borderRadius: 18, padding: '10px 14px',
        border: '1px solid rgba(255,255,255,0.05)',
        display: 'flex', alignItems: 'center', gap: 10,
      }}>
        <div style={{
          width: 20, height: 20, borderRadius: 6, background: '#3F6B3A',
          display: 'grid', placeItems: 'center', flexShrink: 0,
        }}>
          <window.Icon name="leaf" size={12} color="#EFE7D4" stroke={1.8} />
        </div>
        <div style={{ flex: 1, fontSize: 13 }}>
          <b style={{ fontWeight: 700 }}>Фернандо</b>
          <span style={{ opacity: 0.7 }}> · «Я весь поник без воды...»</span>
        </div>
        <div style={{ fontSize: 11, opacity: 0.5 }}>8:14</div>
      </div>

      {/* swipe hint */}
      <div style={{
        position: 'absolute', bottom: 56, left: 0, right: 0, textAlign: 'center',
        fontSize: 13, opacity: 0.55, letterSpacing: '0.02em',
      }}>
        Свайп для ответа на заботу
      </div>

      {/* camera/flash icons bottom corners */}
      <div style={{
        position: 'absolute', bottom: 24, left: 28,
        width: 42, height: 42, borderRadius: 21,
        background: 'rgba(255,255,255,0.12)',
        display: 'grid', placeItems: 'center',
      }}>
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
          <path d="M12 2v6 M5 5l2 2 M19 5l-2 2 M12 14l-3 8 M12 14l3 8" />
        </svg>
      </div>
      <div style={{
        position: 'absolute', bottom: 24, right: 28,
        width: 42, height: 42, borderRadius: 21,
        background: 'rgba(255,255,255,0.12)',
        display: 'grid', placeItems: 'center',
      }}>
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
          <rect x="3" y="6" width="18" height="14" rx="2" />
          <circle cx="12" cy="13" r="3.5" />
        </svg>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// WATER ACTION SHEET — Полить (bottom sheet over plant view)
// ─────────────────────────────────────────────────────────────
function WaterActionScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];

  return (
    <div style={{
      width: '100%', height: '100%', background: t.bg, color: t.ink,
      fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif',
      position: 'relative', overflow: 'hidden',
    }}>
      {/* dimmed plant detail BG */}
      <div style={{
        position: 'absolute', inset: 0, opacity: 0.65,
        filter: 'blur(1px)',
      }}>
        <div style={{
          background: t.primarySoft, padding: '20px 22px 24px',
          position: 'relative', overflow: 'hidden',
        }}>
          <svg width="100%" height="100%" viewBox="0 0 400 300"
            style={{ position: 'absolute', inset: 0, opacity: 0.22 }} preserveAspectRatio="xMaxYMax slice">
            <g transform="translate(290 0) rotate(25)">
              <path d="M 0 0 C -40 -20 -60 -80 -50 -140 C -10 -150 40 -100 50 -40 C 50 -20 30 0 0 0 Z" fill={t.leafDark} />
            </g>
          </svg>
          <div style={{ display: 'flex', justifyContent: 'space-between' }}>
            <div style={{ width: 40, height: 40, borderRadius: 20, background: t.surface }} />
            <div style={{ width: 40, height: 40, borderRadius: 20, background: t.surface }} />
          </div>
          <div style={{ display: 'grid', placeItems: 'center', padding: '8px 0' }}>
            <window.Monstera t={t} size={170} />
          </div>
        </div>
        <div style={{ padding: '12px 22px' }}>
          <div style={{ height: 12, width: '40%', background: t.surfaceWarm, borderRadius: 6, marginBottom: 8 }} />
          <div style={{
            fontFamily: '"Instrument Serif", serif', fontSize: 36,
            color: t.ink, opacity: 0.5,
          }}>
            Моника
          </div>
        </div>
      </div>

      {/* SCRIM */}
      <div style={{
        position: 'absolute', inset: 0,
        background: theme === 'dark' ? 'rgba(0,0,0,0.5)' : 'rgba(31,42,30,0.35)',
      }} />

      {/* SHEET */}
      <div style={{
        position: 'absolute', left: 0, right: 0, bottom: 0,
        background: t.bg,
        borderTopLeftRadius: 32, borderTopRightRadius: 32,
        padding: '8px 0 24px',
        boxShadow: '0 -20px 60px rgba(0,0,0,0.20)',
      }}>
        {/* drag handle */}
        <div style={{ display: 'flex', justifyContent: 'center', marginBottom: 4 }}>
          <div style={{ width: 44, height: 4, borderRadius: 2, background: t.inkMute, opacity: 0.4 }} />
        </div>

        {/* header */}
        <div style={{
          padding: '14px 22px 4px', display: 'flex',
          alignItems: 'center', justifyContent: 'space-between',
        }}>
          <div>
            <div style={{ fontSize: 11, color: t.inkSoft, fontWeight: 600, letterSpacing: '0.06em', textTransform: 'uppercase' }}>
              Полить Монику
            </div>
            <div style={{
              fontFamily: '"Instrument Serif", serif', fontSize: 32, lineHeight: 1,
              letterSpacing: '-0.01em', marginTop: 4,
            }}>
              Сколько <em style={{ color: t.primary, fontStyle: 'italic' }}>водички</em>?
            </div>
          </div>
          <button style={{
            width: 36, height: 36, borderRadius: 18, background: t.surfaceWarm,
            border: 'none', fontSize: 18, color: t.ink, lineHeight: 1,
          }}>×</button>
        </div>

        {/* big amount with slider */}
        <div style={{ padding: '20px 22px 8px' }}>
          <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'center', gap: 6 }}>
            <div style={{
              fontFamily: '"Instrument Serif", serif', fontSize: 80, fontWeight: 400,
              lineHeight: 1, color: t.primary, letterSpacing: '-0.03em',
            }}>200</div>
            <div style={{ fontSize: 18, color: t.inkSoft, fontWeight: 600 }}>мл</div>
          </div>

          {/* water drop visualizer */}
          <div style={{
            position: 'relative', height: 50, marginTop: 6,
            display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 6,
          }}>
            {Array.from({ length: 12 }).map((_, i) => (
              <svg key={i} width="10" height={14 + (i % 3) * 2} viewBox="0 0 10 16">
                <path d="M5 1 C 2 5 1 8 1 10 a4 4 0 0 0 8 0 c0-2-1-5-4-9z"
                  fill={i < 7 ? t.primary : t.line} opacity={i < 7 ? 1 : 0.5} />
              </svg>
            ))}
          </div>

          {/* quick chips */}
          <div style={{ display: 'flex', gap: 8, marginTop: 12, justifyContent: 'space-between' }}>
            {[
              { v: '100', sub: 'немного' },
              { v: '200', sub: 'обычно', active: true },
              { v: '300', sub: 'хорошо' },
              { v: '500', sub: 'до поддона' },
            ].map((c, i) => (
              <div key={i} style={{
                flex: 1, padding: '10px 6px', borderRadius: 16, textAlign: 'center',
                background: c.active ? t.primary : t.surface,
                color: c.active ? t.surface : t.ink,
                border: `1px solid ${c.active ? t.primary : t.line}`,
              }}>
                <div style={{
                  fontFamily: '"Instrument Serif", serif', fontSize: 20, lineHeight: 1,
                }}>{c.v} <span style={{ fontSize: 11, opacity: 0.7 }}>мл</span></div>
                <div style={{ fontSize: 10, marginTop: 2, opacity: 0.7 }}>{c.sub}</div>
              </div>
            ))}
          </div>
        </div>

        {/* options */}
        <div style={{ padding: '14px 16px 0' }}>
          {[
            { l: 'Сухая земля?', sub: 'Замечу — увеличу частоту', on: true },
            { l: 'Полил(а) задним числом', sub: 'Сейчас · можно изменить дату', date: true },
            { l: 'Добавить заметку или фото', sub: 'необязательно' },
          ].map((opt, i) => (
            <div key={i} style={{
              background: t.surface, borderRadius: 18, padding: '12px 14px',
              border: `1px solid ${t.line}`, marginBottom: 8,
              display: 'flex', alignItems: 'center', gap: 12,
            }}>
              <div style={{
                width: 36, height: 36, borderRadius: 12,
                background: i === 0 ? (theme === 'dark' ? 'rgba(199,123,92,0.18)' : '#FBEFE4') : t.surfaceWarm,
                display: 'grid', placeItems: 'center', flexShrink: 0,
              }}>
                {i === 0 ? (
                  <window.Icon name="thermo" size={18} color={t.terracotta} stroke={1.8} />
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
              {i === 0 ? (
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
              ) : opt.date ? (
                <div style={{
                  padding: '6px 10px', borderRadius: 10,
                  background: t.primarySoft, color: t.primary,
                  fontSize: 11, fontWeight: 700,
                }}>Сейчас ▾</div>
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
            background: t.ink, color: t.surface, border: 'none',
            fontSize: 15, fontWeight: 600, fontFamily: 'inherit',
            display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10,
          }}>
            <window.Icon name="drop" size={18} color={t.surface} stroke={2} />
            Полить — спасибо! 💚
          </button>
          <div style={{
            textAlign: 'center', fontSize: 12, color: t.inkSoft, marginTop: 10,
            fontFamily: '"Instrument Serif", serif', fontStyle: 'italic',
          }}>
            «Ты лучший хозяин. Следующий полив — 20 мая.»
          </div>
        </div>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Local helpers
// ─────────────────────────────────────────────────────────────
function iconBtnV2(t, transparent = false, size = 40) {
  return {
    width: size, height: size, borderRadius: size / 2.5,
    background: transparent ? 'transparent' : t.surface,
    border: transparent ? 'none' : `1px solid ${t.line}`,
    display: 'grid', placeItems: 'center', cursor: 'pointer',
  };
}

function stepBtn(t) {
  return {
    width: 28, height: 28, borderRadius: 9,
    background: t.surface, color: t.ink, border: 'none',
    fontSize: 16, fontWeight: 600, lineHeight: 1,
    display: 'grid', placeItems: 'center',
  };
}

function BottomNavV2({ t, active = 'home' }) {
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
          <div style={{
            fontSize: 10, fontWeight: 600,
            color: active === it.id ? t.primary : t.inkSoft,
          }}>{it.label}</div>
        </div>
      ))}
    </div>
  );
}

Object.assign(window, { TodayScreen, AddPlantScreen, NotificationScreen, WaterActionScreen });
