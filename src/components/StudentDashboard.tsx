import { useState } from 'react'

const courses = [
  {
    id: 1,
    title: 'Advanced Mathematics',
    instructor: 'Dr. Elena Vasquez',
    progress: 72,
    nextLesson: 'Differential Equations — Part 3',
    nextDate: 'Today, 2:00 PM',
    color: '#4c7eff',
    tag: 'MATH 401',
    img: 'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=400&h=200&fit=crop&auto=format',
  },
  {
    id: 2,
    title: 'Molecular Biology',
    instructor: 'Prof. James Okonkwo',
    progress: 55,
    nextLesson: 'CRISPR Gene Editing Techniques',
    nextDate: 'Tomorrow, 10:00 AM',
    color: '#00d9a3',
    tag: 'BIO 310',
    img: 'https://images.unsplash.com/photo-1628595351029-c2bf17511435?w=400&h=200&fit=crop&auto=format',
  },
  {
    id: 3,
    title: 'Contemporary Literature',
    instructor: 'Dr. Sarah Kimani',
    progress: 88,
    nextLesson: 'Post-Colonial Narratives',
    nextDate: 'Wed, 9:00 AM',
    color: '#a78bfa',
    tag: 'LIT 220',
    img: 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=200&fit=crop&auto=format',
  },
  {
    id: 4,
    title: 'Data Structures & Algorithms',
    instructor: 'Dr. Min-Jun Lee',
    progress: 41,
    nextLesson: 'Graph Traversal Algorithms',
    nextDate: 'Thu, 3:00 PM',
    color: '#fb923c',
    tag: 'CS 301',
    img: 'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?w=400&h=200&fit=crop&auto=format',
  },
]

const assignments = [
  { id: 1, title: 'Problem Set 7 — Integration', course: 'MATH 401', due: 'Tonight 11:59 PM', urgent: true, type: 'Assignment' },
  { id: 2, title: 'Lab Report: DNA Extraction', course: 'BIO 310', due: 'Jul 26', urgent: false, type: 'Lab Report' },
  { id: 3, title: 'Essay: Things Fall Apart Analysis', course: 'LIT 220', due: 'Jul 28', urgent: false, type: 'Essay' },
  { id: 4, title: 'BST Implementation', course: 'CS 301', due: 'Jul 30', urgent: false, type: 'Project' },
]

const grades = [
  { course: 'MATH 401', grade: 'A−', score: 91, change: '+3' },
  { course: 'BIO 310', grade: 'B+', score: 87, change: '+1' },
  { course: 'LIT 220', grade: 'A', score: 95, change: '0' },
  { course: 'CS 301', grade: 'B', score: 83, change: '-2' },
]

const schedule = [
  { time: '09:00', title: 'Contemporary Literature', room: 'Hall B-204', type: 'lecture' },
  { time: '11:00', title: 'Office Hours — Dr. Vasquez', room: 'Math Dept. 3F', type: 'office' },
  { time: '14:00', title: 'Advanced Mathematics', room: 'Live Session', type: 'live' },
  { time: '16:00', title: 'Study Group — BIO 310', room: 'Library Room 5', type: 'study' },
]

export default function StudentDashboard({ onJoinLive }: { onJoinLive: () => void }) {
  const [activeTab, setActiveTab] = useState<'overview' | 'assignments' | 'grades'>('overview')

  return (
    <div className="flex flex-col gap-8 px-8 py-8 max-w-7xl mx-auto w-full">
      {/* Header */}
      <div className="flex items-start justify-between">
        <div>
          <p className="mono text-xs tracking-widest uppercase mb-1" style={{ color: 'var(--accent)' }}>
            Thursday, July 24
          </p>
          <h1 className="text-3xl font-semibold tracking-tight" style={{ fontFamily: 'Lexend', color: 'var(--foreground)' }}>
            Good afternoon, Amara
          </h1>
          <p className="text-sm mt-1" style={{ color: 'var(--muted-foreground)' }}>
            You have 1 urgent assignment due tonight.
          </p>
        </div>
        <div className="flex gap-2 mt-1">
          {(['overview', 'assignments', 'grades'] as const).map(tab => (
            <button
              key={tab}
              onClick={() => setActiveTab(tab)}
              className="px-4 py-1.5 rounded-full text-sm font-medium capitalize transition-all"
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
          {/* Quick stats */}
          <div className="grid grid-cols-4 gap-4">
            {[
              { label: 'GPA', value: '3.72', sub: 'Current semester' },
              { label: 'Courses', value: '4', sub: 'Enrolled' },
              { label: 'Assignments', value: '3', sub: 'Due this week' },
              { label: 'Attendance', value: '96%', sub: 'All courses' },
            ].map(s => (
              <div key={s.label} className="rounded-xl p-5 border" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
                <p className="text-xs mono uppercase tracking-widest mb-2" style={{ color: 'var(--muted-foreground)' }}>{s.label}</p>
                <p className="text-2xl font-semibold" style={{ fontFamily: 'Lexend', color: 'var(--foreground)' }}>{s.value}</p>
                <p className="text-xs mt-1" style={{ color: 'var(--muted-foreground)' }}>{s.sub}</p>
              </div>
            ))}
          </div>

          <div className="grid grid-cols-3 gap-6">
            {/* Courses */}
            <div className="col-span-2 flex flex-col gap-4">
              <h2 className="text-sm font-semibold mono uppercase tracking-widest" style={{ color: 'var(--muted-foreground)' }}>
                My Courses
              </h2>
              <div className="grid grid-cols-2 gap-4">
                {courses.map(c => (
                  <div
                    key={c.id}
                    className="rounded-xl overflow-hidden border flex flex-col cursor-pointer group transition-transform hover:-translate-y-0.5"
                    style={{ background: 'var(--card)', borderColor: 'var(--border)' }}
                  >
                    <div className="relative h-28 overflow-hidden" style={{ background: c.color + '22' }}>
                      <img src={c.img} alt={c.title} className="w-full h-full object-cover opacity-60 group-hover:opacity-75 transition-opacity" />
                      <span
                        className="absolute top-3 left-3 text-xs mono px-2 py-0.5 rounded-full font-medium"
                        style={{ background: c.color + '33', color: c.color, border: `1px solid ${c.color}44` }}
                      >
                        {c.tag}
                      </span>
                      {c.nextDate.includes('Today') && (
                        <span
                          className="absolute top-3 right-3 flex items-center gap-1 text-xs px-2 py-0.5 rounded-full font-medium"
                          style={{ background: 'var(--accent)', color: 'var(--accent-foreground)' }}
                        >
                          <span className="w-1.5 h-1.5 rounded-full bg-current animate-pulse" />
                          Live Soon
                        </span>
                      )}
                    </div>
                    <div className="p-4 flex flex-col gap-2 flex-1">
                      <h3 className="text-sm font-semibold leading-tight" style={{ fontFamily: 'Lexend' }}>{c.title}</h3>
                      <p className="text-xs" style={{ color: 'var(--muted-foreground)' }}>{c.instructor}</p>
                      <div className="mt-auto pt-2">
                        <div className="flex justify-between text-xs mb-1" style={{ color: 'var(--muted-foreground)' }}>
                          <span>Progress</span>
                          <span className="mono">{c.progress}%</span>
                        </div>
                        <div className="h-1 rounded-full" style={{ background: 'var(--muted)' }}>
                          <div
                            className="h-full rounded-full transition-all"
                            style={{ width: `${c.progress}%`, background: c.color }}
                          />
                        </div>
                        <p className="text-xs mt-2" style={{ color: 'var(--muted-foreground)' }}>
                          Next: <span style={{ color: 'var(--foreground)' }}>{c.nextLesson}</span>
                        </p>
                        <p className="text-xs mono mt-0.5" style={{ color: c.color }}>{c.nextDate}</p>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Right column */}
            <div className="flex flex-col gap-4">
              {/* Today's schedule */}
              <h2 className="text-sm font-semibold mono uppercase tracking-widest" style={{ color: 'var(--muted-foreground)' }}>
                Today's Schedule
              </h2>
              <div className="rounded-xl border p-4 flex flex-col gap-3" style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
                {schedule.map(s => (
                  <div key={s.time} className="flex gap-3 items-start">
                    <span className="mono text-xs pt-0.5 w-10 shrink-0" style={{ color: 'var(--muted-foreground)' }}>{s.time}</span>
                    <div
                      className="w-0.5 self-stretch rounded-full shrink-0"
                      style={{ background: s.type === 'live' ? 'var(--accent)' : 'var(--border)' }}
                    />
                    <div className="flex-1 min-w-0">
                      <p className="text-xs font-medium leading-tight truncate" style={{ color: 'var(--foreground)' }}>{s.title}</p>
                      <p className="text-xs mt-0.5" style={{ color: 'var(--muted-foreground)' }}>{s.room}</p>
                      {s.type === 'live' && (
                        <button
                          onClick={onJoinLive}
                          className="mt-2 text-xs px-3 py-1 rounded-full font-medium transition-opacity hover:opacity-80"
                          style={{ background: 'var(--accent)', color: 'var(--accent-foreground)' }}
                        >
                          Join Live
                        </button>
                      )}
                    </div>
                  </div>
                ))}
              </div>

              {/* Urgent assignments */}
              <h2 className="text-sm font-semibold mono uppercase tracking-widest" style={{ color: 'var(--muted-foreground)' }}>
                Due Soon
              </h2>
              <div className="rounded-xl border flex flex-col divide-y" style={{ background: 'var(--card)', borderColor: 'var(--border)', '--tw-divide-opacity': 1 }}>
                {assignments.slice(0, 3).map(a => (
                  <div key={a.id} className="p-3 flex items-start gap-3" style={{ borderColor: 'var(--border)' }}>
                    <div
                      className="w-1 self-stretch rounded-full shrink-0 mt-1"
                      style={{ background: a.urgent ? '#ef4444' : 'var(--border)' }}
                    />
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

      {activeTab === 'assignments' && (
        <div className="flex flex-col gap-4">
          <div className="grid grid-cols-1 gap-3">
            {assignments.map(a => (
              <div
                key={a.id}
                className="rounded-xl border p-5 flex items-center gap-5"
                style={{ background: 'var(--card)', borderColor: a.urgent ? '#ef444433' : 'var(--border)' }}
              >
                <div className="w-10 h-10 rounded-lg flex items-center justify-center text-lg shrink-0"
                  style={{ background: 'var(--muted)' }}>
                  {a.type === 'Assignment' ? '📝' : a.type === 'Lab Report' ? '🔬' : a.type === 'Essay' ? '📄' : '💻'}
                </div>
                <div className="flex-1">
                  <p className="font-medium text-sm" style={{ fontFamily: 'Lexend' }}>{a.title}</p>
                  <p className="text-xs mono mt-0.5" style={{ color: 'var(--muted-foreground)' }}>{a.course} · {a.type}</p>
                </div>
                <div className="text-right shrink-0">
                  <p className="text-xs mono font-medium" style={{ color: a.urgent ? '#ef4444' : 'var(--muted-foreground)' }}>{a.due}</p>
                  {a.urgent && <span className="text-xs font-medium" style={{ color: '#ef4444' }}>Urgent</span>}
                </div>
                <button className="px-4 py-1.5 rounded-lg text-xs font-medium shrink-0 transition-opacity hover:opacity-80"
                  style={{ background: 'var(--primary)', color: '#fff' }}>
                  Submit
                </button>
              </div>
            ))}
          </div>
        </div>
      )}

      {activeTab === 'grades' && (
        <div className="flex flex-col gap-4">
          <div className="grid grid-cols-2 gap-4">
            {grades.map(g => (
              <div key={g.course} className="rounded-xl border p-6 flex items-center gap-6"
                style={{ background: 'var(--card)', borderColor: 'var(--border)' }}>
                <div className="text-4xl font-semibold" style={{ fontFamily: 'Lexend', color: 'var(--primary)' }}>
                  {g.grade}
                </div>
                <div className="flex-1">
                  <p className="text-xs mono uppercase tracking-widest mb-1" style={{ color: 'var(--muted-foreground)' }}>{g.course}</p>
                  <div className="h-1.5 rounded-full" style={{ background: 'var(--muted)' }}>
                    <div className="h-full rounded-full" style={{ width: `${g.score}%`, background: 'var(--primary)' }} />
                  </div>
                  <div className="flex justify-between text-xs mono mt-1" style={{ color: 'var(--muted-foreground)' }}>
                    <span>{g.score}/100</span>
                    <span style={{ color: g.change.startsWith('+') ? 'var(--accent)' : g.change === '0' ? 'var(--muted-foreground)' : '#ef4444' }}>
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
