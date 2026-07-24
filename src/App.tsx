import { useState } from 'react'
import StudentDashboard from './components/StudentDashboard'
import TeacherPortal from './components/TeacherPortal'
import AdminPortal from './components/AdminPortal'
import LiveMeeting from './components/LiveMeeting'
import AIAssistantModal from './components/AIAssistantModal'

type View = 'admin' | 'student' | 'teacher' | 'live'
type Role = 'admin' | 'student' | 'teacher'

const navItems: { id: View; label: string; icon: string; section?: string }[] = [
  { id: 'admin', label: 'Admin Governance', icon: '🏛️', section: 'System Administration' },
  { id: 'teacher', label: 'Teacher Portal', icon: '📚', section: 'Academic Portals' },
  { id: 'student', label: 'Student View', icon: '🎓', section: '' },
  { id: 'live', label: 'Live Session (LiveKit)', icon: '📡', section: 'Virtual Classroom' },
]

export default function App() {
  const [view, setView] = useState<View>('student')
  const [role, setRole] = useState<Role>('student')
  const [collapsed, setCollapsed] = useState(false)
  const [aiOpen, setAiOpen] = useState(false)

  const goLive = (r: Role) => {
    setRole(r)
    setView('live')
  }

  if (view === 'live') {
    return (
      <div className="relative">
        <button
          onClick={() => setView(role === 'admin' ? 'admin' : role === 'teacher' ? 'teacher' : 'student')}
          className="absolute top-4 left-20 z-50 flex items-center gap-2 text-xs px-3 py-1.5 rounded-full transition-opacity hover:opacity-80"
          style={{ background: 'var(--muted)', color: 'var(--muted-foreground)', border: '1px solid var(--border)' }}
        >
          ← Back
        </button>
        <LiveMeeting role={role === 'admin' ? 'teacher' : role} />
      </div>
    )
  }

  return (
    <div className="flex h-screen overflow-hidden" style={{ background: 'var(--background)' }}>
      {/* AI Modal */}
      <AIAssistantModal isOpen={aiOpen} onClose={() => setAiOpen(false)} />

      {/* Sidebar */}
      <aside
        className="flex flex-col border-r shrink-0 transition-all duration-200"
        style={{
          width: collapsed ? 60 : 230,
          background: 'var(--card)',
          borderColor: 'var(--border)',
        }}
      >
        {/* Logo */}
        <div
          className="flex items-center gap-3 px-4 py-5 border-b"
          style={{ borderColor: 'var(--border)', minHeight: 64 }}
        >
          <div
            className="w-8 h-8 rounded-lg flex items-center justify-center shrink-0 font-bold text-sm"
            style={{ background: 'var(--primary)', color: '#fff', fontFamily: 'Lexend' }}
          >
            L
          </div>
          {!collapsed && (
            <span className="font-semibold tracking-tight text-sm flex items-center gap-2" style={{ fontFamily: 'Lexend', color: 'var(--foreground)' }}>
              LearnSpace <span className="mono text-[10px] px-1.5 py-0.5 rounded bg-blue-500/20 text-blue-400">LMS v2.4</span>
            </span>
          )}
        </div>

        {/* Nav */}
        <nav className="flex-1 px-2 py-4 flex flex-col gap-1">
          {navItems.map((item, i) => {
            const showSection = !collapsed && item.section !== undefined && (i === 0 || navItems[i - 1].section !== item.section)
            return (
              <div key={item.id}>
                {showSection && item.section && (
                  <p className="mono text-xs uppercase tracking-widest px-3 pb-1 pt-3"
                    style={{ color: 'var(--muted-foreground)', fontSize: 10 }}>
                    {item.section}
                  </p>
                )}
                <button
                  onClick={() => {
                    setView(item.id)
                    if (item.id === 'admin') setRole('admin')
                    else if (item.id === 'teacher') setRole('teacher')
                    else if (item.id === 'student') setRole('student')
                  }}
                  className="w-full flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm transition-all text-left"
                  style={{
                    background: view === item.id ? 'var(--primary)22' : 'transparent',
                    color: view === item.id ? 'var(--primary)' : 'var(--muted-foreground)',
                    fontWeight: view === item.id ? 600 : 400,
                  }}
                  title={collapsed ? item.label : undefined}
                >
                  <span className="text-base shrink-0">{item.icon}</span>
                  {!collapsed && (
                    <span style={{ fontFamily: 'DM Sans' }}>{item.label}</span>
                  )}
                  {!collapsed && item.id === 'live' && (
                    <span
                      className="ml-auto text-xs px-1.5 py-0.5 rounded-full mono"
                      style={{ background: 'var(--accent)22', color: 'var(--accent)' }}
                    >
                      LIVE
                    </span>
                  )}
                </button>
              </div>
            )
          })}
        </nav>

        {/* Bottom section */}
        <div className="px-2 pb-4 flex flex-col gap-1 border-t pt-3" style={{ borderColor: 'var(--border)' }}>
          {!collapsed && (
            <div className="px-3 py-2 rounded-lg flex items-center gap-3"
              style={{ background: 'var(--muted)' }}>
              <div
                className="w-7 h-7 rounded-full flex items-center justify-center text-xs font-semibold shrink-0"
                style={{ background: 'var(--primary)33', color: 'var(--primary)', fontFamily: 'Lexend' }}
              >
                {role === 'admin' ? 'AD' : role === 'teacher' ? 'EV' : 'AD'}
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-xs font-medium truncate" style={{ fontFamily: 'Lexend', color: 'var(--foreground)' }}>
                  {role === 'admin' ? 'System Admin' : role === 'teacher' ? 'Dr. Vasquez' : 'Amara Diallo'}
                </p>
                <p className="text-xs truncate capitalize mono" style={{ color: 'var(--muted-foreground)' }}>Role: {role}</p>
              </div>
            </div>
          )}
          <button
            onClick={() => setCollapsed(c => !c)}
            className="w-full flex items-center justify-center py-2 rounded-lg text-xs transition-colors hover:bg-white/[0.04]"
            style={{ color: 'var(--muted-foreground)' }}
          >
            {collapsed ? '→' : '←'}
          </button>
        </div>
      </aside>

      {/* Main content */}
      <main className="flex-1 overflow-y-auto flex flex-col">
        {/* Top bar */}
        <div
          className="flex items-center justify-between px-8 py-4 border-b shrink-0 sticky top-0 z-10"
          style={{ background: 'var(--background)', borderColor: 'var(--border)' }}
        >
          <div className="flex items-center gap-3">
            <h2 className="text-sm font-semibold" style={{ fontFamily: 'Lexend', color: 'var(--foreground)' }}>
              {view === 'admin' ? 'Admin Governance' : view === 'student' ? 'Student Dashboard' : view === 'teacher' ? 'Teacher Portal' : 'Live Session'}
            </h2>
          </div>

          <div className="flex items-center gap-3">
            {/* AI Assistant button */}
            <button
              onClick={() => setAiOpen(true)}
              className="flex items-center gap-1.5 px-3 py-1.5 rounded-full text-xs font-semibold transition-all hover:opacity-90 shadow-sm"
              style={{ background: 'linear-gradient(135deg, #4c7eff 0%, #a78bfa 100%)', color: '#fff' }}
            >
              <span>✨</span>
              <span>AI Features</span>
            </button>

            {/* Role switcher */}
            <div
              className="flex items-center gap-1 p-1 rounded-full"
              style={{ background: 'var(--secondary)' }}
            >
              {(['admin', 'teacher', 'student'] as Role[]).map(r => (
                <button
                  key={r}
                  onClick={() => {
                    setRole(r)
                    setView(r)
                  }}
                  className="px-3 py-1 rounded-full text-xs font-medium capitalize transition-all"
                  style={{
                    background: role === r ? 'var(--primary)' : 'transparent',
                    color: role === r ? '#fff' : 'var(--muted-foreground)',
                  }}
                >
                  {r}
                </button>
              ))}
            </div>

            {/* Notification dot */}
            <button className="relative w-8 h-8 rounded-full flex items-center justify-center transition-colors hover:bg-white/[0.05]"
              style={{ color: 'var(--muted-foreground)' }}>
              🔔
              <span className="absolute top-1 right-1 w-2 h-2 rounded-full" style={{ background: '#ef4444' }} />
            </button>

            {/* Avatar */}
            <div
              className="w-8 h-8 rounded-full flex items-center justify-center text-xs font-semibold cursor-pointer"
              style={{ background: 'var(--primary)33', color: 'var(--primary)', fontFamily: 'Lexend' }}
            >
              {role === 'admin' ? 'AD' : role === 'teacher' ? 'EV' : 'AD'}
            </div>
          </div>
        </div>

        {/* View content */}
        <div className="flex-1">
          {view === 'admin' && <AdminPortal />}
          {view === 'student' && <StudentDashboard onJoinLive={() => goLive('student')} />}
          {view === 'teacher' && <TeacherPortal onStartLive={() => goLive('teacher')} />}
        </div>
      </main>
    </div>
  )
}

