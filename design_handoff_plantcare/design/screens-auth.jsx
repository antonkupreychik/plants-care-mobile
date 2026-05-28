// PlantCate — auth screens
// 07 Welcome / Войти · 08 Telegram код · 09 С возвращением

// ─────────────────────────────────────────────────────────────
// WELCOME / SIGN IN
// ─────────────────────────────────────────────────────────────
function AuthWelcomeScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];

  return (
    <div style={{
      width: '100%', height: '100%', background: t.bg, color: t.ink,
      fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif',
      position: 'relative', overflow: 'hidden',
    }}>
      {/* atmosphere — back gradient */}
      <div style={{
        position: 'absolute', inset: 0,
        background: `radial-gradient(120% 60% at 50% 0%, ${t.primarySoft} 0%, ${t.bg} 60%)`,
      }} />

      {/* decorative leaves bg */}
      <svg width="100%" height="100%" viewBox="0 0 400 800"
        style={{ position: 'absolute', inset: 0, opacity: theme === 'dark' ? 0.25 : 0.4 }}
        preserveAspectRatio="xMidYMid slice">
        <g transform="translate(-30 60) rotate(-25)">
          <path d="M 0 0 C -28 -14 -46 -54 -36 -90 C -8 -92 22 -68 28 -28 C 28 -10 16 8 0 0 Z" fill={t.leaf} />
        </g>
        <g transform="translate(420 30) rotate(35)">
          <path d="M 0 0 C -42 -22 -64 -86 -52 -154 C -8 -158 50 -110 60 -42 C 60 -22 36 4 0 0 Z" fill={t.leafDark} />
          <path d="M -20 -20 L -36 -100 M -2 -8 L 6 -114 M 24 -22 L 40 -100"
            stroke={t.bg} strokeWidth="2" opacity="0.4" />
        </g>
        <g transform="translate(430 750) rotate(-150)">
          <path d="M 0 0 C -42 -22 -64 -86 -52 -154 C -8 -158 50 -110 60 -42 C 60 -22 36 4 0 0 Z" fill={t.leafDark} />
        </g>
      </svg>

      {/* TOP BRAND */}
      <div style={{
        position: 'relative', padding: '24px 28px 0',
        display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
          <div style={{
            width: 36, height: 36, borderRadius: 12, background: t.primary,
            display: 'grid', placeItems: 'center', color: t.surface,
          }}>
            <window.Icon name="leaf" size={20} color={t.surface} stroke={1.6} />
          </div>
          <span style={{ fontWeight: 600, fontSize: 17, letterSpacing: '-0.01em' }}>PlantCate</span>
        </div>
        <span style={{ fontSize: 13, color: t.inkSoft, fontWeight: 600 }}>RU</span>
      </div>

      {/* ILLUSTRATION GARDEN */}
      <div style={{
        position: 'relative', height: 360, marginTop: 12,
        display: 'flex', alignItems: 'flex-end', justifyContent: 'center',
      }}>
        {/* big monstera centered behind */}
        <div style={{ position: 'absolute', bottom: 16, transform: 'scale(1.5)' }}>
          <window.Monstera t={t} size={220} />
        </div>
        {/* fern slightly left, lower */}
        <div style={{ position: 'absolute', bottom: 0, left: 20, transform: 'scale(0.95)' }}>
          <window.Fern t={t} size={150} />
        </div>
        {/* succulent right */}
        <div style={{ position: 'absolute', bottom: 8, right: 30, transform: 'scale(0.85)' }}>
          <window.Succulent t={t} size={130} />
        </div>
        {/* small pothos */}
        <div style={{ position: 'absolute', bottom: 4, right: 130, transform: 'scale(0.6)' }}>
          <window.Cactus t={t} size={100} />
        </div>

        {/* soft floor */}
        <div style={{
          position: 'absolute', bottom: 0, left: 0, right: 0, height: 18,
          background: `linear-gradient(to bottom, transparent, ${t.surfaceWarm})`,
        }} />
      </div>

      {/* HEADLINE + AUTH */}
      <div style={{
        position: 'relative', padding: '12px 28px 0',
        background: t.bg,
      }}>
        <div style={{
          fontSize: 12, color: t.inkSoft, fontWeight: 600,
          letterSpacing: '0.08em', textTransform: 'uppercase', marginBottom: 6,
        }}>
          Дневник для растений
        </div>
        <h1 style={{
          fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 40,
          lineHeight: 1.02, margin: '0 0 8px', letterSpacing: '-0.01em',
        }}>
          Растения,<br/>
          о которых <em style={{ color: t.primary, fontStyle: 'italic' }}>не забывают</em>
        </h1>
        <div style={{
          fontSize: 14, color: t.inkSoft, lineHeight: 1.4,
          maxWidth: 320, marginBottom: 22,
        }}>
          Напоминания о поливе, опрыскивании и подкормке. Прямо как от заботливой бабушки — но цифровой.
        </div>

        {/* AUTH BUTTONS */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
          {/* Google */}
          <button style={{
            display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 12,
            padding: '15px 18px', borderRadius: 18,
            background: t.surface, color: t.ink, border: `1px solid ${t.line}`,
            fontSize: 15, fontWeight: 600, fontFamily: 'inherit',
            boxShadow: theme === 'dark' ? 'none' : '0 2px 10px rgba(40,30,15,0.06)',
          }}>
            <GoogleG />
            Продолжить через Google
          </button>

          {/* Telegram */}
          <button style={{
            display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 12,
            padding: '15px 18px', borderRadius: 18,
            background: '#229ED9', color: '#fff', border: 'none',
            fontSize: 15, fontWeight: 600, fontFamily: 'inherit',
            boxShadow: '0 8px 20px rgba(34,158,217,0.28)',
          }}>
            <TelegramPaperPlane />
            Продолжить через Telegram
          </button>

          {/* divider */}
          <div style={{
            display: 'flex', alignItems: 'center', gap: 10,
            margin: '6px 0', color: t.inkSoft, fontSize: 12,
          }}>
            <div style={{ flex: 1, height: 1, background: t.line }} />
            <span>или</span>
            <div style={{ flex: 1, height: 1, background: t.line }} />
          </div>

          {/* guest */}
          <button style={{
            padding: '13px 18px', borderRadius: 18,
            background: 'transparent', color: t.ink, border: 'none',
            fontSize: 14, fontWeight: 600, fontFamily: 'inherit',
          }}>
            Зайти как гость
          </button>
        </div>

        {/* terms */}
        <div style={{
          fontSize: 11, color: t.inkMute, textAlign: 'center',
          marginTop: 12, lineHeight: 1.5, padding: '0 14px',
        }}>
          Нажимая «Продолжить», вы соглашаетесь с{' '}
          <span style={{ color: t.ink, textDecoration: 'underline' }}>условиями</span> и{' '}
          <span style={{ color: t.ink, textDecoration: 'underline' }}>политикой конфиденциальности</span>.
        </div>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// TELEGRAM CONFIRM — ввод кода
// ─────────────────────────────────────────────────────────────
function AuthTelegramScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];
  const code = ['4', '2', '7', '·', '·', '·'];

  return (
    <div style={{
      width: '100%', height: '100%', background: t.bg, color: t.ink,
      fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif',
      position: 'relative', overflow: 'hidden',
    }}>
      {/* soft top tint */}
      <div style={{
        position: 'absolute', top: 0, left: 0, right: 0, height: 280,
        background: `radial-gradient(80% 100% at 50% 0%, rgba(34,158,217,0.18) 0%, ${t.bg}00 100%)`,
      }} />

      {/* HEADER */}
      <div style={{
        position: 'relative', padding: '16px 22px',
        display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      }}>
        <button style={{
          width: 40, height: 40, borderRadius: 14,
          background: 'transparent', border: 'none',
          display: 'grid', placeItems: 'center',
        }}>
          <window.Icon name="arrow-left" size={20} color={t.ink} />
        </button>
        <span style={{ fontSize: 13, color: t.inkSoft, fontWeight: 600 }}>Шаг 2 из 2</span>
        <div style={{ width: 40 }} />
      </div>

      {/* TELEGRAM "BUBBLE" ILLUSTRATION */}
      <div style={{
        position: 'relative', display: 'grid', placeItems: 'center',
        padding: '24px 0 8px',
      }}>
        {/* halo */}
        <div style={{
          position: 'absolute', width: 200, height: 200, borderRadius: 100,
          background: 'rgba(34,158,217,0.12)', top: 6,
        }} />
        <div style={{
          position: 'absolute', width: 130, height: 130, borderRadius: 65,
          background: 'rgba(34,158,217,0.18)', top: 41,
        }} />

        {/* paper plane in circle */}
        <div style={{
          position: 'relative', width: 88, height: 88, borderRadius: 44,
          background: '#229ED9', display: 'grid', placeItems: 'center',
          boxShadow: '0 16px 40px rgba(34,158,217,0.32)',
        }}>
          <svg width="38" height="38" viewBox="0 0 32 32" fill="none">
            <path d="M28 4 L2 14 L12 17 L15 26 L28 4 Z" fill="#fff" />
            <path d="M12 17 L28 4 L17 19 Z" fill="#B5DAF0" />
          </svg>
        </div>
      </div>

      {/* COPY */}
      <div style={{ padding: '20px 28px 0', textAlign: 'center', position: 'relative' }}>
        <div style={{
          fontSize: 12, color: '#229ED9', fontWeight: 700,
          letterSpacing: '0.08em', textTransform: 'uppercase', marginBottom: 6,
        }}>
          Telegram · подтверждение
        </div>
        <h2 style={{
          fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 32,
          lineHeight: 1.1, margin: '0 0 10px', letterSpacing: '-0.01em',
        }}>
          Введите <em style={{ color: t.primary, fontStyle: 'italic' }}>код</em><br/>
          из чата с ботом
        </h2>
        <div style={{ fontSize: 14, color: t.inkSoft, lineHeight: 1.45 }}>
          Мы написали вам в{' '}
          <span style={{ color: '#229ED9', fontWeight: 600 }}>@PlantCateBot</span>.
          Откройте Telegram и скопируйте 6‑значный код.
        </div>
      </div>

      {/* CODE INPUT */}
      <div style={{
        padding: '24px 28px 0', display: 'flex',
        gap: 8, justifyContent: 'center',
      }}>
        {code.map((c, i) => (
          <div key={i} style={{
            width: 46, height: 56, borderRadius: 14,
            background: t.surface,
            border: c === '·' ? `1px solid ${t.line}` : `2px solid ${t.primary}`,
            display: 'grid', placeItems: 'center',
            fontFamily: '"Instrument Serif", serif',
            fontSize: c === '·' ? 28 : 28, fontWeight: 400,
            color: c === '·' ? t.inkMute : t.ink,
            position: 'relative',
          }}>
            {c}
            {/* caret on 4th */}
            {i === 3 && (
              <div style={{
                position: 'absolute', top: 14, bottom: 14,
                width: 2, background: t.primary, borderRadius: 1,
                animation: 'pcblink 1s steps(2) infinite',
              }} />
            )}
          </div>
        ))}
      </div>

      {/* STATE */}
      <div style={{
        marginTop: 20, padding: '0 28px', textAlign: 'center',
        fontSize: 13, color: t.inkSoft,
      }}>
        Отправить новый код через{' '}
        <span style={{ color: t.ink, fontWeight: 700 }}>0:45</span>
      </div>

      {/* BIG OPEN TELEGRAM BUTTON */}
      <div style={{
        position: 'absolute', left: 22, right: 22, bottom: 80,
      }}>
        <button style={{
          width: '100%', padding: '15px 18px', borderRadius: 18,
          background: '#229ED9', color: '#fff', border: 'none',
          fontSize: 15, fontWeight: 600, fontFamily: 'inherit',
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10,
          boxShadow: '0 12px 26px rgba(34,158,217,0.28)',
        }}>
          <TelegramPaperPlane />
          Открыть Telegram
        </button>
        <div style={{ textAlign: 'center', marginTop: 14 }}>
          <span style={{ fontSize: 13, color: t.inkSoft }}>Другой способ — </span>
          <span style={{ fontSize: 13, color: t.primary, fontWeight: 600 }}>войти через Google</span>
        </div>
      </div>

      {/* keyboard placeholder */}
      <AuthKeypad t={t} theme={theme} />

      <style>{`@keyframes pcblink { 0%,40% { opacity: 1 } 50%,100% { opacity: 0 } }`}</style>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// WELCOME BACK — первый вход / привет
// ─────────────────────────────────────────────────────────────
function AuthWelcomeBackScreen({ theme = 'light' }) {
  const t = window.PC_THEMES[theme];

  return (
    <div style={{
      width: '100%', height: '100%', background: t.bg, color: t.ink,
      fontFamily: '"Plus Jakarta Sans", system-ui, sans-serif',
      position: 'relative', overflow: 'hidden',
    }}>
      {/* top primary gradient */}
      <div style={{
        position: 'absolute', top: 0, left: 0, right: 0, height: 360,
        background: `linear-gradient(180deg, ${t.primarySoft} 0%, ${t.bg} 100%)`,
      }} />

      {/* decorative leaves */}
      <svg width="100%" height="380" viewBox="0 0 400 380"
        style={{ position: 'absolute', top: 0, left: 0, opacity: theme === 'dark' ? 0.28 : 0.35 }}
        preserveAspectRatio="xMidYMid slice">
        <g transform="translate(-10 -30) rotate(-15)">
          <path d="M 0 0 C -28 -14 -46 -54 -36 -90 C -8 -92 22 -68 28 -28 C 28 -10 16 8 0 0 Z" fill={t.leafDark} />
        </g>
        <g transform="translate(410 50) rotate(40)">
          <path d="M 0 0 C -42 -22 -64 -86 -52 -154 C -8 -158 50 -110 60 -42 C 60 -22 36 4 0 0 Z" fill={t.leafDark} />
          <path d="M -16 -22 L -36 -110 M 0 -10 L 6 -120 M 22 -22 L 40 -110"
            stroke={t.surface} strokeWidth="2" opacity="0.5" />
        </g>
      </svg>

      {/* AVATAR + GREETING */}
      <div style={{
        position: 'relative', display: 'grid', placeItems: 'center',
        padding: '36px 28px 0',
      }}>
        <div style={{
          width: 92, height: 92, borderRadius: 46,
          background: t.surface, border: `3px solid ${t.bg}`,
          display: 'grid', placeItems: 'center',
          boxShadow: '0 12px 30px rgba(40,30,15,0.18)',
          marginBottom: 16,
          fontFamily: '"Instrument Serif", serif', fontSize: 40,
          color: t.primary, position: 'relative',
        }}>
          А
          {/* checkmark badge */}
          <div style={{
            position: 'absolute', bottom: -2, right: -2,
            width: 30, height: 30, borderRadius: 15,
            background: t.primary, border: `3px solid ${t.bg}`,
            display: 'grid', placeItems: 'center',
          }}>
            <window.Icon name="check" size={14} color={t.surface} stroke={2.6} />
          </div>
        </div>

        <div style={{
          fontSize: 12, color: t.inkSoft, fontWeight: 600,
          letterSpacing: '0.08em', textTransform: 'uppercase',
        }}>
          Аккаунт привязан · Telegram
        </div>

        <h1 style={{
          fontFamily: '"Instrument Serif", serif', fontWeight: 400, fontSize: 44,
          lineHeight: 1.04, margin: '8px 0 0', letterSpacing: '-0.01em', textAlign: 'center',
        }}>
          Привет,<br/>
          <em style={{ color: t.primary, fontStyle: 'italic' }}>Алина</em> 🌿
        </h1>

        <div style={{
          fontSize: 14, color: t.inkSoft, lineHeight: 1.45,
          textAlign: 'center', marginTop: 10, maxWidth: 300,
        }}>
          Тут будет жить ваш сад. Добавим первое растение — и научимся его понимать.
        </div>
      </div>

      {/* ANIMATED PLANT LINEUP */}
      <div style={{
        position: 'relative', height: 220, marginTop: 16,
        display: 'flex', alignItems: 'flex-end', justifyContent: 'center', gap: 0,
      }}>
        <div style={{ transform: 'translateY(8px) rotate(-3deg)', opacity: 0.9 }}>
          <window.Cactus t={t} size={110} />
        </div>
        <div style={{ transform: 'scale(1.15) translateY(-4px)', zIndex: 2 }}>
          <window.Monstera t={t} size={140} />
        </div>
        <div style={{ transform: 'translateY(6px) rotate(2deg)', opacity: 0.9 }}>
          <window.Fern t={t} size={120} />
        </div>
        <div style={{ transform: 'translateY(12px) rotate(-2deg)', opacity: 0.85, marginLeft: -10 }}>
          <window.Succulent t={t} size={100} />
        </div>
      </div>

      {/* CHIPS — что внутри */}
      <div style={{
        display: 'flex', gap: 8, padding: '12px 22px 0', justifyContent: 'center',
        flexWrap: 'wrap',
      }}>
        {[
          { l: 'Напоминания', icon: 'bell' },
          { l: 'Дневник', icon: 'leaf' },
          { l: 'Календарь', icon: 'calendar' },
        ].map((c, i) => (
          <div key={i} style={{
            display: 'flex', alignItems: 'center', gap: 6,
            padding: '8px 12px', borderRadius: 999,
            background: t.surface, border: `1px solid ${t.line}`,
            fontSize: 12, fontWeight: 600,
          }}>
            <window.Icon name={c.icon} size={14} color={t.primary} stroke={1.8} />
            {c.l}
          </div>
        ))}
      </div>

      {/* BOTTOM CTA */}
      <div style={{
        position: 'absolute', left: 22, right: 22, bottom: 24,
      }}>
        <button style={{
          width: '100%', padding: '16px 18px', borderRadius: 20,
          background: t.ink, color: t.surface, border: 'none',
          fontSize: 15, fontWeight: 600, fontFamily: 'inherit',
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10,
          boxShadow: theme === 'dark' ? 'none' : '0 12px 24px rgba(31,42,30,0.20)',
        }}>
          <window.Icon name="plus" size={18} color={t.surface} stroke={2.2} />
          Добавить первое растение
        </button>
        <div style={{ textAlign: 'center', marginTop: 12 }}>
          <span style={{ fontSize: 13, color: t.inkSoft, fontWeight: 500 }}>
            Я просто посмотрю →
          </span>
        </div>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Brand mark helpers
// ─────────────────────────────────────────────────────────────
function GoogleG() {
  return (
    <svg width="20" height="20" viewBox="0 0 48 48">
      <path fill="#4285F4" d="M24 9.5c3.5 0 6.3 1.5 8.3 3.3l6.1-6.1C34.6 3 29.6 1 24 1 14.7 1 6.6 6.4 2.7 14.2l7.2 5.6C11.7 13.6 17.4 9.5 24 9.5z"/>
      <path fill="#34A853" d="M46.5 24.5c0-1.6-.1-3.1-.4-4.5H24v9h12.7c-.5 3-2.2 5.6-4.7 7.3l7.2 5.6c4.2-3.9 7.3-9.7 7.3-17.4z"/>
      <path fill="#FBBC05" d="M9.9 28.8c-.5-1.5-.8-3-.8-4.8s.3-3.3.8-4.8L2.7 13.6C1 17 0 20.4 0 24s1 7 2.7 10.4l7.2-5.6z"/>
      <path fill="#EA4335" d="M24 47c6.5 0 11.9-2.1 15.9-5.8l-7.2-5.6c-2 1.4-4.7 2.4-8.7 2.4-6.6 0-12.3-4.1-14.1-10.2l-7.2 5.6C6.6 41.6 14.7 47 24 47z"/>
    </svg>
  );
}

function TelegramPaperPlane() {
  return (
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
      <path d="M21 3 2 11 9 13 11 20 21 3z" fill="#fff" />
      <path d="M9 13 L21 3 L13 14 Z" fill="#9BD0E8" opacity="0.6" />
    </svg>
  );
}

// ─────────────────────────────────────────────────────────────
// Keypad mock for the Telegram screen (visual only)
// ─────────────────────────────────────────────────────────────
function AuthKeypad({ t, theme }) {
  const rows = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['', '0', '⌫'],
  ];
  return (
    <div style={{
      position: 'absolute', left: 0, right: 0, bottom: 0,
      background: theme === 'dark' ? '#0e120e' : '#D9D5CB',
      padding: '8px 6px 10px',
      display: 'none', // hidden visually — keep the layout clean
    }}>
      {rows.map((r, i) => (
        <div key={i} style={{ display: 'flex', gap: 6, padding: '4px 0' }}>
          {r.map((k, j) => (
            <div key={j} style={{
              flex: 1, height: 44, borderRadius: 8,
              background: k ? (theme === 'dark' ? '#26302a' : '#fff') : 'transparent',
              display: 'grid', placeItems: 'center',
              fontSize: 20, fontWeight: 500, color: t.ink,
              boxShadow: k ? '0 1px 0 rgba(0,0,0,0.2)' : 'none',
            }}>
              {k}
            </div>
          ))}
        </div>
      ))}
    </div>
  );
}

Object.assign(window, { AuthWelcomeScreen, AuthTelegramScreen, AuthWelcomeBackScreen });
