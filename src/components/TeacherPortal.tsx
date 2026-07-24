import { useState } from 'react'
import {
  AreaChart, Area, XAxis, YAxis, Tooltip, ResponsiveContainer,
  BarChart, Bar, Cell
} from 'recharts'

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

const students = [
  { id: 1, name: 'Amara Diallo', email: 'a.diallo@uni.edu', grade: 'A−', score: 91, attendance: '97%', status: 'active' },
  { id: 2, name: 'Luca Ferretti', email: 'l.ferretti@uni.edu', grade: 'B+', score: 87, attendance: '92%', status: 'active' },
  { id: 3, name: 'Yuna Park', email: 'y.park@uni.edu', grade: 'A', score: 96, attendance: '100%', status: 'active' },
  { id: 4, name: 'Kwame Asante', email: 'k.asante@uni.edu', grade: 'C+', score: 74, attendance: '78%', status: 'at-risk' },
  { id: 5, name: 'Sofia Reyes', email: 's.reyes@uni.edu', grade: 'B', score: 83, attendance: '88%', status: 'active' },
  { id: 6, name: 'Tariq Hassan', email: 't.hassan@uni.edu', grade: 'D', score: 62, attendance: '65%', status: 'at-risk' },
  { id: 7, name: 'Mei-Ling Chen', email: 'm.chen@uni.edu', grade: 'A+', score: 99, attendance: '100%', status: 'active' },
  { id: 8, name: 'Andrei Popescu', email: 'a.popescu@uni.edu', grade: 'B−', score: 80, attendance: '85%', status: 'active' },
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
      <div className="rounded-lg border px-3 py-2 text-xs" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
        <p className="mono mb-1" style={{ color: 'var(--muted-foreground)' }}>{label}</p>
        {payload.map((p: any) => (
          <p key={p.name} style={{ color: p.color }}>{p.name}: <strong>{p.value}</strong></p>
        ))}
      </div>
    )
  }
  return null
}

export default function TeacherPortal({ onStartLive }: { onStartLive: () => void }) {
  const [activeTab, setActiveTab] = useState<'overview' | 'students' | 'assignments'>('overview')
  const [search, setSearch] = useState('')

  const filtered = students.filter(s =>
    s.name.toLowerCase().includes(search.toLowerCase()) ||
    s.email.toLowerCase().includes(search.toLowerCase())
  )

  return (
    <div className="flex flex-col gap-8 px-8 py-8 max-w-7xl mx-auto w-full">
      {/* Header */}
      <div className="flex items-start justify-between">
        <div>
          <p className="mono text-xs tracking-widest uppercase mb-1" style={{ color: 'var(--accent)' }}>
            Instructor View — Spring 2026
          </p>
          <h1 className="text-3xl font-semibold tracking-tight" style={{ fontFamily: 'Lexend', color: 'var(--foreground)' }}>
            Dr. Elena Vasquez
          </h1>
          <p className="text-sm mt-1" style={{ color: 'var(--muted-foreground)' }}>
            Department of Mathematics & Computer Science
          </p>
        </div>
        <div className="flex gap-2 mt-1">
          <button
            onClick={onStartLive}
            className="flex items-center gap-2 px-4 py-2 rounded-full text-sm font-medium transition-opacity hover:opacity-85"
            style={{ background: 'var(--accent)', color: 'var(--accent-foreground)' }}
          >
            <span className="w-2 h-2 rounded-full bg-current animate-pulse" />
            Start Live Session
          </button>
          {(['overview', 'students', 'assignments'] as const).map(tab => (
            <button
              key={tab}
              onClick={() => setActiveTab(tab)}
              className="px-4 py-2 rounded-full text-sm font-medium capitalize transition-all"
              style={{
                background: activeTab === tab ? 'var(--primary)' : 'var(--secondary)',
                color: activeTab === tab ? '#fff' : 'var(--muted-foreground)',
              }}
            >
              {tab}
            </button>
          ))}
        </div>
      </div>

      {activeTab === 'overview' && (
        <>
          {/* Stats */}
          <div className="grid grid-cols-4 gap-4">
            {[
              { label: 'Total Students', value: '119', sub: 'Across 3 courses' },
              { label: 'Avg. Grade', value: '84.2', sub: 'This semester' },
              { label: 'At Risk', value: '7', sub: 'Below 70%' },
              { label: 'Pending Reviews', value: '12', sub: 'Submissions' },
            ].map(s => (
              <div key={s.label} className="rounded-xl p-5 border" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
                <p className="text-xs mono uppercase tracking-widest mb-2" style={{ color: 'var(--muted-foreground)' }}>{s.label}</p>
                <p className="text-2xl font-semibold" style={{ fontFamily: 'Lexend', color: 'var(--foreground)' }}>{s.value}</p>
                <p className="text-xs mt-1" style={{ color: 'var(--muted-foreground)' }}>{s.sub}</p>
              </div>
            ))}
          </div>

          <div className="grid grid-cols-3 gap-6">
            {/* Engagement chart */}
            <div className="col-span-2 rounded-xl border p-6" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
              <div className="flex items-center justify-between mb-5">
                <div>
                  <h3 className="text-sm font-semibold" style={{ fontFamily: 'Lexend' }}>Weekly Engagement</h3>
                  <p className="text-xs mt-0.5" style={{ color: 'var(--muted-foreground)' }}>Students active vs. submissions received</p>
                </div>
                <span className="mono text-xs px-2 py-1 rounded" style={{ background: 'var(--muted)', color: 'var(--muted-foreground)' }}>Last 8 weeks</span>
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

            {/* Right column */}
            <div className="flex flex-col gap-4">
              {/* Course completion */}
              <div className="rounded-xl border p-5" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
                <h3 className="text-sm font-semibold mb-4" style={{ fontFamily: 'Lexend' }}>Course Completion</h3>
                <ResponsiveContainer width="100%" height={100}>
                  <BarChart data={courseCompletion} layout="vertical" margin={{ top: 0, right: 0, left: 0, bottom: 0 }}>
                    <XAxis type="number" hide domain={[0, 100]} />
                    <YAxis dataKey="name" type="category" tick={{ fill: '#64748b', fontSize: 10, fontFamily: 'JetBrains Mono' }} axisLine={false} tickLine={false} width={60} />
                    <Tooltip content={<CustomTooltip />} />
                    <Bar dataKey="pct" name="Completion %" radius={4}>
                      {courseCompletion.map((entry, i) => (
                        <Cell key={i} fill={['#4c7eff', '#00d9a3', '#a78bfa'][i]} />
                      ))}
                    </Bar>
                  </BarChart>
                </ResponsiveContainer>
              </div>

              {/* Upcoming sessions */}
              <div className="rounded-xl border p-5 flex flex-col gap-3" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
                <h3 className="text-sm font-semibold" style={{ fontFamily: 'Lexend' }}>Upcoming Sessions</h3>
                {upcomingSessions.map((s, i) => (
                  <div key={i} className="flex items-start gap-3 py-2 border-t" style={{ borderColor: 'var(--border)' }}>
                    <div
                      className="w-1 h-8 rounded-full shrink-0 mt-0.5"
                      style={{ background: i === 0 ? 'var(--accent)' : 'var(--border)' }}
                    />
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

      {activeTab === 'students' && (
        <div className="flex flex-col gap-4">
          <div className="flex items-center gap-3">
            <input
              type="text"
              placeholder="Search students..."
              value={search}
              onChange={e => setSearch(e.target.value)}
              className="flex-1 max-w-xs px-4 py-2 rounded-lg text-sm border outline-none"
              style={{
                background: 'var(--card)',
                borderColor: 'var(--border)',
                color: 'var(--foreground)',
              }}
            />
            <span className="mono text-xs" style={{ color: 'var(--muted-foreground)' }}>{filtered.length} students</span>
          </div>
          <div className="rounded-xl border overflow-hidden" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
            <table className="w-full text-sm">
              <thead>
                <tr style={{ borderBottom: '1px solid var(--border)' }}>
                  {['Student', 'Email', 'Grade', 'Attendance', 'Status'].map(h => (
                    <th key={h} className="text-left px-5 py-3 text-xs mono uppercase tracking-widest font-medium"
                      style={{ color: 'var(--muted-foreground)' }}>{h}</th>
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
                          className="w-7 h-7 rounded-full flex items-center justify-center text-xs font-semibold shrink-0"
                          style={{ background: 'var(--primary)22', color: 'var(--primary)' }}
                        >
                          {s.name.split(' ').map(n => n[0]).join('')}
                        </div>
                        <span className="font-medium" style={{ fontFamily: 'Lexend', fontSize: 13 }}>{s.name}</span>
                      </div>
                    </td>
                    <td className="px-5 py-3 mono text-xs" style={{ color: 'var(--muted-foreground)' }}>{s.email}</td>
                    <td className="px-5 py-3">
                      <div className="flex items-center gap-2">
                        <span className="mono text-xs font-semibold" style={{ color: 'var(--primary)' }}>{s.grade}</span>
                        <span className="mono text-xs" style={{ color: 'var(--muted-foreground)' }}>{s.score}%</span>
                      </div>
                    </td>
                    <td className="px-5 py-3 mono text-xs"
                      style={{ color: parseInt(s.attendance) < 80 ? '#ef4444' : 'var(--foreground)' }}>
                      {s.attendance}
                    </td>
                    <td className="px-5 py-3">
                      <span
                        className="mono text-xs px-2 py-0.5 rounded-full"
                        style={{
                          background: s.status === 'at-risk' ? '#ef444422' : 'var(--accent)22',
                          color: s.status === 'at-risk' ? '#ef4444' : 'var(--accent)',
                        }}
                      >
                        {s.status}
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {activeTab === 'assignments' && (
        <div className="flex flex-col gap-4">
          {assignments.map((a, i) => (
            <div key={i} className="rounded-xl border p-6" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
              <div className="flex items-start justify-between mb-4">
                <div>
                  <h3 className="font-semibold" style={{ fontFamily: 'Lexend' }}>{a.title}</h3>
                  <p className="text-xs mono mt-0.5" style={{ color: 'var(--muted-foreground)' }}>{a.course} · Due {a.due}</p>
                </div>
                <button className="text-xs px-3 py-1.5 rounded-lg font-medium transition-opacity hover:opacity-80"
                  style={{ background: 'var(--primary)', color: '#fff' }}>
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
                    <div className="flex justify-between text-xs mono mb-1" style={{ color: 'var(--muted-foreground)' }}>
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
