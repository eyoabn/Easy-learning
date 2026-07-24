import { useState } from 'react'

export type UserRole = 'admin' | 'teacher' | 'student'

export interface AuthUser {
  id: string
  name: string
  email: string
  role: UserRole
  status: 'pending' | 'approved' | 'rejected'
  department?: string
  avatar: string
}

type AuthScreen = 'login' | 'register' | 'pending' | 'rejected'

interface AuthFlowProps {
  onLogin: (user: AuthUser) => void
  registeredUsers: AuthUser[]
  onRegister: (user: AuthUser) => void
}

const DEMO_ADMIN: AuthUser = {
  id: 'admin-1',
  name: 'Amara Diallo',
  email: 'admin@learnspace.edu',
  role: 'admin',
  status: 'approved',
  avatar: 'AD',
}

const departments = [
  'Computer Science',
  'Mathematics',
  'Biology & Life Sciences',
  'Physics',
  'Business & Economics',
  'Arts & Humanities',
  'Engineering',
  'Law',
]

const InputField = ({
  label,
  type = 'text',
  value,
  onChange,
  placeholder,
  required,
}: {
  label: string
  type?: string
  value: string
  onChange: (v: string) => void
  placeholder?: string
  required?: boolean
}) => (
  <div className="flex flex-col gap-1.5">
    <label className="text-xs font-medium" style={{ color: 'var(--foreground)', fontFamily: 'DM Sans' }}>
      {label} {required && <span style={{ color: 'var(--primary)' }}>*</span>}
    </label>
    <input
      type={type}
      value={value}
      onChange={e => onChange(e.target.value)}
      placeholder={placeholder}
      required={required}
      className="px-4 py-2.5 rounded-xl text-sm border outline-none transition-all focus:ring-2"
      style={{
        background: 'var(--input-bg)',
        borderColor: 'var(--border)',
        color: 'var(--foreground)',
        fontFamily: 'DM Sans',
        ringColor: 'var(--primary)',
      }}
    />
  </div>
)

export default function AuthFlow({ onLogin, registeredUsers, onRegister }: AuthFlowProps) {
  const [screen, setScreen] = useState<AuthScreen>('login')
  const [pendingUser, setPendingUser] = useState<AuthUser | null>(null)

  // Login state
  const [loginEmail, setLoginEmail] = useState('')
  const [loginPass, setLoginPass] = useState('')
  const [loginError, setLoginError] = useState('')

  // Register state
  const [regName, setRegName] = useState('')
  const [regEmail, setRegEmail] = useState('')
  const [regPass, setRegPass] = useState('')
  const [regRole, setRegRole] = useState<'teacher' | 'student'>('student')
  const [regDept, setRegDept] = useState(departments[0])
  const [regError, setRegError] = useState('')
  const [regSuccess, setRegSuccess] = useState(false)

  const handleLogin = (e: React.FormEvent) => {
    e.preventDefault()
    setLoginError('')

    // Admin shortcut
    if (loginEmail === DEMO_ADMIN.email || loginEmail === 'admin') {
      onLogin(DEMO_ADMIN)
      return
    }

    const found = registeredUsers.find(u => u.email === loginEmail)
    if (!found) {
      setLoginError('No account found with this email.')
      return
    }
    if (found.status === 'pending') {
      setPendingUser(found)
      setScreen('pending')
      return
    }
    if (found.status === 'rejected') {
      setPendingUser(found)
      setScreen('rejected')
      return
    }
    onLogin(found)
  }

  const handleRegister = (e: React.FormEvent) => {
    e.preventDefault()
    setRegError('')
    if (!regName || !regEmail || !regPass) {
      setRegError('Please fill in all required fields.')
      return
    }
    if (registeredUsers.find(u => u.email === regEmail)) {
      setRegError('An account with this email already exists.')
      return
    }
    const newUser: AuthUser = {
      id: `user-${Date.now()}`,
      name: regName,
      email: regEmail,
      role: regRole,
      status: 'pending',
      department: regDept,
      avatar: regName.split(' ').map(n => n[0]).join('').slice(0, 2).toUpperCase(),
    }
    onRegister(newUser)
    setRegSuccess(true)
    setTimeout(() => {
      setPendingUser(newUser)
      setScreen('pending')
    }, 1500)
  }

  // ── Pending Screen ──────────────────────────────────────────────────────────
  if (screen === 'pending' && pendingUser) {
    return (
      <div className="min-h-screen flex items-center justify-center p-6" style={{ background: 'var(--background)' }}>
        <div className="w-full max-w-md flex flex-col items-center gap-6 text-center">
          <div className="relative">
            <div
              className="w-20 h-20 rounded-2xl flex items-center justify-center text-2xl font-bold"
              style={{ background: 'linear-gradient(135deg, #4c7eff22 0%, #a78bfa22 100%)', border: '1px solid var(--border)', color: 'var(--primary)', fontFamily: 'Lexend' }}
            >
              {pendingUser.avatar}
            </div>
            <div
              className="absolute -bottom-1 -right-1 w-7 h-7 rounded-full flex items-center justify-center text-sm border-2"
              style={{ background: '#fb923c', borderColor: 'var(--background)' }}
            >
              ⏳
            </div>
          </div>

          <div>
            <div className="mono text-xs tracking-widest uppercase mb-2" style={{ color: '#fb923c' }}>
              Awaiting Admin Approval
            </div>
            <h1 className="text-2xl font-semibold" style={{ fontFamily: 'Lexend', color: 'var(--foreground)' }}>
              Application Under Review
            </h1>
            <p className="text-sm mt-2 leading-relaxed" style={{ color: 'var(--muted-foreground)' }}>
              Hi <strong style={{ color: 'var(--foreground)' }}>{pendingUser.name}</strong>, your {pendingUser.role} registration has been submitted.
              An administrator will review and approve your account shortly.
            </p>
          </div>

          <div className="w-full rounded-2xl border p-5 flex flex-col gap-3 text-left" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
            <p className="text-xs font-semibold mono uppercase tracking-widest" style={{ color: 'var(--muted-foreground)' }}>
              Registration Details
            </p>
            {[
              { label: 'Name', value: pendingUser.name },
              { label: 'Email', value: pendingUser.email },
              { label: 'Role', value: pendingUser.role.charAt(0).toUpperCase() + pendingUser.role.slice(1) },
              { label: 'Department', value: pendingUser.department || '—' },
              { label: 'Status', value: 'Pending Review' },
            ].map(item => (
              <div key={item.label} className="flex items-center justify-between text-sm">
                <span style={{ color: 'var(--muted-foreground)' }}>{item.label}</span>
                <span className="font-medium mono text-xs" style={{ color: item.label === 'Status' ? '#fb923c' : 'var(--foreground)' }}>
                  {item.value}
                </span>
              </div>
            ))}
          </div>

          <div className="w-full rounded-2xl border p-4 flex items-start gap-3" style={{ background: '#fb923c11', borderColor: '#fb923c33' }}>
            <span style={{ color: '#fb923c' }}>💡</span>
            <p className="text-xs leading-relaxed" style={{ color: 'var(--muted-foreground)' }}>
              You will be notified by email once your account is approved. This typically takes 1–2 business days.
              The admin can also log in to approve you faster.
            </p>
          </div>

          <button
            onClick={() => { setScreen('login'); setLoginEmail(''); setLoginPass('') }}
            className="text-xs transition-opacity hover:opacity-70"
            style={{ color: 'var(--muted-foreground)' }}
          >
            ← Back to Sign In
          </button>
        </div>
      </div>
    )
  }

  // ── Rejected Screen ─────────────────────────────────────────────────────────
  if (screen === 'rejected') {
    return (
      <div className="min-h-screen flex items-center justify-center p-6" style={{ background: 'var(--background)' }}>
        <div className="w-full max-w-md flex flex-col items-center gap-6 text-center">
          <div className="w-20 h-20 rounded-2xl flex items-center justify-center text-3xl" style={{ background: '#ef444422', border: '1px solid #ef444433' }}>
            ✕
          </div>
          <div>
            <h1 className="text-2xl font-semibold" style={{ fontFamily: 'Lexend', color: '#ef4444' }}>Application Rejected</h1>
            <p className="text-sm mt-2" style={{ color: 'var(--muted-foreground)' }}>
              Your registration request was not approved. Please contact the institution administrator for more information.
            </p>
          </div>
          <button
            onClick={() => setScreen('login')}
            className="px-6 py-2.5 rounded-xl text-sm font-semibold"
            style={{ background: 'var(--primary)', color: '#fff' }}
          >
            Back to Sign In
          </button>
        </div>
      </div>
    )
  }

  // ── Main Auth Screen (Login / Register) ─────────────────────────────────────
  return (
    <div
      className="min-h-screen flex"
      style={{ background: 'var(--background)' }}
    >
      {/* Left decorative panel */}
      <div
        className="hidden lg:flex flex-col justify-between p-10 w-2/5"
        style={{
          background: 'linear-gradient(145deg, #0d1117 0%, #111827 50%, #0d1117 100%)',
          borderRight: '1px solid var(--border)',
        }}
      >
        {/* Logo */}
        <div className="flex items-center gap-3">
          <div
            className="w-10 h-10 rounded-xl flex items-center justify-center font-bold text-lg"
            style={{ background: 'linear-gradient(135deg, #4c7eff 0%, #a78bfa 100%)', color: '#fff', fontFamily: 'Lexend' }}
          >
            L
          </div>
          <div>
            <p className="font-semibold text-sm" style={{ fontFamily: 'Lexend', color: 'var(--foreground)' }}>LearnSpace</p>
            <p className="text-xs mono" style={{ color: 'var(--muted-foreground)' }}>Enterprise LMS v2.4</p>
          </div>
        </div>

        {/* Decorative feature list */}
        <div className="flex flex-col gap-6">
          <h2 className="text-3xl font-semibold leading-snug" style={{ fontFamily: 'Lexend', color: 'var(--foreground)' }}>
            Education,<br />
            <span style={{ background: 'linear-gradient(90deg, #4c7eff, #a78bfa)', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent' }}>
              reimagined.
            </span>
          </h2>
          <div className="flex flex-col gap-4">
            {[
              { icon: '🎓', title: 'Multi-Role Platform', desc: 'Separate portals for admins, teachers, and students.' },
              { icon: '📡', title: 'Live Virtual Classrooms', desc: 'Real-time sessions powered by LiveKit WebRTC.' },
              { icon: '✨', title: 'AI-Powered Tools', desc: 'Quiz generation, lesson summaries, and AI tutoring.' },
              { icon: '🔒', title: 'Secure & Compliant', desc: 'RBAC, audit logs, and enterprise-grade security.' },
            ].map(f => (
              <div key={f.title} className="flex items-start gap-3">
                <div className="w-8 h-8 rounded-lg flex items-center justify-center text-base shrink-0"
                  style={{ background: 'var(--muted)', border: '1px solid var(--border)' }}>
                  {f.icon}
                </div>
                <div>
                  <p className="text-sm font-medium" style={{ fontFamily: 'Lexend', color: 'var(--foreground)' }}>{f.title}</p>
                  <p className="text-xs" style={{ color: 'var(--muted-foreground)' }}>{f.desc}</p>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Stats */}
        <div className="flex gap-6">
          {[
            { value: '18K+', label: 'Students' },
            { value: '420+', label: 'Teachers' },
            { value: '99.9%', label: 'Uptime' },
          ].map(s => (
            <div key={s.label}>
              <p className="text-xl font-semibold" style={{ fontFamily: 'Lexend', color: 'var(--primary)' }}>{s.value}</p>
              <p className="text-xs mono" style={{ color: 'var(--muted-foreground)' }}>{s.label}</p>
            </div>
          ))}
        </div>
      </div>

      {/* Right form panel */}
      <div className="flex-1 flex items-center justify-center p-6">
        <div className="w-full max-w-md">
          {/* Mobile logo */}
          <div className="flex items-center gap-2 mb-8 lg:hidden">
            <div className="w-8 h-8 rounded-lg flex items-center justify-center font-bold"
              style={{ background: 'linear-gradient(135deg, #4c7eff 0%, #a78bfa 100%)', color: '#fff', fontFamily: 'Lexend' }}>
              L
            </div>
            <span className="font-semibold text-sm" style={{ fontFamily: 'Lexend' }}>LearnSpace LMS</span>
          </div>

          {/* Tabs */}
          <div className="flex gap-1 p-1 rounded-xl mb-7" style={{ background: 'var(--muted)' }}>
            {(['login', 'register'] as const).map(s => (
              <button
                key={s}
                onClick={() => { setScreen(s); setRegSuccess(false); setRegError(''); setLoginError('') }}
                className="flex-1 py-2 rounded-lg text-sm font-medium capitalize transition-all"
                style={{
                  background: screen === s ? 'var(--card)' : 'transparent',
                  color: screen === s ? 'var(--foreground)' : 'var(--muted-foreground)',
                  fontFamily: 'Lexend',
                  boxShadow: screen === s ? '0 1px 3px rgba(0,0,0,0.3)' : 'none',
                }}
              >
                {s === 'login' ? 'Sign In' : 'Create Account'}
              </button>
            ))}
          </div>

          {/* ── LOGIN FORM ── */}
          {screen === 'login' && (
            <form onSubmit={handleLogin} className="flex flex-col gap-5">
              <div>
                <h1 className="text-2xl font-semibold" style={{ fontFamily: 'Lexend', color: 'var(--foreground)' }}>
                  Welcome back
                </h1>
                <p className="text-sm mt-1" style={{ color: 'var(--muted-foreground)' }}>
                  Sign in to your LearnSpace account
                </p>
              </div>

              <InputField label="Email address" type="email" value={loginEmail} onChange={setLoginEmail}
                placeholder="you@institution.edu" required />
              <InputField label="Password" type="password" value={loginPass} onChange={setLoginPass}
                placeholder="••••••••" required />

              {loginError && (
                <div className="rounded-xl px-4 py-3 text-xs" style={{ background: '#ef444411', border: '1px solid #ef444433', color: '#ef4444' }}>
                  {loginError}
                </div>
              )}

              <button
                type="submit"
                className="w-full py-3 rounded-xl font-semibold text-sm transition-opacity hover:opacity-90"
                style={{ background: 'linear-gradient(135deg, #4c7eff 0%, #6366f1 100%)', color: '#fff', fontFamily: 'Lexend' }}
              >
                Sign In
              </button>

              {/* Quick demo logins */}
              <div>
                <p className="text-center text-xs mb-3" style={{ color: 'var(--muted-foreground)' }}>
                  — Quick demo access —
                </p>
                <div className="grid grid-cols-3 gap-2">
                  {[
                    { role: 'Admin', email: DEMO_ADMIN.email, icon: '🏛️', color: '#a78bfa' },
                    { role: 'Teacher', email: 'vasquez@learnspace.edu', icon: '📚', color: '#4c7eff' },
                    { role: 'Student', email: 'amara@learnspace.edu', icon: '🎓', color: '#00d9a3' },
                  ].map(d => (
                    <button
                      key={d.role}
                      type="button"
                      onClick={() => {
                        if (d.role === 'Admin') {
                          onLogin(DEMO_ADMIN)
                          return
                        }
                        const found = registeredUsers.find(u => u.email === d.email)
                        if (found && found.status === 'approved') {
                          onLogin(found)
                        }
                      }}
                      className="flex flex-col items-center gap-1 p-3 rounded-xl border text-xs transition-all hover:border-opacity-60"
                      style={{ background: 'var(--card)', borderColor: 'var(--border)', color: 'var(--muted-foreground)' }}
                    >
                      <span className="text-base">{d.icon}</span>
                      <span style={{ color: d.color, fontFamily: 'Lexend', fontWeight: 600 }}>{d.role}</span>
                    </button>
                  ))}
                </div>
              </div>
            </form>
          )}

          {/* ── REGISTER FORM ── */}
          {screen === 'register' && (
            <form onSubmit={handleRegister} className="flex flex-col gap-5">
              <div>
                <h1 className="text-2xl font-semibold" style={{ fontFamily: 'Lexend', color: 'var(--foreground)' }}>
                  Create account
                </h1>
                <p className="text-sm mt-1" style={{ color: 'var(--muted-foreground)' }}>
                  Register to request access to LearnSpace
                </p>
              </div>

              {/* Role selector */}
              <div>
                <p className="text-xs font-medium mb-2" style={{ color: 'var(--foreground)' }}>
                  I am registering as <span style={{ color: 'var(--primary)' }}>*</span>
                </p>
                <div className="flex gap-2">
                  {(['student', 'teacher'] as const).map(r => (
                    <button
                      key={r}
                      type="button"
                      onClick={() => setRegRole(r)}
                      className="flex-1 flex items-center gap-2 px-4 py-3 rounded-xl border text-sm font-medium transition-all"
                      style={{
                        background: regRole === r ? 'var(--primary)11' : 'var(--card)',
                        borderColor: regRole === r ? 'var(--primary)' : 'var(--border)',
                        color: regRole === r ? 'var(--primary)' : 'var(--muted-foreground)',
                        fontFamily: 'Lexend',
                      }}
                    >
                      <span>{r === 'student' ? '🎓' : '📚'}</span>
                      <span className="capitalize">{r}</span>
                    </button>
                  ))}
                </div>
              </div>

              <InputField label="Full Name" value={regName} onChange={setRegName} placeholder="Dr. Jane Smith" required />
              <InputField label="Institutional Email" type="email" value={regEmail} onChange={setRegEmail}
                placeholder="name@institution.edu" required />
              <InputField label="Password" type="password" value={regPass} onChange={setRegPass}
                placeholder="Create a strong password" required />

              {/* Department */}
              <div className="flex flex-col gap-1.5">
                <label className="text-xs font-medium" style={{ color: 'var(--foreground)' }}>Department</label>
                <select
                  value={regDept}
                  onChange={e => setRegDept(e.target.value)}
                  className="px-4 py-2.5 rounded-xl text-sm border outline-none"
                  style={{ background: 'var(--input-bg)', borderColor: 'var(--border)', color: 'var(--foreground)', fontFamily: 'DM Sans' }}
                >
                  {departments.map(d => <option key={d} value={d}>{d}</option>)}
                </select>
              </div>

              {regError && (
                <div className="rounded-xl px-4 py-3 text-xs" style={{ background: '#ef444411', border: '1px solid #ef444433', color: '#ef4444' }}>
                  {regError}
                </div>
              )}

              {regSuccess && (
                <div className="rounded-xl px-4 py-3 text-xs" style={{ background: 'var(--accent)11', border: '1px solid var(--accent)33', color: 'var(--accent)' }}>
                  ✓ Registration submitted! Awaiting admin approval...
                </div>
              )}

              <button
                type="submit"
                disabled={regSuccess}
                className="w-full py-3 rounded-xl font-semibold text-sm transition-opacity hover:opacity-90 disabled:opacity-50"
                style={{ background: 'linear-gradient(135deg, #4c7eff 0%, #6366f1 100%)', color: '#fff', fontFamily: 'Lexend' }}
              >
                Submit Registration
              </button>

              <p className="text-center text-xs" style={{ color: 'var(--muted-foreground)' }}>
                Your request will be reviewed by an administrator before access is granted.
              </p>
            </form>
          )}
        </div>
      </div>
    </div>
  )
}
