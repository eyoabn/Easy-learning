import { useState } from 'react'
import AuthFlow, { type AuthUser } from './components/AuthFlow'
import StudentDashboard from './components/StudentDashboard'
import TeacherPortal from './components/TeacherPortal'
import AdminPortal from './components/AdminPortal'
import LiveMeeting from './components/LiveMeeting'
import AIAssistantModal from './components/AIAssistantModal'

// Seed demo accounts that are already approved
const SEED_USERS: AuthUser[] = [
  {
    id: 'teacher-1',
    name: 'Dr. Elena Vasquez',
    email: 'vasquez@learnspace.edu',
    role: 'teacher',
    status: 'approved',
    department: 'Mathematics & Computer Science',
    avatar: 'EV',
  },
  {
    id: 'student-1',
    name: 'Amara Diallo',
    email: 'amara@learnspace.edu',
    role: 'student',
    status: 'approved',
    department: 'Engineering',
    avatar: 'AD',
  },
]

type View = 'dashboard' | 'live'

export default function App() {
  const [currentUser, setCurrentUser] = useState<AuthUser | null>(null)
  const [view, setView] = useState<View>('dashboard')
  const [registeredUsers, setRegisteredUsers] = useState<AuthUser[]>(SEED_USERS)
  const [aiOpen, setAiOpen] = useState(false)
  const [sidebarCollapsed, setSidebarCollapsed] = useState(false)

  // ── Auth handlers ──────────────────────────────────────────────────────────
  const handleLogin = (user: AuthUser) => {
    setCurrentUser(user)
    setView('dashboard')
  }

  const handleLogout = () => {
    setCurrentUser(null)
    setView('dashboard')
  }

  const handleRegister = (user: AuthUser) => {
    setRegisteredUsers(prev => [...prev, user])
  }

  const handleApproveUser = (id: string) => {
    setRegisteredUsers(prev =>
      prev.map(u => u.id === id ? { ...u, status: 'approved' } : u)
    )
  }

  const handleRejectUser = (id: string) => {
    setRegisteredUsers(prev =>
      prev.map(u => u.id === id ? { ...u, status: 'rejected' } : u)
    )
  }

  // Users waiting for approval (only pending ones)
  const pendingUsers = registeredUsers.filter(u => u.status === 'pending')

  // ── Not logged in → show auth ──────────────────────────────────────────────
  if (!currentUser) {
    return (
      <AuthFlow
        onLogin={handleLogin}
        registeredUsers={registeredUsers}
        onRegister={handleRegister}
      />
    )
  }

  // ── Live meeting view ───────────────────────────────────────────────────────
  if (view === 'live') {
    return (
      <div className="relative">
        <button
          onClick={() => setView('dashboard')}
          className="absolute top-4 left-4 z-50 flex items-center gap-2 text-xs px-4 py-2 rounded-full transition-all hover:opacity-80"
          style={{ background: 'var(--card)', color: 'var(--muted-foreground)', border: '1px solid var(--border)' }}
        >
          ← Back to Dashboard
        </button>
        <LiveMeeting role={currentUser.role === 'admin' ? 'teacher' : currentUser.role} />
      </div>
    )
  }

  // ── Main layout ─────────────────────────────────────────────────────────────
  const notifCount = currentUser.role === 'admin' ? pendingUsers.length : 0

  return (
    <div className="flex h-screen overflow-hidden" style={{ background: 'var(--background)' }}>
      <AIAssistantModal isOpen={aiOpen} onClose={() => setAiOpen(false)} />

      {/* ── Sidebar ── */}
      <aside
        className="flex flex-col border-r shrink-0 transition-all duration-200"
        style={{ width: sidebarCollapsed ? 64 : 240, background: 'var(--card)', borderColor: 'var(--border)' }}
      >
        {/* Logo */}
        <div
          className="flex items-center gap-3 px-4 py-5 border-b"
          style={{ borderColor: 'var(--border)', minHeight: 64 }}
        >
          <div
            className="w-8 h-8 rounded-xl flex items-center justify-center shrink-0 font-bold text-sm"
            style={{ background: 'linear-gradient(135deg, #4c7eff 0%, #a78bfa 100%)', color: '#fff', fontFamily: 'Lexend' }}
          >
            L
          </div>
          {!sidebarCollapsed && (
            <div>
              <p className="font-semibold text-sm" style={{ fontFamily: 'Lexend', color: 'var(--foreground)' }}>
                LearnSpace
              </p>
              <p className="text-xs mono" style={{ color: 'var(--muted-foreground)' }}>LMS v2.4</p>
            </div>
          )}
        </div>

        {/* Navigation */}
        <nav className="flex-1 px-2 py-4 flex flex-col gap-1">
          {/* Role badge */}
          {!sidebarCollapsed && (
            <div className="px-3 mb-3">
              <span
                className="mono text-xs px-2.5 py-1 rounded-full capitalize font-medium"
                style={{
                  background: currentUser.role === 'admin' ? '#a78bfa22' : currentUser.role === 'teacher' ? '#4c7eff22' : '#00d9a322',
                  color: currentUser.role === 'admin' ? '#a78bfa' : currentUser.role === 'teacher' ? '#4c7eff' : '#00d9a3',
                }}
              >
                {currentUser.role === 'admin' ? '🏛️' : currentUser.role === 'teacher' ? '📚' : '🎓'} {currentUser.role}
              </span>
            </div>
          )}

          {/* Nav items per role */}
          {currentUser.role === 'admin' && (
            <>
              <NavItem icon="📊" label="Dashboard" collapsed={sidebarCollapsed} active />
              <NavItem icon="✅" label={`Approvals${pendingUsers.length > 0 ? ` (${pendingUsers.length})` : ''}`} collapsed={sidebarCollapsed} badge={pendingUsers.length} />
              <NavItem icon="🏛️" label="Institutions" collapsed={sidebarCollapsed} />
              <NavItem icon="🔍" label="Audit Logs" collapsed={sidebarCollapsed} />
              <NavItem icon="⚙️" label="System Settings" collapsed={sidebarCollapsed} />
            </>
          )}
          {currentUser.role === 'teacher' && (
            <>
              <NavItem icon="📊" label="Overview" collapsed={sidebarCollapsed} active />
              <NavItem icon="🎓" label="My Students" collapsed={sidebarCollapsed} />
              <NavItem icon="📋" label="Enrollment Requests" collapsed={sidebarCollapsed} />
              <NavItem icon="📝" label="Assignments" collapsed={sidebarCollapsed} />
              <NavItem icon="📡" label="Live Session" collapsed={sidebarCollapsed} live onClick={() => setView('live')} />
            </>
          )}
          {currentUser.role === 'student' && (
            <>
              <NavItem icon="🏠" label="Dashboard" collapsed={sidebarCollapsed} active />
              <NavItem icon="📚" label="My Courses" collapsed={sidebarCollapsed} />
              <NavItem icon="📝" label="Assignments" collapsed={sidebarCollapsed} />
              <NavItem icon="📊" label="Grades" collapsed={sidebarCollapsed} />
              <NavItem icon="📡" label="Join Live" collapsed={sidebarCollapsed} live onClick={() => setView('live')} />
            </>
          )}
        </nav>

        {/* Bottom user section */}
        <div className="px-2 pb-4 flex flex-col gap-2 border-t pt-3" style={{ borderColor: 'var(--border)' }}>
          {!sidebarCollapsed && (
            <div className="px-3 py-2.5 rounded-xl flex items-center gap-3" style={{ background: 'var(--muted)' }}>
              <div
                className="w-8 h-8 rounded-xl flex items-center justify-center text-xs font-semibold shrink-0"
                style={{
                  background: currentUser.role === 'admin' ? '#a78bfa33' : currentUser.role === 'teacher' ? '#4c7eff33' : '#00d9a333',
                  color: currentUser.role === 'admin' ? '#a78bfa' : currentUser.role === 'teacher' ? '#4c7eff' : '#00d9a3',
                  fontFamily: 'Lexend',
                }}
              >
                {currentUser.avatar}
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-xs font-medium truncate" style={{ fontFamily: 'Lexend', color: 'var(--foreground)' }}>
                  {currentUser.name}
                </p>
                <p className="text-xs truncate mono" style={{ color: 'var(--muted-foreground)' }}>{currentUser.email}</p>
              </div>
            </div>
          )}
          <button
            onClick={() => setSidebarCollapsed(c => !c)}
            className="w-full flex items-center justify-center py-2 rounded-xl text-xs transition-colors hover:bg-white/[0.04]"
            style={{ color: 'var(--muted-foreground)' }}
            title={sidebarCollapsed ? 'Expand sidebar' : 'Collapse sidebar'}
          >
            {sidebarCollapsed ? '→' : '←'}
          </button>
        </div>
      </aside>

      {/* ── Main Content ── */}
      <main className="flex-1 overflow-y-auto flex flex-col">
        {/* Topbar */}
        <header
          className="flex items-center justify-between px-8 py-4 border-b shrink-0 sticky top-0 z-10"
          style={{ background: 'var(--background)', borderColor: 'var(--border)' }}
        >
          <div className="flex items-center gap-3">
            <div>
              <h2 className="text-sm font-semibold" style={{ fontFamily: 'Lexend', color: 'var(--foreground)' }}>
                {currentUser.role === 'admin' ? 'Admin Control Center' : currentUser.role === 'teacher' ? 'Teacher Portal' : 'Student Dashboard'}
              </h2>
              <p className="text-xs" style={{ color: 'var(--muted-foreground)' }}>
                {currentUser.department || (currentUser.role === 'admin' ? 'System Administration' : '')}
              </p>
            </div>
          </div>

          <div className="flex items-center gap-2">
            {/* AI Features */}
            <button
              onClick={() => setAiOpen(true)}
              className="flex items-center gap-1.5 px-4 py-2 rounded-xl text-xs font-semibold transition-all hover:opacity-90 shadow-sm"
              style={{ background: 'linear-gradient(135deg, #4c7eff 0%, #a78bfa 100%)', color: '#fff', fontFamily: 'Lexend' }}
            >
              <span>✨</span>
              <span>AI Features</span>
            </button>

            {/* Notifications */}
            <button
              className="relative w-9 h-9 rounded-xl flex items-center justify-center transition-colors hover:bg-white/[0.05] text-base"
              style={{ color: 'var(--muted-foreground)' }}
            >
              🔔
              {notifCount > 0 && (
                <span
                  className="absolute top-1.5 right-1.5 w-4 h-4 rounded-full flex items-center justify-center text-[9px] font-bold"
                  style={{ background: '#ef4444', color: '#fff' }}
                >
                  {notifCount}
                </span>
              )}
            </button>

            {/* User Avatar */}
            <div
              className="w-9 h-9 rounded-xl flex items-center justify-center text-xs font-semibold cursor-pointer"
              style={{
                background: currentUser.role === 'admin' ? '#a78bfa33' : currentUser.role === 'teacher' ? '#4c7eff33' : '#00d9a333',
                color: currentUser.role === 'admin' ? '#a78bfa' : currentUser.role === 'teacher' ? '#4c7eff' : '#00d9a3',
                fontFamily: 'Lexend',
              }}
            >
              {currentUser.avatar}
            </div>
          </div>
        </header>

        {/* Portal Content */}
        <div className="flex-1">
          {currentUser.role === 'admin' && (
            <AdminPortal
              pendingUsers={pendingUsers}
              onApprove={handleApproveUser}
              onReject={handleRejectUser}
              onLogout={handleLogout}
              currentUser={currentUser}
            />
          )}
          {currentUser.role === 'teacher' && (
            <TeacherPortal
              onStartLive={() => setView('live')}
              onLogout={handleLogout}
              currentUser={currentUser}
            />
          )}
          {currentUser.role === 'student' && (
            <StudentDashboard
              onJoinLive={() => setView('live')}
              onLogout={handleLogout}
              currentUser={currentUser}
            />
          )}
        </div>
      </main>
    </div>
  )
}

// ── NavItem helper ─────────────────────────────────────────────────────────────
function NavItem({
  icon, label, collapsed, active, live, badge, onClick,
}: {
  icon: string
  label: string
  collapsed: boolean
  active?: boolean
  live?: boolean
  badge?: number
  onClick?: () => void
}) {
  return (
    <button
      onClick={onClick}
      className="w-full flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm transition-all text-left"
      style={{
        background: active ? 'var(--primary)15' : 'transparent',
        color: active ? 'var(--primary)' : 'var(--muted-foreground)',
        fontWeight: active ? 600 : 400,
      }}
      title={collapsed ? label : undefined}
    >
      <span className="text-base shrink-0">{icon}</span>
      {!collapsed && (
        <>
          <span className="flex-1 text-sm truncate" style={{ fontFamily: 'DM Sans' }}>{label}</span>
          {live && (
            <span className="mono text-xs px-1.5 py-0.5 rounded-full" style={{ background: 'var(--accent)22', color: 'var(--accent)' }}>
              LIVE
            </span>
          )}
          {badge && badge > 0 ? (
            <span className="w-5 h-5 rounded-full flex items-center justify-center text-xs font-bold" style={{ background: '#fb923c', color: '#fff' }}>
              {badge}
            </span>
          ) : null}
        </>
      )}
    </button>
  )
}
