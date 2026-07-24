import { useState, useEffect } from 'react'

const participants = [
  { id: 1, name: 'Dr. Elena Vasquez', role: 'instructor', speaking: true, muted: false, video: true, initials: 'EV' },
  { id: 2, name: 'Amara Diallo', role: 'student', speaking: false, muted: false, video: true, initials: 'AD' },
  { id: 3, name: 'Luca Ferretti', role: 'student', speaking: false, muted: true, video: false, initials: 'LF' },
  { id: 4, name: 'Yuna Park', role: 'student', speaking: false, muted: false, video: true, initials: 'YP' },
  { id: 5, name: 'Kwame Asante', role: 'student', speaking: false, muted: true, video: true, initials: 'KA' },
  { id: 6, name: 'Sofia Reyes', role: 'student', speaking: false, muted: false, video: false, initials: 'SR' },
]

const avatarColors = ['#4c7eff', '#00d9a3', '#a78bfa', '#fb923c', '#f472b6', '#34d399']

const initialMessages = [
  { id: 1, sender: 'Dr. Vasquez', text: "Today we'll cover differential equations — please have your notes ready.", time: '14:02', self: false },
  { id: 2, sender: 'Amara Diallo', text: "Ready! Quick question — will the integration techniques from last week be on the midterm?", time: '14:03', self: true },
  { id: 3, sender: 'Yuna Park', text: "Same question here 🙏", time: '14:03', self: false },
  { id: 4, sender: 'Dr. Vasquez', text: "Yes, integration by parts will definitely be there. We'll do a quick review at the end.", time: '14:05', self: false },
  { id: 5, sender: 'Luca Ferretti', text: "Can we go over the chain rule again?", time: '14:06', self: false },
]

function ParticipantTile({
  participant, large, color
}: { participant: typeof participants[0]; large?: boolean; color: string }) {
  return (
    <div
      className="relative rounded-xl overflow-hidden flex items-center justify-center"
      style={{
        background: `${color}15`,
        border: participant.speaking ? `2px solid ${color}` : '2px solid transparent',
        aspectRatio: '16/9',
        minHeight: large ? 240 : 120,
        transition: 'border-color 0.2s',
      }}
    >
      {/* Simulated video / avatar */}
      {participant.video ? (
        <div
          className="absolute inset-0"
          style={{
            background: `radial-gradient(ellipse at 50% 30%, ${color}22, transparent 70%), ${color}0a`,
          }}
        >
          <div
            className="absolute bottom-1/4 left-1/2 -translate-x-1/2 rounded-full flex items-center justify-center font-semibold"
            style={{
              width: large ? 72 : 40,
              height: large ? 72 : 40,
              fontSize: large ? 28 : 15,
              background: color + '40',
              color,
              border: `2px solid ${color}60`,
              fontFamily: 'Lexend',
            }}
          >
            {participant.initials}
          </div>
        </div>
      ) : (
        <div
          className="rounded-full flex items-center justify-center font-semibold"
          style={{
            width: large ? 72 : 40,
            height: large ? 72 : 40,
            fontSize: large ? 28 : 15,
            background: color + '30',
            color,
            fontFamily: 'Lexend',
          }}
        >
          {participant.initials}
        </div>
      )}

      {/* Name badge */}
      <div
        className="absolute bottom-2 left-2 flex items-center gap-1.5 px-2 py-0.5 rounded"
        style={{ background: 'rgba(0,0,0,0.6)' }}
      >
        {participant.role === 'instructor' && (
          <span className="text-xs" style={{ color: 'var(--accent)' }}>★</span>
        )}
        <span className="text-xs font-medium" style={{ color: '#fff', fontFamily: 'Lexend' }}>
          {large ? participant.name : participant.name.split(' ')[0]}
        </span>
      </div>

      {/* Mute indicator */}
      {participant.muted && (
        <div
          className="absolute top-2 right-2 w-5 h-5 rounded-full flex items-center justify-center"
          style={{ background: '#ef444488' }}
        >
          <svg width="10" height="10" viewBox="0 0 10 10" fill="none">
            <line x1="1" y1="1" x2="9" y2="9" stroke="white" strokeWidth="1.5" strokeLinecap="round" />
          </svg>
        </div>
      )}

      {/* Speaking ring */}
      {participant.speaking && (
        <div className="absolute inset-0 rounded-xl" style={{ boxShadow: `inset 0 0 0 2px ${color}` }} />
      )}
    </div>
  )
}

export default function LiveMeeting({ role = 'student' }: { role?: 'student' | 'teacher' }) {
  const [muted, setMuted] = useState(false)
  const [videoOff, setVideoOff] = useState(false)
  const [chatOpen, setChatOpen] = useState(true)
  const [participantsOpen, setParticipantsOpen] = useState(false)
  const [messages, setMessages] = useState(initialMessages)
  const [input, setInput] = useState('')
  const [elapsed, setElapsed] = useState(0)
  const [handRaised, setHandRaised] = useState(false)

  useEffect(() => {
    const t = setInterval(() => setElapsed(e => e + 1), 1000)
    return () => clearInterval(t)
  }, [])

  const formatTime = (s: number) => {
    const m = Math.floor(s / 60).toString().padStart(2, '0')
    const sec = (s % 60).toString().padStart(2, '0')
    return `${m}:${sec}`
  }

  const sendMessage = () => {
    if (!input.trim()) return
    setMessages(prev => [...prev, {
      id: prev.length + 1,
      sender: role === 'teacher' ? 'Dr. Vasquez' : 'Amara Diallo',
      text: input.trim(),
      time: new Date().toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: false }),
      self: true,
    }])
    setInput('')
  }

  const instructor = participants[0]
  const studentsGrid = participants.slice(1)

  return (
    <div className="flex flex-col h-screen overflow-hidden" style={{ background: '#080b10' }}>
      {/* Top bar */}
      <div
        className="flex items-center justify-between px-6 py-3 border-b shrink-0"
        style={{ background: 'var(--card)', borderColor: 'var(--border)' }}
      >
        <div className="flex items-center gap-4">
          <div className="flex items-center gap-2">
            <span className="w-2 h-2 rounded-full animate-pulse" style={{ background: 'var(--accent)' }} />
            <span className="font-semibold text-sm" style={{ fontFamily: 'Lexend', color: 'var(--foreground)' }}>
              MATH 401 — Advanced Mathematics
            </span>
          </div>
          <span className="mono text-xs px-2 py-0.5 rounded" style={{ background: 'var(--muted)', color: 'var(--muted-foreground)' }}>
            LIVE
          </span>
        </div>
        <div className="flex items-center gap-4">
          <span className="mono text-sm" style={{ color: 'var(--accent)' }}>{formatTime(elapsed)}</span>
          <span className="mono text-xs" style={{ color: 'var(--muted-foreground)' }}>{participants.length} participants</span>
          <button className="text-xs px-3 py-1.5 rounded-lg font-medium transition-opacity hover:opacity-80"
            style={{ background: '#ef444422', color: '#ef4444', border: '1px solid #ef444444' }}>
            End Session
          </button>
        </div>
      </div>

      {/* Main body */}
      <div className="flex flex-1 overflow-hidden">
        {/* Video area */}
        <div className="flex-1 flex flex-col gap-4 p-5 overflow-y-auto">
          {/* Instructor — large tile */}
          <ParticipantTile participant={instructor} large color={avatarColors[0]} />

          {/* Student grid */}
          <div className="grid grid-cols-5 gap-3">
            {studentsGrid.map((p, i) => (
              <ParticipantTile key={p.id} participant={p} color={avatarColors[i + 1]} />
            ))}
          </div>
        </div>

        {/* Sidebar */}
        <div
          className="w-72 shrink-0 flex flex-col border-l"
          style={{ background: 'var(--card)', borderColor: 'var(--border)' }}
        >
          {/* Sidebar tabs */}
          <div className="flex border-b" style={{ borderColor: 'var(--border)' }}>
            {[
              { key: 'chat', label: 'Chat' },
              { key: 'participants', label: `People (${participants.length})` },
            ].map(tab => (
              <button
                key={tab.key}
                onClick={() => {
                  if (tab.key === 'chat') { setChatOpen(true); setParticipantsOpen(false) }
                  else { setParticipantsOpen(true); setChatOpen(false) }
                }}
                className="flex-1 py-3 text-xs font-medium transition-colors"
                style={{
                  color: (tab.key === 'chat' ? chatOpen : participantsOpen) ? 'var(--primary)' : 'var(--muted-foreground)',
                  borderBottom: (tab.key === 'chat' ? chatOpen : participantsOpen)
                    ? '2px solid var(--primary)' : '2px solid transparent',
                }}
              >
                {tab.label}
              </button>
            ))}
          </div>

          {/* Chat */}
          {chatOpen && (
            <>
              <div className="flex-1 overflow-y-auto p-4 flex flex-col gap-3">
                {messages.map(m => (
                  <div key={m.id} className={`flex flex-col gap-0.5 ${m.self ? 'items-end' : 'items-start'}`}>
                    {!m.self && (
                      <span className="text-xs mono" style={{ color: 'var(--muted-foreground)' }}>{m.sender}</span>
                    )}
                    <div
                      className="max-w-[85%] px-3 py-2 rounded-xl text-xs leading-relaxed"
                      style={{
                        background: m.self ? 'var(--primary)' : 'var(--muted)',
                        color: m.self ? '#fff' : 'var(--foreground)',
                        borderRadius: m.self ? '14px 14px 4px 14px' : '14px 14px 14px 4px',
                      }}
                    >
                      {m.text}
                    </div>
                    <span className="text-xs mono" style={{ color: 'var(--muted-foreground)', fontSize: 10 }}>{m.time}</span>
                  </div>
                ))}
              </div>
              <div className="p-3 border-t flex gap-2" style={{ borderColor: 'var(--border)' }}>
                <input
                  type="text"
                  value={input}
                  onChange={e => setInput(e.target.value)}
                  onKeyDown={e => e.key === 'Enter' && sendMessage()}
                  placeholder="Send a message..."
                  className="flex-1 px-3 py-2 rounded-lg text-xs border outline-none"
                  style={{ background: 'var(--muted)', borderColor: 'var(--border)', color: 'var(--foreground)' }}
                />
                <button
                  onClick={sendMessage}
                  className="px-3 py-2 rounded-lg text-xs font-medium transition-opacity hover:opacity-80"
                  style={{ background: 'var(--primary)', color: '#fff' }}
                >
                  ↵
                </button>
              </div>
            </>
          )}

          {/* Participants */}
          {participantsOpen && (
            <div className="flex-1 overflow-y-auto p-3 flex flex-col gap-1">
              {participants.map((p, i) => (
                <div key={p.id} className="flex items-center gap-3 p-2 rounded-lg hover:bg-white/[0.03] transition-colors">
                  <div
                    className="w-7 h-7 rounded-full flex items-center justify-center text-xs font-semibold shrink-0"
                    style={{ background: avatarColors[i] + '30', color: avatarColors[i], fontFamily: 'Lexend' }}
                  >
                    {p.initials}
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="text-xs font-medium truncate" style={{ color: 'var(--foreground)', fontFamily: 'Lexend' }}>{p.name}</p>
                    <p className="text-xs" style={{ color: 'var(--muted-foreground)' }}>{p.role}</p>
                  </div>
                  <div className="flex items-center gap-1.5">
                    {p.muted && (
                      <span className="text-xs" style={{ color: '#ef4444' }}>🔇</span>
                    )}
                    {!p.video && (
                      <span className="text-xs" style={{ color: 'var(--muted-foreground)' }}>📷</span>
                    )}
                    {p.speaking && (
                      <span className="w-2 h-2 rounded-full animate-pulse" style={{ background: 'var(--accent)' }} />
                    )}
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>

      {/* Controls bar */}
      <div
        className="flex items-center justify-center gap-3 py-4 border-t shrink-0"
        style={{ background: 'var(--card)', borderColor: 'var(--border)' }}
      >
        <ControlButton
          active={!muted}
          onClick={() => setMuted(m => !m)}
          icon={muted ? '🔇' : '🎤'}
          label={muted ? 'Unmute' : 'Mute'}
        />
        <ControlButton
          active={!videoOff}
          onClick={() => setVideoOff(v => !v)}
          icon={videoOff ? '📷' : '📹'}
          label={videoOff ? 'Start Video' : 'Stop Video'}
        />
        <ControlButton active={false} icon="🖥️" label="Share Screen" />
        <ControlButton
          active={handRaised}
          onClick={() => setHandRaised(h => !h)}
          icon="✋"
          label={handRaised ? 'Lower Hand' : 'Raise Hand'}
          accent={handRaised}
        />
        {role === 'teacher' && (
          <ControlButton active={false} icon="📋" label="Whiteboard" />
        )}
        <ControlButton
          active={chatOpen}
          onClick={() => { setChatOpen(true); setParticipantsOpen(false) }}
          icon="💬"
          label="Chat"
        />
        <div className="w-px h-8 mx-1" style={{ background: 'var(--border)' }} />
        <button
          className="px-5 py-2.5 rounded-xl text-sm font-semibold transition-opacity hover:opacity-85"
          style={{ background: '#ef4444', color: '#fff', fontFamily: 'Lexend' }}
        >
          Leave
        </button>
      </div>
    </div>
  )
}

function ControlButton({
  active, onClick, icon, label, accent
}: {
  active: boolean
  onClick?: () => void
  icon: string
  label: string
  accent?: boolean
}) {
  return (
    <button
      onClick={onClick}
      className="flex flex-col items-center gap-1 px-3 py-2 rounded-xl transition-all hover:bg-white/[0.05]"
      style={{ minWidth: 60 }}
    >
      <span
        className="w-10 h-10 rounded-full flex items-center justify-center text-lg transition-all"
        style={{
          background: accent ? 'var(--accent)33' : active ? 'var(--primary)22' : 'var(--muted)',
          border: accent ? '1px solid var(--accent)66' : active ? '1px solid var(--primary)44' : '1px solid var(--border)',
        }}
      >
        {icon}
      </span>
      <span className="text-xs" style={{ color: 'var(--muted-foreground)', fontFamily: 'DM Sans' }}>{label}</span>
    </button>
  )
}
