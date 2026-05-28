// PlantCate — batch 7 — пустые состояния и успех
// Хелперы из v5: window.pcIconBtn, PcSectionLabel

// ─────────────────────────────────────────────────────────────
// 31 · ПУСТОЙ ДНЕВНИК — у нового растения ещё нет событий
//      вход: Карточка нового растения → Дневник
// ─────────────────────────────────────────────────────────────
function EmptyJournalScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];
  const IB = window.pcIconBtn;

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'hidden', position: 'relative', display: 'flex', flexDirection: 'column' }}>
      <div style={{ padding: '16px 22px 8px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <button style={IB(t)}><window.Icon name="arrow-left" size={20} color={t.ink} /></button>
          <div style={{ textAlign: 'center' }}>
            <div style={{ fontSize: 11, color: t.inkSoft, fontWeight: 600, letterSpacing: '0.06em', textTransform: 'uppercase' }}>Дневник ухода</div>
            <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 20, lineHeight: 1.1 }}>Базилик</div>
          </div>
          <button style={IB(t)}><window.Icon name="plus" size={20} color={t.ink} /></button>
        </div>
      </div>

      {/* EMPTY BODY */}
      <div style={{ flex: 1, display: 'grid', placeItems: 'center', padding: '0 32px' }}>
        <div style={{ textAlign: 'center' }}>
          <div style={{ position: 'relative', display: 'inline-block', marginBottom: 18 }}>
            <div style={{ position: 'absolute', inset: -28, borderRadius: '50%', background: t.primarySoft, opacity: 0.7 }} />
            <div style={{ position: 'relative' }}>
              <window.Pothos t={t} size={140} />
            </div>
          </div>

          <h1 style={{ fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 30, lineHeight: 1.1, margin: '0 0 10px', letterSpacing: '-0.01em' }}>
            История <em style={{ color: t.primary, fontStyle: 'italic' }}>только начинается</em>
          </h1>

          {/* speech bubble */}
          <div style={{ background: t.surface, borderRadius: 20, padding: '14px 18px', border: `1px solid ${t.line}`, position: 'relative', display: 'inline-block', maxWidth: 300 }}>
            <div style={{ position: 'absolute', top: -6, left: '50%', transform: 'translateX(-50%) rotate(45deg)', width: 12, height: 12, background: t.surface, borderTop: `1px solid ${t.line}`, borderLeft: `1px solid ${t.line}` }} />
            <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 17, fontStyle: 'italic', lineHeight: 1.4, color: t.ink }}>
              «Я только переехал к тебе. Отметь первый уход — и начнём вести историю вместе.»
            </div>
            <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 6, fontWeight: 600 }}>— Базилик</div>
          </div>
        </div>
      </div>

      {/* CTA */}
      <div style={{ padding: '0 22px 28px' }}>
        <button style={{
          width: '100%', padding: '16px', borderRadius: 20, background: t.ink, color: t.surface,
          border: 'none', fontSize: 15, fontWeight: 600, fontFamily: 'inherit',
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10,
        }}>
          <window.Icon name="check" size={18} color={t.surface} stroke={2.2} />
          Отметить первый уход
        </button>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 32 · ПУСТАЯ ЛЕНТА УВЕДОМЛЕНИЙ — всё спокойно
//      вход: 🔔 на главной, когда непрочитанных нет
// ─────────────────────────────────────────────────────────────
function EmptyInboxScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];
  const IB = window.pcIconBtn;

  return (
    <div style={{ width: '100%', height: '100%', background: t.bg, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'hidden', position: 'relative', display: 'flex', flexDirection: 'column' }}>
      <div style={{ padding: '16px 22px 8px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <button style={IB(t)}><window.Icon name="arrow-left" size={20} color={t.ink} /></button>
          <div style={{ fontSize: 12, fontWeight: 600, letterSpacing: '0.06em', color: t.inkSoft, textTransform: 'uppercase' }}>Уведомления</div>
          <div style={{ width: 40 }} />
        </div>
      </div>

      <div style={{ flex: 1, display: 'grid', placeItems: 'center', padding: '0 36px' }}>
        <div style={{ textAlign: 'center' }}>
          <div style={{ position: 'relative', display: 'inline-block', marginBottom: 20 }}>
            <div style={{ position: 'absolute', inset: -30, borderRadius: '50%', background: t.primarySoft, opacity: 0.7 }} />
            {/* sun + plant */}
            <div style={{ position: 'relative' }}>
              <window.Succulent t={t} size={140} />
              <div style={{ position: 'absolute', top: -6, right: -10, fontSize: 30 }}>☀️</div>
            </div>
          </div>

          <h1 style={{ fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 32, lineHeight: 1.1, margin: '0 0 10px', letterSpacing: '-0.01em' }}>
            Пока <em style={{ color: t.primary, fontStyle: 'italic' }}>тихо</em>
          </h1>
          <div style={{ fontSize: 15, color: t.inkSoft, lineHeight: 1.5, textWrap: 'pretty' }}>
            Все растения довольны — ни одной заботы не пропущено. Загляну сюда, когда кому-то понадобится внимание.
          </div>

          {/* tiny reassurance chip */}
          <div style={{
            display: 'inline-flex', alignItems: 'center', gap: 8, marginTop: 20,
            padding: '8px 14px', borderRadius: 999, background: t.surface, border: `1px solid ${t.line}`,
          }}>
            <span style={{ width: 8, height: 8, borderRadius: 4, background: t.primary }} />
            <span style={{ fontSize: 12, fontWeight: 600, color: t.inkSoft }}>12 растений в порядке</span>
          </div>
        </div>
      </div>

      <div style={{ height: 24 }} />
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 33 · УСПЕХ — первый уход отмечен (старт стрика)
//      вход: после подтверждения первого полива
// ─────────────────────────────────────────────────────────────
function FirstWaterSuccessScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];

  return (
    <div style={{ width: '100%', height: '100%', background: t.primarySoft, color: t.ink, fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif', overflow: 'hidden', position: 'relative', display: 'flex', flexDirection: 'column' }}>
      {/* decorative leaves */}
      <svg width="100%" height="100%" viewBox="0 0 400 800" style={{ position: 'absolute', inset: 0, opacity: 0.18, pointerEvents: 'none' }} preserveAspectRatio="xMidYMid slice">
        <g transform="translate(330 60) rotate(30)">
          <path d="M 0 0 C -40 -20 -60 -80 -50 -140 C -10 -150 40 -100 50 -40 C 50 -20 30 0 0 0 Z" fill={t.leafDark} />
        </g>
        <g transform="translate(60 720) rotate(-150)">
          <path d="M 0 0 C -40 -20 -60 -80 -50 -140 C -10 -150 40 -100 50 -40 C 50 -20 30 0 0 0 Z" fill={t.leafDark} />
        </g>
      </svg>

      <div style={{ flex: 1, display: 'grid', placeItems: 'center', position: 'relative', padding: '0 32px' }}>
        <div style={{ textAlign: 'center' }}>
          {/* check + plant */}
          <div style={{ position: 'relative', display: 'inline-block', marginBottom: 22 }}>
            <window.Monstera t={t} size={176} />
            <div style={{
              position: 'absolute', bottom: 0, right: -6, width: 56, height: 56, borderRadius: 28,
              background: t.primary, display: 'grid', placeItems: 'center',
              border: `4px solid ${t.primarySoft}`, boxShadow: '0 8px 24px rgba(0,0,0,0.2)',
            }}>
              <window.Icon name="check" size={28} color={theme === 'dark' ? t.bg : '#fff'} stroke={3} />
            </div>
          </div>

          <div style={{ fontSize: 12, color: t.primary, fontWeight: 700, letterSpacing: '0.08em', textTransform: 'uppercase' }}>Готово</div>
          <h1 style={{ fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 40, lineHeight: 1.05, margin: '6px 0 14px', letterSpacing: '-0.01em' }}>
            Моника <em style={{ color: t.primary, fontStyle: 'italic' }}>напоена</em>
          </h1>

          {/* speech bubble */}
          <div style={{ background: theme === 'dark' ? 'rgba(255,255,255,0.06)' : 'rgba(255,255,255,0.6)', borderRadius: 20, padding: '14px 20px', display: 'inline-block', maxWidth: 300 }}>
            <div style={{ fontFamily: '"Instrument Serif", serif', fontSize: 19, fontStyle: 'italic', lineHeight: 1.4, color: t.ink }}>
              «Спасибо! Сразу легче дышится 💧»
            </div>
          </div>

          {/* streak start */}
          <div style={{
            display: 'inline-flex', alignItems: 'center', gap: 10, marginTop: 22,
            padding: '10px 16px', borderRadius: 999, background: t.ink, color: t.surface,
          }}>
            <span style={{ fontSize: 16 }}>🌱</span>
            <span style={{ fontSize: 13, fontWeight: 700 }}>Стрик начат · день 1</span>
          </div>
        </div>
      </div>

      {/* next + CTA */}
      <div style={{ padding: '0 22px 28px', position: 'relative' }}>
        <div style={{ textAlign: 'center', fontSize: 13, color: t.inkSoft, marginBottom: 14 }}>
          Следующий полив — <b style={{ color: t.ink, fontWeight: 700 }}>через 7 дней</b>, напомню сама
        </div>
        <button style={{
          width: '100%', padding: '16px', borderRadius: 20, background: t.ink, color: t.surface,
          border: 'none', fontSize: 15, fontWeight: 600, fontFamily: 'inherit',
        }}>Вернуться в сад</button>
      </div>
    </div>
  );
}

Object.assign(window, { EmptyJournalScreen, EmptyInboxScreen, FirstWaterSuccessScreen });
