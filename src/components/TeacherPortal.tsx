import { useState } from 'react'
import {
  AreaChart, Area, XAxis, YAxis, Tooltip, ResponsiveContainer,
  BarChart, Bar, Cell
} from 'recharts'
import type { AuthUser } from './AuthFlow'

interface TeacherPortalProps {
  onStartLive: () => void
  onLogout: () => void
  currentUser: AuthUser
}

const engagementData = [
  { week: 'W1', students: 142, submissions: 128 },
  { week: 'W2', students: 138, submissions: 135 },
  { week: 'W3', students: 149, submissions: 141 },
  { week: 'W4', students: 144, submissions: 139 },
  { week: 'W5', students: 156, submissions: 152 },
  { week: 'W6', students: 151, submissions: 148 },
  { week: 'W7', students: 160, submissions: 157 },
  { week: 'W8', students: 158, submissions: 154 },
]

const courseCompletion = [
  { name: 'MATH 401', pct: 72, enrolled: 38 },
  { name: 'CS 301', pct: 41, enrolled: 52 },
  { name: 'STAT 210', pct: 85, enrolled: 29 },
]

const enrolledStudents = [
  { id: 1, name: 'Amara Diallo', email: 'a.diallo@uni.edu', grade: 'A−', score: 91, attendance: '97%', status: 'active', course: 'MATH 401' },
  { id: 2, name: 'Luca Ferretti', email: 'l.ferretti@uni.edu', grade: 'B+', score: 87, attendance: '92%', status: 'active', course: 'MATH 401' },
  { id: 3, name: 'Yuna Park', email: 'y.park@uni.edu', grade: 'A', score: 96, attendance: '100%', status: 'active', course: 'CS 301' },
  { id: 4, name: 'Kwame Asante', email: 'k.asante@uni.edu', grade: 'C+', score: 74, attendance: '78%', status: 'at-risk', course: 'MATH 401' },
  { id: 5, name: 'Sofia Reyes', email: 's.reyes@uni.edu', grade: 'B', score: 83, attendance: '88%', status: 'active', course: 'STAT 210' },
  { id: 6, name: 'Tariq Hassan', email: 't.hassan@uni.edu', grade: 'D', score: 62, attendance: '65%', status: 'at-risk', course: 'CS 301' },
  { id: 7, name: 'Mei-Ling Chen', email: 'm.chen@uni.edu', grade: 'A+', score: 99, attendance: '100%', status: 'active', course: 'STAT 210' },
  { id: 8, name: 'Andrei Popescu', email: 'a.popescu@uni.edu', grade: 'B−', score: 80, attendance: '85%', status: 'active', course: 'CS 301' },
]

const pendingEnrollmentRequests = [
  { id: 9, name: 'Kira Nakamura', email: 'k.nakamura@uni.edu', course: 'MATH 401', requestDate: 'Jul 24, 2026' },
  { id: 10, name: 'Omar Al-Rashid', email: 'o.rashid@uni.edu', course: 'CS 301', requestDate: 'Jul 23, 2026' },
  { id: 11, name: 'Elena Brandt', email: 'e.brandt@uni.edu', course: 'STAT 210', requestDate: 'Jul 23, 2026' },
]

const assignments = [
  { title: 'Problem Set 7', course: 'MATH 401', due: 'Jul 24', submitted: 29, total: 38, graded: 12 },
  { title: 'BST Implementation', course: 'CS 301', due: 'Jul 30', submitted: 44, total: 52, graded: 44 },
  { title: 'Probability Proof', course: 'STAT 210', due: 'Jul 28', submitted: 27, total: 29, graded: 27 },
]

const upcomingSessions = [
  { title: 'MATH 401 — Lecture', time: 'Today 2:00 PM', duration: '90 min', enrolled: 38 },
  { title: 'CS 301 — Lab Session', time: 'Thu 3:00 PM', duration: '120 min', enrolled: 52 },
  { title: 'Office Hours', time: 'Fri 11:00 AM', duration: '60 min', enrolled: 0 },
]

const CustomTooltip = ({ active, payload, label }: any) => {
  if (active && payload && payload.length) {
    return (
      <div className="rounded-xl border px-3 py-2 text-xs" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
        <p className="mono mb-1" style={{ color: 'var(--muted-foreground)' }}>{label}</p>
        {payload.map((p: any) => (
          <p key={p.name} style={{ color: p.color }}>{p.name}: <strong>{p.value}</strong></p>
        ))}
      </div>
    )
  }
  return null
}

type Tab = 'overview' | 'students' | 'enrollments' | 'assignments'

export default function TeacherPortal({ onStartLive, onLogout, currentUser }: TeacherPortalProps) {
  const [activeTab, setActiveTab] = useState<Tab>('overview')
  const [search, setSearch] = useState('')
  const [enrollmentRequests, setEnrollmentRequests] = useState(pendingEnrollmentRequests)
  const [students, setStudents] = useState(enrolledStudents)
  const [toast, setToast] = useState<string | null>(null)

  const showToast = (msg: string) => {
    setToast(msg)
    setTimeout(() => setToast(null), 3000)
  }

  const handleAcceptStudent = (req: typeof pendingEnrollmentRequests[0]) => {
    setEnrollmentRequests(prev => prev.filter(r => r.id !== req.id))
    setStudents(prev => [...prev, {
      id: req.id,
      name: req.name,
      email: req.email,
      grade: '—',
      score: 0,
      attendance: '—',
      status: 'active' as const,
      course: req.course,
    }])
    showToast(`✓ Accepted ${req.name} into ${req.course}`)
  }

  const handleDeclineStudent = (req: typeof pendingEnrollmentRequests[0]) => {
    setEnrollmentRequests(prev => prev.filter(r => r.id !== req.id))
    showToast(`Declined ${req.name}'s enrollment request`)
  }

  const filtered = students.filter(s =>
    s.name.toLowerCase().includes(search.toLowerCase()) ||
    s.email.toLowerCase().includes(search.toLowerCase()) ||
    s.course.toLowerCase().includes(search.toLowerCase())
  )

  const tabs: { id: Tab; label: string; icon: string }[] = [
    { id: 'overview', label: 'Overview', icon: '📊' },
    { id: 'students', label: 'My Students', icon: '🎓' },
    { id: 'enrollments', label: `Enrollment Requests${enrollmentRequests.length > 0 ? ` (${enrollmentRequests.length})` : ''}`, icon: '📋' },
    { id: 'assignments', label: 'Assignments', icon: '📝' },
  ]

  return (
    <div className="flex flex-col gap-6 px-8 py-8 max-w-7xl mx-auto w-full relative">
      {/* Toast */}
      {toast && (
        <div
          className="fixed bottom-6 right-6 z-50 px-5 py-3 rounded-2xl shadow-2xl border text-sm font-medium flex items-center gap-2"
          style={{ background: 'var(--card)', borderColor: 'var(--accent)', color: 'var(--accent)' }}
        >
          <span className="w-2 h-2 rounded-full" style={{ background: 'currentColor' }} />
          {toast}
        </div>
      )}

      {/* Header */}
      <div className="flex items-start justify-between">
        <div>
          <p className="mono text-xs tracking-widest uppercase mb-1.5" style={{ color: 'var(--primary)' }}>
            Instructor View — Spring 2026
          </p>
          <h1 className="text-3xl font-semibold tracking-tight" style={{ fontFamily: 'Lexend', color: 'var(--foreground)' }}>
            {currentUser.name}
          </h1>
          <p className="text-sm mt-1" style={{ color: 'var(--muted-foreground)' }}>
            {currentUser.department || 'Department of Mathematics & Computer Science'} · 3 active courses
          </p>
        </div>
        <div className="flex items-center gap-2">
          <button
            onClick={onStartLive}
            className="flex items-center gap-2 px-5 py-2.5 rounded-xl text-sm font-semibold transition-opacity hover:opacity-85"
            style={{ background: 'var(--accent)', color: 'var(--accent-foreground)', fontFamily: 'Lexend' }}
          >
            <span className="w-2 h-2 rounded-full bg-current animate-pulse" />
            Start Live Session
          </button>
          <button
            onClick={onLogout}
            className="flex items-center gap-2 px-4 py-2.5 rounded-xl border text-xs font-medium transition-colors hover:bg-white/[0.04]"
            style={{ borderColor: 'var(--border)', color: 'var(--muted-foreground)' }}
          >
            ← Sign Out
          </button>
        </div>
      </div>

      {/* Tabs */}
      <div className="flex gap-1 p-1 rounded-xl w-fit" style={{ background: 'var(--muted)' }}>
        {tabs.map(tab => (
          <button
            key={tab.id}
            onClick={() => setActiveTab(tab.id)}
            className="flex items-center gap-2 px-4 py-2 rounded-lg text-xs font-medium transition-all"
            style={{
              background: activeTab === tab.id ? 'var(--card)' : 'transparent',
              color: activeTab === tab.id ? 'var(--foreground)' : 'var(--muted-foreground)',
              fontFamily: 'Lexend',
              boxShadow: activeTab === tab.id ? '0 1px 3px rgba(0,0,0,0.3)' : 'none',
            }}
          >
            <span>{tab.icon}</span>
            <span>{tab.label}</span>
            {tab.id === 'enrollments' && enrollmentRequests.length > 0 && (
              <span className="w-1.5 h-1.5 rounded-full" style={{ background: '#fb923c' }} />
            )}
          </button>
        ))}
      </div>

      {/* ── OVERVIEW TAB ── */}
      {activeTab === 'overview' && (
        <>
          <div className="grid grid-cols-4 gap-4">
            {[
              { label: 'Total Students', value: `${students.length}`, sub: 'Across 3 courses', color: '#4c7eff', icon: '🎓' },
              { label: 'Avg. Grade', value: '84.2', sub: 'This semester', color: '#00d9a3', icon: '📈' },
              { label: 'At Risk', value: `${students.filter(s => s.status === 'at-risk').length}`, sub: 'Below 70%', color: '#ef4444', icon: '⚠️' },
              { label: 'Pending Submissions', value: '12', sub: 'Awaiting grading', color: '#fb923c', icon: '📋' },
            ].map(s => (
              <div key={s.label} className="rounded-2xl p-5 border flex flex-col gap-3" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
                <div className="flex items-center justify-between">
                  <p className="text-xs mono uppercase tracking-widest" style={{ color: 'var(--muted-foreground)' }}>{s.label}</p>
                  <span className="w-8 h-8 rounded-xl flex items-center justify-center text-base" style={{ background: s.color + '22' }}>{s.icon}</span>
                </div>
                <p className="text-2xl font-semibold" style={{ fontFamily: 'Lexend', color: s.color }}>{s.value}</p>
                <p className="text-xs" style={{ color: 'var(--muted-foreground)' }}>{s.sub}</p>
              </div>
            ))}
          </div>

          <div className="grid grid-cols-3 gap-5">
            <div className="col-span-2 rounded-2xl border p-6" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
              <div className="flex items-center justify-between mb-5">
                <div>
                  <h3 className="text-sm font-semibold" style={{ fontFamily: 'Lexend' }}>Weekly Engagement</h3>
                  <p className="text-xs mt-0.5" style={{ color: 'var(--muted-foreground)' }}>Active students vs. submissions received</p>
                </div>
                <span className="mono text-xs px-2 py-1 rounded-lg" style={{ background: 'var(--muted)', color: 'var(--muted-foreground)' }}>Last 8 weeks</span>
              </div>
              <ResponsiveContainer width="100%" height={200}>
                <AreaChart data={engagementData} margin={{ top: 0, right: 0, left: -20, bottom: 0 }}>
                  <defs>
                    <linearGradient id="gradStudents" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%" stopColor="#4c7eff" stopOpacity={0.3} />
                      <stop offset="95%" stopColor="#4c7eff" stopOpacity={0} />
                    </linearGradient>
                    <linearGradient id="gradSubs" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%" stopColor="#00d9a3" stopOpacity={0.3} />
                      <stop offset="95%" stopColor="#00d9a3" stopOpacity={0} />
                    </linearGradient>
                  </defs>
                  <XAxis dataKey="week" tick={{ fill: '#64748b', fontSize: 11, fontFamily: 'JetBrains Mono' }} axisLine={false} tickLine={false} />
                  <YAxis tick={{ fill: '#64748b', fontSize: 11, fontFamily: 'JetBrains Mono' }} axisLine={false} tickLine={false} />
                  <Tooltip content={<CustomTooltip />} />
                  <Area type="monotone" dataKey="students" name="Active Students" stroke="#4c7eff" strokeWidth={2} fill="url(#gradStudents)" />
                  <Area type="monotone" dataKey="submissions" name="Submissions" stroke="#00d9a3" strokeWidth={2} fill="url(#gradSubs)" />
                </AreaChart>
              </ResponsiveContainer>
            </div>

            <div className="flex flex-col gap-4">
              <div className="rounded-2xl border p-5" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
                <h3 className="text-sm font-semibold mb-4" style={{ fontFamily: 'Lexend' }}>Course Completion</h3>
                <ResponsiveContainer width="100%" height={100}>
                  <BarChart data={courseCompletion} layout="vertical" margin={{ top: 0, right: 0, left: 0, bottom: 0 }}>
                    <XAxis type="number" hide domain={[0, 100]} />
                    <YAxis dataKey="name" type="category" tick={{ fill: '#64748b', fontSize: 10, fontFamily: 'JetBrains Mono' }} axisLine={false} tickLine={false} width={60} />
                    <Tooltip content={<CustomTooltip />} />
                    <Bar dataKey="pct" name="Completion %" radius={4}>
                      {courseCompletion.map((_, i) => (
                        <Cell key={i} fill={['#4c7eff', '#00d9a3', '#a78bfa'][i]} />
                      ))}
                    </Bar>
                  </BarChart>
                </ResponsiveContainer>
              </div>

              <div className="rounded-2xl border p-5 flex flex-col gap-3" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
                <h3 className="text-sm font-semibold" style={{ fontFamily: 'Lexend' }}>Upcoming Sessions</h3>
                {upcomingSessions.map((s, i) => (
                  <div key={i} className="flex items-start gap-3 py-2 border-t" style={{ borderColor: 'var(--border)' }}>
                    <div className="w-1 h-8 rounded-full shrink-0 mt-0.5" style={{ background: i === 0 ? 'var(--accent)' : 'var(--border)' }} />
                    <div className="flex-1 min-w-0">
                      <p className="text-xs font-medium truncate">{s.title}</p>
                      <p className="text-xs mono mt-0.5" style={{ color: 'var(--muted-foreground)' }}>{s.time} · {s.duration}</p>
                    </div>
                    {i === 0 && (
                      <button
                        onClick={onStartLive}
                        className="text-xs px-2.5 py-1 rounded-full shrink-0 font-medium transition-opacity hover:opacity-80"
                        style={{ background: 'var(--accent)22', color: 'var(--accent)', border: '1px solid var(--accent)44' }}
                      >
                        Start
                      </button>
                    )}
                  </div>
                ))}
              </div>
            </div>
          </div>
        </>
      )}

      {/* ── STUDENTS TAB ── */}
      {activeTab === 'students' && (
        <div className="flex flex-col gap-4">
          <div className="flex items-center gap-3">
            <div className="relative flex-1 max-w-xs">
              <span className="absolute left-3 top-1/2 -translate-y-1/2 text-sm" style={{ color: 'var(--muted-foreground)' }}>🔍</span>
              <input
                type="text"
                placeholder="Search students, courses..."
                value={search}
                onChange={e => setSearch(e.target.value)}
                className="w-full pl-9 pr-4 py-2 rounded-xl text-sm border outline-none"
                style={{ background: 'var(--card)', borderColor: 'var(--border)', color: 'var(--foreground)' }}
              />
            </div>
            <span className="mono text-xs" style={{ color: 'var(--muted-foreground)' }}>{filtered.length} students</span>
          </div>

          <div className="rounded-2xl border overflow-hidden" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
            <table className="w-full text-sm">
              <thead>
                <tr style={{ borderBottom: '1px solid var(--border)', background: 'var(--muted)' }}>
                  {['Student', 'Course', 'Grade', 'Attendance', 'Status', 'Action'].map(h => (
                    <th key={h} className="text-left px-5 py-3 text-xs mono uppercase tracking-widest font-medium" style={{ color: 'var(--muted-foreground)' }}>{h}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {filtered.map((s, i) => (
                  <tr
                    key={s.id}
                    className="transition-colors hover:bg-white/[0.02]"
                    style={{ borderTop: i > 0 ? '1px solid var(--border)' : undefined }}
                  >
                    <td className="px-5 py-3">
                      <div className="flex items-center gap-3">
                        <div
                          className="w-8 h-8 rounded-xl flex items-center justify-center text-xs font-semibold shrink-0"
                          style={{ background: 'var(--primary)22', color: 'var(--primary)' }}
                        >
                          {s.name.split(' ').map(n => n[0]).join('')}
                        </div>
                        <div>
                          <p className="font-medium text-xs" style={{ fontFamily: 'Lexend' }}>{s.name}</p>
                          <p className="text-xs mono" style={{ color: 'var(--muted-foreground)' }}>{s.email}</p>
                        </div>
                      </div>
                    </td>
                    <td className="px-5 py-3">
                      <span className="mono text-xs px-2 py-0.5 rounded-full" style={{ background: 'var(--muted)', color: 'var(--foreground)' }}>{s.course}</span>
                    </td>
                    <td className="px-5 py-3">
                      <span className="mono text-xs font-semibold" style={{ color: s.score < 70 ? '#ef4444' : 'var(--primary)' }}>
                        {s.grade} {s.score > 0 ? `(${s.score}%)` : ''}
                      </span>
                    </td>
                    <td className="px-5 py-3 mono text-xs" style={{ color: s.attendance !== '—' && parseInt(s.attendance) < 80 ? '#ef4444' : 'var(--foreground)' }}>
                      {s.attendance}
                    </td>
                    <td className="px-5 py-3">
                      <span className="mono text-xs px-2 py-0.5 rounded-full" style={{
                        background: s.status === 'at-risk' ? '#ef444422' : 'var(--accent)22',
                        color: s.status === 'at-risk' ? '#ef4444' : 'var(--accent)',
                      }}>
                        {s.status}
                      </span>
                    </td>
                    <td className="px-5 py-3">
                      <button
                        onClick={() => showToast(`Viewing ${s.name}'s profile...`)}
                        className="text-xs px-3 py-1 rounded-lg border transition-colors hover:bg-white/[0.04]"
                        style={{ borderColor: 'var(--border)', color: 'var(--muted-foreground)' }}
                      >
                        View
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* ── ENROLLMENT REQUESTS TAB ── */}
      {activeTab === 'enrollments' && (
        <div className="flex flex-col gap-4">
          <div className="flex items-center justify-between">
            <div>
              <h2 className="text-base font-semibold" style={{ fontFamily: 'Lexend', color: 'var(--foreground)' }}>
                Student Enrollment Requests
              </h2>
              <p className="text-xs mt-0.5" style={{ color: 'var(--muted-foreground)' }}>
                Review and accept students who want to join your courses
              </p>
            </div>
            {enrollmentRequests.length > 0 && (
              <span className="mono text-xs px-3 py-1 rounded-full font-medium" style={{ background: '#fb923c22', color: '#fb923c', border: '1px solid #fb923c44' }}>
                {enrollmentRequests.length} pending
              </span>
            )}
          </div>

          {enrollmentRequests.length === 0 ? (
            <div className="rounded-2xl border p-12 flex flex-col items-center gap-3" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
              <div className="text-4xl">✅</div>
              <p className="text-sm font-medium" style={{ fontFamily: 'Lexend' }}>All caught up!</p>
              <p className="text-xs" style={{ color: 'var(--muted-foreground)' }}>
                No pending enrollment requests for your courses.
              </p>
            </div>
          ) : (
            <div className="flex flex-col gap-3">
              {enrollmentRequests.map(req => (
                <div
                  key={req.id}
                  className="rounded-2xl border p-5 flex items-center gap-5"
                  style={{ background: 'var(--card)', borderColor: 'var(--border)' }}
                >
                  <div
                    className="w-12 h-12 rounded-xl flex items-center justify-center text-sm font-bold shrink-0"
                    style={{ background: '#4c7eff22', color: '#4c7eff', fontFamily: 'Lexend' }}
                  >
                    {req.name.split(' ').map(n => n[0]).join('')}
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="font-semibold text-sm" style={{ fontFamily: 'Lexend' }}>{req.name}</p>
                    <p className="text-xs mono mt-0.5" style={{ color: 'var(--muted-foreground)' }}>{req.email}</p>
                    <div className="flex items-center gap-2 mt-1">
                      <span className="text-xs" style={{ color: 'var(--muted-foreground)' }}>Wants to join:</span>
                      <span className="mono text-xs px-2 py-0.5 rounded-full" style={{ background: 'var(--primary)22', color: 'var(--primary)' }}>{req.course}</span>
                    </div>
                  </div>
                  <p className="text-xs mono shrink-0" style={{ color: 'var(--muted-foreground)' }}>{req.requestDate}</p>
                  <div className="flex items-center gap-2 shrink-0">
                    <button
                      onClick={() => handleAcceptStudent(req)}
                      className="flex items-center gap-1.5 px-4 py-2 rounded-xl text-xs font-semibold transition-opacity hover:opacity-80"
                      style={{ background: 'var(--accent)', color: 'var(--accent-foreground)' }}
                    >
                      ✓ Accept
                    </button>
                    <button
                      onClick={() => handleDeclineStudent(req)}
                      className="flex items-center gap-1.5 px-4 py-2 rounded-xl text-xs font-semibold border transition-opacity hover:opacity-80"
                      style={{ borderColor: '#ef444466', color: '#ef4444', background: '#ef444411' }}
                    >
                      ✕ Decline
                    </button>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      )}

      {/* ── ASSIGNMENTS TAB ── */}
      {activeTab === 'assignments' && (
        <div className="flex flex-col gap-4">
          <div className="flex items-center justify-between">
            <div>
              <h2 className="text-base font-semibold" style={{ fontFamily: 'Lexend', color: 'var(--foreground)' }}>
                Assignment Management
              </h2>
              <p className="text-xs mt-0.5" style={{ color: 'var(--muted-foreground)' }}>Track submission progress and grading</p>
            </div>
            <button
              onClick={() => showToast('Opening new assignment creator...')}
              className="flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-semibold"
              style={{ background: 'var(--primary)', color: '#fff' }}
            >
              + New Assignment
            </button>
          </div>

          {assignments.map((a, i) => (
            <div key={i} className="rounded-2xl border p-6" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
              <div className="flex items-start justify-between mb-5">
                <div>
                  <h3 className="font-semibold" style={{ fontFamily: 'Lexend' }}>{a.title}</h3>
                  <p className="text-xs mono mt-0.5" style={{ color: 'var(--muted-foreground)' }}>{a.course} · Due {a.due}</p>
                </div>
                <button
                  onClick={() => showToast(`Opening grading interface for ${a.title}...`)}
                  className="text-xs px-3 py-1.5 rounded-xl font-semibold transition-opacity hover:opacity-80"
                  style={{ background: 'var(--primary)', color: '#fff' }}
                >
                  Grade All
                </button>
              </div>
              <div className="grid grid-cols-3 gap-4">
                {[
                  { label: 'Submitted', value: a.submitted, total: a.total, color: 'var(--primary)' },
                  { label: 'Graded', value: a.graded, total: a.submitted, color: 'var(--accent)' },
                  { label: 'Pending', value: a.submitted - a.graded, total: a.submitted, color: '#fb923c' },
                ].map(stat => (
                  <div key={stat.label}>
                    <div className="flex justify-between text-xs mono mb-1.5" style={{ color: 'var(--muted-foreground)' }}>
                      <span>{stat.label}</span>
                      <span style={{ color: stat.color }}>{stat.value}/{stat.total}</span>
                    </div>
                    <div className="h-1.5 rounded-full" style={{ background: 'var(--muted)' }}>
                      <div className="h-full rounded-full transition-all"
                        style={{ width: `${Math.round((stat.value / stat.total) * 100)}%`, background: stat.color }} />
                    </div>
                  </div>
                ))}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
