import { useState } from 'react'
import type { AuthUser } from './AuthFlow'

interface StudentDashboardProps {
  onJoinLive: () => void
  onLogout: () => void
  currentUser: AuthUser
}

const courses = [
  { id: 1, title: 'Advanced Mathematics', instructor: 'Dr. Elena Vasquez', progress: 72, nextLesson: 'Differential Equations — Part 3', nextDate: 'Today, 2:00 PM', color: '#4c7eff', tag: 'MATH 401', status: 'enrolled' },
  { id: 2, title: 'Molecular Biology', instructor: 'Prof. James Okonkwo', progress: 55, nextLesson: 'CRISPR Gene Editing Techniques', nextDate: 'Tomorrow, 10:00 AM', color: '#00d9a3', tag: 'BIO 310', status: 'enrolled' },
  { id: 3, title: 'Contemporary Literature', instructor: 'Dr. Sarah Kimani', progress: 88, nextLesson: 'Post-Colonial Narratives', nextDate: 'Wed, 9:00 AM', color: '#a78bfa', tag: 'LIT 220', status: 'enrolled' },
  { id: 4, title: 'Data Structures & Algorithms', instructor: 'Dr. Min-Jun Lee', progress: 41, nextLesson: 'Graph Traversal Algorithms', nextDate: 'Thu, 3:00 PM', color: '#fb923c', tag: 'CS 301', status: 'enrolled' },
]

const availableCourses = [
  { id: 5, title: 'Organic Chemistry', instructor: 'Prof. Aisha Mensah', tag: 'CHEM 201', color: '#f472b6', seats: '8 seats left' },
  { id: 6, title: 'International Law', instructor: 'Dr. Marco Ricci', tag: 'LAW 301', color: '#34d399', seats: '22 seats left' },
  { id: 7, title: 'Quantum Physics', instructor: 'Prof. Chen Wei', tag: 'PHYS 410', color: '#60a5fa', seats: '5 seats left' },
]

const assignments = [
  { id: 1, title: 'Problem Set 7 — Integration', course: 'MATH 401', due: 'Tonight 11:59 PM', urgent: true, type: 'Assignment', status: 'pending' },
  { id: 2, title: 'Lab Report: DNA Extraction', course: 'BIO 310', due: 'Jul 26', urgent: false, type: 'Lab Report', status: 'pending' },
  { id: 3, title: 'Essay: Things Fall Apart Analysis', course: 'LIT 220', due: 'Jul 28', urgent: false, type: 'Essay', status: 'submitted' },
  { id: 4, title: 'BST Implementation', course: 'CS 301', due: 'Jul 30', urgent: false, type: 'Project', status: 'pending' },
]

const grades = [
  { course: 'MATH 401', grade: 'A−', score: 91, change: '+3', color: '#4c7eff' },
  { course: 'BIO 310', grade: 'B+', score: 87, change: '+1', color: '#00d9a3' },
  { course: 'LIT 220', grade: 'A', score: 95, change: '0', color: '#a78bfa' },
  { course: 'CS 301', grade: 'B', score: 83, change: '-2', color: '#fb923c' },
]

const schedule = [
  { time: '09:00', title: 'Contemporary Literature', room: 'Hall B-204', type: 'lecture', color: '#a78bfa' },
  { time: '11:00', title: 'Office Hours — Dr. Vasquez', room: 'Math Dept. 3F', type: 'office', color: '#64748b' },
  { time: '14:00', title: 'Advanced Mathematics', room: 'Live Session', type: 'live', color: '#4c7eff' },
  { time: '16:00', title: 'Study Group — BIO 310', room: 'Library Room 5', type: 'study', color: '#00d9a3' },
]

const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
const today = new Date()

type Tab = 'overview' | 'courses' | 'assignments' | 'grades'

export default function StudentDashboard({ onJoinLive, onLogout, currentUser }: StudentDashboardProps) {
  const [activeTab, setActiveTab] = useState<Tab>('overview')
  const [enrollRequested, setEnrollRequested] = useState<number[]>([])
  const [toast, setToast] = useState<string | null>(null)

  const showToast = (msg: string) => {
    setToast(msg)
    setTimeout(() => setToast(null), 3000)
  }

  const handleEnrollRequest = (courseId: number, title: string) => {
    setEnrollRequested(prev => [...prev, courseId])
    showToast(`Enrollment request sent for "${title}" — awaiting teacher approval.`)
  }

  const tabs: { id: Tab; label: string; icon: string }[] = [
    { id: 'overview', label: 'Overview', icon: '🏠' },
    { id: 'courses', label: 'My Courses', icon: '📚' },
    { id: 'assignments', label: 'Assignments', icon: '📝' },
    { id: 'grades', label: 'Grades', icon: '📊' },
  ]

  const urgentCount = assignments.filter(a => a.urgent && a.status === 'pending').length

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
          <p className="mono text-xs tracking-widest uppercase mb-1.5" style={{ color: 'var(--accent)' }}>
            {today.toLocaleDateString('en-US', { weekday: 'long', month: 'long', day: 'numeric' })}
          </p>
          <h1 className="text-3xl font-semibold tracking-tight" style={{ fontFamily: 'Lexend', color: 'var(--foreground)' }}>
            Good {today.getHours() < 12 ? 'morning' : today.getHours() < 17 ? 'afternoon' : 'evening'},{' '}
            {currentUser.name.split(' ')[0]}
          </h1>
          <p className="text-sm mt-1" style={{ color: 'var(--muted-foreground)' }}>
            {urgentCount > 0
              ? `You have ${urgentCount} urgent assignment${urgentCount > 1 ? 's' : ''} due today.`
              : "You're all caught up! Great work."}
          </p>
        </div>
        <div className="flex items-center gap-2">
          <button
            onClick={() => showToast('Browsing available courses...')}
            className="flex items-center gap-2 px-5 py-2.5 rounded-xl text-sm font-semibold transition-opacity hover:opacity-85"
            style={{ background: 'var(--primary)', color: '#fff', fontFamily: 'Lexend' }}
          >
            + Enroll in Course
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
          </button>
        ))}
      </div>

      {/* ── OVERVIEW TAB ── */}
      {activeTab === 'overview' && (
        <>
          <div className="grid grid-cols-4 gap-4">
            {[
              { label: 'GPA', value: '3.72', sub: 'Current semester', color: '#4c7eff', icon: '🎓' },
              { label: 'Courses', value: '4', sub: 'Enrolled', color: '#00d9a3', icon: '📚' },
              { label: 'Assignments Due', value: `${assignments.filter(a => a.status === 'pending').length}`, sub: 'This week', color: '#fb923c', icon: '📝' },
              { label: 'Attendance', value: '96%', sub: 'All courses', color: '#a78bfa', icon: '✅' },
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
            {/* Courses grid */}
            <div className="col-span-2 flex flex-col gap-4">
              <h2 className="text-xs font-semibold mono uppercase tracking-widest" style={{ color: 'var(--muted-foreground)' }}>
                My Courses
              </h2>
              <div className="grid grid-cols-2 gap-4">
                {courses.map(c => (
                  <div
                    key={c.id}
                    className="rounded-2xl overflow-hidden border flex flex-col cursor-pointer group transition-all hover:-translate-y-0.5 hover:shadow-lg"
                    style={{ background: 'var(--card)', borderColor: 'var(--border)' }}
                  >
                    {/* Course color header */}
                    <div className="h-2 w-full" style={{ background: `linear-gradient(90deg, ${c.color}, ${c.color}88)` }} />
                    <div className="p-4 flex flex-col gap-2 flex-1">
                      <div className="flex items-center justify-between">
                        <span className="mono text-xs px-2 py-0.5 rounded-full font-medium"
                          style={{ background: c.color + '22', color: c.color, border: `1px solid ${c.color}44` }}>
                          {c.tag}
                        </span>
                        {c.nextDate.includes('Today') && (
                          <span className="flex items-center gap-1 text-xs px-2 py-0.5 rounded-full font-medium"
                            style={{ background: 'var(--accent)22', color: 'var(--accent)' }}>
                            <span className="w-1.5 h-1.5 rounded-full bg-current animate-pulse" />
                            Live Soon
                          </span>
                        )}
                      </div>
                      <h3 className="text-sm font-semibold leading-tight" style={{ fontFamily: 'Lexend' }}>{c.title}</h3>
                      <p className="text-xs" style={{ color: 'var(--muted-foreground)' }}>{c.instructor}</p>
                      <div className="mt-auto pt-2">
                        <div className="flex justify-between text-xs mb-1.5" style={{ color: 'var(--muted-foreground)' }}>
                          <span>Progress</span>
                          <span className="mono">{c.progress}%</span>
                        </div>
                        <div className="h-1.5 rounded-full" style={{ background: 'var(--muted)' }}>
                          <div className="h-full rounded-full transition-all" style={{ width: `${c.progress}%`, background: c.color }} />
                        </div>
                        <p className="text-xs mt-2" style={{ color: 'var(--muted-foreground)' }}>
                          Next: <span style={{ color: 'var(--foreground)' }}>{c.nextLesson}</span>
                        </p>
                        <p className="text-xs mono mt-0.5" style={{ color: c.color }}>{c.nextDate}</p>
                        {c.nextDate.includes('Today') && (
                          <button
                            onClick={onJoinLive}
                            className="mt-3 w-full text-xs py-1.5 rounded-xl font-medium transition-opacity hover:opacity-80"
                            style={{ background: 'var(--accent)', color: 'var(--accent-foreground)' }}
                          >
                            Join Live Session
                          </button>
                        )}
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Right column */}
            <div className="flex flex-col gap-4">
              {/* Today's schedule */}
              <h2 className="text-xs font-semibold mono uppercase tracking-widest" style={{ color: 'var(--muted-foreground)' }}>
                Today's Schedule
              </h2>
              <div className="rounded-2xl border p-4 flex flex-col gap-3" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
                {schedule.map(s => (
                  <div key={s.time} className="flex gap-3 items-start">
                    <span className="mono text-xs pt-0.5 w-10 shrink-0" style={{ color: 'var(--muted-foreground)' }}>{s.time}</span>
                    <div className="w-0.5 self-stretch rounded-full shrink-0" style={{ background: s.color }} />
                    <div className="flex-1 min-w-0">
                      <p className="text-xs font-medium leading-tight truncate">{s.title}</p>
                      <p className="text-xs mt-0.5" style={{ color: 'var(--muted-foreground)' }}>{s.room}</p>
                      {s.type === 'live' && (
                        <button
                          onClick={onJoinLive}
                          className="mt-1.5 text-xs px-3 py-1 rounded-full font-medium transition-opacity hover:opacity-80"
                          style={{ background: 'var(--accent)', color: 'var(--accent-foreground)' }}
                        >
                          Join Live
                        </button>
                      )}
                    </div>
                  </div>
                ))}
              </div>

              {/* Due soon */}
              <h2 className="text-xs font-semibold mono uppercase tracking-widest" style={{ color: 'var(--muted-foreground)' }}>
                Due Soon
              </h2>
              <div className="rounded-2xl border flex flex-col" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
                {assignments.slice(0, 3).map((a, i) => (
                  <div key={a.id} className="p-3 flex items-start gap-3" style={{ borderTop: i > 0 ? '1px solid var(--border)' : undefined }}>
                    <div className="w-1 self-stretch rounded-full shrink-0 mt-1"
                      style={{ background: a.urgent ? '#ef4444' : 'var(--border)' }} />
                    <div className="flex-1 min-w-0">
                      <p className="text-xs font-medium leading-snug">{a.title}</p>
                      <p className="text-xs mono mt-0.5" style={{ color: a.urgent ? '#ef4444' : 'var(--muted-foreground)' }}>{a.due}</p>
                    </div>
                    <span className="text-xs mono shrink-0" style={{ color: 'var(--muted-foreground)' }}>{a.course}</span>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </>
      )}

      {/* ── COURSES TAB ── */}
      {activeTab === 'courses' && (
        <div className="flex flex-col gap-6">
          <div>
            <h2 className="text-xs font-semibold mono uppercase tracking-widest mb-4" style={{ color: 'var(--muted-foreground)' }}>
              Enrolled Courses
            </h2>
            <div className="grid grid-cols-2 gap-4">
              {courses.map(c => (
                <div key={c.id} className="rounded-2xl border p-5 flex flex-col gap-3" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
                  <div className="flex items-start justify-between">
                    <div>
                      <span className="mono text-xs px-2 py-0.5 rounded-full" style={{ background: c.color + '22', color: c.color }}>{c.tag}</span>
                      <h3 className="text-sm font-semibold mt-2" style={{ fontFamily: 'Lexend' }}>{c.title}</h3>
                      <p className="text-xs mt-0.5" style={{ color: 'var(--muted-foreground)' }}>{c.instructor}</p>
                    </div>
                    <span className="mono text-xs px-2 py-0.5 rounded-full" style={{ background: 'var(--accent)22', color: 'var(--accent)' }}>Enrolled</span>
                  </div>
                  <div>
                    <div className="flex justify-between text-xs mono mb-1" style={{ color: 'var(--muted-foreground)' }}>
                      <span>Progress</span><span>{c.progress}%</span>
                    </div>
                    <div className="h-2 rounded-full" style={{ background: 'var(--muted)' }}>
                      <div className="h-full rounded-full" style={{ width: `${c.progress}%`, background: c.color }} />
                    </div>
                  </div>
                  <p className="text-xs" style={{ color: 'var(--muted-foreground)' }}>
                    Next: <span style={{ color: 'var(--foreground)' }}>{c.nextLesson}</span>
                  </p>
                </div>
              ))}
            </div>
          </div>

          {/* Available courses */}
          <div>
            <h2 className="text-xs font-semibold mono uppercase tracking-widest mb-4" style={{ color: 'var(--muted-foreground)' }}>
              Available Courses — Request Enrollment
            </h2>
            <div className="grid grid-cols-3 gap-4">
              {availableCourses.map(c => (
                <div key={c.id} className="rounded-2xl border p-5 flex flex-col gap-3" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
                  <span className="mono text-xs px-2 py-0.5 rounded-full w-fit" style={{ background: c.color + '22', color: c.color }}>{c.tag}</span>
                  <h3 className="text-sm font-semibold" style={{ fontFamily: 'Lexend' }}>{c.title}</h3>
                  <p className="text-xs" style={{ color: 'var(--muted-foreground)' }}>{c.instructor}</p>
                  <p className="text-xs mono" style={{ color: 'var(--accent)' }}>{c.seats}</p>
                  <button
                    disabled={enrollRequested.includes(c.id)}
                    onClick={() => handleEnrollRequest(c.id, c.title)}
                    className="py-2 rounded-xl text-xs font-semibold transition-all"
                    style={{
                      background: enrollRequested.includes(c.id) ? 'var(--muted)' : 'var(--primary)',
                      color: enrollRequested.includes(c.id) ? 'var(--muted-foreground)' : '#fff',
                    }}
                  >
                    {enrollRequested.includes(c.id) ? '⏳ Request Sent' : 'Request Enrollment'}
                  </button>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* ── ASSIGNMENTS TAB ── */}
      {activeTab === 'assignments' && (
        <div className="flex flex-col gap-3">
          {assignments.map(a => (
            <div
              key={a.id}
              className="rounded-2xl border p-5 flex items-center gap-5"
              style={{ background: 'var(--card)', borderColor: a.urgent && a.status === 'pending' ? '#ef444433' : 'var(--border)' }}
            >
              <div className="w-10 h-10 rounded-xl flex items-center justify-center text-lg shrink-0" style={{ background: 'var(--muted)' }}>
                {a.type === 'Assignment' ? '📝' : a.type === 'Lab Report' ? '🔬' : a.type === 'Essay' ? '📄' : '💻'}
              </div>
              <div className="flex-1">
                <p className="font-medium text-sm" style={{ fontFamily: 'Lexend' }}>{a.title}</p>
                <p className="text-xs mono mt-0.5" style={{ color: 'var(--muted-foreground)' }}>{a.course} · {a.type}</p>
              </div>
              <div className="text-right shrink-0">
                <p className="text-xs mono font-medium" style={{ color: a.urgent && a.status === 'pending' ? '#ef4444' : 'var(--muted-foreground)' }}>{a.due}</p>
                {a.urgent && a.status === 'pending' && <p className="text-xs font-medium" style={{ color: '#ef4444' }}>Urgent!</p>}
              </div>
              {a.status === 'submitted' ? (
                <span className="mono text-xs px-3 py-1 rounded-full shrink-0" style={{ background: 'var(--accent)22', color: 'var(--accent)' }}>
                  ✓ Submitted
                </span>
              ) : (
                <button
                  onClick={() => showToast(`Opening submission for "${a.title}"...`)}
                  className="px-4 py-2 rounded-xl text-xs font-semibold shrink-0 transition-opacity hover:opacity-80"
                  style={{ background: 'var(--primary)', color: '#fff' }}
                >
                  Submit
                </button>
              )}
            </div>
          ))}
        </div>
      )}

      {/* ── GRADES TAB ── */}
      {activeTab === 'grades' && (
        <div className="flex flex-col gap-4">
          <div className="rounded-2xl border p-5 flex items-center gap-6" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
            <div className="text-center">
              <p className="text-xs mono uppercase tracking-widest mb-1" style={{ color: 'var(--muted-foreground)' }}>Cumulative GPA</p>
              <p className="text-5xl font-semibold" style={{ fontFamily: 'Lexend', color: 'var(--primary)' }}>3.72</p>
              <p className="text-xs mt-1" style={{ color: 'var(--accent)' }}>+0.04 this semester</p>
            </div>
            <div className="w-px self-stretch" style={{ background: 'var(--border)' }} />
            <div className="flex-1 grid grid-cols-2 gap-3">
              {[
                { label: 'Highest Grade', value: 'A (LIT 220)', color: '#a78bfa' },
                { label: 'At Risk', value: 'None 🎉', color: 'var(--accent)' },
                { label: 'Semester Credits', value: '16 / 18', color: 'var(--primary)' },
                { label: 'Rank', value: 'Top 15%', color: '#fb923c' },
              ].map(s => (
                <div key={s.label} className="rounded-xl p-3" style={{ background: 'var(--muted)' }}>
                  <p className="text-xs mono" style={{ color: 'var(--muted-foreground)' }}>{s.label}</p>
                  <p className="text-sm font-semibold mt-1" style={{ fontFamily: 'Lexend', color: s.color }}>{s.value}</p>
                </div>
              ))}
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4">
            {grades.map(g => (
              <div key={g.course} className="rounded-2xl border p-6 flex items-center gap-5" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
                <div
                  className="w-16 h-16 rounded-2xl flex items-center justify-center text-2xl font-semibold shrink-0"
                  style={{ background: g.color + '22', color: g.color, fontFamily: 'Lexend' }}
                >
                  {g.grade}
                </div>
                <div className="flex-1">
                  <p className="text-xs mono uppercase tracking-widest mb-1" style={{ color: 'var(--muted-foreground)' }}>{g.course}</p>
                  <div className="h-2 rounded-full mb-1.5" style={{ background: 'var(--muted)' }}>
                    <div className="h-full rounded-full" style={{ width: `${g.score}%`, background: g.color }} />
                  </div>
                  <div className="flex justify-between text-xs mono" style={{ color: 'var(--muted-foreground)' }}>
                    <span>{g.score}/100</span>
                    <span style={{
                      color: g.change.startsWith('+') ? 'var(--accent)' : g.change === '0' ? 'var(--muted-foreground)' : '#ef4444'
                    }}>
                      {g.change !== '0' ? g.change + ' pts' : 'No change'}
                    </span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  )
}
